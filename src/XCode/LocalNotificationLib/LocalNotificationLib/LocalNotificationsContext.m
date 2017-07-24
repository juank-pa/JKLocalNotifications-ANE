/*************************************************************************
 *
 * ADOBE CONFIDENTIAL
 * ___________________
 *
 *  Copyright 2011 Adobe Systems Incorporated
 *  All Rights Reserved.
 *
 * NOTICE:  All information contained herein is, and remains
 * the property of Adobe Systems Incorporated and its suppliers,
 * if any.  The intellectual and technical concepts contained
 * herein are proprietary to Adobe Systems Incorporated and its
 * suppliers and are protected by trade secret or copyright law.
 * Dissemination of this information or reproduction of this material
 * is strictly forbidden unless prior written permission is obtained
 * from Adobe Systems Incorporated.
 **************************************************************************/


#import <UIKit/UIKit.h>
#import "FlashRuntimeExtensions.h"
#import "FlashRuntimeExtensions+Private.h"
#import "ExtensionUtils.h"

#import "LocalNotificationsContext.h"
#import "LocalNotificationManager.h"
#import "LocalNotification.h"
#import "LocalNotificationAppDelegate.h"

@interface LocalNotificationsContext()

- (void)createManager;
- (void)notify:(LocalNotification*)localNotification;
- (void)cancel:(NSString*)notificationCode;
- (void)cancelAll;

@property (nonatomic, copy) NSString *selectedNotificationCode;
@property (nonatomic, copy) NSData *selectedNotificationData;
@property (nonatomic, retain) UIUserNotificationSettings *selectedSettings;
@property (nonatomic, retain) LocalNotificationManager *notificationManager;
@property (nonatomic, assign) FREContext extensionContext;
@property (nonatomic, retain) LocalNotificationAppDelegate *sourceDelegate;

@end


@implementation LocalNotificationsContext

+ (instancetype)notificationsContextWithContext:(FREContext)ctx {
    return [[[LocalNotificationsContext alloc] initWithContext:ctx] autorelease];
}

- (id)initWithContext:(FREContext)ctx {
    if (self = [super init]) {
        _extensionContext = ctx;

        // Use proxy delegate
        id<UIApplicationDelegate> targetDelegate = [UIApplication sharedApplication].delegate;
        _sourceDelegate = [[LocalNotificationAppDelegate alloc] initWithTargetDelegate:targetDelegate];
        [UIApplication sharedApplication].delegate = _sourceDelegate;
    }
    return self;
}


- (void)dealloc {
    _extensionContext = NULL;
    [self.notificationManager release];
    [self.selectedNotificationCode release];
    [self.selectedNotificationData release];
    [self.selectedSettings release];

    [UIApplication sharedApplication].delegate = self.sourceDelegate.target;
    [self.sourceDelegate release];

    [[NSNotificationCenter defaultCenter] removeObserver:self name:(NSString *)FRPE_ApplicationDidReceiveLocalNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:(NSString *)FRPE_ApplicationDidRegisterUserNotificationSettings object:nil];

    [super dealloc];
}


- (void)createManager {
    self.notificationManager = [LocalNotificationManager notificationManager];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didReceiveLocalNotification:)
                                                 name:(NSString *)FRPE_ApplicationDidReceiveLocalNotification
                                               object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didRegisterUserNotificationSettings:)
                                                 name:(NSString *)FRPE_ApplicationDidRegisterUserNotificationSettings
                                               object:nil];
}

- (void)notify:(LocalNotification*)localNotification {
    [self.notificationManager notify:localNotification];
}


- (void)cancel:(NSString*)notificationCode {
    [self.notificationManager cancel:notificationCode];
}


- (void)cancelAll {
    [self.notificationManager cancelAll];
}

- (void)registerSettingTypes:(UIUserNotificationType)types {
    [self.notificationManager registerSettingTypes:types];
}

- (void)checkForNotificationAction {
    UILocalNotification *localNotification = [self localNotificationFromLaunchOptions];
    NSDictionary *notificationUserInfo = [localNotification userInfo];
    if (!notificationUserInfo) return;

    self.selectedNotificationCode = [notificationUserInfo objectForKey:NOTIFICATION_CODE_KEY];
    self.selectedNotificationData = [notificationUserInfo objectForKey:NOTIFICATION_DATA_KEY];
#ifdef SAMPLE
    [self.delegate localNotificationContext:self didReceiveLocalNotification:localNotification];
#else
    // Dispatch event to AS side of ExtensionContext.
    FREDispatchStatusEventAsync(self.extensionContext, (const uint8_t*)NOTIFICATION_SELECTED, (const uint8_t*)STATUS);
#endif
}

- (UILocalNotification *)localNotificationFromLaunchOptions {
    NSDictionary *launchOptions = FRPE_getApplicationLaunchOptions();
    return [launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];
}

- (void)didReceiveLocalNotification:(NSNotification*)notification {
    // Extract local notification.
    UILocalNotification *localNotification = [[notification userInfo] valueForKey:(NSString*)FRPE_ApplicationDidReceiveLocalNotificationKey];
    
    NSDictionary *notificationUserInfo = [localNotification userInfo]; 
    
    self.selectedNotificationCode = [notificationUserInfo objectForKey:NOTIFICATION_CODE_KEY];
    self.selectedNotificationData = [notificationUserInfo objectForKey:NOTIFICATION_DATA_KEY];
    
#ifndef SAMPLE
    // Dispatch event to AS side of ExtensionContext.
    FREResult result = FREDispatchStatusEventAsync(self.extensionContext, (const uint8_t*)NOTIFICATION_SELECTED, (const uint8_t*)STATUS);
    assert(result == FRE_OK);
#else
    [self.delegate localNotificationContext:self didReceiveLocalNotification:localNotification];
#endif
}

- (void)didRegisterUserNotificationSettings:(NSNotification *)notification {
    // Extract notification settings.
    self.selectedSettings = [[notification userInfo] valueForKey:(NSString*)FRPE_ApplicationDidRegisterUserNotificationSettingsKey];

#ifndef SAMPLE
    // Dispatch event to AS side of ExtensionContext.
    FREResult result = FREDispatchStatusEventAsync(self.extensionContext, (const uint8_t*)SETTINGS_SUBSCRIBED, (const uint8_t*)STATUS);
    assert(result == FRE_OK);
#else
    [self.delegate localNotificationContext:self didRegisterSettings:self.selectedSettings];
#endif
}

#ifndef SAMPLE

FREObject ADEPCreateManager(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]) {
    LocalNotificationsContext *localContextID = [ExtensionUtils getContextID:ctx];
    [localContextID createManager];

    return NULL;
}

FREObject ADEPNotify(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]) {
    LocalNotification *localNotification = [LocalNotification localNotification];
    
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
    LocalNotificationsContext *localContextID = [ExtensionUtils getContextID:ctx];
    [localContextID notify:localNotification];
    
    return NULL;
}


FREObject ADEPCancel(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]) {
    NSString *notificationCode = [ExtensionUtils getStringFromFREObject:argv[0]];
    LocalNotificationsContext *localContextID = [ExtensionUtils getContextID:ctx];
    [localContextID cancel:notificationCode];
    return NULL;
}


FREObject ADEPCancelAll(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]) {
    LocalNotificationsContext *localContextID = [ExtensionUtils getContextID:ctx];
    [localContextID cancelAll];
    return NULL;
}


FREObject ADEPRegisterSettings(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]) {
    uint32_t types = [ExtensionUtils getUIntFromFREObject:argv[0]];
    LocalNotificationsContext *localContextID = [ExtensionUtils getContextID:ctx];
    [localContextID registerSettingTypes:(UIUserNotificationType)types];
    return NULL;
}


FREObject ADEPCheckForNotificationAction(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]) {
    LocalNotificationsContext *localContextID = [ExtensionUtils getContextID:ctx];
    [localContextID checkForNotificationAction];
    return NULL;
}

FREObject ADEPGetApplicationBadgeNumber(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]) {
    int32_t appBadgeNumber = (int32_t)[UIApplication sharedApplication].applicationIconBadgeNumber;
    FREObject numberObject = [ExtensionUtils getFREObjectFromInt:appBadgeNumber];
    return numberObject;
}

FREObject ADEPSetApplicationBadgeNumber(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]) {
    int32_t appBadgeNumber = [ExtensionUtils getIntFromFREObject:argv[0]];
    [UIApplication sharedApplication].applicationIconBadgeNumber = appBadgeNumber;
    return NULL;
}

FREObject ADEPGetSelectedSettings(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]) {
    LocalNotificationsContext *localContextID = [ExtensionUtils getContextID:ctx];
    UIUserNotificationSettings* settings = localContextID.selectedSettings;
    FREObject numberObject = [ExtensionUtils getFREObjectFromUInt:(uint32_t)settings.types];
    return numberObject;
}

FREObject ADEPGetSelectedNotificationCode(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]) {
    LocalNotificationsContext *localContextID = [ExtensionUtils getContextID:ctx];
    NSString* notificationCode = localContextID.selectedNotificationCode;
    return [ExtensionUtils getFREObjectFromString:notificationCode];
}

FREObject ADEPGetSelectedNotificationData(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]) {
    LocalNotificationsContext *localContextID = [ExtensionUtils getContextID:ctx];
    NSData *notificationData = localContextID.selectedNotificationData;
    
    if(!notificationData) return NULL;

    return [ExtensionUtils getFREObjectFromData:notificationData];
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

