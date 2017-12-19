//
//  JKLocalNotificationActionDecoder.m
//  LocalNotificationLib
//
//  Created by Juan Carlos Pazmiño on 11/27/17.
//
//

#import "JKLocalNotificationActionDecoder.h"
#import "JKTextInputLocalNotificationAction.h"
#import "JKLocalNotificationAction.h"

@implementation JKLocalNotificationActionDecoder

- (JKLocalNotificationAction *)decode {
    if (self.isTextInput)
        return [self setupTextInputAction:[JKTextInputLocalNotificationAction new]];
    return [self setupAction:[JKLocalNotificationAction new]];
}

- (JKLocalNotificationAction *)setupAction:(JKLocalNotificationAction *)action {
    action.identifier = [self decodeStringProperty:@"identifier" withDefault:nil];
    action.title = [self decodeStringProperty:@"title" withDefault:nil];
    action.background = [self decodeBoolProperty:@"isBackground" withDefault:false];
    return action;
}

- (JKTextInputLocalNotificationAction *)setupTextInputAction:(JKTextInputLocalNotificationAction *)action {
    [self setupAction:action];
    action.textInputButtonTitle = [self decodeStringProperty:@"textInputButtonTitle" withDefault:nil];
    action.textInputPlaceholder = [self decodeStringProperty:@"textInputPlaceholder" withDefault:nil];
    return action;
}

- (BOOL)isTextInput {
    return [self hasProperty:@"textInputButtonTitle"];
}

@end
