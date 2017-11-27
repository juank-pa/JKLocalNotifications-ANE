//
//  JKNotificationBuilderTest.m
//  LocalNotificationLib
//
//  Created by Juan Carlos Pazmino on 10/11/17.
//
//

#import <XCTest/XCTest.h>
#import "JKLocalNotification.h"
#import "JKNotificationBuilder.h"
#import "JKLegacyTestCase.h"

@interface JKNotificationBuilderTest : JKLegacyTestCase
@property (nonatomic, strong) JKLocalNotification *notification;
@property (nonatomic, strong) UILocalNotification *localNotification;
@property (nonatomic, strong) JKNotificationBuilder *subject;
@end

@implementation JKNotificationBuilderTest

- (void)setUp {
    [super setUp];
    self.notification = [JKLocalNotification new];
    self.notification.repeatInterval = JKCalendarUnitMonth;
    self.notification.body = @"body";
    self.notification.title = @"title";
    self.notification.actionLabel = @"actionLabel";
    self.notification.hasAction = YES;
    self.notification.numberAnnotation = 10;
    self.notification.notificationCode = @"code123";
    self.notification.launchImage = @"launchImage";
    self.notification.category = @"Category1";

    self.subject = [JKNotificationBuilder new];
}

- (void)tearDown {
    [super tearDown];
}

- (void)verifyNotification {
    XCTAssertEqual((JKCalendarUnit)self.localNotification.repeatInterval, self.notification.repeatInterval);
    XCTAssertEqual(self.localNotification.alertBody, self.notification.body);
    XCTAssertEqual(self.localNotification.alertAction, self.notification.actionLabel);
    XCTAssertEqual(self.localNotification.hasAction, self.notification.hasAction);
    XCTAssertEqual(self.localNotification.applicationIconBadgeNumber, self.notification.numberAnnotation);
    XCTAssertEqualObjects(self.localNotification.userInfo, self.notification.userInfo);
    XCTAssertEqual(self.localNotification.fireDate, self.notification.fireDate);
    XCTAssertEqual(self.localNotification.timeZone, [NSTimeZone defaultTimeZone]);
    XCTAssertEqual(self.localNotification.alertLaunchImage, self.notification.launchImage);
    XCTAssertEqual(self.localNotification.category, self.notification.category);

    if ([self.localNotification respondsToSelector:@selector(alertTitle)]) {
        XCTAssertEqual(self.localNotification.alertTitle, self.notification.title);
    }
}

- (void)testBuildNotification {
    self.localNotification = [self.subject buildFromNotification:self.notification];
    [self verifyNotification];
}

- (void)testBuildNotificationWithoutSound {
    self.notification.playSound = NO;
    self.localNotification = [self.subject buildFromNotification:self.notification];

    XCTAssertNil(self.localNotification.soundName);
    [self verifyNotification];
}

- (void)testBuildNotificationWithNamedSound {
    self.notification.playSound = YES;
    self.notification.soundName = @"soundName";
    self.localNotification = [self.subject buildFromNotification:self.notification];

    XCTAssertEqualObjects(self.localNotification.soundName, @"soundName");
    [self verifyNotification];
}

- (void)testBuildNotificationWithUnamedSound {
    self.notification.playSound = YES;
    self.localNotification = [self.subject buildFromNotification:self.notification];

    XCTAssertEqualObjects(self.localNotification.soundName, UILocalNotificationDefaultSoundName);
    [self verifyNotification];
}

@end
