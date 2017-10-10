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

        _listener = [_factory createListener];
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

- (void)notify:(JKLocalNotification*)localNotification {
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

- (void)didReceiveNotificationDataForNotificationListener:(JKNotificationListener *)listener {
#ifdef SAMPLE
    [self.delegate localNotificationContext:self didReceiveNotificationFromListener:listener];
#else
    // Dispatch event to AS side of ExtensionContext.
    FREResult result = FREDispatchStatusEventAsync(self.extensionContext, (const uint8_t*)JK_NOTIFICATION_SELECTED_EVENT, (const uint8_t*)JK_NOTIFICATION_STATUS_KEY);
    assert(result == FRE_OK);
#endif
}

- (void)notificationAuthorizer:(JKLocalNotificationManager *)notificationManager didAuthorizeWithSettings:(JKLocalNotificationSettings *)settings {
#ifndef SAMPLE
    // Dispatch event to AS side of ExtensionContext.
    FREResult result = FREDispatchStatusEventAsync(self.extensionContext, (const uint8_t*)JK_SETTINGS_SUBSCRIBED_EVENT, (const uint8_t*)JK_NOTIFICATION_STATUS_KEY);
    assert(result == FRE_OK);
#else
    [self.delegate localNotificationContext:self didRegisterSettings:settings];
#endif
}

#ifndef SAMPLE

FREObject ADEPCreateManager(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]) {
    return NULL;
}

FREObject ADEPNotify(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]) {
    @autoreleasepool {
        JKLocalNotification *localNotification = [JKLocalNotification localNotification];
        
        // Notification Code.
        NSString *notificationCode = [ExtensionUtils getStringFromFREObject:argv[0]];
        if (notificationCode) {
            [localNotification setNotificationCode:notificationCode];
        }

        FREObject notification = argv[1];
        
        // Fire Date.
        FREObject freFireDate = [ExtensionUtils getProperty:@"fireDate" fromObject:notification];
        if (freFireDate) {
            FREObject timeProperty = [ExtensionUtils getProperty:@"time" fromObject:freFireDate];

            double time = ([ExtensionUtils getDoubleFromFREObject:timeProperty] / 1000.0);
            if ((uint32_t)time > 0) {
                localNotification.fireDate = [NSDate dateWithTimeIntervalSince1970:time];
            }
        }
        
        // Repeat Interval.
        FREObject freRepeatInterval = [ExtensionUtils getProperty:@"repeatInterval" fromObject:notification];
        if (freRepeatInterval) {
            localNotification.repeatInterval = [ExtensionUtils getUIntFromFREObject:freRepeatInterval];
        }
        
        // Action Label.
        FREObject freActionLabel = [ExtensionUtils getProperty:@"actionLabel" fromObject:notification];
        if (freActionLabel) {
            localNotification.actionLabel = [ExtensionUtils getStringFromFREObject:freActionLabel];
        }
        
        // Body.
        FREObject freBody = [ExtensionUtils getProperty:@"body" fromObject:notification];
        if (freBody) {
            localNotification.body = [ExtensionUtils getStringFromFREObject:freBody];
        }

        // Title.
        FREObject freTitle = [ExtensionUtils getProperty:@"title" fromObject:notification];
        if (freTitle) {
            localNotification.title = [ExtensionUtils getStringFromFREObject:freTitle];
        }

        // Has Action.
        FREObject freHasAction = [ExtensionUtils getProperty:@"hasAction" fromObject:notification];
        if (freHasAction) {
            localNotification.hasAction = [ExtensionUtils getBoolFromFREObject:freHasAction];
        }
        
        // Number Annotation.
        FREObject freNumberAnnotation = [ExtensionUtils getProperty:@"numberAnnotation" fromObject:notification];
        if (freNumberAnnotation) {
            localNotification.numberAnnotation = [ExtensionUtils getUIntFromFREObject:freNumberAnnotation];
        }
        
        // Play Sound.
        FREObject frePlaySound = [ExtensionUtils getProperty:@"playSound" fromObject:notification];
        if (frePlaySound) {
            localNotification.playSound = [ExtensionUtils getBoolFromFREObject:frePlaySound];
        }
        
        // Sound name.
        FREObject freSoundName = [ExtensionUtils getProperty:@"soundName" fromObject:notification];
        if (freSoundName) {
            localNotification.soundName = [ExtensionUtils getStringFromFREObject:freSoundName];
        }
        
        // Action Data.
        FREObject freActionData = [ExtensionUtils getProperty:@"actionData" fromObject:notification];

        if (freActionData) {
             localNotification.actionData = [ExtensionUtils getDataFromFREObject:freActionData];
        }
        
        // Notify.
        [jkNotificationsContext notify:localNotification];
    }
    return NULL;
}


FREObject ADEPCancel(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]) {
    @autoreleasepool {
        NSString *notificationCode = [ExtensionUtils getStringFromFREObject:argv[0]];
        [jkNotificationsContext cancel:notificationCode];
        return NULL;
    }
}


FREObject ADEPCancelAll(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]) {
    @autoreleasepool {
        [jkNotificationsContext cancelAll];
        return NULL;
    }
}


FREObject ADEPRegisterSettings(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]) {
    @autoreleasepool {
        uint32_t types = [ExtensionUtils getUIntFromFREObject:argv[0]];
        JKLocalNotificationSettings *settings = [JKLocalNotificationSettings settingsWithLocalNotificationTypes:(JKLocalNotificationType)types];
        [jkNotificationsContext authorizeWithSettings:settings];
        return NULL;
    }
}


FREObject ADEPCheckForNotificationAction(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]) {
    @autoreleasepool {
        [jkNotificationsContext checkForNotificationAction];
        return NULL;
    }
}

FREObject ADEPGetApplicationBadgeNumber(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]) {
    @autoreleasepool {
        int32_t appBadgeNumber = (int32_t)[UIApplication sharedApplication].applicationIconBadgeNumber;
        FREObject numberObject = [ExtensionUtils getFREObjectFromInt:appBadgeNumber];
        return numberObject;
    }
}

FREObject ADEPSetApplicationBadgeNumber(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]) {
    @autoreleasepool {
        int32_t appBadgeNumber = [ExtensionUtils getIntFromFREObject:argv[0]];
        [UIApplication sharedApplication].applicationIconBadgeNumber = appBadgeNumber;
        return NULL;
    }
}

FREObject ADEPGetSelectedSettings(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]) {
    @autoreleasepool {
        JKLocalNotificationSettings* settings = jkNotificationsContext.settings;
        FREObject numberObject = [ExtensionUtils getFREObjectFromUInt:(uint32_t)settings.types];
        return numberObject;
    }
}

FREObject ADEPGetSelectedNotificationCode(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]) {
    @autoreleasepool {
        NSString* notificationCode = jkNotificationsContext.notificationCode;
        return [ExtensionUtils getFREObjectFromString:notificationCode];
    }
}

FREObject ADEPGetSelectedNotificationData(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]) {
    @autoreleasepool {
        NSData *notificationData = jkNotificationsContext.notificationData;

        if(!notificationData) return NULL;
        return [ExtensionUtils getFREObjectFromData:notificationData];
    }
}

#endif

#pragma mark -
#pragma mark ADEPExtensionProtocol methods

#ifndef SAMPLE

- (uint32_t)initExtensionFunctions:(const FRENamedFunction**)namedFunctions {
    uint32_t numFunctions = 11;
    
    FRENamedFunction* func = (FRENamedFunction*)malloc(sizeof(FRENamedFunction)*numFunctions);  // TODO: Free this. 
    
    func[0].name = (const uint8_t*)"createManager";
    func[0].functionData = NULL;
    func[0].function = &ADEPCreateManager;
    
    func[1].name = (const uint8_t*)"notify";
    func[1].functionData = NULL;
    func[1].function = &ADEPNotify;
    
    func[2].name = (const uint8_t*)"cancel";
    func[2].functionData = NULL;
    func[2].function = &ADEPCancel;
    
    func[3].name = (const uint8_t*)"cancelAll";
    func[3].functionData = NULL;
    func[3].function = &ADEPCancelAll;
    
    func[4].name = (const uint8_t*)"checkForNotificationAction";
    func[4].functionData = NULL;
    func[4].function = &ADEPCheckForNotificationAction;
    
    func[5].name = (const uint8_t*)"getSelectedNotificationCode";
    func[5].functionData = NULL;
    func[5].function = &ADEPGetSelectedNotificationCode;

    func[6].name = (const uint8_t*)"getSelectedNotificationData";
    func[6].functionData = NULL;
    func[6].function = &ADEPGetSelectedNotificationData;
    
    func[7].name = (const uint8_t*)"setApplicationBadgeNumber";
    func[7].functionData = NULL;
    func[7].function = &ADEPSetApplicationBadgeNumber;
    
    func[8].name = (const uint8_t*)"getApplicationBadgeNumber";
    func[8].functionData = NULL;
    func[8].function = &ADEPGetApplicationBadgeNumber;
    
    func[9].name = (const uint8_t*)"registerSettings";
    func[9].functionData = NULL;
    func[9].function = &ADEPRegisterSettings;

    func[10].name = (const uint8_t*)"getSelectedSettings";
    func[10].functionData = NULL;
    func[10].function = &ADEPGetSelectedSettings;

    *namedFunctions = func;
    
    return numFunctions;
}

#endif

@end
