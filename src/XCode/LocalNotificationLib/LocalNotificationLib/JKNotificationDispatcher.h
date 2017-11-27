//
//  JKNotificationDispatcher.h
//  LocalNotificationLib
//
//  Created by Juan Carlos Pazmino on 12/1/17.
//
//

#import "JKNotificationListener.h"

@interface JKNotificationDispatcher : NSObject
+ (instancetype) __unavailable new;
- (instancetype) __unavailable init;
+ (instancetype)dispatcherWithListener:(JKNotificationListener *)listener;
- (instancetype)initWithListener:(JKNotificationListener *)listener;
- (void)dispatchDidReceiveNotificationWithActionId:(NSString *)actionId userInfo:(NSDictionary *)userInfo completionHandler:(void(^)())completionHandler;
- (void)dispatchDidReceiveNotificationWithActionId:(NSString *)actionId userInfo:(NSDictionary *)userInfo;
- (void)dispatchDidReceiveNotificationWithUserInfo:(NSDictionary *)userInfo completionHandler:(void(^)())completionHandler;
- (void)dispatchDidReceiveNotificationWithUserInfo:(NSDictionary *)userInfo;
@end
