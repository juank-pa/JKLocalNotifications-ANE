//
//  JKLegacyNotificationSettingsBuilder.h
//  LocalNotificationLib
//
//  Created by Juan Carlos Pazmino on 11/28/17.
//
//

#import <UIKit/UIKit.h>
#import "JKLocalNotificationSettings.h"

@interface JKLegacyNotificationSettingsBuilder : NSObject
- (UIUserNotificationSettings *)buildFromSettings:(JKLocalNotificationSettings *)settings;
@end
