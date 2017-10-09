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
    return [[self new] autorelease];
}

- (void)notify:(JKLocalNotification*)notification { }
- (void)cancel:(NSString*)notificationCode { }
- (void)cancelAll { }

- (NSDictionary *)fetchUserInfo:(JKLocalNotification *)notification {
    NSMutableDictionary *infoDict = [NSMutableDictionary dictionaryWithCapacity:2];
    infoDict[JK_NOTIFICATION_CODE_KEY] = notification.notificationCode;

    if(notification.actionData) {
        infoDict[JK_NOTIFICATION_DATA_KEY] = notification.actionData;
    }
    return infoDict;
}
@end
