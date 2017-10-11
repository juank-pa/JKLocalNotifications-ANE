//
//  JKLegacyLocalNotificationFactory.m
//  LocalNotificationLib
//
//  Created by Juan Carlos Pazmino on 9/30/17.
//
//

#import "JKLegacyLocalNotificationFactory.h"
#import "JKLegacyLocalNotificationAuthorizer.h"
#import "JKLegacyNotificationListener.h"
#import "JKLegacyLocalNotificationManager.h"

@implementation JKLegacyLocalNotificationFactory

- (id<JKAuthorizer>)createAuthorizer {
    return [[JKLegacyLocalNotificationAuthorizer alloc] initWithFactory:self];;
}

- (JKNotificationListener *)createListener {
    return [[JKLegacyNotificationListener alloc] initWithFactory:self];
}

- (JKLocalNotificationManager *)createManager {
    return [JKLegacyLocalNotificationManager new];
}

- (UIApplication *)application {
    return [UIApplication sharedApplication];
}

- (UIUserNotificationSettings *)createSettingsForTypes:(UIUserNotificationType)types {
    return [UIUserNotificationSettings settingsForTypes:types categories:nil];
}

@end
