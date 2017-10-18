//
//  JKLocalNotificationSettings.m
//  LocalNotificationLib
//
//  Created by Juan Carlos Pazmino on 9/30/17.
//
//

#import "JKLocalNotificationSettings.h"

@implementation JKLocalNotificationSettings
{
    JKLocalNotificationType _types;
}

+ (instancetype)settingsWithUserNotificationTypes:(UIUserNotificationType)types {
    return [[self alloc] initWithUserNotificationTypes:types];
}

+ (instancetype)settingswithAuthorizationOptions:(UNAuthorizationOptions)options {
    return [[self alloc] initWithAuthorizationOptions:options];
}

+ (instancetype)settingsWithLocalNotificationTypes:(JKLocalNotificationType)options; {
    return [[self alloc] initWithLocalNotificationTypes:options];
}

- (instancetype)initWithAuthorizationOptions:(UNAuthorizationOptions)options {
    if(self = [super init]) {
        _types = (JKLocalNotificationType)(options);
    }
    return self;
}

- (instancetype)initWithUserNotificationTypes:(UIUserNotificationType)types {
    if(self = [super init]) {
        _types = (JKLocalNotificationType)(types);
    }
    return self;
}

- (instancetype)initWithLocalNotificationTypes:(JKLocalNotificationType)types {
    if(self = [super init]) {
        _types = types;
    }
    return self;
}

- (UIUserNotificationType)notificationTypes {
    return (UIUserNotificationType)self.types;
}

- (UNAuthorizationOptions)authorizationOptions {
    return (UNAuthorizationOptions)self.types;
}
@end
