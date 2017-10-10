//
//  JKLegacyLocalNotificationFactoryTest.m
//  LocalNotificationLib
//
//  Created by Juan Carlos Pazmino on 10/9/17.
//
//

#import "JKLegacyTestCase.h"
#import "JKLegacyLocalNotificationFactory.h"
#import "JKLegacyLocalNotificationAuthorizer.h"
#import "JKLegacyLocalNotificationManager.h"
#import "JKLegacyNotificationListener.h"

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
}

- (void)testCreateManager {
    JKLocalNotificationManager *manager = [self.subject createManager];
    XCTAssertEqual([manager class], [JKLegacyLocalNotificationManager class]);
}

- (void)testCreateListener {
    JKNotificationListener *listener = [self.subject createListener];
    XCTAssertEqual([listener class], [JKLegacyNotificationListener class]);
}

@end
