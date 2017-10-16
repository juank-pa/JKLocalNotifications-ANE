//
//  JKLocalNotificationFactory.m
//  LocalNotificationLib
//
//  Created by Juan Carlos Pazmino on 9/30/17.
//
//

#import <UserNotifications/UserNotifications.h>
#import "JKNotificationFactory.h"
#import "JKNewLocalNotificationFactory.h"
#import "JKLegacyLocalNotificationFactory.h"
#import "Constants.h"

@implementation JKNotificationFactory

+ (BOOL)isNewAPI {
    return !![UNUserNotificationCenter class];
}

+ (instancetype)factory {
    if ([self isNewAPI]) {
        return [JKNewLocalNotificationFactory new];
    }
    return [JKLegacyLocalNotificationFactory new];
}

- (UIApplication *)application {
    return [UIApplication sharedApplication];
}

- (id<JKAuthorizer>)createAuthorizer {
    return nil;
}

- (JKNotificationListener *)createListener {
    return nil;
}

- (JKLocalNotificationManager *)createManager {
    return nil;
}

- (NSDictionary *)fetchUserInfo:(JKLocalNotification *)notification {
    NSMutableDictionary *infoDict = [NSMutableDictionary dictionaryWithCapacity:2];
    infoDict[JK_NOTIFICATION_CODE_KEY] = notification.notificationCode;

    if(notification.actionData) {
        infoDict[JK_NOTIFICATION_DATA_KEY] = notification.actionData;
    }
    return infoDict;
}

@end
