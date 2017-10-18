//
//  JKTriggerFactory.h
//  LocalNotificationLib
//
//  Created by Juan Carlos Pazmino on 10/1/17.
//
//

#import <UserNotifications/UserNotifications.h>
#import "JKTriggerBuilder.h"

@implementation JKTriggerBuilder

+ (instancetype)builder {
    return [self new];
}

- (UNNotificationTrigger *)buildFromDate:(NSDate *)date repeatInterval:(JKCalendarUnit)repeatInterval {
    if(!date) { return nil; }

    BOOL repeats = repeatInterval != JKCalendarUnitNone;

    NSDateComponents *components = [self dateComponentsFromDate:date
                                                 repeatInterval:repeatInterval];
    return [UNCalendarNotificationTrigger triggerWithDateMatchingComponents:components
                                                                    repeats:repeats];
}

- (NSDateComponents *)dateComponentsFromDate:(NSDate *)date repeatInterval:(JKCalendarUnit)repeatInterval {
    switch(repeatInterval) {
        case JKCalendarUnitNone:
            return [self dateComponentsFromDate:date];
        case JKCalendarUnitYear:
            return [self yearlyIntervalFromDate:date];
        case JKCalendarUnitMonth:
            return [self monthlyIntervalFromDate:date];
        case JKCalendarUnitDay:
            return [self dailyIntervalFromDate:date];
        case JKCalendarUnitHour:
            return [self hourlyIntervalFromDate:date];
        case JKCalendarUnitMinute:
            return [self minuteIntervalFromDate:date];
        case JKCalendarUnitWeekday:
            return [self dailyIntervalFromDate:date];
        case JKCalendarUnitWeekdayOrdinal:
            return [self weekdayOrdinalIntervalFromDate:date];
        case JKCalendarUnitWeekOfYear:
            return [self weekOfYearIntervalFromDate:date];
        default:
            break;
    }

    return nil;
}

- (NSDateComponents *)dateComponentsFromDate:(NSDate *)date {
    return [self components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond fromDate:date];
}

- (NSDateComponents *)minuteIntervalFromDate:(NSDate *)date {
    return [self components:NSCalendarUnitSecond fromDate:date];
}

- (NSDateComponents *)hourlyIntervalFromDate:(NSDate *)date {
    return [self components:NSCalendarUnitMinute | NSCalendarUnitSecond fromDate:date];
}

- (NSDateComponents *)dailyIntervalFromDate:(NSDate *)date {
    return [self components:NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond fromDate:date];
}

- (NSDateComponents *)monthlyIntervalFromDate:(NSDate *)date {
    return [self components:NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond fromDate:date];
}

- (NSDateComponents *)weekdayOrdinalIntervalFromDate:(NSDate *)date {
    return [self components:NSCalendarUnitWeekdayOrdinal | NSCalendarUnitWeekday | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond fromDate:date];
}

- (NSDateComponents *)weekOfYearIntervalFromDate:(NSDate *)date {
    return [self components:NSCalendarUnitWeekday | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond fromDate:date];
}

- (NSDateComponents *)yearlyIntervalFromDate:(NSDate *)date {
    return [self components:NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond fromDate:date];
}

- (NSDateComponents *)components:(NSCalendarUnit)components fromDate:(NSDate *)date {
    NSCalendar *gregorianCalendar = [NSCalendar currentCalendar];
    return [gregorianCalendar components:components fromDate:date];
}

@end
