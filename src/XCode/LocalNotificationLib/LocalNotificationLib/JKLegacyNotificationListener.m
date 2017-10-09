//
//  JKLegacyNotificationListener.m
//  LocalNotificationLib
//
//  Created by Juan Carlos Pazmino on 7/20/17.
//
//

#import <UIKit/UIKit.h>
#import "JKLegacyNotificationListener.h"
#import "FlashRuntimeExtensions+Private.h"
#import "Constants.h"

@interface JKNotificationListener ()<UIApplicationDelegate>
@property (nonatomic, retain) id savedDelegate;
- (void)dispatchDidReceiveNotificationWithUserInfo:(NSDictionary *)userInfo;
@end

@implementation JKLegacyNotificationListener

@dynamic savedDelegate;

- (instancetype)init {
    if (self = [super initWithTarget:[UIApplication sharedApplication].delegate]) {
        [UIApplication sharedApplication].delegate = self;
    }
    return self;
}

- (void)dealloc {
    [UIApplication sharedApplication].delegate = self.savedDelegate;
    [super dealloc];
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    if ([self.savedDelegate respondsToSelector:@selector(application:didReceiveLocalNotification:)]) {
        [self.savedDelegate application:application didReceiveLocalNotification:notification];
    }
    [self dispatchDidReceiveNotificationWithUserInfo:notification.userInfo];
}

@end
