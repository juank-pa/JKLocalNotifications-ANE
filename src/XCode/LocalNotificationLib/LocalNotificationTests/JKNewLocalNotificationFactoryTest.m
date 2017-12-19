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
#import "JKNewCategoryBuilder.h"

@interface JKLegacyLocalNotificationFactory ()
@property (nonatomic, strong) JKLegacyLocalNotificationFactory *factory;
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
    XCTAssertEqual([self.subject.notificationCenter class], [UNUserNotificationCenter class]);
}

- (void)testListener {
    JKNotificationListener *listener = [self.subject listener];
    XCTAssertEqual([listener class], [JKNewNotificationListener class]);
}

- (void)testApplication {
    XCTAssertEqual([self.subject.application class], [UIApplication class]);
}

- (void)testCreateRequestBuilder {
    JKNotificationRequestBuilder *listener = [self.subject createRequestBuilder];
    XCTAssertEqual([listener class], [JKNotificationRequestBuilder class]);
}

- (void)testCreateCategoryBuilder {
    JKNewCategoryBuilder *listener = [self.subject createCategoryBuilder];
    XCTAssertEqual([listener class], [JKNewCategoryBuilder class]);
}

- (void)testCreateActionBuilder {
    id<JKActionBuilder> builder = [self.subject createActionBuilder];
    XCTAssertEqual([builder class], [JKNewActionBuilder class]);
}

- (void)testCreateTextInputActionBuilder {
    id<JKActionBuilder> builder = [self.subject createTextInputActionBuilder];
    XCTAssertEqual([builder class], [JKNewTextInputActionBuilder class]);
}

@end
