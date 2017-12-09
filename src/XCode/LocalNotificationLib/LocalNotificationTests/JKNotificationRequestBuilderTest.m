//
//  JKNotificationBuilderTest.m
//  LocalNotificationLib
//
//  Created by Juan Carlos Pazmino on 10/11/17.
//
//

#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>
#import "JKLocalNotification.h"
#import "JKNotificationRequestBuilder.h"
#import "JKNewTestCase.h"
#import "JKTriggerBuilder.h"

@interface JKNotificationRequestBuilderTest : JKNewTestCase
@property (nonatomic, strong) JKLocalNotification *notification;
@property (nonatomic, strong) UNNotificationRequest *notificationRequest;
@property (nonatomic, strong) JKNotificationRequestBuilder *subject;
@end

@implementation JKNotificationRequestBuilderTest

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

    self.subject = [JKNotificationRequestBuilder new];
}

- (void)tearDown {
    [super tearDown];
}

- (void)verifyNotification {
    XCTAssertEqual(self.notification.title, self.notificationRequest.content.title);
    XCTAssertEqual(self.notification.notificationCode, self.notificationRequest.identifier);
    XCTAssertEqual(self.notification.body, self.notificationRequest.content.body);
    XCTAssertEqualObjects(@(self.notification.numberAnnotation), self.notificationRequest.content.badge);
    XCTAssertEqualObjects(self.notification.userInfo, self.notificationRequest.content.userInfo);
    XCTAssertEqual(self.notification.launchImage, self.notificationRequest.content.launchImageName);
    XCTAssertEqualObjects(self.notification.category, self.notificationRequest.content.categoryIdentifier);
}

- (void)testBuildNotification {
    self.notificationRequest = [self.subject buildFromNotification:self.notification];
    [self verifyNotification];
}

- (void)testBuildNotificationRequestWithoutSound {
    self.notification.playSound = NO;
    self.notificationRequest = [self.subject buildFromNotification:self.notification];

    XCTAssertNil(self.notificationRequest.content.sound);
    [self verifyNotification];
}

- (void)testBuildNotificationRequestWithNamedSound {
    self.notification.playSound = YES;
    self.notification.soundName = @"soundName";
    self.notificationRequest = [self.subject buildFromNotification:self.notification];

    XCTAssertEqualObjects(self.notificationRequest.content.sound, [UNNotificationSound soundNamed:@"soundName"]);
    [self verifyNotification];
}

- (void)testBuildNotificationRequestWithUnamedSound {
    self.notification.playSound = YES;
    self.notificationRequest = [self.subject buildFromNotification:self.notification];

    XCTAssertEqualObjects(self.notificationRequest.content.sound, [UNNotificationSound defaultSound]);
    [self verifyNotification];
}

- (void)testBuildNotificationRequestWithTrigger {
    id trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:NSTimeIntervalSince1970 repeats:YES];

    id triggerBuilderMock = OCMClassMock([JKTriggerBuilder class]);
    OCMStub([triggerBuilderMock builder]).andReturn(triggerBuilderMock);
    OCMExpect([triggerBuilderMock buildFromDate:self.notification.fireDate repeatInterval:self.notification.repeatInterval]).andReturn(trigger);

    self.notificationRequest = [self.subject buildFromNotification:self.notification];

    XCTAssertEqual(self.notificationRequest.trigger, trigger);
    OCMVerifyAll(triggerBuilderMock);
    [self verifyNotification];

    [triggerBuilderMock stopMocking];
}

@end
