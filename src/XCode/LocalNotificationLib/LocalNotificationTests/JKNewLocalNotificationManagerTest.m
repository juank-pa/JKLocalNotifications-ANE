//
//  JKNewLocalNotificationManagerTest.m
//  LocalNotificationLib
//
//  Created by Juan Carlos Pazmino on 7/23/17.
//
//

#import <UserNotifications/UserNotifications.h>
#import <OCMock/OCMock.h>
#import "Stubs.h"
#import "FlashRuntimeExtensions+Private.h"
#import "JKNewTestCase.h"
#import "JKNewLocalNotificationManager.h"
#import "JKLocalNotification.h"
#import "JKTriggerFactory.h"
#import "Constants.h"

@interface UILocalNotification (NotificationManager)
+ (instancetype)localNotification;
@end

@interface JKNewLocalNotificationManagerTest : JKNewTestCase
@property (nonatomic, retain) JKNewLocalNotificationManager *subject;
@property (nonatomic, retain) JKLocalNotification *notification;

@property (nonatomic, retain) id notificationCenterMock;
@property (nonatomic, retain) id notificationMock;

@end

@implementation JKNewLocalNotificationManagerTest

- (void)setUp {
    [super setUp];
    self.subject = [JKNewLocalNotificationManager new];
    self.notificationCenterMock = OCMClassMock([UNUserNotificationCenter class]);
    OCMStub([self.notificationCenterMock currentNotificationCenter]).andReturn(self.notificationCenterMock);
}

- (void)tearDown {
    [self.notificationCenterMock stopMocking];
    [super tearDown];
}

- (void)setUpNotify {
    self.notification = [JKLocalNotification new];
    self.notification.repeatInterval = JKCalendarUnitMonth;
    self.notification.body = @"body";
    self.notification.title = @"title";
    self.notification.actionLabel = @"actionLabel";
    self.notification.hasAction = YES;
    self.notification.numberAnnotation = 10;
    self.notification.notificationCode = @"code123";

    self.notificationMock = OCMClassMock([UNMutableNotificationContent class]);
    OCMStub([self.notificationMock new]).andReturn(self.notificationMock);

    OCMExpect([self.notificationMock setTitle:@"title"]);
    OCMExpect([self.notificationMock setBody:@"body"]);
    OCMExpect([self.notificationMock setBadge:@10]);
}

- (void)tearDownNotify {
    OCMVerifyAll(self.notificationCenterMock);
    OCMVerifyAll(self.notificationMock);

    [self.notificationMock stopMocking];
}

- (void)testNotifyImmediately {
    [self setUpNotify];

    self.notification.fireDate = nil;

    id requestMock = OCMClassMock([UNNotificationRequest class]);
    OCMStub([requestMock requestWithIdentifier:self.notification.notificationCode content:self.notificationMock trigger:nil]).andReturn(requestMock);

    OCMExpect([self.notificationCenterMock addNotificationRequest:requestMock withCompletionHandler:NULL]);

    [self.subject notify:self.notification];

    [requestMock stopMocking];
    [self tearDownNotify];
}

- (void)testNotifyAtFutureDate {
    [self setUpNotify];

    NSDate *date = [NSDate date];
    self.notification.fireDate = date;

    id triggerMock = OCMClassMock([UNNotificationTrigger class]);
    id triggerFactoryMock = OCMClassMock([JKTriggerFactory class]);
    OCMStub([triggerFactoryMock factory]).andReturn(triggerFactoryMock);
    OCMStub([triggerFactoryMock createFromDate:date repeatInterval:JKCalendarUnitMonth]).andReturn(triggerMock);

    id requestMock = OCMClassMock([UNNotificationRequest class]);
    OCMStub([requestMock requestWithIdentifier:self.notification.notificationCode content:self.notificationMock trigger:triggerMock]).andReturn(requestMock);

    OCMExpect([self.notificationCenterMock addNotificationRequest:requestMock withCompletionHandler:NULL]);

    [self.subject notify:self.notification];

    [requestMock stopMocking];
    [self tearDownNotify];
}

- (void)testNotifyWithoutSound {
    [self setUpNotify];

    self.notification.playSound = NO;
    OCMExpect([self.notificationMock setSound:nil]);

    [self.subject notify:self.notification];

    [self tearDownNotify];
}


- (void)testNotifyWithNamedSound {
    [self setUpNotify];

    self.notification.playSound = YES;
    self.notification.soundName = @"soundName";
    OCMExpect([self.notificationMock setSound:[UNNotificationSound soundNamed:@"soundName"]]);

    [self.subject notify:self.notification];

    [self tearDownNotify];
}

- (void)testNotifyWithUnamedSound {
    [self setUpNotify];

    self.notification.playSound = YES;
    OCMExpect([self.notificationMock setSound:[UNNotificationSound defaultSound]]);

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

- (void)testCancel {
    NSString *code = @"my-code";
    OCMExpect([self.notificationCenterMock removePendingNotificationRequestsWithIdentifiers:@[code]]);
    [self.subject cancel:code];
    OCMVerifyAll(self.notificationCenterMock);
}

- (void)testCancelAll {
    OCMExpect([self.notificationCenterMock removeAllPendingNotificationRequests]);
    [self.subject cancelAll];
    OCMVerifyAll(self.notificationCenterMock);
}

@end
