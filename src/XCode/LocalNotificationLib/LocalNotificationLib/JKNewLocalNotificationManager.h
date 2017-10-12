//
//  JKNewLocalNotificationManager.h
//  LocalNotificationLib
//
//  Created by Juan Carlos Pazmino on 10/1/17.
//
//

#import <Foundation/Foundation.h>
#import "JKLocalNotificationManager.h"
@class JKNewLocalNotificationFactory;

@interface JKNewLocalNotificationManager : JKLocalNotificationManager
+ (instancetype) __unavailable new;
- (instancetype) __unavailable init;
- (instancetype)initWithFactory:(JKNewLocalNotificationFactory *)factory NS_DESIGNATED_INITIALIZER;
@end

