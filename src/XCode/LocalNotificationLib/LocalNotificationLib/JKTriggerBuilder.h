//
//  JKTriggerFactory.h
//  LocalNotificationLib
//
//  Created by Juan Carlos Pazmino on 10/1/17.
//
//

#import <Foundation/Foundation.h>
#import "JKCalendarUnit.h"

@interface JKTriggerBuilder : NSObject
+ (instancetype)builder;
- (UNNotificationTrigger *)buildFromDate:(NSDate *)date repeatInterval:(JKCalendarUnit)repeatInterval;
@end
