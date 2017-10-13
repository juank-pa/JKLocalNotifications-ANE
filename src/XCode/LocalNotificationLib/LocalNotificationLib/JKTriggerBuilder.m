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
            [self dateComponentsFromDate:date];
            break;
        case JKCalendarUnitYear:
            return [self yearlyIntervalFromDate:date];
            break;
        case JKCalendarUnitMonth:
            return [self monthlyIntervalFromDate:date];
            break;
        case JKCalendarUnitDay:
            return [self dailyIntervalFromDate:date];
            break;
        case JKCalendarUnitHour:
            return [self dailyIntervalFromDate:date];
            break;
        case JKCalendarUnitMinute:
            return [self minuteIntervalFromDate:date];
            break;
        case JKCalendarUnitWeekday:
            return [self dailyIntervalFromDate:date];
            break;
        case JKCalendarUnitWeekOfYear:
            return [self weekOfYearIntervalFromDate:date];
            break;
        default:
            break;
    }

    return nil;
}

- (NSDateComponents *)dateComponentsFromDate:(NSDate *)date {
    return [self components: NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond fromDate:date];
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
    return [self components: NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond fromDate:date];
}

- (NSDateComponents *)weekOfYearIntervalFromDate:(NSDate *)date {
    return [self components: NSCalendarUnitWeekOfYear | NSCalendarUnitWeekday | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond fromDate:date];
}

- (NSDateComponents *)yearlyIntervalFromDate:(NSDate *)date {
    return [self components: NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond fromDate:date];
}

- (NSDateComponents *)components:(NSCalendarUnit)components fromDate:(NSDate *)date {
    NSCalendar *gregorianCalendar = [NSCalendar currentCalendar];
    return [gregorianCalendar components:components fromDate:date];
}

@end
