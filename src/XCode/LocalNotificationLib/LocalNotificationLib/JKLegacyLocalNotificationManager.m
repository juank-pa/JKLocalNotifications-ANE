//
//  JKLegacyLocalNotificationManager.m
//  LocalNotificationLib
//
//  Created by Juan Carlos Pazmino on 10/1/17.
//
//

#import <UIKit/UIKit.h>
#import "JKLegacyLocalNotificationManager.h"

@interface UILocalNotification (LocalNotificationManager)
+ (instancetype)localNotification;
@end

@implementation UILocalNotification (LocalNotificationManager)
+ (instancetype)localNotification {
    return [[self new] autorelease];
}
@end

@implementation JKLegacyLocalNotificationManager

- (void)notify:(JKLocalNotification*)notification {
    UILocalNotification *localNotification = [UILocalNotification localNotification];

    localNotification.fireDate = notification.fireDate;
    localNotification.timeZone = [NSTimeZone defaultTimeZone];
    localNotification.repeatInterval = (NSCalendarUnit)notification.repeatInterval;
    
    localNotification.alertBody = notification.body;
    localNotification.alertAction = notification.actionLabel;
    localNotification.hasAction = notification.hasAction;
    localNotification.soundName = [self soundNameForNotification:notification];
    localNotification.applicationIconBadgeNumber = notification.numberAnnotation;
    localNotification.userInfo = [self fetchUserInfo:notification];

    if ([localNotification respondsToSelector:@selector(setAlertTitle:)]) {
        localNotification.alertTitle = notification.title;
    }

    [self archiveNotification:localNotification withCode:notification.notificationCode];

    if (notification.fireDate != nil) {
        [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
    }
    else {
        [[UIApplication sharedApplication] presentLocalNotificationNow:localNotification];
    }
}

- (void)cancel:(NSString*)notificationCode {
    NSArray *notificationList = [self getNotificationList:notificationCode];
    for (UILocalNotification *notification in notificationList) {
        [[UIApplication sharedApplication] cancelLocalNotification:notification];
    }

    if(notificationList.count > 0) {
        [self archiveNotification:nil withCode:notificationCode];
    }
}

- (void)cancelAll {
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
}

- (NSString *)soundNameForNotification:(JKLocalNotification *)notification {
    if(!notification.playSound) { return nil; }
    return (notification.soundName.length > 0? notification.soundName : UILocalNotificationDefaultSoundName);
}

- (NSArray *)getNotificationList:(NSString*)notificationCode {
    NSString *archiveName = [NSString stringWithFormat:@"Notification_%@.archive", notificationCode];
    NSString *archivePath = [NSTemporaryDirectory() stringByAppendingPathComponent:archiveName];

    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:archivePath];

    return (fileExists? [NSKeyedUnarchiver unarchiveObjectWithFile:archivePath] : [NSArray array]);
}

-(void)archiveNotification:(UILocalNotification *)notification withCode:(NSString *)notificationCode {
    NSArray *notificationList =
      notification ? [[self getNotificationList:notificationCode] arrayByAddingObject:notification] : [NSArray array];

    NSString *archiveName = [NSString stringWithFormat:@"Notification_%@.archive", notificationCode];
    NSString *archivePath = [NSTemporaryDirectory() stringByAppendingPathComponent:archiveName];
    [NSKeyedArchiver archiveRootObject:notificationList toFile:archivePath];
}

@end
