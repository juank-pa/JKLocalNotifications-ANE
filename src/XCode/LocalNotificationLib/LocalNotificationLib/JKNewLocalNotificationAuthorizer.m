//
//  JKNewLocalNotificationAuthorizer.m
//  LocalNotificationLib
//
//  Created by Juan Carlos Pazmino on 9/30/17.
//
//

#import <UserNotifications/UserNotifications.h>
#import "JKNewLocalNotificationAuthorizer.h"
#import "FlashRuntimeExtensions.h"
#import "FlashRuntimeExtensions+Private.h"
#import "JKLocalNotificationSettings.h"

@implementation JKNewLocalNotificationAuthorizer

@synthesize settings = _settings;
@synthesize delegate = _delegate;

- (void)requestAuthorizationWithSettings:(JKLocalNotificationSettings *)settings {
    UNAuthorizationOptions options = settings.authorizationOptions;
    [[UNUserNotificationCenter currentNotificationCenter] requestAuthorizationWithOptions:options completionHandler:^(BOOL granted, NSError * _Nullable error) {
        _settings = [JKLocalNotificationSettings settingswithAuthorizationOptions:options];
        [self.delegate notificationAuthorizer:self didAuthorizeWithSettings:self.settings];
    }];
}

@end
