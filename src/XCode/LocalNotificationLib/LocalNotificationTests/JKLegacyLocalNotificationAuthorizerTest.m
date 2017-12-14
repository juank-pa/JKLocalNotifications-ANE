//
//  JKLegacyNotificationAuthorizerTest.m
//  LocalNotificationLib
//
//  Created by Juan Carlos Pazmino on 10/2/17.
//
//

#import <UIKit/UIKit.h>
#import <OCMock/OCMock.h>
#import "JKLegacyTestCase.h"
#import "JKLegacyNotificationListener.h"
#import "JKLegacyLocalNotificationAuthorizer.h"
#import "JKLegacyLocalNotificationFactory.h"
#import "JKLocalNotificationSettings.h"
#import "Constants.h"
#import "Stubs.h"

@interface JKLegacyLocalNotificationAuthorizer (Test)<JKNotificationAuthorizationListenerDelegate>
@end

@interface JKLocalLegacyNotificationAuthorizerTest : JKLegacyTestCase
@property (nonatomic, strong) JKLegacyLocalNotificationAuthorizer *subject;
@property (nonatomic, strong) JKLocalNotificationSettings *settings;
@property (nonatomic, strong) id factoryMock;
@property (nonatomic, strong) id appMock;
@property (nonatomic, strong) id listenerMock;
@end

@implementation JKLocalLegacyNotificationAuthorizerTest

- (void)setUp {
    [super setUp];

    self.settings = [JKLocalNotificationSettings settingsWithLocalNotificationTypes:JKLocalNotificationTypeAlert | JKLocalNotificationTypeBadge];

    self.listenerMock = OCMClassMock([JKLegacyNotificationListener class]);
    self.appMock = OCMClassMock([UIApplication class]);

    self.factoryMock = OCMClassMock([JKLegacyLocalNotificationFactory class]);
    OCMStub([self.factoryMock listener]).andReturn(self.listenerMock);
    OCMStub([self.factoryMock application]).andReturn(self.appMock);

    self.subject = [[JKLegacyLocalNotificationAuthorizer alloc] initWithFactory:self.factoryMock];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testInitialization {
    JKLegacyLocalNotificationAuthorizer *subject = [JKLegacyLocalNotificationAuthorizer alloc];
    OCMExpect([self.listenerMock setAuthorizationDelegate:subject]);
    [subject initWithFactory:self.factoryMock];
    OCMVerifyAll(self.listenerMock);
}


- (void)testRequestAuthorizationWithSettings {
    id settingsBuilderMock = OCMClassMock([JKLegacyNotificationSettingsBuilder class]);
    OCMStub([self.factoryMock createSettingsBuilder]).andReturn(settingsBuilderMock);

    id settingsMock = OCMClassMock([UIUserNotificationSettings class]);
    OCMStub([settingsBuilderMock buildFromSettings:self.settings]).andReturn(settingsMock);

    OCMExpect([self.appMock registerUserNotificationSettings:settingsMock]);

    [self.subject requestAuthorizationWithSettings:self.settings];

    OCMVerifyAll(self.appMock);
}

- (void)testNotificationListenerDidRegisterUserNotificationSettings {
    XCTAssertNil(self.subject.settings);

    UIUserNotificationType types = UIUserNotificationTypeAlert | UIUserNotificationTypeBadge;
    id settingsMock = OCMClassMock([JKLocalNotificationSettings class]);
    OCMStub([settingsMock settingsWithUserNotificationTypes:types]).andReturn(settingsMock);

    id delegateMock = OCMProtocolMock(@protocol(JKAuthorizerDelegate));
    OCMExpect([delegateMock notificationAuthorizer:self.subject didAuthorizeWithSettings:settingsMock]);
    self.subject.delegate = delegateMock;

    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
    [self.subject notificationListener:self.listenerMock didRegisterUserNotificationSettings:settings];

    XCTAssertEqual(self.subject.settings, settingsMock);
    OCMVerifyAll(delegateMock);

    [settingsMock stopMocking];
}

@end
