//
//  JKLegacyNotificationListener.m
//  LocalNotificationLib
//
//  Created by Juan Carlos Pazmiño on 11/29/17.
//  Copyright © 2017 Juank. All rights reserved.
//

#import <UserNotifications/UserNotifications.h>
#import "JKLegacyNotificationListener.h"
#import "JKNotificationDispatcher.h"
#import "JKNotificationFactory.h"

@interface JKLegacyNotificationListener ()<UIApplicationDelegate>
- (void)didFinishLaunchingWithOptions:(NSDictionary *)launchOptions;
@end

@implementation JKLegacyNotificationListener

+ (void)load {
    if (JKNotificationFactory.isNewAPI) return;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(createStarterNotificationChecker:)
                                                 name:@"UIApplicationDidFinishLaunchingNotification"
                                               object:nil];
}

+ (void)createStarterNotificationChecker:(NSNotification *)notification {
    UIApplication *app = JKNotificationFactory.factory.application;
    id<UIApplicationDelegate> originalDelegate = app.delegate;
    app.delegate = [[self sharedListener] setupWithOriginalDelegate:originalDelegate];
    [self.sharedListener didFinishLaunchingWithOptions:notification.userInfo];
}

@dynamic originalDelegate;

- (void)didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    UILocalNotification *notification = launchOptions[UIApplicationLaunchOptionsLocalNotificationKey];
    [self.dispatcher dispatchDidReceiveNotificationWithUserInfo:notification.userInfo];
}

- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings {
    if ([self.originalDelegate respondsToSelector:@selector(application:didRegisterUserNotificationSettings:)]) {
        [self.originalDelegate application:application didRegisterUserNotificationSettings:notificationSettings];
    }
    [self.authorizationDelegate notificationListener:self didRegisterUserNotificationSettings:notificationSettings];
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    if ([self.originalDelegate respondsToSelector:@selector(application:didReceiveLocalNotification:)]) {
        [self.originalDelegate application:application didReceiveLocalNotification:notification];
    }
    [self.dispatcher dispatchDidReceiveNotificationWithUserInfo:notification.userInfo];
}

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wstrict-prototypes"

- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forLocalNotification:(UILocalNotification *)notification completionHandler:(void (^)())completionHandler {
    if ([self.originalDelegate respondsToSelector:@selector(application:handleActionWithIdentifier:forLocalNotification:completionHandler:)]) {
        [self.originalDelegate application:application handleActionWithIdentifier:identifier forLocalNotification:notification completionHandler:^{
            [self.dispatcher dispatchDidReceiveNotificationWithActionId:identifier
                                                               userInfo:notification.userInfo
                                                      completionHandler:completionHandler];
        }];
        return;
    }

    [self.dispatcher dispatchDidReceiveNotificationWithActionId:identifier
                                                       userInfo:notification.userInfo
                                              completionHandler:completionHandler];
}

- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forLocalNotification:(UILocalNotification *)notification withResponseInfo:(NSDictionary *)responseInfo completionHandler:(void (^)())completionHandler {
    NSString *response = responseInfo? responseInfo[UIUserNotificationActionResponseTypedTextKey] : nil;
    if ([self.originalDelegate respondsToSelector:@selector(application:handleActionWithIdentifier:forLocalNotification:withResponseInfo:completionHandler:)]) {
        [self.originalDelegate application:application handleActionWithIdentifier:identifier forLocalNotification:notification withResponseInfo:responseInfo completionHandler:^{
            [self.dispatcher dispatchDidReceiveNotificationWithActionId:identifier
                                                               userInfo:notification.userInfo
                                                               response:response
                                                      completionHandler:completionHandler];
        }];
        return;
    }
    [self.dispatcher dispatchDidReceiveNotificationWithActionId:identifier
                                                       userInfo:notification.userInfo
                                                       response:response
                                              completionHandler:completionHandler];
}

#pragma clang diagnostic pop

@end
