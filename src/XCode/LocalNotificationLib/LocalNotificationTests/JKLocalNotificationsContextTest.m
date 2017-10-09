//
//  LocalNotificationsContextTest.m
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

@interface JKLocalNotificationsContext (Tests)<JKAuthorizerDelegate, JKNotificationListenerDelegate>
- (void)notify:(JKLocalNotification*)localNotification;
- (void)cancel:(NSString*)notificationCode;
- (void)cancelAll;
- (void)authorizeWithSettings:(JKLocalNotificationSettings *)settings;
- (void)checkForNotificationAction;
@property (nonatomic, readonly) JKLocalNotificationManager *manager;
@property (nonatomic, retain) JKNotificationListener *listener;
@property (nonatomic, retain) JKNotificationFactory *factory;
@property (nonatomic, readonly) id<JKAuthorizer> *authorizer;
@property (nonatomic, assign) FREContext extensionContext;
@end

@interface JKLocalNotificationsContextTest : XCTestCase
@property (retain, nonatomic) JKLocalNotificationsContext *subject;
@property (retain, nonatomic) id notificationManagerMock;
@property (assign, nonatomic) id factoryMock;
@property (retain, nonatomic) id listenerMock;
@property (retain, nonatomic) id authorizerMock;
@end

@implementation JKLocalNotificationsContextTest

- (void)setUp {
    [super setUp];
    self.factoryMock = [OCMClassMock([JKNotificationFactory class]) autorelease];

    self.listenerMock = OCMClassMock([JKNotificationListener class]);
    OCMStub([self.factoryMock createListener]).andReturn(self.listenerMock);

    self.authorizerMock = OCMProtocolMock(@protocol(JKAuthorizer));
    OCMStub([self.factoryMock createAuthorizer]).andReturn(self.authorizerMock);

    self.notificationManagerMock = OCMClassMock([JKLocalNotificationManager class]);
    OCMStub([self.factoryMock createManager]).andReturn(self.notificationManagerMock);

    self.subject = [[[JKLocalNotificationsContext alloc] initWithContext:self factory:self.factoryMock] autorelease];
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
    XCTAssertEqual((id)context.authorizer, self.authorizerMock);
}

- (void)testInitialization {
    int extensionContext = 1002;

    JKLocalNotificationsContext *context = [[JKLocalNotificationsContext alloc] autorelease];
    OCMExpect([self.listenerMock setDelegate:context]);
    OCMExpect([self.authorizerMock setDelegate:context]);
    [context initWithContext:&extensionContext factory:self.factoryMock];

    XCTAssertEqual(context.extensionContext, &extensionContext);
    XCTAssertEqual(*(int *)(context.extensionContext), 1002);
    XCTAssertEqual(context.factory, self.factoryMock);
    XCTAssertEqual(context.listener, self.listenerMock);
    XCTAssertEqual(context.manager, self.notificationManagerMock);
    XCTAssertEqual((id)context.authorizer, self.authorizerMock);
    OCMVerifyAll(self.listenerMock);
    OCMVerifyAll(self.authorizerMock);
}

- (void)testListener {
    XCTAssertEqual((id)self.subject.listener, self.listenerMock);
}

- (void)testManager {
    XCTAssertEqual(self.subject.manager, self.notificationManagerMock);
}

- (void)testAuthorizer {
    XCTAssertEqual((id)self.subject.authorizer, self.authorizerMock);
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

    XCTAssertEqual(sentFreContext, self);
    XCTAssertEqual((char *)sentEventCode, JK_NOTIFICATION_SELECTED_EVENT);
    XCTAssertEqual((char *)sentEventLevel, JK_NOTIFICATION_STATUS_KEY);
}

- (void)testSettingsConfirmed {
    [self.subject notificationAuthorizer:self.authorizerMock didAuthorizeWithSettings:[JKLocalNotificationSettings new]];

    XCTAssertEqual(sentFreContext, self);
    XCTAssertEqual((char *)sentEventCode, JK_SETTINGS_SUBSCRIBED_EVENT);
    XCTAssertEqual((char *)sentEventLevel, JK_NOTIFICATION_STATUS_KEY);
}

- (void)testInitExtensionFunctions {
    const FRENamedFunction *functions = NULL;
    uint32_t functionsToSet = [self.subject initExtensionFunctions:&functions];

    XCTAssertEqual(functionsToSet, 11);

    FRENamedFunction expectedFunctions[] = {
        {
            (const uint8_t*)"createManager",
            NULL,
            &ADEPCreateManager
        },
        {
            (const uint8_t*)"notify",
            NULL,
            &ADEPNotify
        },
        {
            (const uint8_t*)"cancel",
            NULL,
            &ADEPCancel
        },
        {
            (const uint8_t*)"cancelAll",
            NULL,
            &ADEPCancelAll
        },
        {
            (const uint8_t*)"checkForNotificationAction",
            NULL,
            &ADEPCheckForNotificationAction
        },
        {
            (const uint8_t*)"getSelectedNotificationCode",
            NULL,
            &ADEPGetSelectedNotificationCode
        },
        {
            (const uint8_t*)"getSelectedNotificationData",
            NULL,
            &ADEPGetSelectedNotificationData
        },
        {
            (const uint8_t*)"setApplicationBadgeNumber",
            NULL,
            &ADEPSetApplicationBadgeNumber
        },
        {
            (const uint8_t*)"getApplicationBadgeNumber",
            NULL,
            &ADEPGetApplicationBadgeNumber
        },
        {
            (const uint8_t*)"registerSettings",
            NULL,
            &ADEPRegisterSettings
        },
        {
            (const uint8_t*)"getSelectedSettings",
            NULL,
            &ADEPGetSelectedSettings
        }
    };

    for(int i = 0; i < 11; i++) {
        XCTAssertEqual(strcmp((char *)functions[i].name, (char *)expectedFunctions[i].name), 0);
        XCTAssertEqual(functions[i].functionData, expectedFunctions[i].functionData);
        XCTAssertEqual(functions[i].function, expectedFunctions[i].function);
    }

    free((void *)functions);
}

@end
