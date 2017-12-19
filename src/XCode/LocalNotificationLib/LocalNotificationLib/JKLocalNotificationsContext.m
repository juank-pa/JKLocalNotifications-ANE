//
//  JKLocalNotificationsContext.h
//  LocalNotificationLib
//
//  Created by Juan Carlos Pazmino on 10/1/17.
//
//

#import <UIKit/UIKit.h>
#import <UserNotifications/UserNotifications.h>
#import "FlashRuntimeExtensions.h"
#import "FlashRuntimeExtensions+Private.h"
#import "Constants.h"
#import "ExtensionUtils.h"

#import "JKLocalNotificationsContext.h"
#import "JKLocalNotification.h"
#import "JKLocalNotificationManager.h"
#import "JKNotificationListener.h"
#import "JKAuthorizer.h"
#import "JKNotificationFactory.h"
#import "JKLocalNotificationSettings.h"
#import "JKLocalNotificationDecoder.h"
#import "JKLocalNotificationSettingsDecoder.h"
#import "macros.h"

@interface JKLocalNotificationsContext()<JKAuthorizerDelegate, JKNotificationListenerDelegate>

- (void)notify:(JKLocalNotification*)localNotification;
- (void)cancel:(NSString*)notificationCode;
- (void)cancelAll;

@property (nonatomic, strong) JKNotificationFactory *factory;
@property (nonatomic, readonly, strong) JKLocalNotificationManager *manager;
@property (nonatomic, readonly, strong) id<JKAuthorizer> authorizer;
@property (nonatomic, readonly, strong) JKNotificationListener *listener;
@property (nonatomic, assign) FREContext extensionContext;

@end

@implementation JKLocalNotificationsContext

+ (instancetype)notificationsContextWithContext:(FREContext)ctx factory:(JKNotificationFactory *)factory {
    return [[JKLocalNotificationsContext alloc] initWithContext:ctx factory:factory];
}

- (id)initWithContext:(FREContext)ctx factory:(JKNotificationFactory *)factory {
    if (self = [super init]) {
        _extensionContext = ctx;
        _factory = factory;

        _listener = _factory.listener;
        _listener.delegate = self;

        _manager = [_factory createManager];
        
        _authorizer = [_factory createAuthorizer];
        _authorizer.delegate = self;
    }
    return self;
}

- (void)dealloc {
    _listener.delegate = nil;
    _authorizer.delegate = nil;

    _extensionContext = NULL;
}

- (void)notify:(JKLocalNotification *)localNotification {
    [self.manager notify:localNotification];
}

- (void)cancel:(NSString*)notificationCode {
    [self.manager cancel:notificationCode];
}

- (void)cancelAll {
    [self.manager cancelAll];
}

- (void)authorizeWithSettings:(JKLocalNotificationSettings *)settings {
    [self.authorizer requestAuthorizationWithSettings:settings];
}

- (void)checkForNotificationAction {
    [self.listener checkForNotificationAction];
}

- (NSString *)notificationCode {
    return self.listener.notificationCode;
}

- (NSData *)notificationData {
    return self.listener.notificationData;
}

- (JKLocalNotificationSettings *)settings {
    return self.authorizer.settings;
}

- (NSString *)notificationAction {
    return self.listener.notificationAction;
}

- (NSString *)notificationUserResponse {
    return self.listener.userResponse;
}

- (void)didReceiveNotificationDataForNotificationListener:(JKNotificationListener *)listener {
#ifdef SAMPLE
    [NSOperationQueue.mainQueue addOperationWithBlock:^ {
        [self.delegate localNotificationContext:self didReceiveNotificationFromListener:listener];
    }];
#else
    // Dispatch event to AS side of ExtensionContext.
    FREResult result = FREDispatchStatusEventAsync(self.extensionContext, (const uint8_t*)JK_NOTIFICATION_SELECTED_EVENT, (const uint8_t*)JK_NOTIFICATION_STATUS_KEY);
    assert(result == FRE_OK);
#endif
}

- (void)notificationAuthorizer:(JKLocalNotificationManager *)notificationManager didAuthorizeWithSettings:(JKLocalNotificationSettings *)settings {
#ifdef SAMPLE
    [NSOperationQueue.mainQueue addOperationWithBlock:^ {
        [self.delegate localNotificationContext:self didRegisterSettings:settings];
    }];
#else
    // Dispatch event to AS side of ExtensionContext.
    FREResult result = FREDispatchStatusEventAsync(self.extensionContext, (const uint8_t*)JK_SETTINGS_SUBSCRIBED_EVENT, (const uint8_t*)JK_NOTIFICATION_STATUS_KEY);
    assert(result == FRE_OK);
#endif
}

#ifndef SAMPLE

DEFINE_ANE_FUNCTION(notify) {
    @autoreleasepool {
        JKLocalNotificationDecoder *decoder = [[JKLocalNotificationDecoder alloc]
                                               initWithFREObject:argv[0]];
        JKLocalNotification *localNotification = [decoder decodeObject:argv[1]];
        [jkNotificationsContext notify:localNotification];
    }
    return NULL;
}

DEFINE_ANE_FUNCTION(cancel) {
    @autoreleasepool {
        NSString *notificationCode = [ExtensionUtils getStringFromFREObject:argv[0]];
        [jkNotificationsContext cancel:notificationCode];
        return NULL;
    }
}

DEFINE_ANE_FUNCTION(cancelAll) {
    @autoreleasepool {
        [jkNotificationsContext cancelAll];
        return NULL;
    }
}

DEFINE_ANE_FUNCTION(registerSettings) {
    @autoreleasepool {
        JKLocalNotificationSettings *settings = [[JKLocalNotificationSettingsDecoder new] decodeObject:argv[0]];
        [jkNotificationsContext authorizeWithSettings:settings];
        return NULL;
    }
}

DEFINE_ANE_FUNCTION(checkForNotificationAction) {
    @autoreleasepool {
        [jkNotificationsContext checkForNotificationAction];
        return NULL;
    }
}

DEFINE_ANE_FUNCTION(getApplicationBadgeNumber) {
    @autoreleasepool {
        int32_t appBadgeNumber = (int32_t)[UIApplication sharedApplication].applicationIconBadgeNumber;
        return [ExtensionUtils getFREObjectFromInt:appBadgeNumber];
    }
}

DEFINE_ANE_FUNCTION(setApplicationBadgeNumber) {
    @autoreleasepool {
        int32_t appBadgeNumber = [ExtensionUtils getIntFromFREObject:argv[0]];
        [UIApplication sharedApplication].applicationIconBadgeNumber = appBadgeNumber;
        return NULL;
    }
}

DEFINE_ANE_FUNCTION(getSelectedSettings) {
    @autoreleasepool {
        JKLocalNotificationSettings* settings = jkNotificationsContext.settings;
        return [ExtensionUtils getFREObjectFromUInt:(uint32_t)settings.types];
    }
}

DEFINE_ANE_FUNCTION(getSelectedNotificationCode) {
    @autoreleasepool {
        NSString* notificationCode = jkNotificationsContext.notificationCode;
        return [ExtensionUtils getFREObjectFromString:notificationCode];
    }
}

DEFINE_ANE_FUNCTION(getSelectedNotificationData) {
    @autoreleasepool {
        NSData *notificationData = jkNotificationsContext.notificationData;
        if(!notificationData) return NULL;
        return [ExtensionUtils getFREObjectFromData:notificationData];
    }
}

DEFINE_ANE_FUNCTION(getSelectedNotificationAction) {
    @autoreleasepool {
        NSString* notificationAction = jkNotificationsContext.notificationAction;
        return [ExtensionUtils getFREObjectFromString:notificationAction];
    }
}

DEFINE_ANE_FUNCTION(getSelectedNotificationUserResponse) {
    @autoreleasepool {
        NSString* notificationUserResponse = jkNotificationsContext.notificationUserResponse;
        return [ExtensionUtils getFREObjectFromString:notificationUserResponse];
    }
}

#endif

#pragma mark -
#pragma mark ADEPExtensionProtocol methods

#ifndef SAMPLE

- (uint32_t)initExtensionFunctions:(const FRENamedFunction**)namedFunctions {
    static FRENamedFunction functions[] = {
        MAP_FUNCTION(notify),
        MAP_FUNCTION(cancel),
        MAP_FUNCTION(cancelAll),
        MAP_FUNCTION(checkForNotificationAction),
        MAP_FUNCTION(getSelectedNotificationCode),
        MAP_FUNCTION(getSelectedNotificationData),
        MAP_FUNCTION(getSelectedNotificationAction),
        MAP_FUNCTION(getSelectedNotificationUserResponse),
        MAP_FUNCTION(setApplicationBadgeNumber),
        MAP_FUNCTION(getApplicationBadgeNumber),
        MAP_FUNCTION(registerSettings),
        MAP_FUNCTION(getSelectedSettings)
    };

    *namedFunctions = functions;
    return sizeof(functions) / sizeof(FRENamedFunction);
}

#endif

@end
