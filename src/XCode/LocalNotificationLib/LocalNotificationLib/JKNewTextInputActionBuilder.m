//
//  JKNewTextFieldActionBuilder.m
//  LocalNotificationLib
//
//  Created by Juan Carlos Pazmiño on 12/15/17.
//

#import <UserNotifications/UserNotifications.h>
#import "JKNewTextInputActionBuilder.h"
#import "JKTextInputLocalNotificationAction.h"

@implementation JKNewTextInputActionBuilder

- (UNNotificationAction *)buildFromAction:(JKTextInputLocalNotificationAction *)action {
    return [UNTextInputNotificationAction actionWithIdentifier:action.identifier
                                                         title:action.title
                                                       options:[self optionForBackgroundMode:action.isBackground]
                                          textInputButtonTitle:action.textInputButtonTitle
                                          textInputPlaceholder:action.textInputPlaceholder];
}

@end
