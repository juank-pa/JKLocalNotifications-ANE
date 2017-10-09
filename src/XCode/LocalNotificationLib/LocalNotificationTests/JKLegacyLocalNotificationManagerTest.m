//
//  LocalNotificationManagerTest.m
//  LocalNotificationLib
//
//  Created by Juan Carlos Pazmino on 7/23/17.
//
//

#import <UIKit/UIKit.h>
#import <OCMock/OCMock.h>
#import "Stubs.h"
#import "FlashRuntimeExtensions+Private.h"
#import "JKLegacyTestCase.h"
#import "JKLegacyLocalNotificationManager.h"
#import "JKLocalNotification.h"
#import "Constants.h"

@interface UILocalNotification (NotificationManager)
+ (instancetype)localNotification;
@end

@interface JKLegacyLocalNotificationManagerTest : JKLegacyTestCase
@property (nonatomic, retain) JKLegacyLocalNotificationManager *subject;
@property (nonatomic, retain) JKLocalNotification *notification;

@property (nonatomic, retain) id appMock;
@property (nonatomic, retain) id notificationMock;
@property (nonatomic, retain) id archiverMock;

@property (nonatomic, readonly) NSString *archivePath;
@end

@implementation JKLegacyLocalNotificationManagerTest

- (NSString *)archivePath {
    return [NSTemporaryDirectory() stringByAppendingPathComponent:@"Notification_code123.archive"];
}

- (void)setUp {
    [super setUp];
    self.subject = [[JKLegacyLocalNotificationManager new] autorelease];
    self.appMock = OCMClassMock([UIApplication class]);
    OCMStub([self.appMock sharedApplication]).andReturn(self.appMock);
}

- (void)tearDown {
    [self.subject release];
    [super tearDown];
}

- (void)setUpNotify {
    self.notification = [JKLocalNotification new];
    self.notification.repeatInterval = NSCalendarUnitMonth;
    self.notification.body = @"body";
    self.notification.title = @"title";
    self.notification.actionLabel = @"actionLabel";
    self.notification.hasAction = YES;
    self.notification.numberAnnotation = 10;
    self.notification.notificationCode = @"code123";

    self.notificationMock = OCMClassMock([UILocalNotification class]);
    OCMStub([self.notificationMock localNotification]).andReturn(self.notificationMock);
    OCMExpect([self.notificationMock setTimeZone:[NSTimeZone defaultTimeZone]]);
    OCMExpect([self.notificationMock setRepeatInterval:NSCalendarUnitMonth]);

    if ([self.notificationMock respondsToSelector:@selector(setAlertTitle:)]) {
        OCMExpect([self.notificationMock setAlertTitle:@"title"]);
    }
    OCMExpect([self.notificationMock setAlertBody:@"body"]);
    OCMExpect([self.notificationMock setAlertAction:@"actionLabel"]);
    OCMExpect([self.notificationMock setHasAction:YES]);
    OCMExpect([self.notificationMock setApplicationIconBadgeNumber:10]);

    self.archiverMock = OCMClassMock([NSKeyedArchiver class]);
}

- (void)tearDownNotify {
    OCMVerifyAll(self.appMock);
    OCMVerifyAll(self.notificationMock);
    OCMVerifyAll(self.archiverMock);
}

- (void)testNotifyImmediately {
    NSDate *fireDate = nil;
    [self setUpNotify];
    self.notification.fireDate = fireDate;
    OCMExpect([self.notificationMock setFireDate:fireDate]);
    OCMExpect([self.appMock presentLocalNotificationNow:self.notificationMock]);

    [self.subject notify:self.notification];

    [self tearDownNotify];
}

- (void)testNotifyAtFutureDate {

    [self setUpNotify];

    NSDate *date = [NSDate date];
    self.notification.fireDate = date;
    OCMExpect([self.notificationMock setFireDate:date]);
    OCMExpect([self.appMock scheduleLocalNotification:self.notificationMock]);

    [self.subject notify:self.notification];

    [self tearDownNotify];
}

- (void)testNotifyWithoutSound {
    [self setUpNotify];

    self.notification.playSound = NO;
    OCMExpect([self.notificationMock setSoundName:nil]);

    [self.subject notify:self.notification];

    [self tearDownNotify];
}


- (void)testNotifyWithNamedSound {
    [self setUpNotify];

    self.notification.playSound = YES;
    self.notification.soundName = @"soundName";
    OCMExpect([self.notificationMock setSoundName:@"soundName"]);

    [self.subject notify:self.notification];

    [self tearDownNotify];
}

- (void)testNotifyWithUnamedSound {
    [self setUpNotify];

    self.notification.playSound = YES;
    OCMExpect([self.notificationMock setSoundName:UILocalNotificationDefaultSoundName]);

    [self.subject notify:self.notification];

    [self tearDownNotify];
}

- (void)testNotifyWithData {
    [self setUpNotify];

    NSData *data = [NSData dataWithBytes:"hi" length:3];
    NSDictionary *userInfo = @{JK_NOTIFICATION_CODE_KEY: @"code123",
                               JK_NOTIFICATION_DATA_KEY: data};

    self.notification.actionData = data;
    OCMExpect([self.notificationMock setUserInfo:userInfo]);

    [self.subject notify:self.notification];

    [self tearDownNotify];
}

- (void)testNotifyWithoutData {
    [self setUpNotify];

    NSDictionary *userInfo = @{JK_NOTIFICATION_CODE_KEY: @"code123"};
    OCMExpect([self.notificationMock setUserInfo:userInfo]);
    [self.subject notify:self.notification];

    [self tearDownNotify];
}

- (void)testNotifyFirstTime {
    [self setUpNotify];

    id fileManagerMock = OCMClassMock([NSFileManager class]);
    OCMStub([fileManagerMock defaultManager]).andReturn(fileManagerMock);
    OCMStub([fileManagerMock fileExistsAtPath:self.archivePath]).andReturn(NO);

    OCMExpect([self.archiverMock archiveRootObject:@[self.notificationMock] toFile:self.archivePath]);
    [self.subject notify:self.notification];

    [self tearDownNotify];
}

- (void)testNotifyAgain {
    [self setUpNotify];

    id fileManagerMock = OCMClassMock([NSFileManager class]);
    OCMStub([fileManagerMock defaultManager]).andReturn(fileManagerMock);
    OCMStub([fileManagerMock fileExistsAtPath:self.archivePath]).andReturn(YES);

    UILocalNotification *prevNotification = [[UILocalNotification new] autorelease];
    id unarchiverMock = OCMClassMock([NSKeyedUnarchiver class]);
    OCMStub([unarchiverMock unarchiveObjectWithFile:self.archivePath]).andReturn(@[prevNotification]);

    NSArray *notificationList = @[prevNotification, self.notificationMock];
    OCMExpect([self.archiverMock archiveRootObject:notificationList toFile:self.archivePath]);
    [self.subject notify:self.notification];

    [self tearDownNotify];
}

- (void)testCancelNonExistingNotifications {
    NSString *code = @"code";
    id archiverMock = OCMClassMock([NSKeyedArchiver class]);
    OCMReject([archiverMock archiveRootObject:[OCMArg any] toFile:[OCMArg any]]);
    OCMReject([self.appMock cancelLocalNotification:[OCMArg any]]);
    [self.subject cancel:code];
    OCMVerifyAll(self.appMock);
    OCMVerifyAll(self.archiverMock);
}

- (void)testCancelExistingNotification {
    UILocalNotification *notification = [[UILocalNotification new] autorelease];

    id fileManagerMock = OCMClassMock([NSFileManager class]);
    OCMStub([fileManagerMock defaultManager]).andReturn(fileManagerMock);
    OCMStub([fileManagerMock fileExistsAtPath:self.archivePath]).andReturn(YES);

    id unarchiverMock = OCMClassMock([NSKeyedUnarchiver class]);
    OCMStub([unarchiverMock unarchiveObjectWithFile:self.archivePath]).andReturn(@[notification]);

    id archiverMock = OCMClassMock([NSKeyedArchiver class]);
    OCMExpect([archiverMock archiveRootObject:@[] toFile:self.archivePath]);

    NSString *code = @"code123";
    OCMExpect([self.appMock cancelLocalNotification:notification]);
    [self.subject cancel:code];
    OCMVerifyAll(self.appMock);
    OCMVerifyAll(self.archiverMock);
}

- (void)testCancelAll {
    OCMExpect([self.appMock cancelAllLocalNotifications]);
    [self.subject cancelAll];
    OCMVerifyAll(self.appMock);
}

@end
