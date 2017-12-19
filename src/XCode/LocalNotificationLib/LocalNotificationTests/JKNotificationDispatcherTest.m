//
//  JKNotificationDispatcher.m
//  LocalNotificationLib
//
//  Created by Juan Carlos Pazmiño on 11/17/17.
//
//

#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>
#import "Constants.h"
#import "Stubs.h"
#import "JKLegacyNotificationListener.h"
#import "JKNotificationDispatcher.h"

@interface JKNotificationListener (Test)
@property (nonatomic, readwrite, strong) NSDictionary *userInfo;
@end

@interface JKNotificationDispatcherTest : XCTestCase
@property (nonatomic, strong) id delegateMock;
@property (nonatomic, strong) JKNotificationListener *listener;
@property (nonatomic, strong) JKNotificationDispatcher *subject;
@end

@implementation JKNotificationDispatcherTest

- (void)setUp {
    [super setUp];
    self.listener = [[JKNotificationListener alloc] initWithTarget:nil];
    self.delegateMock = OCMProtocolMock(@protocol(JKNotificationListenerDelegate));
    self.listener.delegate = self.delegateMock;

    self.subject = [[JKNotificationDispatcher alloc] initWithListener:self.listener];
    [self.subject dispatchDidReceiveNotificationWithUserInfo:@{}];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testDispatchDidReceiveNotificationWithoutUserInfoDoesNothing {
    [self.subject dispatchDidReceiveNotificationWithUserInfo:nil];

    XCTAssertNil(self.listener.notificationCode);
    XCTAssertNil(self.listener.notificationData);
    XCTAssertNil(self.listener.notificationAction);

    __block BOOL called = NO;
    void (^testBlock)(void) = ^{
        called = YES;
    };

    OCMReject([self.delegateMock didReceiveNotificationDataForNotificationListener:self.listener]);

    [self.subject dispatchDidReceiveNotificationWithActionId:@"actionId"
                                                    userInfo:nil
                                                    response:@"Response"
                                           completionHandler:testBlock];

    XCTAssertFalse(called);
    XCTAssertNil(self.listener.notificationCode);
    XCTAssertNil(self.listener.notificationData);
    XCTAssertNil(self.listener.notificationAction);
}

- (void)testDispatchDidReceiveNotificationWithUserInfoSetsData {
    NSData *data = [NSData data];
    NSDictionary *userInfo = @{
                               JK_NOTIFICATION_CODE_KEY: @"MyCode",
                               JK_NOTIFICATION_DATA_KEY: data
                               };
    [self.subject dispatchDidReceiveNotificationWithActionId:@"actionId"
                                                    userInfo:userInfo
                                                    response:@"Response"
                                           completionHandler:NULL];

    XCTAssertEqual(self.listener.notificationCode, @"MyCode");
    XCTAssertEqual(self.listener.notificationData, data);
    XCTAssertEqual(self.listener.notificationAction, @"actionId");
    XCTAssertEqual(self.listener.userResponse, @"Response");

    [self.subject dispatchDidReceiveNotificationWithActionId:nil
                                                    userInfo:userInfo
                                                    response:nil
                                           completionHandler:NULL];

    XCTAssertEqual(self.listener.notificationCode, @"MyCode");
    XCTAssertEqual(self.listener.notificationData, data);
    XCTAssertNil(self.listener.notificationAction);
    XCTAssertNil(self.listener.userResponse);
}

- (void)testDispatchDidReceiveNotificationWithUserInfoDelegatesIfDelegateIsNotNil {
    OCMExpect([self.delegateMock didReceiveNotificationDataForNotificationListener:self.listener]);
    [self.subject dispatchDidReceiveNotificationWithActionId:@"actionId"
                                                    userInfo:@{ }
                                           completionHandler:NULL];

    OCMVerifyAll(self.delegateMock);
}

- (void)testDispatchDidReceiveNotificationWithUserInfoCallsBlock {
    __block BOOL called = NO;
    void (^testBlock)(void) = ^{
        called = YES;
    };

    [self.subject dispatchDidReceiveNotificationWithActionId:@"actionId"
                                                    userInfo:@{ }
                                           completionHandler:testBlock];

    XCTAssertTrue(called);
    OCMVerifyAll(self.delegateMock);
}

- (void)testDispatchDidReceiveNotificationWithUserInfoCallsBlockEvenIfNoDelegate {
    __block BOOL called = NO;
    void (^testBlock)(void) = ^{
        called = YES;
    };

    self.listener.delegate = nil;
    [self.subject dispatchDidReceiveNotificationWithActionId:@"actionId"
                                                    userInfo:@{ }
                                           completionHandler:testBlock];

    XCTAssertTrue(called);
    OCMVerifyAll(self.delegateMock);
}

- (void)testDispatchDidReceiveNotificationWithUserInfoCachesDataIfThereIsNoDelegate {
    XCTAssertNil(self.listener.userInfo);

    NSDictionary *userInfo = @{};
    self.listener.delegate = nil;
    [self.subject dispatchDidReceiveNotificationWithActionId:@"actionId"
                                                    userInfo:userInfo
                                                    response:@"Response"
                                           completionHandler:NULL];

    XCTAssertEqual(self.listener.userInfo, userInfo);
}

// Test method variations
- (void)testDispatchDidReceiveNotificationWithUserInfo {
    id subject = OCMPartialMock(self.subject);
    NSDictionary *userInfo = @{};

    OCMExpect([subject dispatchDidReceiveNotificationWithActionId:nil
                                                         userInfo:userInfo
                                                         response:nil
                                                completionHandler:NULL]);

    [self.subject dispatchDidReceiveNotificationWithUserInfo:userInfo];

    OCMVerifyAll(subject);
}

- (void)testDispatchDidReceiveNotificationWithUserInfoCompletionHandler {
    id subject = OCMPartialMock(self.subject);
    void (^testBlock)(void) = ^{};
    NSDictionary *userInfo = @{};

    OCMExpect([subject dispatchDidReceiveNotificationWithActionId:nil
                                                         userInfo:userInfo
                                                         response:nil
                                                completionHandler:testBlock]);

    [self.subject dispatchDidReceiveNotificationWithUserInfo:userInfo
                                           completionHandler:testBlock];

    OCMVerifyAll(subject);
}

- (void)testDispatchDidReceiveNotificationWithActionIdUserInfoCompletionHandler {
    id subject = OCMPartialMock(self.subject);
    void (^testBlock)(void) = ^{};
    NSDictionary *userInfo = @{};

    OCMExpect([subject dispatchDidReceiveNotificationWithActionId:@"ActionId"
                                                         userInfo:userInfo
                                                         response:nil
                                                completionHandler:testBlock]);

    [self.subject dispatchDidReceiveNotificationWithActionId:@"ActionId"
                                                    userInfo:userInfo
                                           completionHandler:testBlock];

    OCMVerifyAll(subject);
}

@end
