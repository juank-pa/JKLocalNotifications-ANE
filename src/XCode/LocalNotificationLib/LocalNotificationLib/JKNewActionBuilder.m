//
//  JKNewActionBuilder.m
//  LocalNotificationLib
//
//  Created by Juan Carlos Pazmiño on 11/28/17.
//
//

#import "JKNewActionBuilder.h"
#import "NSArray+HigherOrder.h"
#import "JKTextInputLocalNotificationAction.h"

@implementation JKNewActionBuilder

+ (NSArray <UNNotificationAction *> *)buildFromActions:(NSArray <JKLocalNotificationAction *> *)actions {
    return [actions map:^UNNotificationAction *(JKLocalNotificationAction *action) {
        return [action.builder buildFromAction:action];
    }];
}

- (UNNotificationAction *)buildFromAction:(JKLocalNotificationAction *)action {
    return [UNNotificationAction actionWithIdentifier:action.identifier
                                                title:action.title
                                              options:[self optionForBackgroundMode:action.isBackground]];
}

- (UNNotificationActionOptions)optionForBackgroundMode:(BOOL)isBackground {
    return isBackground? UNNotificationActionOptionNone : UNNotificationActionOptionForeground;
}

@end
