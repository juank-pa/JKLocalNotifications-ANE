//
//  JKLegacyNotificationListenerTest.m
//  LocalNotificationLib
//
//  Created by Juan Carlos Pazmino on 10/3/17.
//
//

#import <OCMock/OCMock.h>
#import "Constants.h"
#import "JKLegacyTestCase.h"
#import "JKLegacyNotificationListener.h"
#import "JKLegacyLocalNotificationFactory.h"

@interface JKLegacyNotificationListener ()<UIApplicationDelegate>
@property (nonatomic, strong) id savedDelegate;
@end

@interface JKLegacyNotificationListenerTest : JKLegacyTestCase
@property (nonatomic, strong) JKLegacyNotificationListener *subject;
@property (nonatomic, strong) id factoryMock;
@property (nonatomic, strong) id appMock;
@property (nonatomic, strong) id appDelegateMock;
@end

@implementation JKLegacyNotificationListenerTest

- (void)setUp {
    [super setUp];
    self.appDelegateMock = OCMProtocolMock(@protocol(UIApplicationDelegate));
    self.appMock = OCMClassMock([UIApplication class]);
    OCMStub([self.appMock delegate]).andReturn(self.appDelegateMock);

    self.factoryMock = OCMClassMock([JKLegacyLocalNotificationFactory class]);
    OCMStub([self.factoryMock application]).andReturn(self.appMock);

    self.subject = [[JKLegacyNotificationListener alloc] initWithFactory:self.factoryMock];
}

- (void)tearDown {
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
    /*OCMExpect([self.appMock setDelegate:self.appDelegateMock]);
    @autoreleasepool {
        [JKLegacyNotificationListener new];
    }
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
    XCTAssertFalse([self.subject respondsToSelector:@selector(tableView:canEditRowAtIndexPath:)]);
    XCTAssertTrue([self.subject respondsToSelector:@selector(applicationWillTerminate:)]);
}

- (void)testDidReceiveLocalNotificationForwardsInvocation {
    UILocalNotification *notification = [UILocalNotification new];
    NSData *data = [NSData data];
    notification.userInfo = @{JK_NOTIFICATION_CODE_KEY: @"code", JK_NOTIFICATION_DATA_KEY: data};
    OCMExpect([self.appDelegateMock application:self.appMock didReceiveLocalNotification:notification]);

    [self.subject application:self.appMock didReceiveLocalNotification:notification];

    OCMVerifyAll(self.appDelegateMock);
}

- (void)testDidReceiveLocalNotificationCallsDelegate {
    UILocalNotification *notification = [UILocalNotification new];
    NSData *data = [NSData data];
    notification.userInfo = @{JK_NOTIFICATION_CODE_KEY: @"code", JK_NOTIFICATION_DATA_KEY: data};

    id deletegateMock = OCMProtocolMock(@protocol(JKNotificationListenerDelegate));
    OCMExpect([deletegateMock didReceiveNotificationDataForNotificationListener:self.subject]);

    self.subject.delegate = deletegateMock;
    [self.subject application:self.appMock didReceiveLocalNotification:notification];

    XCTAssertEqualObjects(self.subject.notificationCode, @"code");
    XCTAssertEqualObjects(self.subject.notificationData, data);

    OCMVerifyAll(deletegateMock);
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
