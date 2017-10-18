//
//  JKNewLocalNotificationAuthorizer.h
//  LocalNotificationLib
//
//  Created by Juan Carlos Pazmino on 9/30/17.
//
//

#import "JKAuthorizer.h"
@class JKNewLocalNotificationFactory;

@interface JKNewLocalNotificationAuthorizer : NSObject<JKAuthorizer>
+ (instancetype) __unavailable new;
- (instancetype) __unavailable init;

- (instancetype)initWithFactory:(JKNewLocalNotificationFactory *)factory NS_DESIGNATED_INITIALIZER;
@end
