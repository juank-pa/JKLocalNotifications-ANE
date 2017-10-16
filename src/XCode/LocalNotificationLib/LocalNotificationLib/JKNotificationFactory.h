//
//  JKLocalNotificationFactory.h
//  LocalNotificationLib
//
//  Created by Juan Carlos Pazmino on 9/30/17.
//
//

#import <UIKit/UIKit.h>
#import "JKAuthorizer.h"
#import "JKNotificationListener.h"
#import "JKLocalNotificationManager.h"

@interface JKNotificationFactory : NSObject
+ (instancetype)factory;

- (id<JKAuthorizer>)createAuthorizer;
- (JKNotificationListener *)createListener;
- (JKLocalNotificationManager *)createManager;
- (NSDictionary *)fetchUserInfo:(JKLocalNotification *)notification;

@property (nonatomic, readonly) UIApplication *application;
@end
