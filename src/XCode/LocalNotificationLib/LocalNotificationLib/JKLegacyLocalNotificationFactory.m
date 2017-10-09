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
    return [[JKLegacyLocalNotificationAuthorizer new] autorelease];
}

- (JKNotificationListener *)createListener {
    return [[JKLegacyNotificationListener new] autorelease];
}

- (JKLocalNotificationManager *)createManager {
    return [[JKLegacyLocalNotificationManager new] autorelease];
}

@end
