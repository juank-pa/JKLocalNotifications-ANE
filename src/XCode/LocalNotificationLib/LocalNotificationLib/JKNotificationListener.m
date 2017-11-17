//
//  JKNotificationListener.m
//  LocalNotificationLib
//
//  Created by Juan Carlos Pazmino on 9/30/17.
//
//

#import <UIKit/UIKit.h>
#import "JKNotificationListener.h"
#import "JKNotificationDispatcher.h"
#import "Constants.h"
#import "FlashRuntimeExtensions+Private.h"

@interface JKNotificationListener ()
@property (nonatomic, strong) JKNotificationDispatcher *dispatcher;
@property (nonatomic, readwrite) NSString *notificationCode;
@property (nonatomic, readwrite) NSData *notificationData;
@end

@implementation JKNotificationListener

- (instancetype)initWithTarget:(id)target {
    if (self = [super initWithTarget:target]) {
        _dispatcher = [JKNotificationDispatcher dispatcherWithListener:self];
    }
    return self;
}

@synthesize delegate = _delegate;
@synthesize notificationCode = _notificationCode;
@synthesize notificationData = _notificationData;

- (void)checkForNotificationAction {
    UILocalNotification *localNotification = [self localNotificationFromLaunchOptions];
    [self dispatchDidReceiveNotificationWithUserInfo:localNotification.userInfo];
}

- (UILocalNotification *)localNotificationFromLaunchOptions {
    NSDictionary *launchOptions = FRPE_getApplicationLaunchOptions();
    return [launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];
}

- (void)dispatchDidReceiveNotificationWithUserInfo:(NSDictionary *)userInfo {
    [self dispatchDidReceiveNotificationWithUserInfo:userInfo completionHandler:NULL];
}

- (void)dispatchDidReceiveNotificationWithUserInfo:(NSDictionary *)userInfo completionHandler:(void(^)())completionHandler {
    [self.dispatcher dispatchDidReceiveNotificationWithUserInfo:userInfo completionHandler:completionHandler];
}

@end
