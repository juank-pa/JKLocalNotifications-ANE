//
//  LocalNotificationAppDelegate.m
//  LocalNotificationLib
//
//  Created by Juan Carlos Pazmino on 7/20/17.
//
//

#import "LocalNotificationAppDelegate.h"
#import "FlashRuntimeExtensions.h"
#import "FlashRuntimeExtensions+Private.h"

@implementation LocalNotificationAppDelegate

- (instancetype)initWithTargetDelegate:(id<UIApplicationDelegate>)target {
    if (self = [super init]) {
        _target = [target retain];
    }
    return self;
}

- (void)dealloc {
    [_target release];
    [super dealloc];
}

- (BOOL)respondsToSelector:(SEL)aSelector {
    return [self.target respondsToSelector:aSelector];
}

- (id)forwardingTargetForSelector:(SEL)aSelector {
    return self.target;
}

- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings {
    if ([self.target respondsToSelector:@selector(application:didRegisterUserNotificationSettings:)]) {
        [self.target application:application didRegisterUserNotificationSettings:notificationSettings];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:(NSString *)FRPE_ApplicationDidRegisterUserNotificationSettings
                                                        object:self
                                                      userInfo:@{FRPE_ApplicationDidRegisterUserNotificationSettingsKey: notificationSettings}];
}

@end
