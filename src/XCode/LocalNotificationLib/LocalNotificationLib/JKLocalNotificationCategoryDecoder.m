//
//  JKLocalNotificationCategoryDecoder.m
//  LocalNotificationLib
//
//  Created by Juan Carlos Pazmiño on 11/27/17.
//
//

#import "JKLocalNotificationCategoryDecoder.h"
#import "JKLocalNotificationCategory.h"
#import "JKLocalNotificationActionDecoder.h"

@implementation JKLocalNotificationCategoryDecoder

- (JKLocalNotificationCategory *)decode {
    JKLocalNotificationCategory *category = [JKLocalNotificationCategory new];

    category.identifier = [self decodeStringProperty:@"identifier" withDefault:nil];

    JKLocalNotificationActionDecoder *actionDecoder = [JKLocalNotificationActionDecoder new];
    category.actions = [self decodeArrayProperty:@"actions" withDecoder:actionDecoder];
    category.useCustomDismissAction = [self decodeBoolProperty:@"useCustomDismissAction" withDefault:NO];

    return category;
}

@end
