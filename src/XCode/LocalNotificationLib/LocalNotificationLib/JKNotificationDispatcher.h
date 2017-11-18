//
//  JKNotificationDispatcher.h
//  LocalNotificationLib
//
//  Created by Juan Carlos Pazmino on 11/16/17.
//
//

#import <Foundation/Foundation.h>
@class JKNotificationListener;

@interface JKNotificationDispatcher : NSObject
+ (instancetype) __unavailable new;
+ (instancetype)dispatcherWithListener:(JKNotificationListener *)listener;

- (instancetype) __unavailable init;
- (instancetype) initWithListener:(JKNotificationListener *)listener;
- (void)dispatchDidReceiveNotificationWithUserInfo:(NSDictionary *)userInfo;
- (void)dispatchDidReceiveNotificationWithUserInfo:(NSDictionary *)userInfo completionHandler:(void(^)())completionHandler;
@end
