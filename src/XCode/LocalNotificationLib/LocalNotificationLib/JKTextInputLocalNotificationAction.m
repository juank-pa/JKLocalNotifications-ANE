//
//  JKTextInputLocalNotificationAction.m
//  LocalNotificationLib
//
//  Created by Juan Carlos Pazmiño on 12/15/17.
//

#import "JKTextInputLocalNotificationAction.h"
#import "JKLegacyTextInputActionBuilder.h"
#import "JKNewTextInputActionBuilder.h"
#import "JKNotificationFactory.h"

@implementation JKTextInputLocalNotificationAction
- (id<JKActionBuilder>)builder {
    return [[JKNotificationFactory factory] createTextInputActionBuilder];
}
@end
