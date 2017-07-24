//
//  LocalNotificationAppDelegate.h
//  LocalNotificationLib
//
//  Created by Juan Carlos Pazmino on 7/20/17.
//
//

#import <UIKit/UIKit.h>

// FRPE_ApplicationDidRegisterUserNotificationSettings: Posted when call to
// application:didRegisterUserNotificationSettings: is received.
static const NSString *FRPE_ApplicationDidRegisterUserNotificationSettings = @"FRPE_ApplicationDidRegisterUserNotificationSettings";

// FRPE_ApplicationDidRegisterUserNotificationSettingsKey accesses an the UserInfo dictionary of
// FRPE_ApplicationDidRegisterUserNotificationSettings
//
static const NSString *FRPE_ApplicationDidRegisterUserNotificationSettingsKey = @"FRPE_ApplicationDidRegisterUserNotificationSettingsKey";

@interface LocalNotificationAppDelegate : NSObject<UIApplicationDelegate>
- (instancetype)initWithTargetDelegate:(id<UIApplicationDelegate>)target;
@property (nonatomic, retain) id<UIApplicationDelegate> target;
@end
