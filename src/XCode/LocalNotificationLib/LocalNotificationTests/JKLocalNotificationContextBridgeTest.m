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
#import "JKAuthorizer.h"
#import "ExtensionUtils.h"

@interface JKLocalNotificationsContext (Tests)
- (void)notify:(JKLocalNotification*)localNotification;
- (void)cancel:(NSString*)notificationCode;
- (void)cancelAll;
- (void)authorizeWithSettings:(JKLocalNotificationSettings *)settings;
- (void)checkForNotificationAction;
@property (nonatomic, readonly) id<JKAuthorizer> authorizer;
@property (nonatomic, retain) JKNotificationListener *listener;
@end

@interface JKLocalNotificationContextBridgeTest : XCTestCase
@property (nonatomic, retain) id utilsMock;
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
    NSString *code = @"code";

    //10/17/17, 8:50 PM

    NSDate *date = [NSDate dateWithTimeIntervalSince1970:(int)NSDate.date.timeIntervalSince1970];
    NSData *data = [NSData data];

    int fireDateContext, timeContext, repeatIntervalContext, actionLabelContext;
    int bodyContext, hasActionContext, numberAnnotationContext, playSoundContext;
    int soundNameContext, actionDataContext, titleContext, launchImageContext, showInForegroundContext;

    OCMStub([self.utilsMock getStringFromFREObject:&codeContext]).andReturn(code);

    // Property access
    OCMStub([self.utilsMock getProperty:@"fireDate" fromObject:&notificationContext]).andReturn((void *)&fireDateContext);
    OCMStub([self.utilsMock getProperty:@"time" fromObject:&fireDateContext]).andReturn((void *)&timeContext);
    OCMStub([self.utilsMock getProperty:@"repeatInterval" fromObject:&notificationContext]).andReturn((void *)&repeatIntervalContext);
    OCMStub([self.utilsMock getProperty:@"actionLabel" fromObject:&notificationContext]).andReturn((void *)&actionLabelContext);
    OCMStub([self.utilsMock getProperty:@"body" fromObject:&notificationContext]).andReturn((void *)&bodyContext);
    OCMStub([self.utilsMock getProperty:@"title" fromObject:&notificationContext]).andReturn((void *)&titleContext);
    OCMStub([self.utilsMock getProperty:@"hasAction" fromObject:&notificationContext]).andReturn((void *)&hasActionContext);
    OCMStub([self.utilsMock getProperty:@"numberAnnotation" fromObject:&notificationContext]).andReturn((void *)&numberAnnotationContext);
    OCMStub([self.utilsMock getProperty:@"playSound" fromObject:&notificationContext]).andReturn((void *)&playSoundContext);
    OCMStub([self.utilsMock getProperty:@"soundName" fromObject:&notificationContext]).andReturn((void *)&soundNameContext);
    OCMStub([self.utilsMock getProperty:@"actionData" fromObject:&notificationContext]).andReturn((void *)&actionDataContext);
    OCMStub([self.utilsMock getProperty:@"launchImage" fromObject:&notificationContext]).andReturn((void *)&launchImageContext);
    OCMStub([self.utilsMock getProperty:@"showInForeground" fromObject:&notificationContext]).andReturn((void *)&showInForegroundContext);


    // Value fetch
    OCMStub([self.utilsMock getDoubleFromFREObject:&timeContext]).andReturn(date.timeIntervalSince1970 * 1000);
    OCMStub([self.utilsMock getUIntFromFREObject:&repeatIntervalContext]).andReturn(NSCalendarUnitWeekday);
    OCMStub([self.utilsMock getStringFromFREObject:&actionLabelContext]).andReturn(@"actionLabel");
    OCMStub([self.utilsMock getStringFromFREObject:&bodyContext]).andReturn(@"body");
    OCMStub([self.utilsMock getStringFromFREObject:&titleContext]).andReturn(@"title");
    OCMStub([self.utilsMock getBoolFromFREObject:&hasActionContext]).andReturn(YES);
    OCMStub([self.utilsMock getUIntFromFREObject:&numberAnnotationContext]).andReturn(15);
    OCMStub([self.utilsMock getBoolFromFREObject:&playSoundContext]).andReturn(YES);
    OCMStub([self.utilsMock getStringFromFREObject:&soundNameContext]).andReturn(@"soundName");
    OCMStub([self.utilsMock getDataFromFREObject:&actionDataContext]).andReturn(data);
    OCMStub([self.utilsMock getStringFromFREObject:&launchImageContext]).andReturn(@"launchImage.png");
    OCMStub([self.utilsMock getBoolFromFREObject:&showInForegroundContext]).andReturn(YES);


    id notificationMock = OCMStrictClassMock([JKLocalNotification class]);
    OCMStub([notificationMock localNotification]).andReturn(notificationMock);
    OCMExpect([notificationMock setNotificationCode:@"code"]);
    OCMExpect([notificationMock setFireDate:date]);
    OCMExpect([notificationMock setRepeatInterval:NSCalendarUnitWeekday]);
    OCMExpect([notificationMock setActionLabel:@"actionLabel"]);
    OCMExpect([notificationMock setBody:@"body"]);
    OCMExpect([notificationMock setTitle:@"title"]);
    OCMExpect([notificationMock setHasAction:YES]);
    OCMExpect([notificationMock setNumberAnnotation:15]);
    OCMExpect([notificationMock setPlaySound:YES]);
    OCMExpect([notificationMock setSoundName:@"soundName"]);
    OCMExpect([notificationMock setActionData:data]);
    OCMExpect([notificationMock setLaunchImage:@"launchImage.png"]);
    OCMExpect([notificationMock setShowInForeground:YES]);

    OCMExpect([jkNotificationsContext notify:notificationMock]);

    ADEPNotify(&context, NULL, 2, args);
    OCMVerifyAll(notificationMock);
    OCMVerifyAll((id)jkNotificationsContext);

    [notificationMock stopMocking];
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
    JKLocalNotificationType types = JKLocalNotificationTypeSound | JKLocalNotificationTypeBadge;
    OCMStub([self.utilsMock getUIntFromFREObject:&context]).andReturn(types);

    id settingsMock = OCMClassMock([JKLocalNotificationSettings class]);
    OCMStub([settingsMock settingsWithLocalNotificationTypes:types]).andReturn(settingsMock);


    OCMExpect([jkNotificationsContext authorizeWithSettings:settingsMock]);
    ADEPRegisterSettings(&context, NULL, 0, args);
    OCMVerifyAll((id)jkNotificationsContext);

    [settingsMock stopMocking];
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


@end
