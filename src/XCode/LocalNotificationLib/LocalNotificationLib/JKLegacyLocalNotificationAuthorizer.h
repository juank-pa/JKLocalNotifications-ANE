//
//  JKLegacyLocalNotificationAuthorizer.h
//  LocalNotificationLib
//
//  Created by Juan Carlos Pazmino on 9/30/17.
//
//

#import "JKAuthorizer.h"
#import "JKDelegateProxy.h"

@class JKLegacyLocalNotificationFactory;

@interface JKLegacyLocalNotificationAuthorizer : JKDelegateProxy<JKAuthorizer>
+ (instancetype) __unavailable new;
- (instancetype) __unavailable init;

- (instancetype)initWithFactory:(JKLegacyLocalNotificationFactory *)factory NS_DESIGNATED_INITIALIZER;
@end
