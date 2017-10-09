//
//  JKTriggerFactory.h
//  LocalNotificationLib
//
//  Created by Juan Carlos Pazmino on 10/1/17.
//
//

#import <Foundation/Foundation.h>
#import "JKCalendarUnit.h"

@interface JKTriggerFactory : NSObject
+ (instancetype)factory;
- (UNNotificationTrigger *)createFromDate:(NSDate *)date repeatInterval:(JKCalendarUnit)repeatInterval;
@end
