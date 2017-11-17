//
//  JKLegacyNotificationListener.m
//  LocalNotificationLib
//
//  Created by Juan Carlos Pazmino on 7/20/17.
//
//

#import <UIKit/UIKit.h>
#import "JKLegacyNotificationListener.h"
#import "JKLegacyLocalNotificationFactory.h"
#import "JKNotificationDispatcher.h"
#import "FlashRuntimeExtensions+Private.h"
#import "Constants.h"

@interface JKNotificationListener ()<UIApplicationDelegate>
@property (nonatomic, strong) id savedDelegate;
@property (nonatomic, strong) JKNotificationDispatcher *dispatcher;
@end

@interface JKLegacyNotificationListener ()
@property (nonatomic, strong) JKLegacyLocalNotificationFactory *factory;
@end

@implementation JKLegacyNotificationListener

@dynamic savedDelegate;

- (instancetype)initWithFactory:(JKLegacyLocalNotificationFactory *)factory {
    if (self = [super initWithTarget:factory.application.delegate]) {
        _factory = factory;
        _factory.application.delegate = self;
    }
    return self;
}

- (void)dealloc {
    self.factory.application.delegate = self.savedDelegate;
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    if ([self.savedDelegate respondsToSelector:@selector(application:didReceiveLocalNotification:)]) {
        [self.savedDelegate application:application didReceiveLocalNotification:notification];
    }
    [self.dispatcher dispatchDidReceiveNotificationWithUserInfo:notification.userInfo];
}

@end
