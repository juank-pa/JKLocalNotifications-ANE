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

- (id<JKAuthorizer>)createAuthorizer {
    return nil;
}

- (JKNotificationListener *)createListener {
    return nil;
}

- (JKLocalNotificationManager *)createManager {
    return nil;
}

@end
