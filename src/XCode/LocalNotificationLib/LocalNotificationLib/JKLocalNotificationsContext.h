//
//  JKLocalNotificationsContext.h
//  LocalNotificationLib
//
//  Created by Juan Carlos Pazmino on 10/1/17.
//
//

#import "FlashRuntimeExtensions.h"

@class JKNotificationFactory;
@class JKLocalNotificationSettings;
@class JKNotificationListener;

#ifdef SAMPLE

@class JKLocalNotificationsContext;

@protocol LocalNotificationDelegate <NSObject>
- (void)localNotificationContext:(JKLocalNotificationsContext *)context didReceiveNotificationFromListener:(JKNotificationListener *)listener;
- (void)localNotificationContext:(JKLocalNotificationsContext *)context didRegisterSettings:(JKLocalNotificationSettings *)settings;
@end

#endif

@class JKLocalNotificationManager;
@class JKLocalNotification;

@interface JKLocalNotificationsContext : NSObject
+ (instancetype)notificationsContextWithContext:(FREContext)ctx factory:(JKNotificationFactory *)factory;

- (id)initWithContext:(FREContext)ctx factory:(JKNotificationFactory *)factory;

@property (nonatomic, readonly) NSString *notificationCode;
@property (nonatomic, readonly) NSData *notificationData;
@property (nonatomic, readonly) NSString *notificationAction;
@property (nonatomic, readonly) JKLocalNotificationSettings *settings;

#ifdef SAMPLE
- (void)notify:(JKLocalNotification*)localNotification;
- (void)cancel:(NSString*)notificationCode;
- (void)cancelAll;
- (void)authorizeWithSettings:(JKLocalNotificationSettings *)settings;
- (void)checkForNotificationAction;

@property (nonatomic, weak) id<LocalNotificationDelegate> delegate;
#else
- (uint32_t) initExtensionFunctions:(const FRENamedFunction**) namedFunctions;
#endif

@end
