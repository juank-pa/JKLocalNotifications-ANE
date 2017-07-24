//
//  LocalNotificationAppDelegateTest.m
//  LocalNotificationLib
//
//  Created by Juan Carlos Pazmino on 7/22/17.
//
//

#import <XCTest/XCTest.h>
#import <UIKit/UIKit.h>
#import <OCMock/OCMock.h>
#import "Stubs.h"
#import "FlashRuntimeExtensions+Private.h"
#import "LocalNotificationAppDelegate.h"

@interface SimpleDelegate: NSObject <UIApplicationDelegate>
- (void)applicationWillTerminate:(UIApplication *)application;
@end

@implementation SimpleDelegate
- (void)applicationWillTerminate:(UIApplication *)application {}
@end

@interface LocalNotificationAppDelegateTest : XCTestCase
@property (nonatomic, strong) LocalNotificationAppDelegate *subject;
@property (nonatomic, strong) SimpleDelegate *appDelegateMock;
@end

@implementation LocalNotificationAppDelegateTest

- (void)setUp {
    [super setUp];
    self.appDelegateMock = [[SimpleDelegate new] autorelease];
    self.subject = [[[LocalNotificationAppDelegate alloc] initWithTargetDelegate:self.appDelegateMock] autorelease];
}

- (void)tearDown {
    [self.subject release];
    [super tearDown];
}

- (void)testForwardingTargetForSelector {
    self.appDelegateMock = OCMProtocolMock(@protocol(UIApplicationDelegate));
    self.subject = [[[LocalNotificationAppDelegate alloc] initWithTargetDelegate:self.appDelegateMock] autorelease];

    XCTAssertEqual([self.subject forwardingTargetForSelector:NULL], self.appDelegateMock);
}

- (void)testSuccessfulForwarding {
    id appMock = OCMClassMock([UIApplication class]);
    id appDelegateMock = OCMProtocolMock(@protocol(UIApplicationDelegate));
    OCMExpect([appDelegateMock applicationWillTerminate:appMock]);
    self.subject.target = appDelegateMock;
    [self.subject applicationWillTerminate:appMock];

    OCMVerifyAll(appDelegateMock);
}

- (void)testResponsToSelector {
    XCTAssertFalse([self.subject respondsToSelector:@selector(applicationDidBecomeActive:)]);
    XCTAssertTrue([self.subject respondsToSelector:@selector(applicationWillTerminate:)]);
}

- (void)verifyNotification:(NSNotification *)notification {
    NSDictionary *userInfo = notification.userInfo;
    UIUserNotificationSettings *settings = userInfo[FRPE_ApplicationDidRegisterUserNotificationSettingsKey];
    XCTAssertEqual(settings.types, UIUserNotificationTypeAlert);
}

- (void)testApplicationDidRegisterUserNotificationSettings {
    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert categories:nil];
    id appMock = OCMClassMock([UIApplication class]);
    id appDelegateMock = OCMProtocolMock(@protocol(UIApplicationDelegate));
    self.subject.target = appDelegateMock;

    OCMExpect([appDelegateMock application:appMock didRegisterUserNotificationSettings:settings]);

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(verifyNotification:)
                                                 name:(NSString *)FRPE_ApplicationDidRegisterUserNotificationSettings
                                               object:self.subject];

    [self.subject application:appMock didRegisterUserNotificationSettings:settings];

    OCMVerifyAll(appDelegateMock);
}


@end
