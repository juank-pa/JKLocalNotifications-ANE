//
//  JKNewLocalNotificationManager.m
//  LocalNotificationLib
//
//  Created by Juan Carlos Pazmino on 10/1/17.
//
//

#import <UserNotifications/UserNotifications.h>
#import "JKNewLocalNotificationManager.h"
#import "JKTriggerBuilder.h"
#import "JKNewLocalNotificationFactory.h"
#import "JKNotificationRequestBuilder.h"

@interface JKNewLocalNotificationManager ()
@property (nonatomic, strong) JKNewLocalNotificationFactory *factory;
@end

@implementation JKNewLocalNotificationManager

- (instancetype)initWithFactory:(JKNewLocalNotificationFactory *)factory {
    if (self = [super init]) {
        _factory = factory;
    }
    return self;
}

- (void)notify:(JKLocalNotification*)notification {
    UNNotificationRequest *request = [[self.factory createRequestBuilder] buildFromNotification:notification];
    [self.factory.notificationCenter addNotificationRequest:request withCompletionHandler:NULL];
}

- (void)cancel:(NSString*)notificationCode {
    [self.factory.notificationCenter removePendingNotificationRequestsWithIdentifiers:@[notificationCode]];
}

- (void)cancelAll {
    [self.factory.notificationCenter removeAllPendingNotificationRequests];
}

@end

