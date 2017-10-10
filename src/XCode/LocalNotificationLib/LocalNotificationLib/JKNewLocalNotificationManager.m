//
//  JKNewLocalNotificationManager.m
//  LocalNotificationLib
//
//  Created by Juan Carlos Pazmino on 10/1/17.
//
//

#import <UserNotifications/UserNotifications.h>
#import "JKNewLocalNotificationManager.h"
#import "JKTriggerFactory.h"

@implementation JKNewLocalNotificationManager

- (void)notify:(JKLocalNotification*)notification {
    UNMutableNotificationContent *content = [UNMutableNotificationContent new];

    content.body = notification.body;
    content.title = notification.title;
    content.badge = @(notification.numberAnnotation);
    content.sound = [self soundForNotification:notification];
    content.userInfo = [self fetchUserInfo:notification];

    UNNotificationTrigger *trigger = [[JKTriggerFactory factory] createFromDate:notification.fireDate
                                                                 repeatInterval:(JKCalendarUnit)notification.repeatInterval];
    UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:notification.notificationCode
                                                                          content:content
                                                                          trigger:trigger];

    [[UNUserNotificationCenter currentNotificationCenter] addNotificationRequest:request withCompletionHandler:NULL];
}

- (void)cancel:(NSString*)notificationCode {
    [[UNUserNotificationCenter currentNotificationCenter] removePendingNotificationRequestsWithIdentifiers:@[notificationCode]];
}

- (void)cancelAll {
    [[UNUserNotificationCenter currentNotificationCenter] removeAllPendingNotificationRequests];
}

- (UNNotificationSound *)soundForNotification:(JKLocalNotification *)notification {
    if(!notification.playSound) { return nil; }
    return (notification.soundName.length > 0?
            [UNNotificationSound soundNamed:notification.soundName] :
            [UNNotificationSound defaultSound]);
}

@end

