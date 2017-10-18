//
//  JKNewNotificationListener.h
//  LocalNotificationLib
//
//  Created by Juan Carlos Pazmino on 9/30/17.
//
//

#import "JKNotificationListener.h"

@class JKNewLocalNotificationFactory;

@interface JKNewNotificationListener : JKNotificationListener
+ (instancetype) __unavailable new;
- (instancetype) __unavailable init;

- (instancetype)initWithFactory:(JKNewLocalNotificationFactory *)factory NS_DESIGNATED_INITIALIZER;
@end
