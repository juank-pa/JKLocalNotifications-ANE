//
//  JKLegacyNotificationListener.h
//  LocalNotificationLib
//
//  Created by Juan Carlos Pazmino on 7/20/17.
//
//

#import "JKNotificationListener.h"

@class JKLegacyLocalNotificationFactory;

@interface JKLegacyNotificationListener : JKNotificationListener
+ (instancetype) __unavailable new;
- (instancetype) __unavailable init;

- (instancetype)initWithFactory:(JKLegacyLocalNotificationFactory *)factory NS_DESIGNATED_INITIALIZER;
@end
