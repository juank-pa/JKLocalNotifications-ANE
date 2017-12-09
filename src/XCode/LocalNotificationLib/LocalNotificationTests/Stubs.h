//
//  Stubs.h
//  LocalNotificationLib
//
//  Created by Juan Carlos Pazmino on 7/21/17.
//
//

#ifndef Stubs_h
#define Stubs_h
#import <UserNotifications/UserNotifications.h>
#import "FlashRuntimeExtensions.h"
#import "JKLocalNotificationsContext.h"
#import "JKNewLocalNotificationFactory.h"
#import "JKLegacyLocalNotificationFactory.h"

extern JKLocalNotificationsContext *jkNotificationsContext;

extern void *nativeContext;
extern void *sentFreContext;

extern  void *freObjectResult;
extern void *freObjectArgument;

extern int32_t freObjectIntArgument;
extern uint32_t freObjectUIntArgument;
extern double freObjectDoubleArgument;
extern uint32_t freObjectBoolArgument;

extern FREObject freObjectString;
extern FREObject freObjectArray;
extern FREObject freObjectNumber;
extern FREObject freObjectBoolean;
extern FREObject freObjectNull;

extern uint8_t* propertyName;
extern FREByteArray resultByteArray;
extern FREObject byteArrayReleased;

extern const uint8_t* sentEventCode;
extern const uint8_t* sentEventLevel;

FREObject ADEPCreateManager(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]);
FREObject ADEPNotify(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]);
FREObject ADEPCancel(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]);
FREObject ADEPCancelAll(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]);
FREObject ADEPRegisterSettings(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]);
FREObject ADEPCheckForNotificationAction(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]);
FREObject ADEPGetApplicationBadgeNumber(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]);
FREObject ADEPSetApplicationBadgeNumber(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]);
FREObject ADEPGetSelectedSettings(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]);
FREObject ADEPGetSelectedNotificationCode(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]);
FREObject ADEPGetSelectedNotificationData(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]);
FREObject ADEPGetSelectedNotificationAction(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]);
void resetEvent(void);

@interface StubCenterDelegate: NSObject<UNUserNotificationCenterDelegate>
@end

@interface StubApplication: NSObject
@property (nonatomic, weak) id<UIApplicationDelegate> delegate;
@end

@interface StubNotificationCenter: UNUserNotificationCenter
@end

@interface StubNewFactory : JKNotificationFactory
@property (nonatomic, strong, readwrite) UNUserNotificationCenter *notificationCenter;
@end

@interface StubLegacyFactory : JKLegacyLocalNotificationFactory
@property (nonatomic, strong, readwrite) UIApplication *application;
@end

#endif /* Stubs_h */
