//
//  JKNotificationDispatcher.m
//  LocalNotificationLib
//
//  Created by Juan Carlos Pazmino on 12/1/17.
//
//

#import "JKNotificationDispatcher.h"
#import "Constants.h"
#import "JKNotificationListener+Private.h"

@interface JKNotificationDispatcher ()
@property (nonatomic, weak) JKNotificationListener *listener;
@end

@implementation JKNotificationDispatcher

+ (instancetype)dispatcherWithListener:(JKNotificationListener *)listener {
    return [[self alloc] initWithListener:listener];
}

- (instancetype)initWithListener:(JKNotificationListener *)listener {
    if (self = [super init]) {
        _listener = listener;
    }
    return self;
}

- (void)storeActionId:(NSString *)actionId withUserInfo:(NSDictionary *)userInfo {
    self.listener.userInfo = userInfo;
    self.listener.notificationAction = actionId;
}

- (void)dispatchDidReceiveNotificationWithUserInfo:(NSDictionary *)userInfo completionHandler:(void(^)())completionHandler {
    [self dispatchDidReceiveNotificationWithActionId:nil userInfo:userInfo completionHandler:completionHandler];
}

- (void)dispatchDidReceiveNotificationWithUserInfo:(NSDictionary *)userInfo {
    [self dispatchDidReceiveNotificationWithUserInfo:userInfo completionHandler:NULL];
}

- (void)dispatchDidReceiveNotificationWithActionId:(NSString *)actionId userInfo:(NSDictionary *)userInfo {
    [self dispatchDidReceiveNotificationWithActionId:actionId userInfo:userInfo completionHandler:NULL];
}

- (void)dispatchDidReceiveNotificationWithActionId:(NSString *)actionId userInfo:(NSDictionary *)userInfo completionHandler:(void(^)())completionHandler {
    if(!userInfo) { return; }
    self.listener.notificationCode = userInfo[JK_NOTIFICATION_CODE_KEY];
    self.listener.notificationData = userInfo[JK_NOTIFICATION_DATA_KEY];
    self.listener.notificationAction = actionId;

    if ([self.listener.delegate respondsToSelector:@selector(didReceiveNotificationDataForNotificationListener:)]) {
        [self.listener.delegate didReceiveNotificationDataForNotificationListener:self.listener];
    }
    else {
        [self storeActionId:actionId withUserInfo:userInfo];
    }
    if (completionHandler) completionHandler();
}

@end
