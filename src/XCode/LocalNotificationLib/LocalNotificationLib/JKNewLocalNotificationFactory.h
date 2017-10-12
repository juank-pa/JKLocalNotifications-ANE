//
//  JKNewLocalNotificationFactory.h
//  LocalNotificationLib
//
//  Created by Juan Carlos Pazmino on 9/30/17.
//
//

#import <UserNotifications/UserNotifications.h>
#import "JKNotificationFactory.h"
#import "JKNotificationRequestBuilder.h"

@interface JKNewLocalNotificationFactory : JKNotificationFactory
@property (nonatomic, readonly) UNUserNotificationCenter *notificationCenter;
- (JKNotificationRequestBuilder *)createRequestBuilder;
@end
