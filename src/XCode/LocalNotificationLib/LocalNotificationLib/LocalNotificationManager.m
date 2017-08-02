/*************************************************************************
 *
 * ADOBE CONFIDENTIAL
 * ___________________
 *
 *  Copyright 2011 Adobe Systems Incorporated
 *  All Rights Reserved.
 *
 * NOTICE:  All information contained herein is, and remains
 * the property of Adobe Systems Incorporated and its suppliers,
 * if any.  The intellectual and technical concepts contained
 * herein are proprietary to Adobe Systems Incorporated and its
 * suppliers and are protected by trade secret or copyright law.
 * Dissemination of this information or reproduction of this material
 * is strictly forbidden unless prior written permission is obtained
 * from Adobe Systems Incorporated.
 **************************************************************************/


#import "LocalNotificationManager.h"
#import "LocalNotification.h"

@interface UILocalNotification (LocalNotificationManager)
+ (instancetype)localNotification;
@end

@implementation UILocalNotification (LocalNotificationManager)
+ (instancetype)localNotification {
    return [[UILocalNotification new] autorelease];
}
@end

@implementation LocalNotificationManager

+ (instancetype)notificationManager {
    return [[LocalNotificationManager new] autorelease];
}

- (void)dealloc {
    [super dealloc];
}

- (void)registerSettingTypes:(UIUserNotificationType)types {
    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
    [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
}

- (void)notify:(LocalNotification*)notification {
    UILocalNotification *localNotification = [UILocalNotification localNotification];

    localNotification.fireDate = notification.fireDate;
    localNotification.timeZone = [NSTimeZone defaultTimeZone];
    localNotification.repeatInterval = notification.repeatInterval;
    
    BOOL isScheduled = notification.fireDate != nil;
    
    // Set the text of the alert body and action button. 
    // IMPORTANT: The alert will only appear if the app is running in the background when it receives the notification.
    localNotification.alertBody = notification.body;
    localNotification.alertAction = notification.actionLabel;
    
    // This defaults to YES. 
    // If it's NO, then the alert will not have an action button with the specified alertAction text and
    // a Close button. It will only have one OK button. Also, if the device is locked, the slider text will not change from 
    // "slide to unlock" to "slide to alert...".
    localNotification.hasAction = notification.hasAction;

    // This title will only be seen inside the notification center.
    if ([localNotification respondsToSelector:@selector(setAlertTitle:)]) {
        localNotification.alertTitle = notification.title;
    }

    // Set the notification sound.
    // IMPORTANT: The sound is only played if the app is running in the background when it receives the notification.
    // Default is nil: no sound.
    if (notification.playSound) {
        localNotification.soundName = (notification.soundName.length > 0? notification.soundName : UILocalNotificationDefaultSoundName);
    }
    
    // Set the badge number on the app icon. 
    // IMPORTANT: The badge number is only changed if the app is running in the background when it receives the notification.
    // This can also be done explicitly by setting the property [UIApplication sharedApplication].applicationIconBadgeNumber and
    // will work if the app is in the foreground.
    localNotification.applicationIconBadgeNumber = notification.numberAnnotation;
    
    // Set the user data associated with the notification.
    NSMutableDictionary *infoDict = [NSMutableDictionary dictionaryWithCapacity:2];
    infoDict[NOTIFICATION_CODE_KEY] = notification.notificationCode;
    
    if(notification.actionData) {
        infoDict[NOTIFICATION_DATA_KEY] = notification.actionData;
    }
    
    localNotification.userInfo = infoDict;
        
    // Archive the notification using its code so we can get it back to cancel.
    // NOTE: The system keeps only the soonest firing 64 notifications and discards the rest.
    [self archiveNotification:localNotification withCode:notification.notificationCode];
    
    // Fire the notification. 
    if (isScheduled) {
        [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
    }
    else {
        [[UIApplication sharedApplication] presentLocalNotificationNow:localNotification];
    }
}

- (NSArray *)getNotificationList:(NSString*)notificationCode {
    NSString *archiveName = [NSString stringWithFormat:@"Notification_%@.archive", notificationCode];
    NSString *archivePath = [NSTemporaryDirectory() stringByAppendingPathComponent:archiveName];
    
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:archivePath];

    return (fileExists? [NSKeyedUnarchiver unarchiveObjectWithFile:archivePath] : [NSArray array]);
}

- (void)cancel:(NSString*)notificationCode {
    // Unarchive the notification using the supplied code and cancel it if successfull.
    NSArray *notificationList = [self getNotificationList:notificationCode];
    for (UILocalNotification *notification in notificationList) {
        [[UIApplication sharedApplication] cancelLocalNotification:notification];
    }
    
    if(notificationList.count > 0) {
        [self archiveNotification:nil withCode:notificationCode];
    }
}

-(void)archiveNotification:(UILocalNotification *)notification withCode:(NSString *)notificationCode {
    NSArray *notificationList = nil;
    
    if(notification) {
        notificationList = [[self getNotificationList:notificationCode] arrayByAddingObject:notification];
    }
    else {
        notificationList = [NSArray array];
    }
    
    NSString *archiveName = [NSString stringWithFormat:@"Notification_%@.archive", notificationCode];
    NSString *archivePath = [NSTemporaryDirectory() stringByAppendingPathComponent:archiveName];
    [NSKeyedArchiver archiveRootObject:notificationList toFile:archivePath];
}

- (void)cancelAll {
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
}

@end

