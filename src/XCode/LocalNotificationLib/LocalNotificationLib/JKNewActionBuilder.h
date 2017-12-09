//
//  JKNewActionBuilder.h
//  LocalNotificationLib
//
//  Created by Juan Carlos Pazmiño on 11/28/17.
//
//

#import <UserNotifications/UserNotifications.h>
#import "JKLocalNotificationAction.h"

@interface JKNewActionBuilder : NSObject
- (UNNotificationAction *)buildFromAction:(JKLocalNotificationAction *)action;
- (NSArray <UNNotificationAction *> *)buildFromActions:(NSArray <JKLocalNotificationAction *> *)actions;
@end
