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
#import "JKNewLocalNotificationFactory.h"

@interface JKNewLocalNotificationAuthorizer ()
@property (nonatomic, weak) JKNewLocalNotificationFactory *factory;
@end

@implementation JKNewLocalNotificationAuthorizer

@synthesize settings = _settings;
@synthesize delegate = _delegate;

- (instancetype)initWithFactory:(JKNewLocalNotificationFactory *)factory {
    if (self = [super init]) {
        _factory = factory;
    }
    return self;
}

- (void)requestAuthorizationWithSettings:(JKLocalNotificationSettings *)settings {
    UNAuthorizationOptions options = settings.authorizationOptions;
    [self.factory.notificationCenter requestAuthorizationWithOptions:options completionHandler:^(BOOL granted, NSError * _Nullable error) {
        _settings = settings;
        [self.delegate notificationAuthorizer:self didAuthorizeWithSettings:self.settings];
    }];
}

@end
