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


@implementation LocalNotificationManager


- (void) dealloc
{
	[localNotification release];
	[super dealloc];
}


- (void) notify :(LocalNotification*)notification
{    
    if (localNotification)
    {
        [localNotification release];
    }
    
    localNotification = [[UILocalNotification alloc] init];
    
    BOOL isScheduled = NO;
        
    localNotification.fireDate = notification.fireDate;
    localNotification.timeZone = [NSTimeZone defaultTimeZone];
    localNotification.repeatInterval = notification.repeatInterval;
    
    if(notification.fireDate) isScheduled = YES;
    
    // Set the text of the alert body and action button. 
    // IMPORTANT: The alert will only appear if the app is running in the background when it receives the notification.
    localNotification.alertBody = notification.body;
    localNotification.alertAction = notification.actionLabel;
    
    // This defaults to YES. 
    // If it's NO, then the alert will not have an action button with the specified alertAction text and 
    // a Close button. It will only have one OK button. Also, if the device is locked, the slider text will not change from 
    // "slide to unlock" to "slide to alert...".
    localNotification.hasAction = notification.hasAction;
    
    // Set the notification sound. 
    // IMPORTANT: The sound is only played if the app is running in the background when it receives the notification.
    // Default is nil: no sound.
    if (notification.playSound)
    {
        localNotification.soundName = UILocalNotificationDefaultSoundName;
    }
    
    // Set the badge number on the app icon. 
    // IMPORTANT: The badge number is only changed if the app is running in the background when it receives the notification.
    // This can also be done explicitly by setting the property [UIApplication sharedApplication].applicationIconBadgeNumber and
    // will work if the app is in the foreground.
    localNotification.applicationIconBadgeNumber = notification.numberAnnotation;
    
    // Set the user data associated with the notification.
    NSMutableDictionary *infoDict = [NSMutableDictionary dictionaryWithCapacity:2];
    [infoDict setObject :notification.notificationCode forKey:NOTIFICATION_CODE_KEY];
    
    if(notification.actionData)
    {
        [infoDict setObject :notification.actionData forKey:NOTIFICATION_DATA_KEY];
    }
    
    localNotification.userInfo = infoDict;
        
    // Fire the notification. 
    // NOTE: The system keeps only the soonest firing 64 notifications and discards the rest.
    if (isScheduled)
    {
        // Archive the notification using its code so we can get it back to cancel.
        NSString *archiveName = [NSString stringWithFormat:@"Notification_%@.archive", notification.notificationCode];
        NSString *archivePath = [NSTemporaryDirectory() stringByAppendingPathComponent:archiveName];
        [NSKeyedArchiver archiveRootObject:localNotification toFile:archivePath];
        
        [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
    }
    else
    {
        [[UIApplication sharedApplication] presentLocalNotificationNow:localNotification];
    }
}

- (void) cancel:(NSString*)notificationCode
{
    // Unarchive the notification using the supplied code and cancel it if successfull.
    UILocalNotification *decodedLocalNotification = nil;
    
    NSString *archiveName = [NSString stringWithFormat:@"Notification_%@.archive", notificationCode];
    NSString *archivePath = [NSTemporaryDirectory() stringByAppendingPathComponent:archiveName];
    
    decodedLocalNotification = [NSKeyedUnarchiver unarchiveObjectWithFile:archivePath];
    
    if (decodedLocalNotification)
    {
        [[UIApplication sharedApplication] cancelLocalNotification:decodedLocalNotification];
    }
}

- (void) cancelAll
{
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
}


@end

