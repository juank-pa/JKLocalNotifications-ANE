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

FREObject JKLN_createManager(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]);
FREObject JKLN_notify(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]);
FREObject JKLN_cancel(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]);
FREObject JKLN_cancelAll(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]);
FREObject JKLN_registerSettings(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]);
FREObject JKLN_checkForNotificationAction(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]);
FREObject JKLN_getApplicationBadgeNumber(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]);
FREObject JKLN_setApplicationBadgeNumber(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]);
FREObject JKLN_getSelectedSettings(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]);
FREObject JKLN_getSelectedNotificationCode(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]);
FREObject JKLN_getSelectedNotificationData(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]);
FREObject JKLN_getSelectedNotificationAction(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]);
FREObject JKLN_getSelectedNotificationUserResponse(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]);
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
