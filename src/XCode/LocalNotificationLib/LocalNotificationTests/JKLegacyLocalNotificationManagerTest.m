//
//  JKLegacyLocalNotificationManagerTest.m
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
#import "JKLegacyLocalNotificationFactory.h"
#import "Constants.h"

@interface UILocalNotification (NotificationManager)
+ (instancetype)localNotification;
@end

@interface JKLegacyLocalNotificationManagerTest : JKLegacyTestCase
@property (nonatomic, retain) JKLegacyLocalNotificationManager *subject;
@property (nonatomic, retain) JKLocalNotification *notification;

@property (nonatomic, retain) id appMock;
@property (nonatomic, retain) id archiverMock;
@property (nonatomic, retain) id factoryMock;
@property (nonatomic, retain) id notificationBuilderMock;
@property (nonatomic, retain) id localNotificationMock;

@property (nonatomic, readonly) NSString *archivePath;
@end

@implementation JKLegacyLocalNotificationManagerTest

- (NSString *)archivePath {
    return [NSTemporaryDirectory() stringByAppendingPathComponent:@"Notification_code123.archive"];
}

- (void)setUp {
    [super setUp];

    self.factoryMock = OCMClassMock([JKLegacyLocalNotificationFactory class]);

    self.subject = [[JKLegacyLocalNotificationManager alloc] initWithFactory:self.factoryMock];
    self.appMock = OCMClassMock([UIApplication class]);
    OCMStub([self.factoryMock application]).andReturn(self.appMock);
}

- (void)tearDown {
    [super tearDown];
}

- (void)setUpNotify {
    self.notification = [JKLocalNotification new];
    self.notification.fireDate = nil;

    self.localNotificationMock = OCMClassMock([UILocalNotification class]);

    self.notificationBuilderMock = OCMClassMock([JKNotificationBuilder class]);
    OCMExpect([self.notificationBuilderMock buildFromNotification:self.notification]).andReturn(self.localNotificationMock);

    OCMStub([self.factoryMock createNotificationBuilder]).andReturn(self.notificationBuilderMock);
}

- (void)testNotifyImmediately {
    [self setUpNotify];
    OCMExpect([self.appMock presentLocalNotificationNow:self.localNotificationMock]);

    [self.subject notify:self.notification];

    OCMVerifyAll(self.appMock);
    OCMVerifyAll(self.notificationBuilderMock);
}

- (void)testNotifyAtFutureDate {
    [self setUpNotify];

    NSDate *date = [NSDate date];
    self.notification.fireDate = date;
    OCMExpect([self.appMock scheduleLocalNotification:self.localNotificationMock]);

    [self.subject notify:self.notification];

    OCMVerifyAll(self.appMock);
    OCMVerifyAll(self.notificationBuilderMock);
}

- (void)testNotifyFirstTime {
    [self setUpNotify];

    id fileManagerMock = OCMClassMock([NSFileManager class]);
    OCMStub([fileManagerMock defaultManager]).andReturn(fileManagerMock);
    OCMStub([fileManagerMock fileExistsAtPath:self.archivePath]).andReturn(NO);

    OCMExpect([self.archiverMock archiveRootObject:@[self.localNotificationMock] toFile:self.archivePath]);
    [self.subject notify:self.notification];

    OCMVerifyAll(self.appMock);
    OCMVerifyAll(self.notificationBuilderMock);
    [fileManagerMock stopMocking];
}

- (void)testNotifyAgain {
    [self setUpNotify];

    id fileManagerMock = OCMClassMock([NSFileManager class]);
    OCMStub([fileManagerMock defaultManager]).andReturn(fileManagerMock);
    OCMStub([fileManagerMock fileExistsAtPath:self.archivePath]).andReturn(YES);

    UILocalNotification *prevNotification = [UILocalNotification new];
    id unarchiverMock = OCMClassMock([NSKeyedUnarchiver class]);
    OCMStub([unarchiverMock unarchiveObjectWithFile:self.archivePath]).andReturn(@[prevNotification]);

    NSArray *notificationList = @[prevNotification, self.localNotificationMock];
    OCMExpect([self.archiverMock archiveRootObject:notificationList toFile:self.archivePath]);

    [self.subject notify:self.notification];

    OCMVerifyAll(self.archiverMock);
    [fileManagerMock stopMocking];
    [unarchiverMock stopMocking];
}

- (void)testCancelNonExistingNotifications {
    NSString *code = @"code";
    id archiverMock = OCMClassMock([NSKeyedArchiver class]);
    OCMReject([archiverMock archiveRootObject:[OCMArg any] toFile:[OCMArg any]]);
    OCMReject([self.appMock cancelLocalNotification:[OCMArg any]]);

    [self.subject cancel:code];

    OCMVerifyAll(self.appMock);
    OCMVerifyAll(self.archiverMock);
    [archiverMock stopMocking];
}

- (void)testCancelExistingNotification {
    UILocalNotification *notification = [UILocalNotification new];

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
    OCMVerifyAll(archiverMock);

    [archiverMock stopMocking];
    [unarchiverMock stopMocking];
    [fileManagerMock stopMocking];
}

- (void)testCancelAll {
    OCMExpect([self.appMock cancelAllLocalNotifications]);
    [self.subject cancelAll];
    OCMVerifyAll(self.appMock);
}

@end
