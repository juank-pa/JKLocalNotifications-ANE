//
//  JKNotificationListener.m
//  LocalNotificationLib
//
//  Created by Juan Carlos Pazmino on 9/30/17.
//
//

#import <UIKit/UIKit.h>
#import "JKNotificationListener.h"
#import "Constants.h"
#import "FlashRuntimeExtensions+Private.h"

@implementation JKNotificationListener

@synthesize delegate = _delegate;

- (void)checkForNotificationAction {
    UILocalNotification *localNotification = [self localNotificationFromLaunchOptions];
    [self dispatchDidReceiveNotificationWithUserInfo:localNotification.userInfo];
}

- (UILocalNotification *)localNotificationFromLaunchOptions {
    NSDictionary *launchOptions = FRPE_getApplicationLaunchOptions();
    return [launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];
}

- (void)dispatchDidReceiveNotificationWithUserInfo:(NSDictionary *)userInfo {
    if(!userInfo) { return; }
    _notificationCode = userInfo[JK_NOTIFICATION_CODE_KEY];
    _notificationData = userInfo[JK_NOTIFICATION_DATA_KEY];

    if ([self.delegate respondsToSelector:@selector(didReceiveNotificationDataForNotificationListener:)]) {
        [self.delegate didReceiveNotificationDataForNotificationListener:self];
    }
}

@end
