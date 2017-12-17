//
//  JKNewActionBuilder.h
//  LocalNotificationLib
//
//  Created by Juan Carlos Pazmiño on 11/28/17.
//
//

#import <UserNotifications/UserNotifications.h>
#import "JKLocalNotificationAction.h"
#import "JKActionBuilder.h"

@interface JKNewActionBuilder : NSObject<JKActionBuilder>
+ (NSArray <UNNotificationAction *> *)buildFromActions:(NSArray <JKLocalNotificationAction *> *)actions;
- (UNNotificationAction *)buildFromAction:(JKLocalNotificationAction *)action;
- (UNNotificationActionOptions)optionForBackgroundMode:(BOOL)isBackground;
@end
