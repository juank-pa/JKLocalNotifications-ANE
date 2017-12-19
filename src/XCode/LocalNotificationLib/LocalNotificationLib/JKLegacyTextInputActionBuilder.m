//
//  JKLegacyTextFieldActionBuilder.m
//  LocalNotificationLib
//
//  Created by Juan Carlos Pazmiño on 12/15/17.
//

#import "JKLegacyTextInputActionBuilder.h"
#import "JKTextInputLocalNotificationAction.h"

@interface JKLegacyActionBuilder ()
- (void)setupNativeAction:(UIMutableUserNotificationAction *)nativeAction withAction:(JKLocalNotificationAction *)action;
@end

@implementation JKLegacyTextInputActionBuilder

- (void)setupNativeAction:(UIMutableUserNotificationAction *)nativeAction withAction:(JKTextInputLocalNotificationAction *)action {
    [super setupNativeAction:nativeAction withAction:action];

    if (![nativeAction respondsToSelector:@selector(behavior)]) return;
    nativeAction.behavior = UIUserNotificationActionBehaviorTextInput;
    nativeAction.parameters = [self paremetersFromAction:action];
    return;
}

- (NSDictionary *)paremetersFromAction:(JKTextInputLocalNotificationAction *)action {
    return @{
             UIUserNotificationTextInputActionButtonTitleKey: action.textInputButtonTitle
             };
}

@end
