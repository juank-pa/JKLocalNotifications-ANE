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


static const char* const STATUS = "status";
static const char* const NOTIFICATION_SELECTED = "notificationSelected";

@interface LocalNotificationsContext()

    - (void) createManager;
    - (void) notify :(LocalNotification*)localNotification;
    - (void) cancel :(NSString*)notificationCode;
    - (void) cancelAll;

    @property (nonatomic, copy) NSString *selectedNotificationCode;
    @property (nonatomic, copy) NSData *selectedNotificationData;

@end


@implementation LocalNotificationsContext

#ifdef TEST

@synthesize delegate;
#endif

@synthesize selectedNotificationCode, selectedNotificationData;

- (id) initWithContext :(FREContext)ctx 
{
    self = [super init];
    if (self) 
    {
        extensionContext = ctx;
    }
    
    return self;
}


- (void) dealloc 
{
    extensionContext = nil;
    [notificationManager release];
    [selectedNotificationCode release];
    [selectedNotificationData release];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:(NSString *)FRPE_ApplicationDidReceiveLocalNotification object:nil];
    
    [super dealloc];
}


- (void) createManager
{
    notificationManager = [[LocalNotificationManager alloc] init];
    
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                          selector:@selector(ADEPDidReceiveLocalNotification:) 
                                          name:(NSString *)FRPE_ApplicationDidReceiveLocalNotification 
                                          object:nil];
}

- (void) notify :(LocalNotification*)localNotification
{
    [notificationManager notify :localNotification];
}


- (void) cancel :(NSString*)notificationCode
{
    [notificationManager cancel :notificationCode];
}


- (void) cancelAll
{
    [notificationManager cancelAll];
}

-(void)checkForNotificationAction
{
    NSDictionary *launchOptions = FRPE_getApplicationLaunchOptions();
    
    if (launchOptions)
    {
        UILocalNotification *localNotification = [launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];
        if (localNotification)
        {
            NSDictionary *notificationUserInfo = [localNotification userInfo];
            if (notificationUserInfo) 
            {
                [self setSelectedNotificationCode :[notificationUserInfo objectForKey:NOTIFICATION_CODE_KEY]];
                [self setSelectedNotificationData :[notificationUserInfo objectForKey:NOTIFICATION_DATA_KEY]];
#ifdef TEST
                [self.delegate localNotificationContext:self didReceiveLocalNotification:localNotification];
#else     
                // Dispatch event to AS side of ExtensionContext.
                FREDispatchStatusEventAsync(extensionContext, (const uint8_t*)NOTIFICATION_SELECTED, (const uint8_t*)STATUS);
#endif
            }
        }
    }
}

- (void) ADEPDidReceiveLocalNotification :(NSNotification*)notification
{
    // Extract local notification.
    UILocalNotification *localNotification = [[notification userInfo] valueForKey:(NSString*)FRPE_ApplicationDidReceiveLocalNotificationKey];
    
    NSDictionary *notificationUserInfo = [localNotification userInfo]; 
    
    self.selectedNotificationCode = [notificationUserInfo objectForKey:NOTIFICATION_CODE_KEY];
    self.selectedNotificationData = [notificationUserInfo objectForKey:NOTIFICATION_DATA_KEY];
    
#ifndef TEST
    // Dispatch event to AS side of ExtensionContext.
    FREResult result = FREDispatchStatusEventAsync(extensionContext, (const uint8_t*)NOTIFICATION_SELECTED, (const uint8_t*)STATUS);
    assert(result == FRE_OK);
#else
    [self.delegate localNotificationContext:self didReceiveLocalNotification:localNotification];
#endif
}

#ifndef TEST

FREObject ADEPCreateManager(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[])
{    
    LocalNotificationsContext *localContextID = [ExtensionUtils getContextID:ctx];
    [localContextID createManager];

    return NULL;
}

FREObject ADEPNotify(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[])
{    
    LocalNotification *localNotification = [[[LocalNotification alloc] init] autorelease];
    
    FREObject propertyValue = NULL;
    FREResult freReturnCode;
    
    // Notification Code.
    NSString *notificationCode = [ExtensionUtils getStringFromFREObject:argv[0]];
    if (notificationCode)
    {
        localNotification.notificationCode = notificationCode;
    }
    
    // Fire Date.
    freReturnCode = FREGetObjectProperty(argv[1], (const uint8_t*)"fireDate", &propertyValue, nil);
    if (freReturnCode == FRE_OK && propertyValue)
    {
        FREObject timeProperty = NULL;
        FREGetObjectProperty(propertyValue, (const uint8_t *)"time", &timeProperty, NULL);
        
        uint32_t time = [ExtensionUtils getDoubleFromFREObject:timeProperty] / 1000.0;
        if (time)
        {
            localNotification.fireDate = [NSDate dateWithTimeIntervalSince1970:time];
        }
    }
    
    // Repeat Interval.
    freReturnCode = FREGetObjectProperty(argv[1], (const uint8_t*)"repeatInterval", &propertyValue, nil);
    if (freReturnCode == FRE_OK && propertyValue)
    {
        uint32_t repeatInterval = [ExtensionUtils getUIntFromFREObject:propertyValue];
        if (repeatInterval)
        {
            localNotification.repeatInterval = repeatInterval;
        }
    }
    
    // Action Label.
    freReturnCode = FREGetObjectProperty(argv[1], (const uint8_t*)"actionLabel", &propertyValue, nil);
    if (freReturnCode == FRE_OK && propertyValue)
    {
        NSString *actionLabel = [ExtensionUtils getStringFromFREObject:propertyValue];
        if (actionLabel)
        {
            localNotification.actionLabel = actionLabel;
        }
    }
    
    // Body.
    freReturnCode = FREGetObjectProperty(argv[1], (const uint8_t*)"body", &propertyValue, nil);
    if (freReturnCode == FRE_OK && propertyValue)
    {
        NSString *body = [ExtensionUtils getStringFromFREObject:propertyValue];
        if (body)
        {
            localNotification.body = body;
        }
    }
    
    // Has Action.
    freReturnCode = FREGetObjectProperty(argv[1], (const uint8_t*)"hasAction", &propertyValue, nil);
    if (freReturnCode == FRE_OK && propertyValue)
    {
        uint32_t hasAction;
        freReturnCode = FREGetObjectAsBool(propertyValue, &hasAction);
        if (freReturnCode == FRE_OK)
        {
            localNotification.hasAction = hasAction;
        }
    }
    
    // Number Annotation.
    freReturnCode = FREGetObjectProperty(argv[1], (const uint8_t*)"numberAnnotation", &propertyValue, nil);
    if (freReturnCode == FRE_OK && propertyValue)
    {
        int32_t numberAnnotation;
        freReturnCode = FREGetObjectAsInt32(propertyValue, &numberAnnotation);
        if (freReturnCode == FRE_OK)
        {
            localNotification.numberAnnotation = numberAnnotation;
        }
    }
    
    // Play Sound.
    freReturnCode = FREGetObjectProperty(argv[1], (const uint8_t*)"playSound", &propertyValue, nil);
    if (freReturnCode == FRE_OK && propertyValue)
    {
        uint32_t playSound;
        freReturnCode = FREGetObjectAsBool(propertyValue, &playSound);
        if (freReturnCode == FRE_OK)
        {
            localNotification.playSound = playSound;
        }
    }
    
    // Sound name.
    freReturnCode = FREGetObjectProperty(argv[1], (const uint8_t*)"soundName", &propertyValue, nil);
    if (freReturnCode == FRE_OK && propertyValue)
    {
        NSString *soundName = [ExtensionUtils getStringFromFREObject:propertyValue];
        if (soundName)
        {
            localNotification.soundName = soundName;
        }
    }
    
    // Action Data.
    freReturnCode = FREGetObjectProperty(argv[1], (const uint8_t*)"actionData", &propertyValue, nil);
    
    FREByteArray byteArray;
    localNotification.actionData = [NSData data];
    
    if (freReturnCode == FRE_OK && propertyValue)
    {
        freReturnCode = FREAcquireByteArray(propertyValue, &byteArray);
        if (freReturnCode == FRE_OK)
        {
            localNotification.actionData = [NSData dataWithBytes :byteArray.bytes length:byteArray.length];
            FREReleaseByteArray(propertyValue);
        }
    }
    
    // Notify.
    LocalNotificationsContext *localContextID = [ExtensionUtils getContextID:ctx];
    [localContextID notify :localNotification];
    
    return NULL;
}


FREObject ADEPCancel(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[])
{    
    NSString *notificationCode = [ExtensionUtils getStringFromFREObject:argv[0]];
    LocalNotificationsContext *localContextID = [ExtensionUtils getContextID:ctx];
    [localContextID cancel :notificationCode];    
    return NULL;
}


FREObject ADEPCancelAll(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[])
{    
    LocalNotificationsContext *localContextID = [ExtensionUtils getContextID:ctx];
    [localContextID cancelAll];
    return NULL;
}


FREObject ADEPCheckForNotificationAction(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[])
{    
    LocalNotificationsContext *localContextID = [ExtensionUtils getContextID:ctx];
    [localContextID checkForNotificationAction];
    
    return NULL;
}

FREObject ADEPGetApplicationBadgeNumber(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[])
{
    int32_t appBadgeNumber = [UIApplication sharedApplication].applicationIconBadgeNumber;
    FREObject numberObject = [ExtensionUtils getFREObjectFromInt:appBadgeNumber];
    return numberObject;
}

FREObject ADEPSetApplicationBadgeNumber(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[])
{
    int32_t appBadgeNumber = [ExtensionUtils getIntFromFREObject:argv[0]];
    [UIApplication sharedApplication].applicationIconBadgeNumber = appBadgeNumber;
    return NULL;
}

FREObject ADEPGetSelectedNotificationCode(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[])
{    
    LocalNotificationsContext *localContextID = [ExtensionUtils getContextID:ctx];
    NSString* notificationCode = [localContextID selectedNotificationCode];
    return [ExtensionUtils getFREObjectFromString:notificationCode];
}

FREObject ADEPGetSelectedNotificationData(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[])
{    
    LocalNotificationsContext *localContextID = [ExtensionUtils getContextID:ctx];
    NSData* notificationData = [localContextID selectedNotificationData];
    
    if(!notificationData) return NULL;
    
    FREResult result;
    
    FREObject byteArray;
    const uint8_t* className = (uint8_t*)"flash.utils.ByteArray";
    result = FRENewObject(className, 0, nil, &byteArray, nil);
    assert(result == FRE_OK);
    
    const unsigned char *data = [notificationData bytes];
    int dataLength = [notificationData length];
    
    // Construct an ActionScript ByteArray object containing the action data of the selected notification.
    for (int i = 0; i < dataLength; i++)
    {
        FREObject arguments[] = {nil};
        arguments[0] = [ExtensionUtils getFREObjectFromInt:data[i]];
        
        const uint8_t* methodName = (uint8_t*)"writeByte";
        FREObject methodResult;
        FREResult result = FRECallObjectMethod(byteArray, methodName, 1, arguments, &methodResult, nil);
        assert(result == FRE_OK);
    }
    return byteArray;
}

#endif

#pragma mark -
#pragma mark ADEPExtensionProtocol methods

#ifndef TEST

- (uint32_t) initExtensionFunctions:(const FRENamedFunction**) namedFunctions
{
    uint32_t numFunctions = 9;
    
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
    
    *namedFunctions = func;
    
    return numFunctions;
}

#endif

@end

