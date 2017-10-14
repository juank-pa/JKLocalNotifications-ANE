//
//  JKTriggerBuilderTest.m
//  LocalNotificationLib
//
//  Created by Juan Carlos Pazmino on 10/14/17.
//
//

#import <XCTest/XCTest.h>
#import <UserNotifications/UserNotifications.h>
#import "JKTriggerBuilder.h"

@interface JKTriggerBuilderTest : XCTestCase
@property (nonatomic, strong) JKTriggerBuilder *subject;
@property (nonatomic, strong) UNCalendarNotificationTrigger *trigger;
@property (nonatomic, strong) NSDateComponents *expectedComponents;
@end

@implementation JKTriggerBuilderTest

- (void)setUp {
    [super setUp];
    self.subject = [JKTriggerBuilder new];
}

- (void)tearDown {
    [super tearDown];
}

- (void)setUpTriggerWithInterval:(JKCalendarUnit)interval {
    self.trigger = (UNCalendarNotificationTrigger *)[self.subject buildFromDate:self.testDate repeatInterval:interval];
}

- (NSDate *)testDate {
    NSDateFormatter *formatter = [NSDateFormatter new];
    formatter.dateStyle = NSDateFormatterShortStyle;
    formatter.timeStyle = NSDateFormatterShortStyle;
    return [formatter dateFromString:@"08/21/2018, 10:30 AM"];
}

- (NSDateComponents *)testComponents:(NSCalendarUnit)components {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    return [calendar components:components fromDate:self.testDate];
}

- (void)testBuildFromDateWithoutRepeatInterval {
    [self setUpTriggerWithInterval:JKCalendarUnitNone];

    XCTAssertFalse(self.trigger.repeats);
    XCTAssertEqualObjects(self.trigger.dateComponents, [self testComponents:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond]);
}

- (void)testBuildFromDateWithMinutelyInterval {
    [self setUpTriggerWithInterval:JKCalendarUnitMinute];

    XCTAssertTrue(self.trigger.repeats);
    XCTAssertEqualObjects(self.trigger.dateComponents, [self testComponents:NSCalendarUnitSecond]);
}

- (void)testBuildFromDateWithHourlyInterval {
    [self setUpTriggerWithInterval:JKCalendarUnitHour];

    XCTAssertTrue(self.trigger.repeats);
    XCTAssertEqualObjects(self.trigger.dateComponents, [self testComponents:NSCalendarUnitSecond | NSCalendarUnitMinute]);
}

- (void)testBuildFromDateWithDailyInterval {
    [self setUpTriggerWithInterval:JKCalendarUnitDay];

    XCTAssertTrue(self.trigger.repeats);
    XCTAssertEqualObjects(self.trigger.dateComponents, [self testComponents:NSCalendarUnitSecond | NSCalendarUnitMinute | NSCalendarUnitHour]);
}

- (void)testBuildFromDateWithMonthlyInterval {
    [self setUpTriggerWithInterval:JKCalendarUnitMonth];

    XCTAssertTrue(self.trigger.repeats);
    XCTAssertEqualObjects(self.trigger.dateComponents, [self testComponents:NSCalendarUnitSecond | NSCalendarUnitMinute | NSCalendarUnitHour | NSCalendarUnitDay]);
}

- (void)testBuildFromDateWithYearlyInterval {
    [self setUpTriggerWithInterval:JKCalendarUnitYear];

    XCTAssertTrue(self.trigger.repeats);
    XCTAssertEqualObjects(self.trigger.dateComponents, [self testComponents:NSCalendarUnitSecond | NSCalendarUnitMinute | NSCalendarUnitHour | NSCalendarUnitDay | NSCalendarUnitMonth]);
}

- (void)testBuildFromDateWithWeekdayInterval {
    [self setUpTriggerWithInterval:JKCalendarUnitWeekday];

    XCTAssertTrue(self.trigger.repeats);
    XCTAssertEqualObjects(self.trigger.dateComponents, [self testComponents:NSCalendarUnitSecond | NSCalendarUnitMinute | NSCalendarUnitHour]);
}

- (void)testBuildFromDateWithWeeklyInterval {
    [self setUpTriggerWithInterval:JKCalendarUnitWeekOfYear];

    XCTAssertTrue(self.trigger.repeats);
    XCTAssertEqualObjects(self.trigger.dateComponents, [self testComponents:NSCalendarUnitSecond | NSCalendarUnitMinute | NSCalendarUnitHour | NSCalendarUnitWeekday]);
}

- (void)testBuildFromDateWithWeeklyOrdinalInterval {
    [self setUpTriggerWithInterval:JKCalendarUnitWeekdayOrdinal];

    XCTAssertTrue(self.trigger.repeats);
    XCTAssertEqualObjects(self.trigger.dateComponents, [self testComponents:NSCalendarUnitSecond | NSCalendarUnitMinute | NSCalendarUnitHour | NSCalendarUnitWeekday | NSCalendarUnitWeekdayOrdinal]);
}

@end
