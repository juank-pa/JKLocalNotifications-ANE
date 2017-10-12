//
//  JKLegacyLocalNotificationManager.m
//  LocalNotificationLib
//
//  Created by Juan Carlos Pazmino on 10/1/17.
//
//

#import <UIKit/UIKit.h>
#import "JKLegacyLocalNotificationManager.h"
#import "JKLegacyLocalNotificationFactory.h"
#import "JKNotificationBuilder.h"

@interface JKLegacyLocalNotificationManager ()
@property (nonatomic, strong) JKLegacyLocalNotificationFactory *factory;
@end

@implementation JKLegacyLocalNotificationManager

- (instancetype)initWithFactory:(JKLegacyLocalNotificationFactory *)factory {
    if (self = [super init]) {
        _factory = factory;
    }
    return self;
}

- (void)notify:(JKLocalNotification*)notification {
    JKNotificationBuilder *notificationBuilder = [self.factory createNotificationBuilder];
    UILocalNotification *localNotification = [notificationBuilder buildFromNotification:notification];

    [self archiveNotification:localNotification withCode:notification.notificationCode];

    if (notification.fireDate != nil) {
        [self.factory.application scheduleLocalNotification:localNotification];
    }
    else {
        [self.factory.application presentLocalNotificationNow:localNotification];
    }
}

- (void)cancel:(NSString*)notificationCode {
    NSArray *notificationList = [self getNotificationList:notificationCode];
    for (UILocalNotification *notification in notificationList) {
        [self.factory.application cancelLocalNotification:notification];
    }

    if(notificationList.count > 0) {
        [self archiveNotification:nil withCode:notificationCode];
    }
}

- (void)cancelAll {
    [self.factory.application cancelAllLocalNotifications];
}

- (NSArray *)getNotificationList:(NSString*)notificationCode {
    NSString *archiveName = [NSString stringWithFormat:@"Notification_%@.archive", notificationCode];
    NSString *archivePath = [NSTemporaryDirectory() stringByAppendingPathComponent:archiveName];

    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:archivePath];

    return (fileExists? [NSKeyedUnarchiver unarchiveObjectWithFile:archivePath] : @[]);
}

- (void)archiveNotification:(UILocalNotification *)notification withCode:(NSString *)notificationCode {
    NSArray *notificationList =
      notification ? [[self getNotificationList:notificationCode] arrayByAddingObject:notification] : [NSArray array];

    NSString *archiveName = [NSString stringWithFormat:@"Notification_%@.archive", notificationCode];
    NSString *archivePath = [NSTemporaryDirectory() stringByAppendingPathComponent:archiveName];
    [NSKeyedArchiver archiveRootObject:notificationList toFile:archivePath];
}

@end
