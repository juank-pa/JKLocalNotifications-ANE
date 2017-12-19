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
#import "JKNotificationBuilder.h"

@implementation JKLegacyLocalNotificationFactory

- (id<JKAuthorizer>)createAuthorizer {
    return [[JKLegacyLocalNotificationAuthorizer alloc] initWithFactory:self];;
}

- (JKNotificationListener *)listener {
    return JKLegacyNotificationListener.sharedListener;
}

- (JKLocalNotificationManager *)createManager {
    return [[JKLegacyLocalNotificationManager alloc] initWithFactory:self];
}

- (JKLegacyNotificationSettingsBuilder *)createSettingsBuilder {
    return [JKLegacyNotificationSettingsBuilder new];
}

- (JKNotificationBuilder *)createNotificationBuilder {
    return [JKNotificationBuilder new];
}

- (JKLegacyActionBuilder *)createActionBuilder {
    return [JKLegacyActionBuilder new];
}

- (JKLegacyTextInputActionBuilder *)createTextInputActionBuilder {
    return [JKLegacyTextInputActionBuilder new];
}

@end
