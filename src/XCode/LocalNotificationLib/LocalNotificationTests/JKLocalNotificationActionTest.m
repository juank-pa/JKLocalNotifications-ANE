//
//  JKLocalNotificationAction.m
//  LocalNotificationTests
//
//  Created by Juan Carlos Pazmiño on 12/16/17.
//

#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>
#import "JKLocalNotificationAction.h"
#import "JKNotificationFactory.h"
#import "JKActionBuilder.h"

@interface JKLocalNotificationActionTest : XCTestCase
@property (nonatomic, strong) JKLocalNotificationAction *subject;
@end

@implementation JKLocalNotificationActionTest

- (void)setUp {
    [super setUp];
    self.subject = [JKLocalNotificationAction new];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testBuilder {
    id actionBuilderMock = OCMProtocolMock(@protocol(JKActionBuilder));
    id factoryMock = OCMClassMock([JKNotificationFactory class]);
    OCMStub([factoryMock factory]).andReturn(factoryMock);
    OCMStub([factoryMock createActionBuilder]).andReturn(actionBuilderMock);

    XCTAssertEqual(self.subject.builder, actionBuilderMock);

    [factoryMock stopMocking];
}

@end
