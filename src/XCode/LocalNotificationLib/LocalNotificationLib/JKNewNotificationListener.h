//
//  JKNewNotificationListener.h
//  LocalNotificationLib
//
//  Created by Juan Carlos Pazmino on 12/1/17.
//  Copyright © 2017 Juank. All rights reserved.
//

#import <UserNotifications/UserNotifications.h>
#import "JKNotificationListener.h"

@interface JKNewNotificationListener : JKNotificationListener
@property (nonatomic, strong) id<UNUserNotificationCenterDelegate>originalDelegate;
@end
