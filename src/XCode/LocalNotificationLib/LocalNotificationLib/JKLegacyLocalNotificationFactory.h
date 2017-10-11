//
//  JKLegacyLocalNotificationFactory.h
//  LocalNotificationLib
//
//  Created by Juan Carlos Pazmino on 9/30/17.
//
//

#import <UIKit/UIKit.h>
#import "JKNotificationFactory.h"

@interface JKLegacyLocalNotificationFactory : JKNotificationFactory
@property (nonatomic, readonly) UIApplication *application;
- (UIUserNotificationSettings *)createSettingsForTypes:(UIUserNotificationType)types;
@end
