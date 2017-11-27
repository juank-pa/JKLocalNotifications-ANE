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
#import "JKNewLocalNotificationFactory.h"
#import "JKNewCategoryBuilder.h"
#import "Constants.h"

@interface JKNewLocalNotificationAuthorizer (Test)<UNUserNotificationCenterDelegate>
@property (nonatomic, strong) id savedDelegate;
@end

@interface JKNewNotificationAuthorizerTest : JKNewTestCase
@property (nonatomic, strong) JKNewLocalNotificationAuthorizer *subject;
@property (nonatomic, strong) JKLocalNotificationSettings *settings;
@property (nonatomic, strong) id notificationCenterMock;
@property (nonatomic, strong) id notificationCenterDelegateMock;
@property (nonatomic, strong) id factoryMock;
@end

@implementation JKNewNotificationAuthorizerTest

- (void)setUp {
    [super setUp];

    self.notificationCenterDelegateMock = OCMProtocolMock(@protocol(UNUserNotificationCenterDelegate));
    self.settings = [JKLocalNotificationSettings settingsWithLocalNotificationTypes:JKLocalNotificationTypeAlert | JKLocalNotificationTypeBadge];
    self.settings.categories = [NSArray array];

    self.notificationCenterMock = OCMClassMock([UNUserNotificationCenter class]);
    OCMStub([self.notificationCenterMock delegate]).andReturn(self.notificationCenterDelegateMock);

    self.factoryMock = OCMClassMock([JKNewLocalNotificationFactory class]);
    OCMStub([self.factoryMock notificationCenter]).andReturn(self.notificationCenterMock);

    self.subject = [[JKNewLocalNotificationAuthorizer alloc] initWithFactory:self.factoryMock];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testRequestAuthorizationWithSettings {
    OCMExpect([self.notificationCenterMock requestAuthorizationWithOptions:self.settings.authorizationOptions completionHandler:[OCMArg any]]);
    [self.subject requestAuthorizationWithSettings:self.settings];
    OCMVerifyAll(self.notificationCenterMock);
}

- (void)testRequestAuthorizationWithSettingsDelegatesWithSettingsIfGranted {
    id arg = [OCMArg invokeBlockWithArgs:OCMOCK_VALUE((BOOL){true}), OCMOCK_VALUE((NSError *){NULL}), nil];
    OCMStub([self.notificationCenterMock requestAuthorizationWithOptions:self.settings.authorizationOptions completionHandler:arg]);

    id delegateMock = OCMProtocolMock(@protocol(JKAuthorizerDelegate));
    OCMExpect([delegateMock notificationAuthorizer:self.subject didAuthorizeWithSettings:self.settings]);
    self.subject.delegate = delegateMock;

    [self.subject requestAuthorizationWithSettings:self.settings];
    OCMVerifyAll(delegateMock);
}

- (void)testRequestAuthorizationWithSettingsDelegatesWithNilSettingsIfNotGranted {
    id arg = [OCMArg invokeBlockWithArgs:OCMOCK_VALUE((BOOL){false}), OCMOCK_VALUE((NSError *){NULL}), nil];
    OCMStub([self.notificationCenterMock requestAuthorizationWithOptions:self.settings.authorizationOptions completionHandler:arg]);

    id delegateMock = OCMProtocolMock(@protocol(JKAuthorizerDelegate));
    OCMExpect([delegateMock notificationAuthorizer:self.subject didAuthorizeWithSettings:nil]);
    self.subject.delegate = delegateMock;

    [self.subject requestAuthorizationWithSettings:self.settings];
    OCMVerifyAll(delegateMock);
}

- (void)testRequestAuthorizationWithSettingsStoresSettingsIfGranted {
    id arg = [OCMArg invokeBlockWithArgs:OCMOCK_VALUE((BOOL){true}), OCMOCK_VALUE((NSError *){NULL}), nil];
    OCMStub([self.notificationCenterMock requestAuthorizationWithOptions:self.settings.authorizationOptions completionHandler:arg]);

    [self.subject requestAuthorizationWithSettings:self.settings];

    XCTAssertEqual(self.subject.settings, self.settings);
}

- (void)testRequestAuthorizationWithSettingsDoesNotStoreSettingsIfNotGranted {
    id arg = [OCMArg invokeBlockWithArgs:OCMOCK_VALUE((BOOL){false}), OCMOCK_VALUE((NSError *){NULL}), nil];
    OCMStub([self.notificationCenterMock requestAuthorizationWithOptions:self.settings.authorizationOptions completionHandler:arg]);

    [self.subject requestAuthorizationWithSettings:self.settings];

    XCTAssertNil(self.subject.settings);
}

- (void)testRequestAuthorizationWithSettingsRegistersCategories {
    NSSet *parsedCategories = [NSSet set];
    id categoryBuilderMock = OCMClassMock([JKNewCategoryBuilder class]);
    OCMStub([self.factoryMock createCategoryBuilder]).andReturn(categoryBuilderMock);
    OCMStub([categoryBuilderMock buildFromCategories:self.settings.categories]).andReturn(parsedCategories);

    OCMExpect([self.notificationCenterMock setNotificationCategories:parsedCategories]);

    [self.subject requestAuthorizationWithSettings:self.settings];
    OCMVerifyAll(self.notificationCenterMock);
}

@end
