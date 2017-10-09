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

@interface JKLegacyLocalNotificationAuthorizer ()<UIApplicationDelegate>
@property (nonatomic, retain) id savedDelegate;
@end

@implementation JKLegacyLocalNotificationAuthorizer

- (instancetype)init {
    if (self = [super initWithTarget:[UIApplication sharedApplication].delegate]) {
        [UIApplication sharedApplication].delegate = self;
    }
    return self;
}

@dynamic savedDelegate;
@synthesize settings = _settings;
@synthesize delegate = _delegate;

- (void)dealloc {
    [UIApplication sharedApplication].delegate = self.savedDelegate;
    [_settings release];
    [super dealloc];
}

- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(nonnull UIUserNotificationSettings *)notificationSettings {
    _settings = [JKLocalNotificationSettings settingsWithUserNotificationTypes:notificationSettings.types];
    [self.delegate notificationAuthorizer:self didAuthorizeWithSettings:self.settings];
}

- (void)requestAuthorizationWithSettings:(JKLocalNotificationSettings *)settings {
    UIUserNotificationType types = settings.notificationTypes;
    UIUserNotificationSettings *notificationSettings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
    [[UIApplication sharedApplication] registerUserNotificationSettings:notificationSettings];
}

@end
