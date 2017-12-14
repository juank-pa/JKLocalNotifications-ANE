//
//  JKLegacyActionBuilder.m
//  LocalNotificationLib
//
//  Created by Juan Carlos Pazmiño on 11/28/17.
//
//

#import "JKLegacyActionBuilder.h"
#import "NSArray+HigherOrder.h"

@implementation JKLegacyActionBuilder

- (NSArray <UIUserNotificationAction *> *)buildFromActions:(NSArray <JKLocalNotificationAction *> *)actions {
    return [actions map:^UIUserNotificationAction *(JKLocalNotificationAction *action) {
        return [self buildFromAction:action];
    }];
}

- (UIUserNotificationAction *)buildFromAction:(JKLocalNotificationAction *)action {
    UIMutableUserNotificationAction *nativeAction = [UIMutableUserNotificationAction new];
    nativeAction.identifier = action.identifier;
    nativeAction.title = action.title;
    nativeAction.activationMode = [self activationModeForBackground:action.isBackground];
    return nativeAction;
}

- (UIUserNotificationActivationMode)activationModeForBackground:(BOOL)isBackground {
    return isBackground? UIUserNotificationActivationModeBackground : UIUserNotificationActivationModeForeground;
}

@end
