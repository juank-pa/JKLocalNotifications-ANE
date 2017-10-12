//
//  JKLegacyLocalNotificationFactory.h
//  LocalNotificationLib
//
//  Created by Juan Carlos Pazmino on 9/30/17.
//
//

#import <UIKit/UIKit.h>
#import "JKNotificationFactory.h"
#import "JKNotificationBuilder.h"

@interface JKLegacyLocalNotificationFactory : JKNotificationFactory
- (UIUserNotificationSettings *)createSettingsForTypes:(UIUserNotificationType)types;
- (JKNotificationBuilder *)createNotificationBuilder;
@end
