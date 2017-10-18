//
//  JKNotificationRequestBuilder.h
//  LocalNotificationLib
//
//  Created by Juan Carlos Pazmino on 10/12/17.
//
//

#import <UserNotifications/UserNotifications.h>
#import "JKLocalNotification.h"

@interface JKNotificationRequestBuilder : NSObject
- (UNNotificationRequest *)buildFromNotification:(JKLocalNotification *)notification;
@end
