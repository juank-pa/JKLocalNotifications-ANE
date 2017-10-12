//
//  JKLocalNotificationManager.m
//  LocalNotificationLib
//
//  Created by Juan Carlos Pazmino on 10/1/17.
//
//

#import "JKLocalNotificationManager.h"
#import "Constants.h"

@implementation JKLocalNotificationManager
+ (instancetype)notificationManager {
    return [self new];
}

- (void)notify:(JKLocalNotification*)notification { }
- (void)cancel:(NSString*)notificationCode { }
- (void)cancelAll { }

@end
