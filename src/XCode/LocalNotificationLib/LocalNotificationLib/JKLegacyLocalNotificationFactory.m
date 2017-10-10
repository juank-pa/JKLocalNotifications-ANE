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
    return [JKLegacyLocalNotificationAuthorizer new];
}

- (JKNotificationListener *)createListener {
    return [JKLegacyNotificationListener new];
}

- (JKLocalNotificationManager *)createManager {
    return [JKLegacyLocalNotificationManager new];
}

@end
