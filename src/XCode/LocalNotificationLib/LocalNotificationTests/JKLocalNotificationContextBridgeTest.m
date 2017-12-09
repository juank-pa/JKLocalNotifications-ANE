//
//  JKLocalNotificationContextBridgeTest.m
//  LocalNotificationLib
//
//  Created by Juan Carlos Pazmino on 7/21/17.
//
//

#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>
#import "Stubs.h"
#import "FlashRuntimeExtensions+Private.h"
#import "JKLocalNotificationsContext.h"
#import "JKLocalNotification.h"
#import "JKLocalNotificationSettings.h"
#import "JKNotificationListener.h"
#import "JKLocalNotificationDecoder.h"
#import "JKLocalNotificationSettingsDecoder.h"
#import "JKAuthorizer.h"
#import "ExtensionUtils.h"

@interface JKLocalNotificationsContext (Tests)
- (void)notify:(JKLocalNotification*)localNotification;
- (void)cancel:(NSString*)notificationCode;
- (void)cancelAll;
- (void)authorizeWithSettings:(JKLocalNotificationSettings *)settings;
- (void)checkForNotificationAction;
@property (nonatomic, readonly) id<JKAuthorizer> authorizer;
@property (nonatomic, strong) JKNotificationListener *listener;
@end

@interface JKLocalNotificationContextBridgeTest : XCTestCase
@property (nonatomic, strong) id utilsMock;
@end

int context;
FREObject args[] = {&context, &context};

@implementation JKLocalNotificationContextBridgeTest

- (void)setUp {
    [super setUp];

    jkNotificationsContext = OCMClassMock([JKLocalNotificationsContext class]);

    self.utilsMock = OCMClassMock([ExtensionUtils class]);
}

- (void)tearDown {
    [self.utilsMock stopMocking];
    jkNotificationsContext = nil;
    [super tearDown];
}

- (void)testNotify {
    int codeContext, notificationContext;
    FREObject args[] = {&codeContext, &notificationContext};
    JKLocalNotification *notification = [JKLocalNotification new];

    id notificationDecoderMock = OCMClassMock([JKLocalNotificationDecoder class]);
    OCMStub([notificationDecoderMock alloc]).andReturn(notificationDecoderMock);
    OCMStub([notificationDecoderMock initWithFREObject:(void *)&codeContext]).andReturn(notificationDecoderMock);
    OCMStub([notificationDecoderMock decodeObject:(void *)&notificationContext]).andReturn(notification);

    OCMExpect([jkNotificationsContext notify:notification]);

    ADEPNotify(&context, NULL, 2, args);
    OCMVerifyAll((id)jkNotificationsContext);

    [notificationDecoderMock stopMocking];
}

- (void)testCancel {
    OCMStub([self.utilsMock getStringFromFREObject:&context]).andReturn(@"My String");
    OCMExpect([jkNotificationsContext cancel:@"My String"]);
    ADEPCancel(&context, NULL, 0, args);
    OCMVerifyAll((id)jkNotificationsContext);
}

- (void)testCancelAll {
    OCMExpect([jkNotificationsContext cancelAll]);
    ADEPCancelAll(&context, NULL, 0, args);
    OCMVerifyAll((id)jkNotificationsContext);
}

- (void)testAuthorizeWithSettings {

    int notificationSettingsContext;
    FREObject args[] = {&notificationSettingsContext};
    JKLocalNotificationSettings *notificationSettings = [JKLocalNotificationSettings new];

    id notificationSettingsDecoderMock = OCMClassMock([JKLocalNotificationSettingsDecoder class]);
    OCMStub([notificationSettingsDecoderMock new]).andReturn(notificationSettingsDecoderMock);
    OCMStub([notificationSettingsDecoderMock decodeObject:(void *)&notificationSettingsContext]).andReturn(notificationSettings);

    OCMExpect([jkNotificationsContext authorizeWithSettings:notificationSettings]);

    ADEPRegisterSettings(&context, NULL, 2, args);
    OCMVerifyAll((id)jkNotificationsContext);

    [notificationSettingsDecoderMock stopMocking];
}

- (void)testCheckForNotificationAction {
    OCMExpect([jkNotificationsContext checkForNotificationAction]);
    ADEPCheckForNotificationAction(&context, NULL, 0, args);
    OCMVerifyAll((id)jkNotificationsContext);
}

- (void)testGetApplicationBadgeNumber {
    int badgeNum = 6;

    id appMock = OCMClassMock([UIApplication class]);
    OCMExpect([appMock sharedApplication]).andReturn(appMock);
    OCMExpect([appMock applicationIconBadgeNumber]).andReturn(badgeNum);

    OCMStub([self.utilsMock getFREObjectFromInt:badgeNum]).andReturn((FREObject)&badgeNum);

    FREObject ret = ADEPGetApplicationBadgeNumber(&context, NULL, 0, args);
    XCTAssertEqual(ret, &badgeNum);
    XCTAssertEqual(*(int *)ret, 6);
    OCMVerifyAll(appMock);

    [appMock stopMocking];
}

- (void)testSetApplicationBadgeNumber {
    int badgeNum = 6;

    id appMock = OCMClassMock([UIApplication class]);
    OCMExpect([appMock sharedApplication]).andReturn(appMock);
    OCMExpect([appMock setApplicationIconBadgeNumber:badgeNum]);

    OCMStub([self.utilsMock getIntFromFREObject:&context])
        .andReturn(badgeNum);

    ADEPSetApplicationBadgeNumber(&context, NULL, 0, args);
    OCMVerifyAll(appMock);

    [appMock stopMocking];
}

- (void)testGetSelectedSettings {
    JKLocalNotificationType types = JKLocalNotificationTypeSound | JKLocalNotificationTypeBadge;
    JKLocalNotificationSettings *settings = [JKLocalNotificationSettings settingsWithLocalNotificationTypes:types];

    OCMExpect([jkNotificationsContext settings]).andReturn(settings);
    OCMStub([self.utilsMock getFREObjectFromUInt:types]).andReturn((FREObject)&types);

    FREObject ret = ADEPGetSelectedSettings(&context, NULL, 0, args);
    XCTAssertEqual(ret, &types);
    XCTAssertEqual(*(int *)ret, JKLocalNotificationTypeSound | JKLocalNotificationTypeBadge);
    OCMVerifyAll((id)jkNotificationsContext);
}

- (void)testGetSelectedNotificationCode {
    char codeStr[] = "Code";
    NSString *code = @"Code";

    OCMExpect([jkNotificationsContext notificationCode]).andReturn(code);
    OCMStub([self.utilsMock getFREObjectFromString:code]).andReturn((FREObject)codeStr);

    FREObject ret = ADEPGetSelectedNotificationCode(&context, NULL, 0, args);
    XCTAssertEqual((void *)codeStr, ret);
    OCMVerifyAll((id)jkNotificationsContext);
}

- (void)testGetSelectedNotificationData {
    const char rawData[] = "hi";
    NSData *data = [NSData dataWithBytes:rawData length:3];

    OCMExpect([jkNotificationsContext notificationData]).andReturn(data);
    OCMStub([self.utilsMock getFREObjectFromData:data]).andReturn((FREObject)rawData);

    FREObject ret = ADEPGetSelectedNotificationData(&context, NULL, 0, args);
    XCTAssertEqual((void *)rawData, ret);
    OCMVerifyAll((id)jkNotificationsContext);
}

- (void)testGetSelectedNotificationAction {
    char actionStr[] = "Code";
    NSString *actionId = @"ActionId";

    OCMExpect([jkNotificationsContext notificationAction]).andReturn(actionId);
    OCMStub([self.utilsMock getFREObjectFromString:actionId]).andReturn((FREObject)actionStr);

    FREObject ret = ADEPGetSelectedNotificationAction(&context, NULL, 0, args);
    XCTAssertEqual((void *)actionStr, ret);
    OCMVerifyAll((id)jkNotificationsContext);
}

@end
