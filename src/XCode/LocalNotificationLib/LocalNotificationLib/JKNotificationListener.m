//
//  JKNotificationListener.m
//  LocalNotificationLib
//
//  Created by Juan Carlos Pazmino on 9/30/17.
//
//

#import <UIKit/UIKit.h>
#import "JKNotificationListener.h"
#import "JKNotificationListener+Private.h"
#import "JKNotificationDispatcher.h"
#import "Constants.h"

@interface JKNotificationListener ()
@property (nonatomic, readwrite) JKNotificationDispatcher *dispatcher;
@end

@implementation JKNotificationListener

+ (instancetype)sharedListener {
    static JKNotificationListener *_sharedInstance = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [self new];
    });
    return _sharedInstance;
}

- (instancetype)setupWithOriginalDelegate:(id<UIApplicationDelegate>)originalDelegate {
    self.originalDelegate = originalDelegate;
    return self;
}

- (instancetype)init {
    if (self = [super initWithTarget:nil]) {
        _dispatcher = [[JKNotificationDispatcher alloc] initWithListener:self];
    }
    return self;
}

- (void)checkForNotificationAction {
    if (self.userInfo == nil) return;
    [self.dispatcher dispatchDidReceiveNotificationWithActionId:self.notificationAction userInfo:self.userInfo response:self.userResponse completionHandler:^{
        self.userInfo = nil;
    }];
}

@end
