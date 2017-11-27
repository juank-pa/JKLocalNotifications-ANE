//
//  JKNewNotificationListenerTest.m
//  LocalNotificationLib
//
//  Created by Juan Carlos Pazmino on 10/3/17.
//
//

#import <OCMock/OCMock.h>
#import <UserNotifications/UserNotifications.h>
#import "Stubs.h"
#import "Constants.h"
#import "JKNewTestCase.h"
#import "JKNewNotificationListener.h"
#import "JKNewLocalNotificationFactory.h"
#import "JKNotificationDispatcher.h"
#import "JKNotificationListenerSharedTests.h"

@interface JKNewNotificationListener (Test)<UNUserNotificationCenterDelegate>
@property (nonatomic, readwrite) JKNotificationDispatcher *dispatcher;
@property (nonatomic, readwrite) NSString *notificationAction;
@property (nonatomic, readwrite) NSDictionary *userInfo;
@end

@interface JKNotificationDispatcher (Test)
@property (nonatomic, readonly) JKNotificationListener *listener;
@end

@interface JKNewNotificationListenerTest : JKNewTestCase
@property (nonatomic, strong) JKNewNotificationListener *subject;
@property (nonatomic, strong) id notificationCenterMock;
@property (nonatomic, strong) id notificationCenterDelegateMock;
@property (nonatomic, strong) id factoryMock;
@property (nonatomic, strong) id dispatcherMock;
@end

@implementation JKNewNotificationListenerTest

- (void)setUp {
    [super setUp];
    self.notificationCenterDelegateMock = OCMProtocolMock(@protocol(UNUserNotificationCenterDelegate));

    self.notificationCenterMock = OCMClassMock([UNUserNotificationCenter class]);
    OCMStub([self.notificationCenterMock delegate]).andReturn(self.notificationCenterDelegateMock);

    self.factoryMock = OCMClassMock([JKNotificationFactory class]);
    OCMStub([self.factoryMock factory]).andReturn(self.factoryMock);

    self.dispatcherMock = OCMClassMock([JKNotificationDispatcher class]);
    OCMStub([self.dispatcherMock dispatcherWithListener:[OCMArg any]]).andReturn(self.dispatcherMock);

    [JKNewNotificationListener load];

    self.subject = JKNewNotificationListener.sharedListener;
}

- (void)tearDown {
    [self.factoryMock stopMocking];
    [super tearDown];
}

- (void)testClassLoad {
    OCMStub([self.factoryMock notificationCenter]).andReturn(self.notificationCenterMock);
    OCMExpect([self.notificationCenterMock setDelegate:self.subject]);

    [JKNewNotificationListener load];

    XCTAssertEqual(self.notificationCenterDelegateMock, self.subject.originalDelegate);
    OCMVerifyAll(self.notificationCenterMock);
    XCTAssertEqual([self.subject.dispatcher class], [JKNotificationDispatcher class]);
}

// Helper methods to stub a notification response
- (UNNotificationResponse *)notificationResponse {
    return [self notificationResponseWithInfo:@{}];
}

- (UNNotificationResponse *)notificationResponseWithInfo:(NSDictionary *)userInfo {
    id responseMock = OCMClassMock([UNNotificationResponse class]);
    id notificationMock = OCMClassMock([UNNotification class]);

    UNMutableNotificationContent *content = [UNMutableNotificationContent new];
    content.userInfo = userInfo;
    UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:@"id" content:content trigger:nil];

    OCMStub([responseMock actionIdentifier]).andReturn(@"actionId");
    OCMStub([responseMock notification]).andReturn(notificationMock);
    OCMStub([notificationMock request]).andReturn(request);
    return responseMock;
}

- (void)testDidReceiveNotificationDispatchesWhenOriginalDelegateNotImplemented {
    UNNotificationResponse *responseMock = self.notificationResponse;
    NSDictionary *userInfo = responseMock.notification.request.content.userInfo;
    id savedDelegateMock = OCMPartialMock([StubCenterDelegate new]);
    void (^testBlock)() = ^{};

    OCMReject([savedDelegateMock userNotificationCenter:[OCMArg any]
                         didReceiveNotificationResponse:[OCMArg any]
                                  withCompletionHandler:[OCMArg any]]);
    OCMExpect([self.dispatcherMock dispatchDidReceiveNotificationWithActionId:@"actionId"
                                                                     userInfo:userInfo
                                                            completionHandler:testBlock]);

    self.subject.dispatcher = self.dispatcherMock;
    self.subject.originalDelegate = savedDelegateMock;
    [self.subject userNotificationCenter:self.notificationCenterMock
          didReceiveNotificationResponse:responseMock
                   withCompletionHandler:testBlock];

    OCMVerifyAll(self.dispatcherMock);
    OCMVerifyAll(savedDelegateMock);
}

- (void)testDidReceiveNotificationDispatchesIfOriginalDelegateCallsCompleteHandler {
    UNNotificationResponse *responseMock = self.notificationResponse;
    NSDictionary *userInfo = responseMock.notification.request.content.userInfo;
    void (^testBlock)() = ^{};

    OCMExpect([self.notificationCenterDelegateMock userNotificationCenter:self.notificationCenterMock
                                           didReceiveNotificationResponse:responseMock
                                                    withCompletionHandler:[OCMArg invokeBlock]]);
    OCMExpect([self.dispatcherMock dispatchDidReceiveNotificationWithActionId:@"actionId"
                                                                     userInfo:userInfo
                                                            completionHandler:testBlock]);

    self.subject.dispatcher = self.dispatcherMock;
    self.subject.originalDelegate = self.notificationCenterDelegateMock;
    [self.subject userNotificationCenter:self.notificationCenterMock
          didReceiveNotificationResponse:responseMock
                   withCompletionHandler:testBlock];

    OCMVerifyAll(self.dispatcherMock);
    OCMVerifyAll(self.notificationCenterDelegateMock);
}

- (void)testDidReceiveNotificationDoesNotDispatchIfOriginalDelegateDoesNotCallBlock {
    UNNotificationResponse *responseMock = self.notificationResponse;
    void (^testBlock)() = ^{};

    OCMExpect([self.notificationCenterDelegateMock userNotificationCenter:self.notificationCenterMock
                                           didReceiveNotificationResponse:responseMock
                                                    withCompletionHandler:testBlock]);
    OCMReject([self.dispatcherMock dispatchDidReceiveNotificationWithActionId:[OCMArg any]
                                                                     userInfo:[OCMArg any]
                                                            completionHandler:[OCMArg any]]);

    self.subject.dispatcher = self.dispatcherMock;
    self.subject.originalDelegate = self.notificationCenterDelegateMock;
    [self.subject userNotificationCenter:self.notificationCenterMock
          didReceiveNotificationResponse:responseMock
                   withCompletionHandler:testBlock];

    OCMVerifyAll(self.dispatcherMock);
}

- (void)testDidReceiveNotificationCanDispatchMoreThanOnce {
    UNNotificationResponse *responseMock = self.notificationResponse;
    NSDictionary *userInfo = responseMock.notification.request.content.userInfo;
    id savedDelegateMock = OCMPartialMock([StubCenterDelegate new]);
    void (^testBlock)() = ^{};

    self.subject.dispatcher = self.dispatcherMock;
    self.subject.originalDelegate = savedDelegateMock;
    [self.subject userNotificationCenter:self.notificationCenterMock
          didReceiveNotificationResponse:responseMock
                   withCompletionHandler:testBlock];


    OCMExpect([self.dispatcherMock dispatchDidReceiveNotificationWithActionId:@"actionId"
                                                                     userInfo:userInfo
                                                            completionHandler:testBlock]);

    [self.subject userNotificationCenter:self.notificationCenterMock
          didReceiveNotificationResponse:responseMock
                   withCompletionHandler:testBlock];

    OCMVerifyAll(self.dispatcherMock);
}

- (void)testWillPresentNotificationDispatchesWhenOriginalDelegateNotImplemented {
    UNNotification *notificationMock = self.notificationResponse.notification;
    NSDictionary *userInfo = notificationMock.request.content.userInfo;
    id savedDelegateMock = OCMPartialMock([StubCenterDelegate new]);

    __block BOOL blockCalled = NO;
    __block int blockParam = -1;
    void (^testBlock)(UNNotificationPresentationOptions) = ^(UNNotificationPresentationOptions options){
        blockParam = options;
        blockCalled = YES;
    };

    OCMReject([savedDelegateMock userNotificationCenter:[OCMArg any]
                                willPresentNotification:[OCMArg any]
                                  withCompletionHandler:[OCMArg any]]);
    OCMExpect([self.dispatcherMock dispatchDidReceiveNotificationWithUserInfo:userInfo
                                                            completionHandler:[OCMArg invokeBlock]]);

    self.subject.dispatcher = self.dispatcherMock;
    self.subject.originalDelegate = savedDelegateMock;
    [self.subject userNotificationCenter:self.notificationCenterMock
                 willPresentNotification:notificationMock
                   withCompletionHandler:testBlock];

    XCTAssertTrue(blockCalled);
    XCTAssertEqual(blockParam, UNNotificationPresentationOptionNone);
    OCMVerifyAll(self.dispatcherMock);
    OCMVerifyAll(savedDelegateMock);
}

- (void)testWillPresentNotificationDispatchesIfOriginalDelegateCallsCompleteHandler {
    UNNotification *notificationMock = self.notificationResponse.notification;
    NSDictionary *userInfo = notificationMock.request.content.userInfo;

    __block BOOL blockCalled = NO;
    __block int blockParam = -1;
    void (^testBlock)(UNNotificationPresentationOptions) = ^(UNNotificationPresentationOptions options){
        blockParam = options;
        blockCalled = YES;
    };

    OCMExpect([self.notificationCenterDelegateMock userNotificationCenter:self.notificationCenterMock
                                                  willPresentNotification:notificationMock
                                                    withCompletionHandler:[OCMArg invokeBlock]]);
    OCMExpect([self.dispatcherMock dispatchDidReceiveNotificationWithUserInfo:userInfo
                                                            completionHandler:[OCMArg invokeBlock]]);

    self.subject.dispatcher = self.dispatcherMock;
    self.subject.originalDelegate = self.notificationCenterDelegateMock;
    [self.subject userNotificationCenter:self.notificationCenterMock
                 willPresentNotification:notificationMock
                   withCompletionHandler:testBlock];

    XCTAssertTrue(blockCalled);
    XCTAssertEqual(blockParam, UNNotificationPresentationOptionNone);
    OCMVerifyAll(self.dispatcherMock);
    OCMVerifyAll(self.notificationCenterDelegateMock);
}

- (void)testWillPresentNotificationDoesNotDispatchWhenOriginalDelegateNotImplementedAndNotificationShowsInForeground {
    NSDictionary *showInForegroundData = @{JK_NOTIFICATION_SHOW_IN_FOREGROUND: @(YES)};
    UNNotification *notificationMock = [self notificationResponseWithInfo:showInForegroundData].notification;
    id savedDelegateMock = OCMPartialMock([StubCenterDelegate new]);

    __block BOOL blockCalled = NO;
    __block int blockParam = -1;
    void (^testBlock)(UNNotificationPresentationOptions) = ^(UNNotificationPresentationOptions options){
        blockParam = options;
        blockCalled = YES;
    };

    OCMReject([savedDelegateMock userNotificationCenter:[OCMArg any]
                                willPresentNotification:[OCMArg any]
                                  withCompletionHandler:[OCMArg any]]);
    OCMReject([self.dispatcherMock dispatchDidReceiveNotificationWithUserInfo:[OCMArg any]
                                                            completionHandler:[OCMArg any]]);

    self.subject.dispatcher = self.dispatcherMock;
    self.subject.originalDelegate = savedDelegateMock;
    [self.subject userNotificationCenter:self.notificationCenterMock
                 willPresentNotification:notificationMock
                   withCompletionHandler:testBlock];

    XCTAssertTrue(blockCalled);
    XCTAssertEqual(blockParam, UNNotificationPresentationOptionAlert | UNNotificationPresentationOptionBadge | UNNotificationPresentationOptionSound);
    OCMVerifyAll(self.dispatcherMock);
    OCMVerifyAll(savedDelegateMock);
}

- (void)testWillPresentNotificationDoesNotDispatchIfOriginalDelegateCallsCompleteHandlerAndNotificationShowsInForeground {
    NSDictionary *showInForegroundData = @{JK_NOTIFICATION_SHOW_IN_FOREGROUND: @(YES)};
    UNNotification *notificationMock = [self notificationResponseWithInfo:showInForegroundData].notification;

    __block BOOL blockCalled = NO;
    __block int blockParam = -1;
    void (^testBlock)(UNNotificationPresentationOptions) = ^(UNNotificationPresentationOptions options){
        blockParam = options;
        blockCalled = YES;
    };

    OCMExpect([self.notificationCenterDelegateMock userNotificationCenter:self.notificationCenterMock
                                                  willPresentNotification:notificationMock
                                                    withCompletionHandler:[OCMArg invokeBlock]]);
    OCMReject([self.dispatcherMock dispatchDidReceiveNotificationWithUserInfo:[OCMArg any]
                                                            completionHandler:[OCMArg any]]);

    self.subject.dispatcher = self.dispatcherMock;
    self.subject.originalDelegate = self.notificationCenterDelegateMock;
    [self.subject userNotificationCenter:self.notificationCenterMock
                 willPresentNotification:notificationMock
                   withCompletionHandler:testBlock];

    XCTAssertTrue(blockCalled);
    XCTAssertEqual(blockParam, UNNotificationPresentationOptionAlert | UNNotificationPresentationOptionBadge | UNNotificationPresentationOptionSound);
    OCMVerifyAll(self.dispatcherMock);
    OCMVerifyAll(self.notificationCenterDelegateMock);
}

- (void)testWillPresentNotificationDoesNotDispatchIfOriginalDelegateDoesNotCallBlock {
    UNNotification *notificationMock = self.notificationResponse.notification;

    __block BOOL blockCalled = NO;
    __block int blockParam = -1;
    void (^testBlock)(UNNotificationPresentationOptions) = ^(UNNotificationPresentationOptions options){
        blockParam = options;
        blockCalled = YES;
    };

    OCMExpect([self.notificationCenterDelegateMock userNotificationCenter:self.notificationCenterMock
                                                  willPresentNotification:notificationMock
                                                    withCompletionHandler:[OCMArg any]]);
    OCMReject([self.dispatcherMock dispatchDidReceiveNotificationWithUserInfo:[OCMArg any]
                                                            completionHandler:[OCMArg any]]);

    self.subject.dispatcher = self.dispatcherMock;
    self.subject.originalDelegate = self.notificationCenterDelegateMock;
    [self.subject userNotificationCenter:self.notificationCenterMock
                 willPresentNotification:notificationMock
                   withCompletionHandler:testBlock];

    XCTAssertFalse(blockCalled);
    OCMVerifyAll(self.dispatcherMock);
    OCMVerifyAll(self.notificationCenterDelegateMock);
}

- (void)testWillPresentNotificationCanDispatchMoreThanOnce {
    UNNotification *notificationMock = self.notificationResponse.notification;
    NSDictionary *userInfo = notificationMock.request.content.userInfo;
    id savedDelegateMock = OCMPartialMock([StubCenterDelegate new]);

    __block BOOL blockCalled = NO;
    __block int blockParam = -1;
    void (^testBlock)(UNNotificationPresentationOptions) = ^(UNNotificationPresentationOptions options){
        blockParam = options;
        blockCalled = YES;
    };

    self.subject.dispatcher = self.dispatcherMock;
    self.subject.originalDelegate = savedDelegateMock;
    [self.subject userNotificationCenter:self.notificationCenterMock
                 willPresentNotification:notificationMock
                   withCompletionHandler:testBlock];

    OCMExpect([self.dispatcherMock dispatchDidReceiveNotificationWithUserInfo:userInfo
                                                            completionHandler:[OCMArg invokeBlock]]);

    [self.subject userNotificationCenter:self.notificationCenterMock
                 willPresentNotification:notificationMock
                   withCompletionHandler:testBlock];

    XCTAssertTrue(blockCalled);
    XCTAssertEqual(blockParam, UNNotificationPresentationOptionNone);
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

@end
