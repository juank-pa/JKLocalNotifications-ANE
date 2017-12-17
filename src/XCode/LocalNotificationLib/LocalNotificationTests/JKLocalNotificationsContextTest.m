//
//  JKLocalNotificationsContext.m
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
#import "JKLocalNotificationManager.h"
#import "JKLocalNotification.h"
#import "JKNotificationListener.h"
#import "JKLocalNotificationSettings.h"
#import "JKNotificationFactory.h"
#import "Constants.h"
#import "macros.h"

@interface JKLocalNotificationsContext (Tests)<JKAuthorizerDelegate, JKNotificationListenerDelegate>
- (void)notify:(JKLocalNotification*)localNotification;
- (void)cancel:(NSString*)notificationCode;
- (void)cancelAll;
- (void)authorizeWithSettings:(JKLocalNotificationSettings *)settings;
- (void)checkForNotificationAction;
@property (nonatomic, readonly, strong) JKLocalNotificationManager *manager;
@property (nonatomic, strong) JKNotificationListener *listener;
@property (nonatomic, strong) JKNotificationFactory *factory;
@property (nonatomic, readonly, strong) id<JKAuthorizer> authorizer;
@property (nonatomic, assign) FREContext extensionContext;
@end

@interface JKLocalNotificationsContextTest : XCTestCase
@property (strong, nonatomic) JKLocalNotificationsContext *subject;
@property (strong, nonatomic) id notificationManagerMock;
@property (strong, nonatomic) id factoryMock;
@property (strong, nonatomic) id listenerMock;
@property (strong, nonatomic) id authorizerMock;
@end

@implementation JKLocalNotificationsContextTest
{
    NSInteger _context;
}

- (void)setUp {
    [super setUp];
    self.factoryMock = OCMClassMock([JKNotificationFactory class]);

    self.listenerMock = OCMClassMock([JKNotificationListener class]);
    OCMStub([self.factoryMock listener]).andReturn(self.listenerMock);

    self.authorizerMock = OCMProtocolMock(@protocol(JKAuthorizer));
    OCMStub([self.factoryMock createAuthorizer]).andReturn(self.authorizerMock);

    self.notificationManagerMock = OCMClassMock([JKLocalNotificationManager class]);
    OCMStub([self.factoryMock createManager]).andReturn(self.notificationManagerMock);

    _context = 10;
    self.subject = [[JKLocalNotificationsContext alloc] initWithContext:(void *)&_context factory:self.factoryMock];
}

- (void)tearDown {
    resetEvent();
    [super tearDown];
}

- (void)testStaticInitialization {
    int extensionContext = 1002;

    OCMExpect([self.listenerMock setDelegate:[OCMArg isKindOfClass:[JKLocalNotificationsContext class]]]);
    OCMExpect([self.authorizerMock setDelegate:[OCMArg isKindOfClass:[JKLocalNotificationsContext class]]]);

    JKLocalNotificationsContext *context = [JKLocalNotificationsContext notificationsContextWithContext:&extensionContext factory:self.factoryMock];

    XCTAssertEqual(context.extensionContext, &extensionContext);
    XCTAssertEqual(*(int *)(context.extensionContext), 1002);
    XCTAssertEqual(context.factory, self.factoryMock);
    XCTAssertEqual(context.listener, self.listenerMock);
    XCTAssertEqual(context.manager, self.notificationManagerMock);
    XCTAssertEqual(context.authorizer, self.authorizerMock);
}

- (void)testInitialization {
    int extensionContext = 1002;

    JKLocalNotificationsContext *context = [JKLocalNotificationsContext alloc];
    OCMExpect([self.listenerMock setDelegate:context]);
    OCMExpect([self.authorizerMock setDelegate:context]);
    [context initWithContext:&extensionContext factory:self.factoryMock];

    XCTAssertEqual(context.extensionContext, &extensionContext);
    XCTAssertEqual(*(int *)(context.extensionContext), 1002);
    XCTAssertEqual(context.factory, self.factoryMock);
    XCTAssertEqual(context.listener, self.listenerMock);
    XCTAssertEqual(context.manager, self.notificationManagerMock);
    XCTAssertEqual(context.authorizer, self.authorizerMock);
    OCMVerifyAll(self.listenerMock);
    OCMVerifyAll(self.authorizerMock);
}

- (void)testListener {
    XCTAssertEqual(self.subject.listener, self.listenerMock);
}

- (void)testManager {
    XCTAssertEqual(self.subject.manager, self.notificationManagerMock);
}

- (void)testAuthorizer {
    XCTAssertEqual(self.subject.authorizer, self.authorizerMock);
}

- (void)testNotify {
    id notification = OCMClassMock([JKLocalNotification class]);
    OCMExpect([self.notificationManagerMock notify:notification]);

    [self.subject notify:notification];

    OCMVerifyAll(self.notificationManagerMock);
}

- (void)testCancel {
    NSString *code = @"code";
    OCMExpect([self.notificationManagerMock cancel:code]);

    [self.subject cancel:code];

    OCMVerifyAll(self.notificationManagerMock);
}

- (void)testCancelAll {
    OCMExpect([self.notificationManagerMock cancelAll]);

    [self.subject cancelAll];

    OCMVerifyAll(self.notificationManagerMock);
}

- (void)testNotificationCode {
    NSString *code = @"MyCode";
    OCMStub([self.listenerMock notificationCode]).andReturn(code);
    XCTAssertEqual(self.subject.notificationCode, code);
}

- (void)testNotificationData {
    NSData *data = [NSData data];
    OCMStub([self.listenerMock notificationData]).andReturn(data);
    XCTAssertEqual(self.subject.notificationData, data);
}

- (void)testNotificationAction {
    NSString *actionId = @"ActionId";
    OCMStub([self.listenerMock notificationAction]).andReturn(actionId);
    XCTAssertEqual(self.subject.notificationAction, actionId);
}

- (void)testNotificationUserResponse {
    NSString *userResponse = @"User Response";
    OCMStub([self.listenerMock userResponse]).andReturn(userResponse);
    XCTAssertEqual(self.subject.notificationUserResponse, userResponse);
}

- (void)testSettings {
    JKLocalNotificationSettings *settings = [JKLocalNotificationSettings new];
    OCMStub([self.authorizerMock settings]).andReturn(settings);
    XCTAssertEqual(self.subject.settings, settings);
}

- (void)testAuthorizeSettingTypes {
    JKLocalNotificationType types = JKLocalNotificationTypeAlert | JKLocalNotificationTypeBadge;
    JKLocalNotificationSettings *settings = [JKLocalNotificationSettings settingsWithLocalNotificationTypes:types];
    OCMExpect([self.authorizerMock requestAuthorizationWithSettings:settings]);

    [self.subject authorizeWithSettings:settings];

    OCMVerifyAll(self.notificationManagerMock);
}

- (void)testCheckForNotificationAction {
    OCMExpect([self.listenerMock checkForNotificationAction]);
    [self.subject checkForNotificationAction];
    OCMVerifyAll(self.listenerMock);
}

- (void)testNotificationSent {
    [self.subject didReceiveNotificationDataForNotificationListener:self.listenerMock];

    XCTAssertEqual(sentFreContext, &_context);
    XCTAssertEqual((char *)sentEventCode, JK_NOTIFICATION_SELECTED_EVENT);
    XCTAssertEqual((char *)sentEventLevel, JK_NOTIFICATION_STATUS_KEY);
}

- (void)testSettingsConfirmed {
    [self.subject notificationAuthorizer:self.authorizerMock didAuthorizeWithSettings:[JKLocalNotificationSettings new]];

    XCTAssertEqual(sentFreContext, &_context);
    XCTAssertEqual((char *)sentEventCode, JK_SETTINGS_SUBSCRIBED_EVENT);
    XCTAssertEqual((char *)sentEventLevel, JK_NOTIFICATION_STATUS_KEY);
}

- (void)testMapFunctionMacro {
    FRENamedFunction namedFunction = MAP_FUNCTION(notify);
    XCTAssertEqual(strcmp((char *)namedFunction.name, "notify"), 0);
    XCTAssertEqual(namedFunction.functionData, NULL);
    XCTAssertEqual(namedFunction.function, &JKLN_notify);
}

- (void)testInitExtensionFunctions {
    const FRENamedFunction *functions = NULL;
    uint32_t functionsToSet = [self.subject initExtensionFunctions:&functions];

    FRENamedFunction expectedFunctions[] = {
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

    int funcCount = sizeof(expectedFunctions) / sizeof(FRENamedFunction);
    XCTAssertEqual(functionsToSet, funcCount);

    for(int i = 0; i < funcCount; i++) {
        XCTAssertEqual(strcmp((char *)functions[i].name, (char *)expectedFunctions[i].name), 0);
        XCTAssertEqual(functions[i].functionData, expectedFunctions[i].functionData);
        XCTAssertEqual(functions[i].function, expectedFunctions[i].function);
    }
}

@end
