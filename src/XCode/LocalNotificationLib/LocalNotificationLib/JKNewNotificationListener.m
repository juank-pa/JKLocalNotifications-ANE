//
//  JKNewNotificationListener.m
//  LocalNotificationLib
//
//  Created by Juan Carlos Pazmino on 9/30/17.
//
//

#import <UserNotifications/UserNotifications.h>
#import "JKNewNotificationListener.h"
#import "Constants.h"

@interface JKNotificationListener ()<UNUserNotificationCenterDelegate>
@property (nonatomic, strong) id savedDelegate;
- (void)dispatchDidReceiveNotificationWithUserInfo:(NSDictionary *)userInfo;
@end

@implementation JKNewNotificationListener

@dynamic savedDelegate;

- (instancetype)init {
    if (self = [super initWithTarget:[UNUserNotificationCenter currentNotificationCenter].delegate]) {
        [UNUserNotificationCenter currentNotificationCenter].delegate = self;
    }
    return self;
}

- (void)dealloc {
    [UNUserNotificationCenter currentNotificationCenter].delegate = self.savedDelegate;
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

- (void)handleResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    NSDictionary *userInfo = response.notification.request.content.userInfo;
    [self dispatchDidReceiveNotificationWithUserInfo:userInfo];
    completionHandler();
}

@end
