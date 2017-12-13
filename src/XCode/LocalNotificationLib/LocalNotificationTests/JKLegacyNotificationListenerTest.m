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
#import "JKNotificationListenerSharedTests.h"

@interface StubAppDelegate : NSObject<UIApplicationDelegate>

@end

@implementation StubAppDelegate

@end

@interface JKLegacyNotificationListener ()<UIApplicationDelegate>
+ (instancetype)new;
@property (nonatomic, strong) JKNotificationDispatcher *dispatcher;
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

    self.factoryMock = OCMClassMock([JKNotificationFactory class]);
    OCMStub([self.factoryMock factory]).andReturn(self.factoryMock);
    OCMStub([self.factoryMock application]).andReturn(self.appMock);

    self.dispatcherMock = OCMClassMock([JKNotificationDispatcher class]);
    OCMStub([self.dispatcherMock dispatcherWithListener:[OCMArg any]]).andReturn(self.dispatcherMock);

    self.subject = [JKLegacyNotificationListener sharedListener];
}

- (void)tearDown {
    [self.dispatcherMock stopMocking];
    [super tearDown];
}

- (void)sendLaunchNotification {
    [self sendLaunchNotificationWithUserInfo:nil];
}

- (void)sendLaunchNotificationWithUserInfo:(NSDictionary *)userInfo {
    [NSNotificationCenter.defaultCenter postNotificationName:@"UIApplicationDidFinishLaunchingNotification"
                                                      object:nil
                                                    userInfo:userInfo];
}

- (void)testOnApplicationDidFinishLaunchingReplacesApplicationDelegate {
    NSDictionary *userInfo = @{};
    id subject = OCMClassMock([JKLegacyNotificationListener class]);
    OCMStub([subject sharedListener]).andReturn(subject);

    OCMExpect([subject setupWithOriginalDelegate:self.appDelegateMock]).andReturn(subject);
    OCMExpect([self.appMock setDelegate:subject]);

    [self sendLaunchNotificationWithUserInfo:userInfo];

    OCMVerifyAll(subject);
    OCMVerifyAll(self.appMock);
    [subject stopMocking];
}

- (void)testOnApplicationDidFinishLaunchingDispatchesNotificationToDelegate {
    NSDictionary *userInfo = @{};
    id subject = OCMClassMock([JKLegacyNotificationListener class]);
    OCMStub([subject sharedListener]).andReturn(subject);
    OCMStub([subject dispatcher]).andReturn(self.dispatcherMock);

    OCMExpect([self.dispatcherMock dispatchDidReceiveNotificationWithUserInfo:userInfo]);

    [self sendLaunchNotificationWithUserInfo:userInfo];

    OCMExpect([self.appMock setDelegate:subject]);

    OCMVerifyAll(subject);
    [subject stopMocking];
}

- (void)testForwardingTargetForSelector {
    [self sendLaunchNotification];
    XCTAssertEqual([self.subject forwardingTargetForSelector:NULL], self.appDelegateMock);
}

- (void)testSuccessfulForwarding {
    id appDelegateMock = OCMProtocolMock(@protocol(UIApplicationDelegate));
    OCMExpect([appDelegateMock applicationWillTerminate:self.appMock]);
    self.subject.originalDelegate = appDelegateMock;
    [self.subject applicationWillTerminate:self.appMock];

    OCMVerifyAll(appDelegateMock);
}

- (void)testResponsToSelector {
    self.subject.originalDelegate = self.appDelegateMock;
    XCTAssertFalse([self.subject respondsToSelector:@selector(tableView:canEditRowAtIndexPath:)]);
    XCTAssertTrue([self.subject respondsToSelector:@selector(applicationWillTerminate:)]);
}

- (void)testDidReceiveLocalNotificationDelegatesIfImplemented {
    UILocalNotification *notification = [UILocalNotification new];
    notification.userInfo = @{};

    OCMExpect([self.appDelegateMock application:self.appMock
                    didReceiveLocalNotification:notification]);

    self.subject.originalDelegate = self.appDelegateMock;
    [self.subject application:self.appMock didReceiveLocalNotification:notification];

    OCMVerifyAll(self.appDelegateMock);
}

- (void)testDidReceiveLocalNotificationDispatches {
    UILocalNotification *notification = [UILocalNotification new];
    notification.userInfo = @{};

    OCMExpect([self.dispatcherMock dispatchDidReceiveNotificationWithUserInfo:notification.userInfo]);

    self.subject.dispatcher = self.dispatcherMock;
    [self.subject application:self.appMock didReceiveLocalNotification:notification];

    OCMVerifyAll(self.dispatcherMock);
}

- (void)testDidReceiveLocalNotificationDispatchesMoreThanOnce {
    UILocalNotification *notification = [UILocalNotification new];
    notification.userInfo = @{};

    self.subject.dispatcher = self.dispatcherMock;
    [self.subject application:self.appMock didReceiveLocalNotification:notification];

    OCMExpect([self.dispatcherMock dispatchDidReceiveNotificationWithUserInfo:notification.userInfo]);

    [self.subject application:self.appMock didReceiveLocalNotification:notification];

    OCMVerifyAll(self.dispatcherMock);
}

// Helper methods to stub a notification response
- (UILocalNotification *)notification {
    return [self notificationWithInfo:@{}];
}

- (UILocalNotification *)notificationWithInfo:(NSDictionary *)userInfo {
    UILocalNotification *notification = [UILocalNotification new];
    notification.userInfo = userInfo;
    return notification;
}

- (void)testHandleActionDispatchesWhenOriginalDelegateNotImplemented {
    UILocalNotification *notification = self.notification;
    id savedDelegateMock = OCMPartialMock([StubAppDelegate new]);
    void (^testBlock)(void) = ^{};

    OCMReject([savedDelegateMock application:[OCMArg any]
                  handleActionWithIdentifier:[OCMArg any]
                        forLocalNotification:[OCMArg any]
                           completionHandler:[OCMArg any]]);
    OCMExpect([self.dispatcherMock dispatchDidReceiveNotificationWithActionId:@"actionId"
                                                                     userInfo:notification.userInfo
                                                            completionHandler:testBlock]);

    self.subject.dispatcher = self.dispatcherMock;
    self.subject.originalDelegate = savedDelegateMock;
    [self.subject application:self.appMock
   handleActionWithIdentifier:@"actionId"
         forLocalNotification:notification
            completionHandler:testBlock];

    OCMVerifyAll(self.dispatcherMock);
    OCMVerifyAll(savedDelegateMock);
}

- (void)testHandleActionDispatchesIfOriginalDelegateCallsCompleteHandler {
    UILocalNotification *notification = self.notification;
    void (^testBlock)(void) = ^{};

    OCMExpect([self.appDelegateMock application:self.appMock
                     handleActionWithIdentifier:@"actionId"
                           forLocalNotification:notification
                              completionHandler:[OCMArg invokeBlock]]);
    OCMExpect([self.dispatcherMock dispatchDidReceiveNotificationWithActionId:@"actionId"
                                                                     userInfo:notification.userInfo
                                                            completionHandler:testBlock]);

    self.subject.dispatcher = self.dispatcherMock;
    self.subject.originalDelegate = self.appDelegateMock;
    [self.subject application:self.appMock
   handleActionWithIdentifier:@"actionId"
         forLocalNotification:notification
            completionHandler:testBlock];

    OCMVerifyAll(self.dispatcherMock);
    OCMVerifyAll(self.appDelegateMock);
}

- (void)testHandleActionDoesNotDispatchIfOriginalDelegateDoesNotCallBlock {
    UILocalNotification *notification = self.notification;
    void (^testBlock)(void) = ^{};

    OCMExpect([self.appDelegateMock application:self.appMock
                     handleActionWithIdentifier:@"actionId"
                           forLocalNotification:notification
                              completionHandler:[OCMArg any]]);
    OCMReject([self.dispatcherMock dispatchDidReceiveNotificationWithActionId:[OCMArg any]
                                                                     userInfo:[OCMArg any]
                                                            completionHandler:[OCMArg any]]);

    self.subject.dispatcher = self.dispatcherMock;
    self.subject.originalDelegate = self.appDelegateMock;
    [self.subject application:self.appMock
   handleActionWithIdentifier:@"actionId"
         forLocalNotification:notification
            completionHandler:testBlock];

    OCMVerifyAll(self.dispatcherMock);
    OCMVerifyAll(self.appDelegateMock);
}

- (void)testHandleActionCanDispatchMoreThanOnce {
    UILocalNotification *notification = self.notification;
    id savedDelegateMock = OCMPartialMock([StubAppDelegate new]);
    void (^testBlock)(void) = ^{};

    self.subject.dispatcher = self.dispatcherMock;
    self.subject.originalDelegate = savedDelegateMock;
    [self.subject application:self.appMock
   handleActionWithIdentifier:@"actionId"
         forLocalNotification:notification
            completionHandler:testBlock];


    OCMExpect([self.dispatcherMock dispatchDidReceiveNotificationWithActionId:@"actionId"
                                                                     userInfo:notification.userInfo
                                                            completionHandler:testBlock]);

    [self.subject application:self.appMock
   handleActionWithIdentifier:@"actionId"
         forLocalNotification:notification
            completionHandler:testBlock];
    
    OCMVerifyAll(self.dispatcherMock);
}

- (void)testHandleActionWithResponseDispatchesWhenOriginalDelegateNotImplemented {
    UILocalNotification *notification = self.notification;
    NSDictionary *response = @{};
    id savedDelegateMock = OCMPartialMock([StubAppDelegate new]);
    void (^testBlock)(void) = ^{};

    OCMExpect([self.dispatcherMock dispatchDidReceiveNotificationWithActionId:@"actionId"
                                                                     userInfo:notification.userInfo
                                                            completionHandler:testBlock]);

    self.subject.dispatcher = self.dispatcherMock;
    self.subject.originalDelegate = savedDelegateMock;
    [self.subject application:self.appMock
   handleActionWithIdentifier:@"actionId"
         forLocalNotification:notification
             withResponseInfo:response
            completionHandler:testBlock];

    OCMVerifyAll(self.dispatcherMock);
    OCMVerifyAll(savedDelegateMock);
}

- (void)testHandleActionWithResponseDispatchesIfOriginalDelegateCallsCompleteHandler {
    UILocalNotification *notification = self.notification;
    NSDictionary *response = @{};
    void (^testBlock)(void) = ^{};

    OCMExpect([self.appDelegateMock application:self.appMock
                     handleActionWithIdentifier:@"actionId"
                           forLocalNotification:notification
                               withResponseInfo:response
                              completionHandler:[OCMArg invokeBlock]]);
    OCMExpect([self.dispatcherMock dispatchDidReceiveNotificationWithActionId:@"actionId"
                                                                     userInfo:notification.userInfo
                                                            completionHandler:testBlock]);

    self.subject.dispatcher = self.dispatcherMock;
    self.subject.originalDelegate = self.appDelegateMock;
    [self.subject application:self.appMock
   handleActionWithIdentifier:@"actionId"
         forLocalNotification:notification
             withResponseInfo:response
            completionHandler:testBlock];

    OCMVerifyAll(self.dispatcherMock);
    OCMVerifyAll(self.appDelegateMock);
}

- (void)testHandleActionWithResponseDoesNotDispatchIfOriginalDelegateDoesNotCallBlock {
    UILocalNotification *notification = self.notification;
    NSDictionary *response = @{};
    void (^testBlock)(void) = ^{};

    OCMExpect([self.appDelegateMock application:self.appMock
                     handleActionWithIdentifier:@"actionId"
                           forLocalNotification:notification
                               withResponseInfo:response
                              completionHandler:[OCMArg any]]);
    OCMReject([self.dispatcherMock dispatchDidReceiveNotificationWithActionId:[OCMArg any]
                                                                     userInfo:[OCMArg any]
                                                            completionHandler:[OCMArg any]]);

    self.subject.dispatcher = self.dispatcherMock;
    self.subject.originalDelegate = self.appDelegateMock;
    [self.subject application:self.appMock
   handleActionWithIdentifier:@"actionId"
         forLocalNotification:notification
             withResponseInfo:response
            completionHandler:testBlock];

    OCMVerifyAll(self.dispatcherMock);
    OCMVerifyAll(self.appDelegateMock);
}

- (void)testHandleActionWithResponseCanDispatchMoreThanOnce {
    UILocalNotification *notification = self.notification;
    NSDictionary *response = @{};
    id savedDelegateMock = OCMPartialMock([StubAppDelegate new]);
    void (^testBlock)(void) = ^{};

    self.subject.dispatcher = self.dispatcherMock;
    self.subject.originalDelegate = savedDelegateMock;
    [self.subject application:self.appMock
   handleActionWithIdentifier:@"actionId"
         forLocalNotification:notification
            completionHandler:testBlock];


    OCMExpect([self.dispatcherMock dispatchDidReceiveNotificationWithActionId:@"actionId"
                                                                     userInfo:notification.userInfo
                                                            completionHandler:testBlock]);

    [self.subject application:self.appMock
   handleActionWithIdentifier:@"actionId"
         forLocalNotification:notification
             withResponseInfo:response
            completionHandler:testBlock];
    
    OCMVerifyAll(self.dispatcherMock);
}

- (JKNotificationListenerSharedTests *)sharedTests {
    return [[JKNotificationListenerSharedTests alloc] initWithSubject:self.subject dispatcher:self.dispatcherMock];
}

- (void)testCheckForNotificationActionDispatchesIfUserInfoWasCached {
    [[self sharedTests] checkForNotificationActionDispatchesIfUserInfoWasCached];
}

- (void)testCheckForNotificationActionDoesNotDispatchIfUserInfoIsNil {
    [[self sharedTests] checkForNotificationActionDoesNotDispatchIfUserInfoIsNil];
}

- (void)testCheckForNotificationActionOnlyOnce {
    [[self sharedTests] checkForNotificationActionOnlyOnce];
}

- (void)testDidRegisterUserNotificationSettingsDelegatesIfImplemented {
    UIUserNotificationType types = UIUserNotificationTypeAlert | UIUserNotificationTypeBadge;
    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:types
                                                                             categories:nil];

    OCMExpect([self.appDelegateMock application:self.appMock
            didRegisterUserNotificationSettings:settings]);

    self.subject.originalDelegate = self.appDelegateMock;
    [self.subject application:self.appMock didRegisterUserNotificationSettings:settings];

    OCMVerifyAll(self.appDelegateMock);
}

- (void)testDidRegisterUserNotificationSettingsDelegatesToAuthorizationListener {
    UIUserNotificationType types = UIUserNotificationTypeAlert | UIUserNotificationTypeBadge;
    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:types
                                                                             categories:nil];

    id authorizationDelegateMock = OCMProtocolMock(@protocol(JKNotificationAuthorizationListenerDelegate));
    self.subject.authorizationDelegate = authorizationDelegateMock;

    OCMExpect([authorizationDelegateMock notificationListener:self.subject
                          didRegisterUserNotificationSettings:settings]);

    [self.subject application:self.appMock didRegisterUserNotificationSettings:settings];

    OCMVerifyAll(self.dispatcherMock);
}

@end
