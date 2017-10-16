//
//  JKNewLocalNotificationFactory.m
//  LocalNotificationLib
//
//  Created by Juan Carlos Pazmino on 9/30/17.
//
//

#import "JKNewLocalNotificationFactory.h"
#import "JKNewLocalNotificationAuthorizer.h"
#import "JKNewNotificationListener.h"
#import "JKLegacyLocalNotificationManager.h"
#import "JKLegacyLocalNotificationFactory.h"

@implementation JKNewLocalNotificationFactory

- (id<JKAuthorizer>)createAuthorizer {
    return [[JKNewLocalNotificationAuthorizer alloc] initWithFactory:self];
}

- (JKNotificationListener *)createListener {
    return [[JKNewNotificationListener alloc] initWithFactory:self];
}

- (JKLocalNotificationManager *)createManager {
    return [[JKLegacyLocalNotificationManager alloc] initWithFactory:[JKLegacyLocalNotificationFactory new]];
}

- (UNUserNotificationCenter *)notificationCenter {
    return [UNUserNotificationCenter currentNotificationCenter];
}

- (JKNotificationRequestBuilder *)createRequestBuilder {
    return [JKNotificationRequestBuilder new];
}

@end
