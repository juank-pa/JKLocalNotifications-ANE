//
//  JKLocalNotificationActionDecoder.m
//  LocalNotificationLib
//
//  Created by Juan Carlos Pazmiño on 11/27/17.
//
//

#import "JKLocalNotificationActionDecoder.h"
#import "JKLocalNotificationAction.h"

@implementation JKLocalNotificationActionDecoder

- (JKLocalNotificationAction *)decode {
    JKLocalNotificationAction *action = [JKLocalNotificationAction new];
    action.identifier = [self decodeStringProperty:@"identifier" withDefault:nil];
    action.title = [self decodeStringProperty:@"title" withDefault:nil];
    return action;
}

@end
