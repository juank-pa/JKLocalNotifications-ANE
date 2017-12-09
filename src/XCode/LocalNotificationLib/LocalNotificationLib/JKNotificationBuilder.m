//
//  JKNotificationBuilder.m
//  LocalNotificationLib
//
//  Created by Juan Carlos Pazmino on 10/11/17.
//
//

#import <UIKit/UIKit.h>
#import "JKNotificationBuilder.h"
#import "JKLocalNotification.h"

@implementation JKNotificationBuilder

- (UILocalNotification *)buildFromNotification:(JKLocalNotification *)notification {
    UILocalNotification *localNotification = [UILocalNotification new];
    localNotification.fireDate = notification.fireDate;
    localNotification.timeZone = [NSTimeZone defaultTimeZone];
    localNotification.repeatInterval = (NSCalendarUnit)notification.repeatInterval;

    localNotification.alertBody = notification.body;
    localNotification.alertAction = notification.actionLabel;
    localNotification.hasAction = notification.hasAction;
    localNotification.soundName = [self soundNameForNotification:notification];
    localNotification.applicationIconBadgeNumber = notification.numberAnnotation;
    localNotification.userInfo = notification.userInfo;
    localNotification.alertLaunchImage = notification.launchImage;
    localNotification.category = notification.category;

    if ([localNotification respondsToSelector:@selector(setAlertTitle:)]) {
        localNotification.alertTitle = notification.title;
    }

    return localNotification;
}

- (NSString *)soundNameForNotification:(JKLocalNotification *)notification {
    if(!notification.playSound) { return nil; }
    return (notification.soundName.length > 0? notification.soundName : UILocalNotificationDefaultSoundName);
}

@end
