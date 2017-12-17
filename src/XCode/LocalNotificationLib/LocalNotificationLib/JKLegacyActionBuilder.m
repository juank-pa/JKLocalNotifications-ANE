//
//  JKLegacyActionBuilder.m
//  LocalNotificationLib
//
//  Created by Juan Carlos Pazmiño on 11/28/17.
//
//

#import "JKLegacyActionBuilder.h"
#import "NSArray+HigherOrder.h"
#import "JKTextInputLocalNotificationAction.h"

@implementation JKLegacyActionBuilder

+ (NSArray <UIUserNotificationAction *> *)buildFromActions:(NSArray <JKLocalNotificationAction *> *)actions {
    return [actions map:^UIUserNotificationAction *(JKLocalNotificationAction *action) {
        return [action.builder buildFromAction:action];
    }];
}

- (UIUserNotificationAction *)buildFromAction:(JKLocalNotificationAction *)action {
    UIMutableUserNotificationAction *nativeAction = [UIMutableUserNotificationAction new];
    [self setupNativeAction:nativeAction withAction:action];
    return nativeAction;
}

- (void)setupNativeAction:(UIMutableUserNotificationAction *)nativeAction withAction:(JKLocalNotificationAction *)action {
    nativeAction.identifier = action.identifier;
    nativeAction.title = action.title;
    nativeAction.activationMode = [self activationModeForBackground:action.isBackground];
    return;
}

- (UIUserNotificationActivationMode)activationModeForBackground:(BOOL)isBackground {
    return isBackground? UIUserNotificationActivationModeBackground : UIUserNotificationActivationModeForeground;
}

@end
