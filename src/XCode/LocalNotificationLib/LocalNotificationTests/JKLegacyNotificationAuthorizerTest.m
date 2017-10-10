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
#import "JKLocalNotificationSettings.h"
#import "Constants.h"

@interface JKLegacyLocalNotificationAuthorizer (Test)<UIApplicationDelegate>
@property (nonatomic, retain) id savedDelegate;
@end

@interface JKLegacyNotificationAuthorizerTest : JKLegacyTestCase
@property (nonatomic, retain) JKLegacyLocalNotificationAuthorizer *subject;
@property (nonatomic, retain) JKLocalNotificationSettings *settings;
@property (nonatomic, retain) id appMock;
@property (nonatomic, retain) id appDelegateMock;
@end

@implementation JKLegacyNotificationAuthorizerTest

- (void)setUp {
    [super setUp];

    self.appDelegateMock = OCMProtocolMock(@protocol(UIApplicationDelegate));
    self.settings = [JKLocalNotificationSettings settingsWithLocalNotificationTypes:JKLocalNotificationTypeAlert | JKLocalNotificationTypeBadge];
    self.appMock = OCMClassMock([UIApplication class]);
    OCMStub([self.appMock sharedApplication]).andReturn(self.appMock);
    OCMStub([self.appMock delegate]).andReturn(self.appDelegateMock);
    self.subject = [JKLegacyLocalNotificationAuthorizer new];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testInitialization {
    JKLegacyLocalNotificationAuthorizer *subject = [JKLegacyLocalNotificationAuthorizer alloc];
    XCTAssertNil(subject.savedDelegate);
    OCMExpect([self.appMock setDelegate:subject]);
    [subject init];

    XCTAssertEqual(subject.savedDelegate, self.appDelegateMock);
    OCMVerifyAll(self.appMock);
}

- (void)testDeallocation {
    /*JKLegacyLocalNotificationAuthorizer *subject = [JKLegacyLocalNotificationAuthorizer new];
    OCMExpect([self.appMock setDelegate:self.appDelegateMock]);
    OCMVerifyAll(self.appMock);*/
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
    JKLegacyLocalNotificationAuthorizer *subject = [JKLegacyLocalNotificationAuthorizer new];
    XCTAssertFalse([subject respondsToSelector:@selector(tableView:canEditRowAtIndexPath:)]);
    XCTAssertTrue([subject respondsToSelector:@selector(applicationWillTerminate:)]);
}

- (void)testRequestAuthorizationWithSettings {
    id settingsMock = OCMClassMock([UIUserNotificationSettings class]);
    OCMStub([settingsMock settingsForTypes:self.settings.notificationTypes categories:nil]).andReturn(settingsMock);

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

    //XCTAssertEqual(self.subject.settings, settingsMock);
    //OCMVerifyAll(delegateMock);
}

@end
