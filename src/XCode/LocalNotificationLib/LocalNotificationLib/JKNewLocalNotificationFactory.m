//
//  JKNewLocalNotificationFactory.m
//  LocalNotificationLib
//
//  Created by Juan Carlos Pazmino on 9/30/17.
//
//

#ifdef TEST
#import <OCMock/OCMock.h>
#endif
#import "JKNewLocalNotificationFactory.h"
#import "JKNewLocalNotificationAuthorizer.h"
#import "JKNewNotificationListener.h"
#import "JKLegacyLocalNotificationManager.h"
#import "JKLegacyLocalNotificationFactory.h"

@implementation JKNewLocalNotificationFactory
#ifdef TEST
id _centerMock;
#endif

- (id<JKAuthorizer>)createAuthorizer {
    return [[JKNewLocalNotificationAuthorizer alloc] initWithFactory:self];
}

- (JKNotificationListener *)listener {
    return JKNewNotificationListener.sharedListener;
}

- (JKLocalNotificationManager *)createManager {
    return [[JKLegacyLocalNotificationManager alloc] initWithFactory:[JKLegacyLocalNotificationFactory new]];
}

- (JKNotificationRequestBuilder *)createRequestBuilder {
    return [JKNotificationRequestBuilder new];
}

- (JKNewCategoryBuilder *)createCategoryBuilder {
    return [JKNewCategoryBuilder new];
}

- (UNUserNotificationCenter *)notificationCenter {
#ifdef TEST
    if (!_centerMock) {
        _centerMock = OCMClassMock([UNUserNotificationCenter class]);
    }
    return _centerMock;
#else
    return [UNUserNotificationCenter currentNotificationCenter];
#endif
}

@end
