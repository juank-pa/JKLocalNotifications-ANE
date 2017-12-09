//
//  JKLegacyNotificationSettingsBuilder.m
//  LocalNotificationLib
//
//  Created by Juan Carlos Pazmino on 11/28/17.
//
//

#import "JKLegacyNotificationSettingsBuilder.h"
#import "JKLegacyCategoryBuilder.h"
#import "NSArray+HigherOrder.h"

@implementation JKLegacyNotificationSettingsBuilder

- (UIUserNotificationSettings *)buildFromSettings:(JKLocalNotificationSettings *)settings {
    NSSet<UIUserNotificationCategory *> *categories =
        [[JKLegacyCategoryBuilder new] buildFromCategories:settings.categories];
    return [UIUserNotificationSettings settingsForTypes:settings.notificationTypes
                                             categories:categories];
}

@end
