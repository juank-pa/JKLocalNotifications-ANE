//
//  JKLocalNotificationFactory.m
//  LocalNotificationLib
//
//  Created by Juan Carlos Pazmino on 9/30/17.
//
//

#ifdef TEST
#import <OCMock/OCMock.h>
#endif
#import <UserNotifications/UserNotifications.h>
#import "JKNotificationFactory.h"
#import "JKNewLocalNotificationFactory.h"
#import "JKLegacyLocalNotificationFactory.h"
#import "Constants.h"

@implementation JKNotificationFactory
#ifdef TEST
id _appMock;
id _centerMock;
#endif

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
#ifdef TEST
    if (!_appMock) {
        _appMock = OCMClassMock([UIApplication class]);
    }
    return _appMock;
#else
    return [UIApplication sharedApplication];
#endif
}

- (id<JKAuthorizer>)createAuthorizer {
    return nil;
}

- (JKNotificationListener *)listener {
    return nil;
}

- (JKLocalNotificationManager *)createManager {
    return nil;
}

- (UNUserNotificationCenter *)notificationCenter {
    if(!self.class.isNewAPI) return nil;
#ifdef TEST
    if (!_centerMock) {
        _centerMock = OCMClassMock([UNUserNotificationCenter class]);
    }
    return _centerMock;
#else
    return [UNUserNotificationCenter currentNotificationCenter];
#endif
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
