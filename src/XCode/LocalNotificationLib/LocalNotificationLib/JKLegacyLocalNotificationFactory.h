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
#import "JKLegacyNotificationSettingsBuilder.h"

@interface JKLegacyLocalNotificationFactory : JKNotificationFactory
- (JKLegacyNotificationSettingsBuilder *)createSettingsBuilder;
- (JKNotificationBuilder *)createNotificationBuilder;
@end
