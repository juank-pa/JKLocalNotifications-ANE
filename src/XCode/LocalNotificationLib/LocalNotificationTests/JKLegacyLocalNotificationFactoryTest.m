//
//  JKLegacyLocalNotificationFactoryTest.m
//  LocalNotificationLib
//
//  Created by Juan Carlos Pazmino on 10/9/17.
//
//

#import <OCMock/OCMock.h>
#import "JKLegacyTestCase.h"
#import "JKLegacyLocalNotificationFactory.h"
#import "JKLegacyLocalNotificationAuthorizer.h"
#import "JKLegacyLocalNotificationManager.h"
#import "JKLegacyNotificationListener.h"
#import "JKNotificationBuilder.h"

@interface JKLegacyLocalNotificationAuthorizer (Test)
@property (nonatomic, strong) JKLegacyLocalNotificationFactory *factory;
@end

@interface JKLegacyLocalNotificationManager (Test)
@property (nonatomic, strong) JKLegacyLocalNotificationFactory *factory;
@end

@interface JKNotificationListener (Test)
@property (nonatomic, strong) JKLegacyLocalNotificationFactory *factory;
@end

@interface JKLegacyLocalNotificationFactoryTest : JKLegacyTestCase
@property (nonatomic, strong) JKLegacyLocalNotificationFactory *subject;
@end

@implementation JKLegacyLocalNotificationFactoryTest

- (void)setUp {
    [super setUp];
    self.subject = [JKLegacyLocalNotificationFactory new];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testCreateAuthorizer {
    id<JKAuthorizer> authorizer = [self.subject createAuthorizer];
    XCTAssertEqual([authorizer class], [JKLegacyLocalNotificationAuthorizer class]);
    XCTAssertEqual(((JKLegacyLocalNotificationAuthorizer *)authorizer).factory, self.subject);
}

- (void)testCreateManager {
    JKLocalNotificationManager *manager = [self.subject createManager];
    XCTAssertEqual([manager class], [JKLegacyLocalNotificationManager class]);
    XCTAssertEqual(((JKLegacyLocalNotificationManager *)manager).factory, self.subject);
}

- (void)testListener {
    JKNotificationListener *listener = [self.subject listener];
    XCTAssertEqual([listener class], [JKLegacyNotificationListener class]);
}

- (void)testApplication {
    XCTAssertEqual([self.subject.application class], [UIApplication class]);
}

- (void)testNotificationCenter {
    XCTAssertNil(self.subject.notificationCenter);
}

- (void)testCreateSettingsBuilder {
    JKLegacyNotificationSettingsBuilder *builder = [self.subject createSettingsBuilder];
    XCTAssertEqual([builder class], [JKLegacyNotificationSettingsBuilder class]);
}

- (void)testCreateLocalNotificationFromNotification {
    JKNotificationBuilder *builder = [self.subject createNotificationBuilder];
    XCTAssertEqual([builder class], [JKNotificationBuilder class]);
}

@end
