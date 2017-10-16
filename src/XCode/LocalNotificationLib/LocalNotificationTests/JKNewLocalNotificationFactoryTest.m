//
//  JKNewLocalNotificationFactoryTest.m
//  LocalNotificationLib
//
//  Created by Juan Carlos Pazmino on 10/9/17.
//
//

#import <OCMock/OCMock.h>
#import <UserNotifications/UserNotifications.h>
#import "JKNewTestCase.h"
#import "JKNewLocalNotificationFactory.h"
#import "JKLegacyLocalNotificationFactory.h"
#import "JKNewLocalNotificationAuthorizer.h"
#import "JKNewLocalNotificationManager.h"
#import "JKLegacyLocalNotificationManager.h"
#import "JKNewNotificationListener.h"

@interface JKLegacyLocalNotificationFactory ()
@property (nonatomic, retain) JKLegacyLocalNotificationFactory *factory;
@end

@interface JKNewLocalNotificationFactoryTest : JKNewTestCase
@property (nonatomic, strong) JKNewLocalNotificationFactory *subject;
@property (nonatomic, strong) id notificationCenterMock;
@end

@implementation JKNewLocalNotificationFactoryTest

- (void)setUp {
    [super setUp];
    self.subject = [JKNewLocalNotificationFactory new];
    self.notificationCenterMock = OCMClassMock([UNUserNotificationCenter class]);
    OCMStub([self.notificationCenterMock currentNotificationCenter]).andReturn(self.notificationCenterMock);
}

- (void)tearDown {
    [self.notificationCenterMock stopMocking];
    [super tearDown];
}

- (void)testCreateAuthorizer {
    id<JKAuthorizer> authorizer = [self.subject createAuthorizer];
    XCTAssertEqual([authorizer class], [JKNewLocalNotificationAuthorizer class]);
}

- (void)testCreateManager {
    JKLocalNotificationManager *manager = [self.subject createManager];
    XCTAssertEqual([manager class], [JKLegacyLocalNotificationManager class]);
    XCTAssertEqual([((JKLegacyLocalNotificationFactory *)manager).factory class], [JKLegacyLocalNotificationFactory class]);
}

- (void)testNotificationCenter {
    XCTAssertEqual(self.subject.notificationCenter, self.notificationCenterMock);
}

- (void)testCreateListener {
    JKNotificationListener *listener = [self.subject createListener];
    XCTAssertEqual([listener class], [JKNewNotificationListener class]);
}

- (void)testApplication {
    id appMock = OCMClassMock([UIApplication class]);
    OCMStub([appMock sharedApplication]).andReturn(appMock);
    XCTAssertEqual(self.subject.application, appMock);
    [appMock stopMocking];
}

- (void)testCreateRequestBuilder {
    JKNotificationRequestBuilder *listener = [self.subject createRequestBuilder];
    XCTAssertEqual([listener class], [JKNotificationRequestBuilder class]);
}

@end
