//
//  JKLegacyActionBuilder.h
//  LocalNotificationLib
//
//  Created by Juan Carlos Pazmiño on 11/28/17.
//
//

#import <UIKit/UIKit.h>
#import "JKLocalNotificationAction.h"

@interface JKLegacyActionBuilder : NSObject
- (NSArray <UIUserNotificationAction *> *)buildFromActions:(NSArray <JKLocalNotificationAction *> *)actions;
- (UIUserNotificationAction *)buildFromAction:(JKLocalNotificationAction *)action;
@end
