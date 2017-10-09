//
//  JKLocalNotificationManager.h
//  LocalNotificationLib
//
//  Created by Juan Carlos Pazmino on 10/1/17.
//
//

#import "JKLocalNotification.h"

@interface JKLocalNotificationManager : NSObject
+ (instancetype)notificationManager;
- (void)notify:(JKLocalNotification*)notification;
- (void)cancel:(NSString*)notificationCode;
- (void)cancelAll;
- (NSDictionary *)fetchUserInfo:(JKLocalNotification *)notification;
@end
