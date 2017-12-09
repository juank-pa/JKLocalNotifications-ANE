//
//  JKLocalNotificationFactory.h
//  LocalNotificationLib
//
//  Created by Juan Carlos Pazmino on 9/30/17.
//
//

#import <UserNotifications/UserNotifications.h>
#import <UIKit/UIKit.h>
#import "JKAuthorizer.h"
#import "JKNotificationListener.h"
#import "JKLocalNotificationManager.h"

@interface JKNotificationFactory : NSObject
+ (instancetype)factory;
+ (BOOL)isNewAPI;

- (id<JKAuthorizer>)createAuthorizer;
- (JKLocalNotificationManager *)createManager;
- (NSDictionary *)fetchUserInfo:(JKLocalNotification *)notification;

@property (nonatomic, readonly) UNUserNotificationCenter *notificationCenter;
@property (nonatomic, readonly) JKNotificationListener *listener;
@property (nonatomic, readonly) UIApplication *application;
@end
