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


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@class LocalNotification;

static const NSString *NOTIFICATION_CODE_KEY = @"notificationCodeKey";
static const NSString *NOTIFICATION_DATA_KEY = @"notificationDataKey";

@interface LocalNotificationManager : NSObject
+ (instancetype)notificationManager;
- (void)notify:(LocalNotification*)notification;
- (void)cancel:(NSString*)notificationCode;
- (void)cancelAll;
- (void)registerSettingTypes:(UIUserNotificationType)types;
@end

