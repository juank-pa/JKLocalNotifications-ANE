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
#import "JKNotificationListener.h"
#import "JKNotificationDispatcher.h"

@interface ListenerDelegate : NSObject<JKNotificationListenerDelegate>
@end

@implementation ListenerDelegate
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
}

- (void)tearDown {
    [super tearDown];
}

- (void)testDispatchDidReceiveNotificationWithoutUserInfoDoesNothing {
    [self.subject dispatchDidReceiveNotificationWithUserInfo:nil];

    XCTAssertNil(self.listener.notificationCode);
    XCTAssertNil(self.listener.notificationData);

    __block BOOL called = NO;
    void (^testBlock)() = ^{
        called = YES;
    };

    OCMReject([self.delegateMock didReceiveNotificationDataForNotificationListener:self.listener]);

    [self.subject dispatchDidReceiveNotificationWithUserInfo:nil completionHandler:testBlock];

    XCTAssertFalse(called);
    XCTAssertNil(self.listener.notificationCode);
    XCTAssertNil(self.listener.notificationData);
}

- (void)testDispatchDidReceiveNotificationWithUserInfoSetsListener {
    NSData *data = [NSData data];
    NSDictionary *userInfo = @{
                               JK_NOTIFICATION_CODE_KEY: @"MyCode",
                               JK_NOTIFICATION_DATA_KEY: data
                               };
    [self.subject dispatchDidReceiveNotificationWithUserInfo:userInfo];

    XCTAssertEqual(self.listener.notificationCode, @"MyCode");
    XCTAssertEqual(self.listener.notificationData, data);
}

- (void)testDispatchDidReceiveNotificationWithUserInfoDelegatesIfImplemented {
    OCMExpect([self.delegateMock didReceiveNotificationDataForNotificationListener:self.listener]);
    [self.subject dispatchDidReceiveNotificationWithUserInfo:@{ }];

    OCMVerifyAll(self.delegateMock);
}

- (void)testDispatchDidReceiveNotificationWithUserInfoDoesNotDelegateIfNotImplemented {
    id delegateMock = OCMPartialMock([ListenerDelegate new]);
    self.listener.delegate = delegateMock;

    OCMReject([delegateMock didReceiveNotificationDataForNotificationListener:self.listener]);
    [self.subject dispatchDidReceiveNotificationWithUserInfo:@{ }];

    OCMVerifyAll(self.delegateMock);
}

- (void)testDispatchDidReceiveNotificationWithUserInfoAndBlockCallsBlock {
    __block BOOL called = NO;
    void (^testBlock)() = ^{
        called = YES;
    };

    [self.subject dispatchDidReceiveNotificationWithUserInfo:@{ } completionHandler:testBlock];

    XCTAssertTrue(called);
    OCMVerifyAll(self.delegateMock);
}

@end
