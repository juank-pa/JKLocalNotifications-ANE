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
    return [[JKNewLocalNotificationAuthorizer new] autorelease];
}

- (JKNotificationListener *)createListener {
    return [[JKNewNotificationListener new] autorelease];
}

- (JKLocalNotificationManager *)createManager {
    return [[JKLocalNotificationManager new] autorelease];
}

@end
