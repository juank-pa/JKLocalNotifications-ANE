//
//  JKLegacyLocalNotificationAuthorizer.m
//  LocalNotificationLib
//
//  Created by Juan Carlos Pazmino on 9/30/17.
//
//

#import "JKLegacyLocalNotificationAuthorizer.h"
#import "Constants.h"
#import "JKLegacyNotificationListener.h"
#import "JKLocalNotificationSettings.h"
#import "JKLegacyLocalNotificationFactory.h"
#import "JKLegacyNotificationSettingsBuilder.h"

@interface JKLegacyLocalNotificationAuthorizer ()<JKNotificationListenerDelegate>
@property (nonatomic, weak) JKLegacyLocalNotificationFactory *factory;
@property (nonatomic, readwrite, strong) JKLocalNotificationSettings *settings;
@end

@implementation JKLegacyLocalNotificationAuthorizer

- (instancetype)initWithFactory:(JKLegacyLocalNotificationFactory *)factory {
    if (self = [super init]) {
        _factory = factory;
        _factory.listener.delegate = self;
    }
    return self;
}

@synthesize settings = _settings;
@synthesize delegate = _delegate;

- (void)notificationListener:(JKNotificationListener *)listener didRegisterUserNotificationSettings:(UIUserNotificationSettings *)settings {
    self.settings = [JKLocalNotificationSettings settingsWithUserNotificationTypes:settings.types];
    [self.delegate notificationAuthorizer:self didAuthorizeWithSettings:self.settings];
}

- (void)requestAuthorizationWithSettings:(JKLocalNotificationSettings *)settings {
    JKLegacyNotificationSettingsBuilder *builder = [self.factory createSettingsBuilder];
    [self.factory.application registerUserNotificationSettings:[builder buildFromSettings:settings]];
}

@end
