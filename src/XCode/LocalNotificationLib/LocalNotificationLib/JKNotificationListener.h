//
//  JKNotificationListener.h
//  LocalNotificationLib
//
//  Created by Juan Carlos Pazmino on 9/30/17.
//
//

#import <Foundation/Foundation.h>
#import "JKDelegateProxy.h"

@class JKNotificationFactory;
@class JKNotificationListener;

@protocol JKNotificationListenerDelegate<NSObject>
@optional
- (void)didReceiveNotificationDataForNotificationListener:(JKNotificationListener *)listener;
@end

@interface JKNotificationListener : JKDelegateProxy
+ (instancetype) __unavailable new;
- (instancetype) __unavailable init;

@property (nonatomic, readonly) NSString *notificationCode;
@property (nonatomic, readonly) NSData *notificationData;
@property (nonatomic, weak) id<JKNotificationListenerDelegate> delegate;
- (void)checkForNotificationAction;
@end
