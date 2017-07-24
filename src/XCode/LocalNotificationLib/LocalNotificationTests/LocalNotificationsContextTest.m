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
#import "LocalNotificationsContext.h"
#import "LocalNotificationAppDelegate.h"
#import "LocalNotificationManager.h"
#import "LocalNotification.h"

@interface LocalNotificationsContext (Tests)
- (void)createManager;
- (void)notify:(LocalNotification*)localNotification;
- (void)cancel:(NSString*)notificationCode;
- (void)cancelAll;
- (void)registerSettingTypes:(UIUserNotificationType)types;
- (void)checkForNotificationAction;
@property (nonatomic, retain) LocalNotificationAppDelegate *sourceDelegate;
@property (nonatomic, retain) LocalNotificationManager *notificationManager;
@property (nonatomic, copy) NSString *selectedNotificationCode;
@property (nonatomic, copy) NSData *selectedNotificationData;
@property (nonatomic, retain) UIUserNotificationSettings *selectedSettings;
@property (nonatomic, assign) FREContext extensionContext;
@end

@interface LocalNotificationsContextTest : XCTestCase
@property (retain, nonatomic) LocalNotificationsContext *subject;
@property (retain, nonatomic) id notificationManagerMock;
@end

@implementation LocalNotificationsContextTest

- (void)setUp {
    [super setUp];
    self.notificationManagerMock = OCMClassMock([LocalNotificationManager class]);
    OCMStub([self.notificationManagerMock new]).andReturn(self.notificationManagerMock);
    self.subject = [[LocalNotificationsContext alloc] initWithContext:self];
}

- (void)tearDown {
    [self.subject release];
    resetEvent();
    [super tearDown];
}

- (void)testInitialization {
    id appDelegateMock = OCMProtocolMock(@protocol(UIApplicationDelegate));
    id appMock = OCMClassMock([UIApplication class]);
    OCMStub([appMock sharedApplication]).andReturn(appMock);
    OCMStub([appMock delegate]).andReturn(appDelegateMock);

    int extensionContext = 1002;
    LocalNotificationsContext *context = [LocalNotificationsContext notificationsContextWithContext:&extensionContext];

    XCTAssertEqual(context.extensionContext, &extensionContext);
    XCTAssertEqual(*(int *)(context.extensionContext), 1002);
    XCTAssertTrue([context.sourceDelegate isKindOfClass:[LocalNotificationAppDelegate class]]);
    XCTAssertEqual(appDelegateMock, context.sourceDelegate.target);
}

- (void)testCreateManager {
    XCTAssertNil(self.subject.notificationManager);
    [self.subject createManager];
    XCTAssertEqual(self.subject.notificationManager, self.notificationManagerMock);
}

- (void)testNotify {
    id notification = OCMClassMock([LocalNotification class]);
    [self.subject createManager];
    OCMExpect([self.notificationManagerMock notify:notification]);

    [self.subject notify:notification];

    OCMVerifyAll(self.notificationManagerMock);
}

- (void)testCancel {
    NSString *code = @"code";
    [self.subject createManager];
    OCMExpect([self.notificationManagerMock cancel:code]);

    [self.subject cancel:code];

    OCMVerifyAll(self.notificationManagerMock);
}

- (void)testCancelAll {
    [self.subject createManager];
    OCMExpect([self.notificationManagerMock cancelAll]);

    [self.subject cancelAll];

    OCMVerifyAll(self.notificationManagerMock);
}

- (void)testRegisterSettingTypes {
    UIUserNotificationType type = UIUserNotificationTypeAlert | UIUserNotificationTypeBadge;
    [self.subject createManager];
    OCMExpect([self.notificationManagerMock registerSettingTypes:type]);

    [self.subject registerSettingTypes:type];

    OCMVerifyAll(self.notificationManagerMock);
}

- (void)testCheckForNotificationAction {
    XCTAssertNil(self.subject.selectedNotificationCode);
    XCTAssertNil(self.subject.selectedNotificationData);

    [self.subject checkForNotificationAction];

    XCTAssertEqualObjects(self.subject.selectedNotificationCode, @"NotificationCodeKey");
    XCTAssertEqualObjects(self.subject.selectedNotificationData, @"NotificationDataKey");
    XCTAssertEqual(sentFreContext, self);
    XCTAssertEqual((char *)sentEventCode, NOTIFICATION_SELECTED);
    XCTAssertEqual((char *)sentEventLevel, STATUS);
}

- (void)testNotificationSent {
    [self.subject createManager];
    XCTAssertNil(self.subject.selectedNotificationCode);
    XCTAssertNil(self.subject.selectedNotificationData);

    UILocalNotification *localNotification = [[UILocalNotification new] autorelease];
    localNotification.userInfo = @{
                                   NOTIFICATION_CODE_KEY: @"MyNotificationCodeKey",
                                   NOTIFICATION_DATA_KEY: @"MyNotificationDataKey"
                                   };
    [[NSNotificationCenter defaultCenter] postNotificationName:(NSString *)FRPE_ApplicationDidReceiveLocalNotification
                                                        object:self
                                                      userInfo:@{FRPE_ApplicationDidReceiveLocalNotificationKey: localNotification}];

    XCTAssertEqualObjects(self.subject.selectedNotificationCode, @"MyNotificationCodeKey");
    XCTAssertEqualObjects(self.subject.selectedNotificationData, @"MyNotificationDataKey");
    XCTAssertEqual(sentFreContext, self);
    XCTAssertEqual((char *)sentEventCode, NOTIFICATION_SELECTED);
    XCTAssertEqual((char *)sentEventLevel, STATUS);
}

- (void)testSettingsConfirmed {
    [self.subject createManager];
    XCTAssertNil(self.subject.selectedSettings);

    UIUserNotificationType types = UIUserNotificationTypeAlert | UIUserNotificationTypeBadge;
    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:(NSString *)FRPE_ApplicationDidRegisterUserNotificationSettings
                                                        object:self
                                                      userInfo:@{FRPE_ApplicationDidRegisterUserNotificationSettingsKey: settings}];

    XCTAssertEqual(self.subject.selectedSettings.types, types);
    XCTAssertEqual(sentFreContext, self);
    XCTAssertEqual((char *)sentEventCode, SETTINGS_SUBSCRIBED);
    XCTAssertEqual((char *)sentEventLevel, STATUS);
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
