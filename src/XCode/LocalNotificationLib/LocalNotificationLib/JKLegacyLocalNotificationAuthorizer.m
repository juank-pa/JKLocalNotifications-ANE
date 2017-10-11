//
//  JKLegacyLocalNotificationAuthorizer.m
//  LocalNotificationLib
//
//  Created by Juan Carlos Pazmino on 9/30/17.
//
//

#import "JKLegacyLocalNotificationAuthorizer.h"
#import "Constants.h"
#import "JKLocalNotificationSettings.h"
#import "JKLegacyLocalNotificationFactory.h"

@interface JKLegacyLocalNotificationAuthorizer ()<UIApplicationDelegate>
@property (nonatomic, strong) id savedDelegate;
@property (nonatomic, weak) JKLegacyLocalNotificationFactory *factory;
@end

@implementation JKLegacyLocalNotificationAuthorizer

- (instancetype)initWithFactory:(JKLegacyLocalNotificationFactory *)factory {
    if (self = [super initWithTarget:factory.application.delegate]) {
        _factory = factory;
        _factory.application.delegate = self;
    }
    return self;
}

@dynamic savedDelegate;
@synthesize settings = _settings;
@synthesize delegate = _delegate;

- (void)dealloc {
    self.factory.application.delegate = self.savedDelegate;
}

- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(nonnull UIUserNotificationSettings *)notificationSettings {
    _settings = [JKLocalNotificationSettings settingsWithUserNotificationTypes:notificationSettings.types];
    [self.delegate notificationAuthorizer:self didAuthorizeWithSettings:self.settings];
}

- (void)requestAuthorizationWithSettings:(JKLocalNotificationSettings *)settings {
    [self.factory.application registerUserNotificationSettings:[self.factory createSettingsForTypes:settings.notificationTypes]];
}

@end
