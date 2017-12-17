//
//  JKLegacyActionBuilder.h
//  LocalNotificationLib
//
//  Created by Juan Carlos Pazmiño on 11/28/17.
//
//

#import <UIKit/UIKit.h>
#import "JKLocalNotificationAction.h"
#import "JKActionBuilder.h"

@interface JKLegacyActionBuilder : NSObject<JKActionBuilder>
+ (NSArray <UIUserNotificationAction *> *)buildFromActions:(NSArray <JKLocalNotificationAction *> *)actions;
- (UIUserNotificationAction *)buildFromAction:(JKLocalNotificationAction *)action;
@end
