//
//  JKLegacyNotificationListener.h
//  LocalNotificationLib
//
//  Created by Juan Carlos Pazmiño on 11/29/17.
//  Copyright © 2017 Juank. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JKNotificationListener.h"

@protocol JKNotificationAuthorizationListenerDelegate<NSObject>
- (void)notificationListener:(JKNotificationListener *)listener didRegisterUserNotificationSettings:(UIUserNotificationSettings *)settings;
@end

@interface JKLegacyNotificationListener : JKNotificationListener
@property (nonatomic, strong) id<UIApplicationDelegate>originalDelegate;
@property (nonatomic, weak) id<JKNotificationAuthorizationListenerDelegate>authorizationDelegate;
@end
