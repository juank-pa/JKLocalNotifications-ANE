//
//  JKLocalNotificationTest.m
//  LocalNotificationLib
//
//  Created by Juan Carlos Pazmino on 10/12/17.
//
//

#import <XCTest/XCTest.h>
#import "JKLocalNotification.h"
#import "Constants.h"

@interface JKLocalNotificationTest : XCTestCase
@property (nonatomic, strong) JKLocalNotification *subject;
@end

@implementation JKLocalNotificationTest

- (void)setUp {
    [super setUp];
    self.subject = [JKLocalNotification new];
    self.subject.notificationCode = @"code123";
}

- (void)tearDown {
    [super tearDown];
}

- (void)testNotificationWithData {
    NSData *data = [NSData dataWithBytes:"hi" length:3];
    NSDictionary *userInfo = @{JK_NOTIFICATION_CODE_KEY: @"code123",
                               JK_NOTIFICATION_DATA_KEY: data};

    self.subject.actionData = data;

    XCTAssertEqualObjects(self.subject.userInfo, userInfo);
}

- (void)testNotificationWithoutData {
    NSDictionary *userInfo = @{JK_NOTIFICATION_CODE_KEY: @"code123"};
    XCTAssertEqualObjects(self.subject.userInfo, userInfo);
}

@end
