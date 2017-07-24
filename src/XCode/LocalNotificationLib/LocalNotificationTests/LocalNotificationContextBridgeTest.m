//
//  LocalNotificationContextBridgeTest.m
//  LocalNotificationLib
//
//  Created by Juan Carlos Pazmino on 7/21/17.
//
//

#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>
#import "Stubs.h"
#import "FlashRuntimeExtensions+Private.h"
#import "LocalNotificationsContext.h"
#import "LocalNotification.h"
#import "ExtensionUtils.h"

@interface LocalNotificationsContext (Tests)
- (void)createManager;
- (void)notify:(LocalNotification*)localNotification;
- (void)cancel:(NSString*)notificationCode;
- (void)cancelAll;
- (void)registerSettingTypes:(UIUserNotificationType)types;
- (void)checkForNotificationAction;
@property (nonatomic, copy) NSString *selectedNotificationCode;
@property (nonatomic, copy) NSData *selectedNotificationData;
@property (nonatomic, retain) UIUserNotificationSettings *selectedSettings;
@end

@interface LocalNotificationContextBridgeTest : XCTestCase
@property (nonatomic, retain) id contextMock;
@property (nonatomic, retain) id utilsMock;
@end

@interface LocalNotification ()
-(NSString *)notificationCode;
-(void)setNotificationCode:(NSString *)code;
@end

int context;
FREObject args[] = {&context, &context};

@implementation LocalNotificationContextBridgeTest

- (void)setUp {
    [super setUp];

    self.contextMock = OCMClassMock([LocalNotificationsContext class]);

    self.utilsMock = OCMClassMock([ExtensionUtils class]);
    OCMStub([self.utilsMock getContextID:&context]).andReturn(self.contextMock);
}

- (void)tearDown {
    [super tearDown];
}

- (void)testCreateManager {
    OCMExpect([self.contextMock createManager]);
    ADEPCreateManager(&context, NULL, 0, args);
    OCMVerifyAll(self.contextMock);
}

- (void)testNotify {
    int codeContext, notificationContext;
    FREObject args[] = {&codeContext, &notificationContext};
    NSString *code = @"code";
    NSDate *date = [NSDate date];
    NSData *data = [NSData data];

    int fireDateContext, timeContext, repeatIntervalContext, actionLabelContext;
    int bodyContext, hasActionContext, numberAnnotationContext, playSoundContext;
    int soundNameContext, actionDataContext;

    OCMStub([self.utilsMock getStringFromFREObject:&codeContext]).andReturn(code);

    // Property access
    OCMStub([self.utilsMock getProperty:@"fireDate" fromObject:&notificationContext]).andReturn((void *)&fireDateContext);
    OCMStub([self.utilsMock getProperty:@"time" fromObject:&fireDateContext]).andReturn((void *)&timeContext);
    OCMStub([self.utilsMock getProperty:@"repeatInterval" fromObject:&notificationContext]).andReturn((void *)&repeatIntervalContext);
    OCMStub([self.utilsMock getProperty:@"actionLabel" fromObject:&notificationContext]).andReturn((void *)&actionLabelContext);
    OCMStub([self.utilsMock getProperty:@"body" fromObject:&notificationContext]).andReturn((void *)&bodyContext);
    OCMStub([self.utilsMock getProperty:@"hasAction" fromObject:&notificationContext]).andReturn((void *)&hasActionContext);
    OCMStub([self.utilsMock getProperty:@"numberAnnotation" fromObject:&notificationContext]).andReturn((void *)&numberAnnotationContext);
    OCMStub([self.utilsMock getProperty:@"playSound" fromObject:&notificationContext]).andReturn((void *)&playSoundContext);
    OCMStub([self.utilsMock getProperty:@"soundName" fromObject:&notificationContext]).andReturn((void *)&soundNameContext);
    OCMStub([self.utilsMock getProperty:@"actionData" fromObject:&notificationContext]).andReturn((void *)&actionDataContext);


    // Value fetch
    OCMStub([self.utilsMock getDoubleFromFREObject:&timeContext]).andReturn(date.timeIntervalSince1970 * 1000);
    OCMStub([self.utilsMock getUIntFromFREObject:&repeatIntervalContext]).andReturn(NSCalendarUnitWeekday);
    OCMStub([self.utilsMock getStringFromFREObject:&actionLabelContext]).andReturn(@"actionLabel");
    OCMStub([self.utilsMock getStringFromFREObject:&bodyContext]).andReturn(@"body");
    OCMStub([self.utilsMock getBoolFromFREObject:&hasActionContext]).andReturn(YES);
    OCMStub([self.utilsMock getUIntFromFREObject:&numberAnnotationContext]).andReturn(15);
    OCMStub([self.utilsMock getBoolFromFREObject:&playSoundContext]).andReturn(YES);
    OCMStub([self.utilsMock getStringFromFREObject:&soundNameContext]).andReturn(@"soundName");
    OCMStub([self.utilsMock getDataFromFREObject:&actionDataContext]).andReturn(data);


    id notificationMock = OCMStrictClassMock([LocalNotification class]);
    OCMStub([notificationMock localNotification]).andReturn(notificationMock);
    OCMExpect([notificationMock setNotificationCode:@"code"]);
    OCMExpect([notificationMock setFireDate:[OCMArg checkWithBlock:^BOOL(NSDate *value) {
        return value.timeIntervalSince1970 == date.timeIntervalSince1970;
    }]]);
    OCMExpect([notificationMock setRepeatInterval:NSCalendarUnitWeekday]);
    OCMExpect([notificationMock setActionLabel:@"actionLabel"]);
    OCMExpect([notificationMock setBody:@"body"]);
    OCMExpect([notificationMock setHasAction:YES]);
    OCMExpect([notificationMock setNumberAnnotation:15]);
    OCMExpect([notificationMock setPlaySound:YES]);
    OCMExpect([notificationMock setSoundName:@"soundName"]);
    OCMExpect([notificationMock setActionData:data]);

    OCMExpect([self.contextMock notify:notificationMock]);

    ADEPNotify(&context, NULL, 2, args);
    OCMVerifyAll(notificationMock);
    OCMVerifyAll(self.contextMock);
}

- (void)testCancel {
    OCMStub([self.utilsMock getStringFromFREObject:&context]).andReturn(@"My String");
    OCMExpect([self.contextMock cancel:@"My String"]);
    ADEPCancel(&context, NULL, 0, args);
    OCMVerifyAll(self.contextMock);
}

- (void)testCancelAll {
    OCMExpect([self.contextMock cancelAll]);
    ADEPCancelAll(&context, NULL, 0, args);
    OCMVerifyAll(self.contextMock);
}

- (void)testRegisterSettings {
    UIUserNotificationType types = UIUserNotificationTypeSound | UIUserNotificationTypeBadge;
    OCMStub([self.utilsMock getUIntFromFREObject:&context]).andReturn(types);
    OCMExpect([self.contextMock registerSettingTypes:types]);
    ADEPRegisterSettings(&context, NULL, 0, args);
    OCMVerifyAll(self.contextMock);
}

- (void)testCheckForNotificationAction {
    OCMExpect([self.contextMock checkForNotificationAction]);
    ADEPCheckForNotificationAction(&context, NULL, 0, args);
    OCMVerifyAll(self.contextMock);
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
}

- (void)testGetSelectedSettings {
    UIUserNotificationType types = UIUserNotificationTypeSound | UIUserNotificationTypeBadge;
    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:types categories:nil];

    OCMExpect([self.contextMock selectedSettings]).andReturn(settings);
    OCMStub([self.utilsMock getFREObjectFromUInt:types]).andReturn((FREObject)&types);

    FREObject ret = ADEPGetSelectedSettings(&context, NULL, 0, args);
    XCTAssertEqual(ret, &types);
    XCTAssertEqual(*(int *)ret, UIUserNotificationTypeSound | UIUserNotificationTypeBadge);
    OCMVerifyAll(self.contextMock);
}

- (void)testGetSelectedNotificationCode {
    NSString *code = @"Code";

    OCMExpect([self.contextMock selectedNotificationCode]).andReturn(code);
    OCMStub([self.utilsMock getFREObjectFromString:code]).andReturn((FREObject)code);

    FREObject ret = ADEPGetSelectedNotificationCode(&context, NULL, 0, args);
    XCTAssertEqual(ret, code);
    OCMVerifyAll(self.contextMock);
}

- (void)testGetSelectedNotificationData {
    const char rawData[] = "hi";
    NSData *data = [NSData dataWithBytes:rawData length:3];

    OCMExpect([self.contextMock selectedNotificationData]).andReturn(data);
    OCMStub([self.utilsMock getFREObjectFromData:data]).andReturn((FREObject)rawData);

    FREObject ret = ADEPGetSelectedNotificationData(&context, NULL, 0, args);
    XCTAssertEqual((void *)rawData, ret);
    OCMVerifyAll(self.contextMock);
}


@end
