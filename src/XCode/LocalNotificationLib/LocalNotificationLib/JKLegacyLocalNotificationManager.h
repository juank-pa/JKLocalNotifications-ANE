//
//  JKLegacyLocalNotificationManager.h
//  LocalNotificationLib
//
//  Created by Juan Carlos Pazmino on 10/1/17.
//
//

#import <Foundation/Foundation.h>
#import "JKLocalNotificationManager.h"
@class JKLegacyLocalNotificationFactory;

@interface JKLegacyLocalNotificationManager : JKLocalNotificationManager
+ (instancetype) __unavailable new;
- (instancetype) __unavailable init;
- (instancetype)initWithFactory:(JKLegacyLocalNotificationFactory *)factory NS_DESIGNATED_INITIALIZER;
@end
