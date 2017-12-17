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
#import "JKLegacyTextInputActionBuilder.h"

@interface JKLegacyLocalNotificationFactory : JKNotificationFactory
- (JKLegacyNotificationSettingsBuilder *)createSettingsBuilder;
- (JKNotificationBuilder *)createNotificationBuilder;
- (JKLegacyActionBuilder *)createActionBuilder;
- (JKLegacyTextInputActionBuilder *)createTextInputActionBuilder;
@end
