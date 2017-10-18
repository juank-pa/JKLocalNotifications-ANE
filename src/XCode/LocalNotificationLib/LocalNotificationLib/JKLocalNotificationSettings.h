//
//  JKLocalNotificationSettings.h
//  LocalNotificationLib
//
//  Created by Juan Carlos Pazmino on 9/30/17.
//
//

#import <UIKit/UIKit.h>
#import <UserNotifications/UserNotifications.h>

typedef NS_OPTIONS(NSUInteger, JKLocalNotificationType) {
    JKLocalNotificationTypeNone    = 0,      // the application may not present any UI upon a notification being received
    JKLocalNotificationTypeBadge   = 1 << 0, // the application may badge its icon upon a notification being received
    JKLocalNotificationTypeSound   = 1 << 1, // the application may play a sound upon a notification being received
    JKLocalNotificationTypeAlert   = 1 << 2, // the application may display an alert upon a notification being received
};

@interface JKLocalNotificationSettings : NSObject
+ (instancetype)settingsWithUserNotificationTypes:(UIUserNotificationType)types;
+ (instancetype)settingswithAuthorizationOptions:(UNAuthorizationOptions)options;
+ (instancetype)settingsWithLocalNotificationTypes:(JKLocalNotificationType)options;

- (instancetype)initWithUserNotificationTypes:(UIUserNotificationType)types;
- (instancetype)initWithAuthorizationOptions:(UNAuthorizationOptions)options;
- (instancetype)initWithLocalNotificationTypes:(JKLocalNotificationType)options;
@property (nonatomic, readonly) JKLocalNotificationType types;
@property (nonatomic, readonly) UIUserNotificationType notificationTypes;
@property (nonatomic, readonly) UNAuthorizationOptions authorizationOptions;
@end
