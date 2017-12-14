//
//  JKNotificationListener.h
//  LocalNotificationLib
//
//  Created by Juan Carlos Pazmino on 9/30/17.
//
//

#import <UIKit/UIKit.h>
#import "JKDelegateProxy.h"

@class JKNotificationFactory;
@class JKNotificationListener;
@class JKNotificationDispatcher;

@protocol JKNotificationListenerDelegate<NSObject>
- (void)didReceiveNotificationDataForNotificationListener:(JKNotificationListener *)listener;
@end

@interface JKNotificationListener : JKDelegateProxy
@property (nonatomic, readonly, copy) NSString *notificationCode;
@property (nonatomic, readonly, copy) NSData *notificationData;
@property (nonatomic, readonly, copy) NSString *notificationAction;

@property (nonatomic, weak) id<JKNotificationListenerDelegate> delegate;
@property (nonatomic, strong) id originalDelegate;
@property (nonatomic, readonly) JKNotificationDispatcher *dispatcher;

+ (instancetype)sharedListener;
- (instancetype)setupWithOriginalDelegate:(id)originalDelegate;
- (void)checkForNotificationAction;
@end
