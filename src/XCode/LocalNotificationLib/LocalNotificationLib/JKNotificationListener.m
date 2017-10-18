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

@interface JKNotificationListener ()
@property (nonatomic, assign, getter=hasTriggered) BOOL triggered;
@end

@implementation JKNotificationListener

- (instancetype)initWithTarget:(id)target {
    if(self = [super initWithTarget:target]) {
        _triggered = NO;
    }
    return self;
}

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

    if (!self.hasTriggered && [self.delegate respondsToSelector:@selector(didReceiveNotificationDataForNotificationListener:)]) {
        self.triggered = YES;
        [self.delegate didReceiveNotificationDataForNotificationListener:self];
    }
}

@end
