//
//  JKTextInputLocalNotificationActionTest.m
//  LocalNotificationTests
//
//  Created by Juan Carlos Pazmiño on 12/16/17.
//

#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>
#import "JKTextInputLocalNotificationAction.h"
#import "JKNotificationFactory.h"
#import "JKActionBuilder.h"

@interface JKTextInputLocalNotificationActionTest : XCTestCase
@property (nonatomic, strong) JKTextInputLocalNotificationAction *subject;
@end

@implementation JKTextInputLocalNotificationActionTest

- (void)setUp {
    [super setUp];
    self.subject = [JKTextInputLocalNotificationAction new];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testBuilder {
    id actionBuilderMock = OCMProtocolMock(@protocol(JKActionBuilder));
    id factoryMock = OCMClassMock([JKNotificationFactory class]);
    OCMStub([factoryMock factory]).andReturn(factoryMock);
    OCMStub([factoryMock createTextInputActionBuilder]).andReturn(actionBuilderMock);

    XCTAssertEqual(self.subject.builder, actionBuilderMock);

    [factoryMock stopMocking];
}

@end
