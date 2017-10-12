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
#import "JKNewLocalNotificationManager.h"

@implementation JKNewLocalNotificationFactory

- (id<JKAuthorizer>)createAuthorizer {
    return [[JKNewLocalNotificationAuthorizer alloc] initWithFactory:self];
}

- (JKNotificationListener *)createListener {
    return [[JKNewNotificationListener alloc] initWithFactory:self];
}

- (JKLocalNotificationManager *)createManager {
    return [[JKNewLocalNotificationManager alloc] initWithFactory:self];
}

- (UNUserNotificationCenter *)notificationCenter {
    return [UNUserNotificationCenter currentNotificationCenter];
}

- (JKNotificationRequestBuilder *)createRequestBuilder {
    return [JKNotificationRequestBuilder new];
}

@end
