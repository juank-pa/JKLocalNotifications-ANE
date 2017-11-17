//
//  JKNotificationDispatcher.m
//  LocalNotificationLib
//
//  Created by Juan Carlos Pazmino on 11/16/17.
//
//

#import "JKNotificationDispatcher.h"
#import "JKNotificationListener.h"
#import "Constants.h"

@interface JKNotificationListener ()
@property (nonatomic, readwrite) NSString *notificationCode;
@property (nonatomic, readwrite) NSData *notificationData;
@end

@interface JKNotificationDispatcher ()
@property (nonatomic, weak) JKNotificationListener *listener;
@end

@implementation JKNotificationDispatcher

+ (instancetype)dispatcherWithListener:(JKNotificationListener *)listener {
    return [[JKNotificationDispatcher alloc] initWithListener:listener];
}

- (instancetype)initWithListener:(JKNotificationListener *)listener {
    if (self = [super init]) {
        _listener = listener;
    }
    return self;
}

- (void)dispatchDidReceiveNotificationWithUserInfo:(NSDictionary *)userInfo {
    [self dispatchDidReceiveNotificationWithUserInfo:userInfo completionHandler:NULL];
}

- (void)dispatchDidReceiveNotificationWithUserInfo:(NSDictionary *)userInfo completionHandler:(void(^)())completionHandler {
    if(!userInfo) { return; }
    self.listener.notificationCode = userInfo[JK_NOTIFICATION_CODE_KEY];
    self.listener.notificationData = userInfo[JK_NOTIFICATION_DATA_KEY];

    if ([self.listener.delegate respondsToSelector:@selector(didReceiveNotificationDataForNotificationListener:)]) {
        [self.listener.delegate didReceiveNotificationDataForNotificationListener:self.listener];
    }
    if (completionHandler) completionHandler();
}

@end
