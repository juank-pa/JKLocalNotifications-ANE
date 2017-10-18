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
#import "JKLegacyLocalNotificationAuthorizer.h"
#import "JKLegacyLocalNotificationFactory.h"
#import "JKLocalNotificationSettings.h"
#import "Constants.h"
#import "Stubs.h"

@interface JKLegacyLocalNotificationAuthorizer (Test)<UIApplicationDelegate>
@property (nonatomic, retain) id savedDelegate;
@end

@interface JKLegacyNotificationAuthorizerTest : JKLegacyTestCase
@property (nonatomic, retain) JKLegacyLocalNotificationAuthorizer *subject;
@property (nonatomic, retain) JKLocalNotificationSettings *settings;
@property (nonatomic, retain) id factoryMock;
@property (nonatomic, retain) id appMock;
@property (nonatomic, retain) id appDelegateMock;
@end

@implementation JKLegacyNotificationAuthorizerTest

- (void)setUp {
    [super setUp];

    self.settings = [JKLocalNotificationSettings settingsWithLocalNotificationTypes:JKLocalNotificationTypeAlert | JKLocalNotificationTypeBadge];

    self.appDelegateMock = OCMProtocolMock(@protocol(UIApplicationDelegate));
    self.appMock = OCMClassMock([UIApplication class]);
    OCMStub([self.appMock delegate]).andReturn(self.appDelegateMock);

    self.factoryMock = OCMClassMock([JKLegacyLocalNotificationFactory class]);
    OCMStub([self.factoryMock application]).andReturn(self.appMock);

    self.subject = [[JKLegacyLocalNotificationAuthorizer alloc] initWithFactory:self.factoryMock];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testInitialization {
    JKLegacyLocalNotificationAuthorizer *subject = [JKLegacyLocalNotificationAuthorizer alloc];
    XCTAssertNil(subject.savedDelegate);
    OCMExpect([self.appMock setDelegate:subject]);
    [subject initWithFactory:self.factoryMock];

    XCTAssertEqual(subject.savedDelegate, self.appDelegateMock);
    OCMVerifyAll(self.appMock);
}

- (void)testDeallocation {
    StubLegacyFactory *factory = [StubLegacyFactory new];
    factory.application.delegate = self.appDelegateMock;
    @autoreleasepool {
        [[JKLegacyLocalNotificationAuthorizer alloc] initWithFactory:factory];
    }
    XCTAssertEqual(factory.application.delegate, self.appDelegateMock);
}

- (void)testForwardingTargetForSelector {
    XCTAssertEqual([self.subject forwardingTargetForSelector:NULL], self.appDelegateMock);
}

- (void)testSuccessfulForwarding {
    id appDelegateMock = OCMProtocolMock(@protocol(UIApplicationDelegate));
    OCMExpect([appDelegateMock applicationWillTerminate:self.appMock]);
    self.subject.savedDelegate = appDelegateMock;
    [self.subject applicationWillTerminate:self.appMock];

    OCMVerifyAll(appDelegateMock);
}

- (void)testResponsToSelector {
    XCTAssertFalse([self.subject respondsToSelector:@selector(tableView:canEditRowAtIndexPath:)]);
    XCTAssertTrue([self.subject respondsToSelector:@selector(applicationWillTerminate:)]);
}

- (void)testRequestAuthorizationWithSettings {
    id settingsMock = OCMClassMock([UIUserNotificationSettings class]);
    OCMStub([self.factoryMock createSettingsForTypes:self.settings.notificationTypes]).andReturn(settingsMock);

    OCMExpect([self.appMock registerUserNotificationSettings:settingsMock]);

    [self.subject requestAuthorizationWithSettings:self.settings];

    OCMVerifyAll(self.appMock);
}

- (void)testApplicationDidRegisterUserNotificationSettings {
    XCTAssertNil(self.subject.settings);

    UIUserNotificationType types = UIUserNotificationTypeAlert | UIUserNotificationTypeBadge;
    id settingsMock = OCMClassMock([JKLocalNotificationSettings class]);
    OCMStub([settingsMock settingsWithUserNotificationTypes:types]).andReturn(settingsMock);

    id delegateMock = OCMProtocolMock(@protocol(JKAuthorizerDelegate));
    OCMExpect([delegateMock notificationAuthorizer:self.subject didAuthorizeWithSettings:settingsMock]);
    self.subject.delegate = delegateMock;

    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
    [self.subject application:self.appMock didRegisterUserNotificationSettings:settings];

    XCTAssertEqual(self.subject.settings, settingsMock);
    OCMVerifyAll(delegateMock);

    [settingsMock stopMocking];
}

@end
