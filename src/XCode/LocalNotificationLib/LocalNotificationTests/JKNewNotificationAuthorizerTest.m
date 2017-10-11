//
//  JKNewNotificationAuthorizerTest.m
//  LocalNotificationLib
//
//  Created by Juan Carlos Pazmino on 10/2/17.
//
//

#import <UserNotifications/UserNotifications.h>
#import <OCMock/OCMock.h>
#import "JKNewTestCase.h"
#import "JKNewLocalNotificationAuthorizer.h"
#import "JKLocalNotificationSettings.h"
#import "Constants.h"

@interface JKNewLocalNotificationAuthorizer (Test)<UNUserNotificationCenterDelegate>
@property (nonatomic, retain) id savedDelegate;
@end

@interface JKNewNotificationAuthorizerTest : JKNewTestCase
@property (nonatomic, retain) JKNewLocalNotificationAuthorizer *subject;
@property (nonatomic, retain) JKLocalNotificationSettings *settings;
@property (nonatomic, retain) id notificationCenterMock;
@property (nonatomic, retain) id notificationCenterDelegateMock;
@end

@implementation JKNewNotificationAuthorizerTest

- (void)setUp {
    [super setUp];

    self.notificationCenterDelegateMock = OCMProtocolMock(@protocol(UNUserNotificationCenterDelegate));
    self.settings = [JKLocalNotificationSettings settingsWithLocalNotificationTypes:JKLocalNotificationTypeAlert | JKLocalNotificationTypeBadge];
    self.notificationCenterMock = OCMClassMock([UNUserNotificationCenter class]);
    OCMStub([self.notificationCenterMock currentNotificationCenter]).andReturn(self.notificationCenterMock);
    OCMStub([self.notificationCenterMock delegate]).andReturn(self.notificationCenterDelegateMock);
    self.subject = [JKNewLocalNotificationAuthorizer new];
}

- (void)tearDown {
    [self.notificationCenterMock stopMocking];
    [super tearDown];
}

- (void)testRequestAuthorizationWithSettings {
    OCMExpect([self.notificationCenterMock requestAuthorizationWithOptions:self.settings.authorizationOptions completionHandler:[OCMArg invokeBlock]]);

    id delegateMock = OCMProtocolMock(@protocol(JKAuthorizerDelegate));
    OCMExpect([delegateMock notificationAuthorizer:self.subject didAuthorizeWithSettings:self.settings]);
    self.subject.delegate = delegateMock;

    [self.subject requestAuthorizationWithSettings:self.settings];

    OCMVerifyAll(self.notificationCenterMock);
    OCMVerifyAll(delegateMock);
}

@end
