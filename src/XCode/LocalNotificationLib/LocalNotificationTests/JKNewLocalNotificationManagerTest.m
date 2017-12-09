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
#import "JKTriggerBuilder.h"
#import "JKNewLocalNotificationFactory.h"
#import "Constants.h"

@interface UILocalNotification (NotificationManager)
+ (instancetype)localNotification;
@end

@interface JKNewLocalNotificationManagerTest : JKNewTestCase
@property (nonatomic, strong) JKNewLocalNotificationManager *subject;
@property (nonatomic, strong) JKLocalNotification *notification;

@property (nonatomic, strong) id notificationCenterMock;
@property (nonatomic, strong) id notificationRequestMock;
@property (nonatomic, strong) id factoryMock;
@property (nonatomic, strong) id notificationRequestBuilder;

@end

@implementation JKNewLocalNotificationManagerTest

- (void)setUp {
    [super setUp];

    self.notificationCenterMock = OCMClassMock([UNUserNotificationCenter class]);

    self.notificationRequestBuilder = OCMClassMock([JKNotificationRequestBuilder class]);

    self.factoryMock = OCMClassMock([JKNewLocalNotificationFactory class]);
    OCMStub([self.factoryMock notificationCenter]).andReturn(self.notificationCenterMock);
    OCMStub([self.factoryMock createRequestBuilder]).andReturn(self.notificationRequestBuilder);

    self.subject = [[JKNewLocalNotificationManager alloc] initWithFactory:self.factoryMock];
}

- (void)tearDown {
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

    self.notificationRequestMock = OCMClassMock([UNNotificationRequest class]);
    OCMStub([self.notificationRequestBuilder buildFromNotification:self.notification]).andReturn(self.notificationRequestMock);
}

- (void)tearDownNotify {
    OCMVerifyAll(self.notificationCenterMock);
}

- (void)testNotify {
    [self setUpNotify];

    self.notification.fireDate = nil;

    OCMExpect([self.notificationCenterMock addNotificationRequest:self.notificationRequestMock withCompletionHandler:NULL]);

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
