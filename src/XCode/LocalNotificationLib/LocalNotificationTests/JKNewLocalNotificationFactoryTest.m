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
#import "JKNewLocalNotificationAuthorizer.h"
#import "JKNewLocalNotificationManager.h"
#import "JKNewNotificationListener.h"

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
    XCTAssertEqual([manager class], [JKNewLocalNotificationManager class]);
}

- (void)testNotificationCenter {
    id notificationCenterMock = OCMClassMock([UNUserNotificationCenter class]);
    OCMStub([notificationCenterMock currentNotificationCenter]).andReturn(notificationCenterMock);
    XCTAssertEqual(self.subject.notificationCenter, notificationCenterMock);
    [notificationCenterMock stopMocking];
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
