//
//  JKNotificationFactoryTest.m
//  LocalNotificationLib
//
//  Created by Juan Carlos Pazmino on 10/9/17.
//
//

#import <XCTest/XCTest.h>
#import <UserNotifications/UserNotifications.h>
#import "JKNotificationFactory.h"
#import "JKLegacyLocalNotificationFactory.h"
#import "JKNewLocalNotificationFactory.h"

@interface JKNotificationFactoryTest : XCTestCase
@end

@implementation JKNotificationFactoryTest

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testLegacyApiFactory {
    JKNotificationFactory *factory = [JKNotificationFactory factory];
    if([UNUserNotificationCenter class]) {
        XCTAssertEqual([factory class], [JKNewLocalNotificationFactory class]);
    }
    else {
        XCTAssertEqual([factory class], [JKLegacyLocalNotificationFactory class]);
    }
}

@end
