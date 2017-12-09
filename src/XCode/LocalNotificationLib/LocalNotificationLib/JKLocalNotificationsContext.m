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

FREObject ADEPCreateManager(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]) {
    return NULL;
}

FREObject ADEPNotify(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]) {
    @autoreleasepool {
        JKLocalNotificationDecoder *decoder = [[JKLocalNotificationDecoder alloc]
                                               initWithFREObject:argv[0]];
        JKLocalNotification *localNotification = [decoder decodeObject:argv[1]];
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
        JKLocalNotificationSettings *settings = [[JKLocalNotificationSettingsDecoder new] decodeObject:argv[0]];
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
        return [ExtensionUtils getFREObjectFromInt:appBadgeNumber];
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
        return [ExtensionUtils getFREObjectFromUInt:(uint32_t)settings.types];
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

FREObject ADEPGetSelectedNotificationAction(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]) {
    @autoreleasepool {
        NSString* notificationAction = jkNotificationsContext.notificationAction;
        return [ExtensionUtils getFREObjectFromString:notificationAction];
    }
}

#endif

#pragma mark -
#pragma mark ADEPExtensionProtocol methods

#ifndef SAMPLE

- (uint32_t)initExtensionFunctions:(const FRENamedFunction**)namedFunctions {
    uint32_t numFunctions = 11;
    
    FRENamedFunction* func = (FRENamedFunction*)malloc(sizeof(FRENamedFunction)*numFunctions);  // TODO: Free this. 
    
    func[0].name = (const uint8_t*)"notify";
    func[0].functionData = NULL;
    func[0].function = &ADEPNotify;
    
    func[1].name = (const uint8_t*)"cancel";
    func[1].functionData = NULL;
    func[1].function = &ADEPCancel;
    
    func[2].name = (const uint8_t*)"cancelAll";
    func[2].functionData = NULL;
    func[2].function = &ADEPCancelAll;
    
    func[3].name = (const uint8_t*)"checkForNotificationAction";
    func[3].functionData = NULL;
    func[3].function = &ADEPCheckForNotificationAction;
    
    func[4].name = (const uint8_t*)"getSelectedNotificationCode";
    func[4].functionData = NULL;
    func[4].function = &ADEPGetSelectedNotificationCode;

    func[5].name = (const uint8_t*)"getSelectedNotificationData";
    func[5].functionData = NULL;
    func[5].function = &ADEPGetSelectedNotificationData;
    
    func[6].name = (const uint8_t*)"setApplicationBadgeNumber";
    func[6].functionData = NULL;
    func[6].function = &ADEPSetApplicationBadgeNumber;
    
    func[7].name = (const uint8_t*)"getApplicationBadgeNumber";
    func[7].functionData = NULL;
    func[7].function = &ADEPGetApplicationBadgeNumber;
    
    func[8].name = (const uint8_t*)"registerSettings";
    func[8].functionData = NULL;
    func[8].function = &ADEPRegisterSettings;

    func[9].name = (const uint8_t*)"getSelectedSettings";
    func[9].functionData = NULL;
    func[9].function = &ADEPGetSelectedSettings;

    func[10].name = (const uint8_t*)"getSelectedNotificationAction";
    func[10].functionData = NULL;
    func[10].function = &ADEPGetSelectedNotificationAction;

    *namedFunctions = func;
    
    return numFunctions;
}

#endif

@end
