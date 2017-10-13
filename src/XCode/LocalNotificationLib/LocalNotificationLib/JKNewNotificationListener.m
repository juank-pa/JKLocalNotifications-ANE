//
//  JKNewNotificationListener.m
//  LocalNotificationLib
//
//  Created by Juan Carlos Pazmino on 9/30/17.
//
//

#import <UserNotifications/UserNotifications.h>
#import "JKNewNotificationListener.h"
#import "JKNewLocalNotificationFactory.h"
#import "Constants.h"

@interface JKNotificationListener ()<UNUserNotificationCenterDelegate>
@property (nonatomic, strong) id savedDelegate;
- (void)dispatchDidReceiveNotificationWithUserInfo:(NSDictionary *)userInfo;
@end

@interface JKNewNotificationListener ()
@property (nonatomic, strong) JKNewLocalNotificationFactory *factory;
@end

@implementation JKNewNotificationListener

@dynamic savedDelegate;

- (instancetype)initWithFactory:(JKNewLocalNotificationFactory *)factory {
    if (self = [super initWithTarget:factory.notificationCenter.delegate]) {
        _factory = factory;
        _factory.notificationCenter.delegate = self;
    }
    return self;
}

- (void)dealloc {
    self.factory.notificationCenter.delegate = self.savedDelegate;
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler {
    if ([self.savedDelegate respondsToSelector:@selector(userNotificationCenter:didReceiveNotificationResponse:withCompletionHandler:)]) {
        [self.savedDelegate userNotificationCenter:center willPresentNotification:notification withCompletionHandler:^(UNNotificationPresentationOptions options){
            [self handleNotification:notification withCompletionHandler:completionHandler options:options];
        }];
        return;
    }

    [self handleNotification:notification withCompletionHandler:completionHandler options:UNNotificationPresentationOptionNone];
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    if ([self.savedDelegate respondsToSelector:@selector(userNotificationCenter:didReceiveNotificationResponse:withCompletionHandler:)]) {
        [self.savedDelegate userNotificationCenter:center didReceiveNotificationResponse:response withCompletionHandler:^{
            [self handleResponse:response withCompletionHandler:completionHandler];
        }];
        return;
    }

    [self handleResponse:response withCompletionHandler:completionHandler];
}

- (void)handleNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler options:(UNNotificationPresentationOptions)options {
    NSDictionary *userInfo = notification.request.content.userInfo;
    [self dispatchDidReceiveNotificationWithUserInfo:userInfo];
    completionHandler(UNNotificationPresentationOptionNone);
}

- (void)handleResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    NSDictionary *userInfo = response.notification.request.content.userInfo;
    [self dispatchDidReceiveNotificationWithUserInfo:userInfo];
    completionHandler();
}

@end
