//
//  JKLocalNotificationDecoder.m
//  LocalNotificationLib
//
//  Created by Juan Carlos Pazmiño on 11/27/17.
//
//

#import "JKLocalNotificationDecoder.h"
#import "JKLocalNotification.h"
#import "ExtensionUtils.h"

@interface JKLocalNotificationDecoder ()
@property (nonatomic, copy) NSString *code;
@end

@implementation JKLocalNotificationDecoder

- (instancetype)initWithFREObject:(FREObject)freObject {
    if (self = [super init]) {
        _code = [ExtensionUtils getStringFromFREObject:freObject];
    }
    return self;
}

- (JKLocalNotification *)decode {
    JKLocalNotification *notification = [JKLocalNotification localNotification];

    notification.notificationCode = self.code;
    notification.fireDate = [self decodeDateProperty:@"fireDate" withDefault:[NSDate date]];
    notification.launchImage = [self decodeStringProperty:@"launchImage" withDefault:nil];
    notification.repeatInterval = [self decodeUIntProperty:@"repeatInterval" withDefault:0];
    notification.actionLabel = [self decodeStringProperty:@"actionLabel" withDefault:nil];
    notification.body = [self decodeStringProperty:@"body" withDefault:nil];
    notification.title = [self decodeStringProperty:@"title" withDefault:nil];
    notification.hasAction = [self decodeBoolProperty:@"hasAction" withDefault:YES];
    notification.numberAnnotation = [self decodeUIntProperty:@"numberAnnotation" withDefault:0];
    notification.playSound = [self decodeBoolProperty:@"playSound" withDefault:YES];
    notification.soundName = [self decodeStringProperty:@"soundName" withDefault:nil];
    notification.actionData = [self decodeDataProperty:@"actionData" withDefault:nil];
    notification.showInForeground = [self decodeBoolProperty:@"showInForeground" withDefault:NO];
    notification.category = [self decodeStringProperty:@"category" withDefault:nil];

    return notification;
}

@end
