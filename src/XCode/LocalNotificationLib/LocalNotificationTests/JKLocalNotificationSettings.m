//
//  JKLocalNotificationSettings.m
//  LocalNotificationLib
//
//  Created by Juan Carlos Pazmino on 10/2/17.
//
//

#import <XCTest/XCTest.h>
#import "JKLocalNotificationSettings.h"

@interface JKLocalNotificationSettingsTest : XCTestCase

@end

@implementation JKLocalNotificationSettingsTest

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testInitializeWithLocalNotificationType {
    JKLocalNotificationType types[] = {
        JKLocalNotificationTypeNone,
        JKLocalNotificationTypeAlert,
        JKLocalNotificationTypeBadge,
        JKLocalNotificationTypeSound,
        JKLocalNotificationTypeAlert | JKLocalNotificationTypeBadge,
        JKLocalNotificationTypeAlert | JKLocalNotificationTypeSound,
        JKLocalNotificationTypeBadge | JKLocalNotificationTypeSound,
        JKLocalNotificationTypeAlert | JKLocalNotificationTypeBadge | JKLocalNotificationTypeSound,
    };

    for(int i = 0; i < 8; i++) {
        JKLocalNotificationSettings *settings = [JKLocalNotificationSettings settingsWithLocalNotificationTypes:types[i]];
        XCTAssertEqual(settings.types, types[i]);

        settings = [[JKLocalNotificationSettings alloc] initWithLocalNotificationTypes:types[i]];
        XCTAssertEqual(settings.types, types[i]);
    }

    [JKLocalNotificationSettings settingsWithLocalNotificationTypes:JKLocalNotificationTypeNone];
}

- (void)testInitializeWithAuthorizationOption {
    JKLocalNotificationType types[] = {
        JKLocalNotificationTypeNone,
        JKLocalNotificationTypeAlert,
        JKLocalNotificationTypeBadge,
        JKLocalNotificationTypeSound,
        JKLocalNotificationTypeAlert | JKLocalNotificationTypeBadge,
        JKLocalNotificationTypeAlert | JKLocalNotificationTypeSound,
        JKLocalNotificationTypeBadge | JKLocalNotificationTypeSound,
        JKLocalNotificationTypeAlert | JKLocalNotificationTypeBadge | JKLocalNotificationTypeSound,
    };
    UNAuthorizationOptions options[] = {
        UNAuthorizationOptionNone,
        UNAuthorizationOptionAlert,
        UNAuthorizationOptionBadge,
        UNAuthorizationOptionSound,
        UNAuthorizationOptionAlert | UNAuthorizationOptionBadge,
        UNAuthorizationOptionAlert | UNAuthorizationOptionSound,
        UNAuthorizationOptionBadge | UNAuthorizationOptionSound,
        UNAuthorizationOptionAlert | UNAuthorizationOptionBadge | UNAuthorizationOptionSound,
    };

    for(int i = 0; i < 8; i++) {
        JKLocalNotificationSettings *settings = [JKLocalNotificationSettings settingswithAuthorizationOptions:options[i]];
        XCTAssertEqual(settings.types, types[i]);
        XCTAssertEqual(settings.authorizationOptions, options[i]);

        settings = [[[JKLocalNotificationSettings alloc] initWithAuthorizationOptions:options[i]] autorelease];
        XCTAssertEqual(settings.types, types[i]);
        XCTAssertEqual(settings.authorizationOptions, options[i]);
    }

    [JKLocalNotificationSettings settingsWithLocalNotificationTypes:JKLocalNotificationTypeNone];
}

- (void)testInitializeWithUserNotificationTypes {
    JKLocalNotificationType types[] = {
        JKLocalNotificationTypeNone,
        JKLocalNotificationTypeAlert,
        JKLocalNotificationTypeBadge,
        JKLocalNotificationTypeSound,
        JKLocalNotificationTypeAlert | JKLocalNotificationTypeBadge,
        JKLocalNotificationTypeAlert | JKLocalNotificationTypeSound,
        JKLocalNotificationTypeBadge | JKLocalNotificationTypeSound,
        JKLocalNotificationTypeAlert | JKLocalNotificationTypeBadge | JKLocalNotificationTypeSound,
    };
    UIUserNotificationType userTypes[] = {
        UIUserNotificationTypeNone,
        UIUserNotificationTypeAlert,
        UIUserNotificationTypeBadge,
        UIUserNotificationTypeSound,
        UIUserNotificationTypeAlert | UIUserNotificationTypeBadge,
        UIUserNotificationTypeAlert | UIUserNotificationTypeSound,
        UIUserNotificationTypeBadge | UIUserNotificationTypeSound,
        UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound,
    };

    for(int i = 0; i < 8; i++) {
        JKLocalNotificationType type = types[i];
        UIUserNotificationType userType = userTypes[i];

        JKLocalNotificationSettings *settings = [JKLocalNotificationSettings settingsWithUserNotificationTypes:userTypes[i]];
        XCTAssertEqual(settings.types, type);
        XCTAssertEqual(settings.notificationTypes, userType);

        settings = [[[JKLocalNotificationSettings alloc] initWithUserNotificationTypes:userType] autorelease];
        XCTAssertEqual(settings.types, type);
        XCTAssertEqual(settings.notificationTypes, userType);
    }

    [JKLocalNotificationSettings settingsWithLocalNotificationTypes:JKLocalNotificationTypeNone];
}

@end
