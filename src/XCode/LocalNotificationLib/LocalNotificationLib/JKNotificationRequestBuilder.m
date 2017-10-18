//
//  JKNotificationRequestBuilder.m
//  LocalNotificationLib
//
//  Created by Juan Carlos Pazmino on 10/12/17.
//
//

#import "JKNotificationRequestBuilder.h"
#import "JKTriggerBuilder.h"

@implementation JKNotificationRequestBuilder

- (UNNotificationSound *)soundForNotification:(JKLocalNotification *)notification {
    if(!notification.playSound) { return nil; }
    return (notification.soundName.length > 0?
            [UNNotificationSound soundNamed:notification.soundName] :
            [UNNotificationSound defaultSound]);
}

- (UNNotificationRequest *)buildFromNotification:(JKLocalNotification *)notification {
    UNMutableNotificationContent *content = [UNMutableNotificationContent new];

    content.body = notification.body;
    content.title = notification.title;
    content.badge = @(notification.numberAnnotation);
    content.sound = [self soundForNotification:notification];
    content.userInfo = notification.userInfo;

    UNNotificationTrigger *trigger = [[JKTriggerBuilder builder] buildFromDate:notification.fireDate
                                                                repeatInterval:notification.repeatInterval];
    return [UNNotificationRequest requestWithIdentifier:notification.notificationCode
                                                content:content
                                                trigger:trigger];
}

@end
