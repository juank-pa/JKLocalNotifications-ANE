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

@interface JKNewNotificationListener ()<UNUserNotificationCenterDelegate>
@property (nonatomic, strong) id savedDelegate;
@end

@interface JKNewNotificationListenerTest : JKNewTestCase
@property (nonatomic, strong) JKNewNotificationListener *subject;
@property (nonatomic, strong) id notificationCenterMock;
@property (nonatomic, strong) id notificationCenterDelegateMock;
@property (nonatomic, strong) id factoryMock;
@end

@implementation JKNewNotificationListenerTest

- (void)setUp {
    [super setUp];
    self.notificationCenterDelegateMock = OCMProtocolMock(@protocol(UNUserNotificationCenterDelegate));

    self.notificationCenterMock = OCMClassMock([UNUserNotificationCenter class]);
    OCMStub([self.notificationCenterMock delegate]).andReturn(self.notificationCenterDelegateMock);

    self.factoryMock = OCMClassMock([JKNewLocalNotificationFactory class]);
    OCMStub([self.factoryMock notificationCenter]).andReturn(self.notificationCenterMock);

    self.subject = [[JKNewNotificationListener alloc] initWithFactory:self.factoryMock];
}

- (void)tearDown {
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

- (void)testDidReceiveLocalNotificationForwardsInvocationAndCallsDelegate {
    NSData *data = [NSData data];
    __block bool completed = false;

    UNMutableNotificationContent *content = [UNMutableNotificationContent new];
    content.userInfo = @{JK_NOTIFICATION_CODE_KEY: @"code", JK_NOTIFICATION_DATA_KEY: data};
    UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:@"id" content:content trigger:nil];

    id responseMock = OCMClassMock([UNNotificationResponse class]);
    id notificationMock = OCMClassMock([UNNotification class]);

    OCMStub([responseMock notification]).andReturn(notificationMock);
    OCMStub([notificationMock request]).andReturn(request);

    id delegateMock = OCMProtocolMock(@protocol(JKNotificationListenerDelegate));
    OCMExpect([delegateMock didReceiveNotificationDataForNotificationListener:self.subject]);

    self.subject.delegate = delegateMock;

    OCMExpect([self.notificationCenterDelegateMock userNotificationCenter:self.notificationCenterMock didReceiveNotificationResponse:responseMock withCompletionHandler:[OCMArg invokeBlock]]);

    [self.subject userNotificationCenter:self.notificationCenterMock
          didReceiveNotificationResponse:responseMock
                   withCompletionHandler:^{
                       completed = true;
                   }];

    XCTAssert(completed);
    XCTAssertEqualObjects(self.subject.notificationCode, @"code");
    XCTAssertEqualObjects(self.subject.notificationData, data);
    OCMVerifyAll(self.notificationCenterDelegateMock);
    OCMVerifyAll(delegateMock);
}

- (void)testDidReceiveLocalNotificationForwardsCallsDelegate {
    NSData *data = [NSData data];
    __block bool completed = false;

    id savedDelegateMock = OCMPartialMock([StubCenterDelegate new]);
    UNMutableNotificationContent *content = [UNMutableNotificationContent new];
    content.userInfo = @{JK_NOTIFICATION_CODE_KEY: @"code", JK_NOTIFICATION_DATA_KEY: data};
    UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:@"id" content:content trigger:nil];

    id responseMock = OCMClassMock([UNNotificationResponse class]);
    id notificationMock = OCMClassMock([UNNotification class]);

    OCMStub([responseMock notification]).andReturn(notificationMock);
    OCMStub([notificationMock request]).andReturn(request);

    id delegateMock = OCMProtocolMock(@protocol(JKNotificationListenerDelegate));
    OCMExpect([delegateMock didReceiveNotificationDataForNotificationListener:self.subject]);

    self.subject.delegate = delegateMock;
    self.subject.savedDelegate = savedDelegateMock;

    OCMReject([savedDelegateMock userNotificationCenter:[OCMArg any] didReceiveNotificationResponse:[OCMArg any] withCompletionHandler:[OCMArg any]]);

    [self.subject userNotificationCenter:self.notificationCenterMock
          didReceiveNotificationResponse:responseMock
                   withCompletionHandler:^{
                       completed = true;
                   }];

    XCTAssert(completed);
    XCTAssertEqualObjects(self.subject.notificationCode, @"code");
    XCTAssertEqualObjects(self.subject.notificationData, data);
    OCMVerifyAll(self.notificationCenterDelegateMock);
    OCMVerifyAll(delegateMock);
}

- (void)testCheckForNotificationAction {
    id deletegateMock = OCMProtocolMock(@protocol(JKNotificationListenerDelegate));
    OCMExpect([deletegateMock didReceiveNotificationDataForNotificationListener:self.subject]);

    self.subject.delegate = deletegateMock;
    [self.subject checkForNotificationAction];

    XCTAssertEqualObjects(self.subject.notificationCode, @"NotificationCodeKey");
    XCTAssertEqualObjects(self.subject.notificationData, @"NotificationDataKey");

    OCMVerifyAll(deletegateMock);
}

@end
