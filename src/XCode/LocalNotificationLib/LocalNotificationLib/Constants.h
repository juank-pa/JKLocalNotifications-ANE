//
//  Constants.h
//  LocalNotificationLib
//
//  Created by Juan Carlos Pazmino on 10/1/17.
//
//

#ifndef constants_h
#define constants_h

#import "JKLocalNotificationsContext.h"

extern JKLocalNotificationsContext * __strong jkNotificationsContext;

static const NSString *JK_NOTIFICATION_CODE_KEY = @"notificationCodeKey";
static const NSString *JK_NOTIFICATION_DATA_KEY = @"notificationDataKey";

static const char* const JK_NOTIFICATION_STATUS_KEY = "status";
static const char* const JK_NOTIFICATION_SELECTED_EVENT = "notificationSelected";
static const char* const JK_SETTINGS_SUBSCRIBED_EVENT = "settingsSubscribed";

#endif /* constants_h */
