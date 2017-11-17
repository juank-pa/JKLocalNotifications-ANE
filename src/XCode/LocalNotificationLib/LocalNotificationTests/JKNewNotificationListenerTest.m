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

@interface JKNewNotificationListener ()<UNUserNotificationCenterDelegate>
@property (nonatomic, strong) id savedDelegate;
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

    self.factoryMock = OCMClassMock([JKNewLocalNotificationFactory class]);
    OCMStub([self.factoryMock notificationCenter]).andReturn(self.notificationCenterMock);

    self.dispatcherMock = OCMClassMock([JKNotificationDispatcher class]);
    OCMStub([self.dispatcherMock dispatcherWithListener:[OCMArg any]]).andReturn(self.dispatcherMock);

    self.subject = [[JKNewNotificationListener alloc] initWithFactory:self.factoryMock];
}

- (void)tearDown {
    [self.dispatcherMock stopMocking];
    [super tearDown];
}

- (void)testInitialization {
    JKNewNotificationListener *subject = [JKNewNotificationListener alloc];
    XCTAssertNil(subject.savedDelegate);
    OCMExpect([self.notificationCenterMock setDelegate:subject]);
    [subject initWithFactory:self.factoryMock];

    XCTAssertEqual(subject.savedDelegate, self.notificationCenterDelegateMock);
    OCMVerifyAll(self.notificationCenterMock);
}

- (void)testDeallocation {
    StubNewFactory *factory = [StubNewFactory new];
    factory.notificationCenter.delegate = self.notificationCenterDelegateMock;
    [self.dispatcherMock stopMocking];
    @autoreleasepool {
        [[JKNewNotificationListener alloc] initWithFactory:factory];
    }
    XCTAssertEqual(factory.notificationCenter.delegate, self.notificationCenterDelegateMock);
}

- (void)testForwardingTargetForSelector {
    XCTAssertEqual([self.subject forwardingTargetForSelector:NULL], self.notificationCenterDelegateMock);
}

- (void)testResponsToSelector {
    XCTAssertFalse([self.subject respondsToSelector:@selector(tableView:canEditRowAtIndexPath:)]);
    XCTAssertTrue([self.subject respondsToSelector:@selector(userNotificationCenter:willPresentNotification:withCompletionHandler:)]);
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
    OCMExpect([self.dispatcherMock dispatchDidReceiveNotificationWithUserInfo:userInfo
                                                            completionHandler:testBlock]);

    self.subject.savedDelegate = savedDelegateMock;
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
    OCMExpect([self.dispatcherMock dispatchDidReceiveNotificationWithUserInfo:userInfo
                                                            completionHandler:testBlock]);

    [self.subject userNotificationCenter:self.notificationCenterMock
          didReceiveNotificationResponse:responseMock
                   withCompletionHandler:testBlock];

    OCMVerifyAll(self.dispatcherMock);
    OCMVerifyAll(self.notificationCenterDelegateMock);
}

- (void)testDidReceiveNotificationDoesNotDispatchIfOriginalDelegateDoesNotCallIt {
    UNNotificationResponse *responseMock = self.notificationResponse;
    NSDictionary *userInfo = responseMock.notification.request.content.userInfo;
    id delegateMock = OCMProtocolMock(@protocol(JKNotificationListenerDelegate));
    void (^testBlock)() = ^{};

    OCMExpect([self.notificationCenterDelegateMock userNotificationCenter:self.notificationCenterMock
                                           didReceiveNotificationResponse:responseMock
                                                    withCompletionHandler:testBlock]);
    OCMReject([self.dispatcherMock dispatchDidReceiveNotificationWithUserInfo:userInfo
                                                            completionHandler:testBlock]);

    self.subject.delegate = delegateMock;
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

    self.subject.savedDelegate = savedDelegateMock;
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

    [self.subject userNotificationCenter:self.notificationCenterMock
                 willPresentNotification:notificationMock
                   withCompletionHandler:testBlock];

    XCTAssertTrue(blockCalled);
    XCTAssertEqual(blockParam, UNNotificationPresentationOptionNone);
    OCMVerifyAll(self.dispatcherMock);
    OCMVerifyAll(self.notificationCenterDelegateMock);
}

- (void)testWillPresentNotificationDoesNotDispatchIfOriginalDelegateDoesNotCallIt {
    UNNotification *notificationMock = self.notificationResponse.notification;
    NSDictionary *userInfo = notificationMock.request.content.userInfo;
    id delegateMock = OCMProtocolMock(@protocol(JKNotificationListenerDelegate));

    __block BOOL blockCalled = NO;
    __block int blockParam = -1;
    void (^testBlock)(UNNotificationPresentationOptions) = ^(UNNotificationPresentationOptions options){
        blockParam = options;
        blockCalled = YES;
    };

    OCMExpect([self.notificationCenterDelegateMock userNotificationCenter:self.notificationCenterMock
                                                  willPresentNotification:notificationMock
                                                    withCompletionHandler:[OCMArg any]]);
    OCMReject([self.dispatcherMock dispatchDidReceiveNotificationWithUserInfo:userInfo
                                                            completionHandler:[OCMArg any]]);

    self.subject.delegate = delegateMock;
    [self.subject userNotificationCenter:self.notificationCenterMock
                 willPresentNotification:notificationMock
                   withCompletionHandler:testBlock];

    XCTAssertFalse(blockCalled);
    OCMVerifyAll(self.dispatcherMock);
    OCMVerifyAll(self.notificationCenterDelegateMock);
}

- (void)testWillPresentNotificationDoesNotDispatchWhenOriginalDelegateNotImplementedAndNotificationShowsInForeground {
    NSDictionary *showInForegroundData = @{JK_NOTIFICATION_SHOW_IN_FOREGROUND: @(YES)};
    UNNotification *notificationMock = [self notificationResponseWithInfo:showInForegroundData].notification;
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
    OCMReject([self.dispatcherMock dispatchDidReceiveNotificationWithUserInfo:userInfo
                                                            completionHandler:[OCMArg invokeBlock]]);

    self.subject.savedDelegate = savedDelegateMock;
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
    OCMReject([self.dispatcherMock dispatchDidReceiveNotificationWithUserInfo:userInfo
                                                            completionHandler:[OCMArg invokeBlock]]);

    [self.subject userNotificationCenter:self.notificationCenterMock
                 willPresentNotification:notificationMock
                   withCompletionHandler:testBlock];

    XCTAssertTrue(blockCalled);
    XCTAssertEqual(blockParam, UNNotificationPresentationOptionAlert | UNNotificationPresentationOptionBadge | UNNotificationPresentationOptionSound);
    OCMVerifyAll(self.dispatcherMock);
    OCMVerifyAll(self.notificationCenterDelegateMock);
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
                                                            completionHandler:[OCMArg invokeBlock]]);

    [self.subject checkForNotificationAction];

    OCMVerifyAll(self.dispatcherMock);
}

@end
