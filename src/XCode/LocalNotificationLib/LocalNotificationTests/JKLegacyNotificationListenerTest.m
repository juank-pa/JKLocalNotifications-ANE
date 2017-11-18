//
//  JKLegacyNotificationListenerTest.m
//  LocalNotificationLib
//
//  Created by Juan Carlos Pazmino on 10/3/17.
//
//

#import <OCMock/OCMock.h>
#import "Constants.h"
#import "Stubs.h"
#import "JKLegacyTestCase.h"
#import "JKLegacyNotificationListener.h"
#import "JKLegacyLocalNotificationFactory.h"
#import "JKNotificationDispatcher.h"

@interface JKLegacyNotificationListener ()<UIApplicationDelegate>
@property (nonatomic, strong) id savedDelegate;
@end

@interface JKLegacyNotificationListenerTest : JKLegacyTestCase
@property (nonatomic, strong) JKLegacyNotificationListener *subject;
@property (nonatomic, strong) id factoryMock;
@property (nonatomic, strong) id appMock;
@property (nonatomic, strong) id appDelegateMock;
@property (nonatomic, strong) id dispatcherMock;
@end

@implementation JKLegacyNotificationListenerTest

- (void)setUp {
    [super setUp];
    self.appDelegateMock = OCMProtocolMock(@protocol(UIApplicationDelegate));
    self.appMock = OCMClassMock([UIApplication class]);
    OCMStub([self.appMock delegate]).andReturn(self.appDelegateMock);

    self.factoryMock = OCMClassMock([JKLegacyLocalNotificationFactory class]);
    OCMStub([self.factoryMock application]).andReturn(self.appMock);

    self.dispatcherMock = OCMClassMock([JKNotificationDispatcher class]);
    OCMStub([self.dispatcherMock dispatcherWithListener:[OCMArg any]]).andReturn(self.dispatcherMock);

    self.subject = [[JKLegacyNotificationListener alloc] initWithFactory:self.factoryMock];
}

- (void)tearDown {
    [self.dispatcherMock stopMocking];
    [super tearDown];
}

- (void)testInitialization {
    JKLegacyNotificationListener *subject = [JKLegacyNotificationListener alloc];
    XCTAssertNil(subject.savedDelegate);
    OCMExpect([self.appMock setDelegate:subject]);
    [subject initWithFactory:self.factoryMock];

    XCTAssertEqual(subject.savedDelegate, self.appDelegateMock);
    OCMVerifyAll(self.appMock);
}

- (void)testDeallocation {
    StubLegacyFactory *factory = [StubLegacyFactory new];
    factory.application.delegate = self.appDelegateMock;
    [self.dispatcherMock stopMocking];
    @autoreleasepool {
        [[JKLegacyNotificationListener alloc] initWithFactory:factory];
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

- (void)testDidReceiveLocalNotificationDelegatesIfImplemented {
    UILocalNotification *notification = [UILocalNotification new];
    NSData *data = [NSData data];
    notification.userInfo = @{JK_NOTIFICATION_CODE_KEY: @"code", JK_NOTIFICATION_DATA_KEY: data};

    OCMExpect([self.appDelegateMock application:self.appMock
                    didReceiveLocalNotification:notification]);
    //OCMExpect([self.dispatcherMock dispatchDidReceiveNotificationWithUserInfo:notification.userInfo]);

    [self.subject application:self.appMock didReceiveLocalNotification:notification];

    //OCMVerifyAll(self.dispatcherMock);
    OCMVerifyAll(self.appDelegateMock);
}

- (void)testDidReceiveLocalNotificationDispatches {
    UILocalNotification *notification = [UILocalNotification new];
    NSData *data = [NSData data];
    notification.userInfo = @{JK_NOTIFICATION_CODE_KEY: @"code", JK_NOTIFICATION_DATA_KEY: data};

    OCMExpect([self.dispatcherMock dispatchDidReceiveNotificationWithUserInfo:notification.userInfo completionHandler:NULL]);

    [self.subject application:self.appMock didReceiveLocalNotification:notification];

    OCMVerifyAll(self.dispatcherMock);
}

- (void)testDidReceiveLocalNotificationDispatchesMoreThanOnce {
    UILocalNotification *notification = [UILocalNotification new];
    NSData *data = [NSData data];
    notification.userInfo = @{JK_NOTIFICATION_CODE_KEY: @"code", JK_NOTIFICATION_DATA_KEY: data};

    [self.subject application:self.appMock didReceiveLocalNotification:notification];

    OCMExpect([self.dispatcherMock dispatchDidReceiveNotificationWithUserInfo:notification.userInfo completionHandler:NULL]);

    [self.subject application:self.appMock didReceiveLocalNotification:notification];

    OCMVerifyAll(self.dispatcherMock);
}

- (void)testCheckForNotificationAction {
    NSDictionary *userInfo = @{
                               JK_NOTIFICATION_CODE_KEY: @"NotificationCodeKey",
                               JK_NOTIFICATION_DATA_KEY: @"NotificationDataKey"
                               };

    OCMExpect([self.dispatcherMock dispatchDidReceiveNotificationWithUserInfo:userInfo
                                                            completionHandler:[OCMArg any]]);

    [self.subject checkForNotificationAction];

    OCMVerifyAll(self.dispatcherMock);
}

- (void)testCheckForNotificationActionOnlyOnce {
    OCMStub([self.dispatcherMock dispatchDidReceiveNotificationWithUserInfo:[OCMArg any]
                                                          completionHandler:[OCMArg invokeBlock]]);

    [self.subject checkForNotificationAction];
    OCMReject([self.dispatcherMock dispatchDidReceiveNotificationWithUserInfo:[OCMArg any]
                                                            completionHandler:[OCMArg any]]);

    [self.subject checkForNotificationAction];

    OCMVerifyAll(self.dispatcherMock);
}

@end
