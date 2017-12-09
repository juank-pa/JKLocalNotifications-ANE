//
//  JKLocalNotificationSettingsDecoder.m
//  LocalNotificationLib
//
//  Created by Juan Carlos Pazmiño on 11/27/17.
//
//

#import "JKLocalNotificationSettingsDecoder.h"
#import "JKLocalNotificationSettings.h"
#import "JKLocalNotificationCategoryDecoder.h"

@implementation JKLocalNotificationSettingsDecoder

- (JKLocalNotificationSettings *)decode {
    JKLocalNotificationType types = [self decodeUIntProperty:@"notificationStyleFlags" withDefault:0];
    JKLocalNotificationSettings *settings =  [JKLocalNotificationSettings settingsWithLocalNotificationTypes:types];

    JKLocalNotificationCategoryDecoder *categoryDecoder = [JKLocalNotificationCategoryDecoder new];
    settings.categories = [self decodeArrayProperty:@"categories" withDecoder:categoryDecoder];

    return settings;
}

@end
