//
//  JKLocalNotificationActionDecoderTest.m
//  LocalNotificationLib
//
//  Created by Juan Carlos Pazmino on 11/28/17.
//
//

#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>
#import "Stubs.h"
#import "FlashRuntimeExtensions+Private.h"
#import "JKLocalNotificationActionDecoder.h"
#import "JKLocalNotificationAction.h"
#import "ExtensionUtils.h"

@interface JKLocalNotificationActionDecoderTest : XCTestCase
@property (nonatomic, strong) id utilsMock;
@property (nonatomic, strong) JKLocalNotificationActionDecoder *subject;
@end

@implementation JKLocalNotificationActionDecoderTest
{
    int actionContext;
}

- (void)setUp {
    [super setUp];
    self.utilsMock = OCMClassMock([ExtensionUtils class]);
    self.subject = [JKLocalNotificationActionDecoder new];
}

- (void)tearDown {
    [self.utilsMock stopMocking];
    [super tearDown];
}

- (void)testDecodeObject {
    id actionMock = OCMClassMock([JKLocalNotificationAction class]);
    OCMStub([actionMock new]).andReturn(actionMock);

    int identifierContext, titleContext;

    // Property access
    OCMStub([self.utilsMock getProperty:@"identifier" fromObject:&actionContext]).andReturn((void *)&identifierContext);
    OCMStub([self.utilsMock getProperty:@"title" fromObject:&actionContext]).andReturn((void *)&titleContext);


    // Value fetch
    OCMStub([self.utilsMock getStringFromFREObject:&identifierContext]).andReturn(@"MyId");
    OCMStub([self.utilsMock getStringFromFREObject:&titleContext]).andReturn(@"Title");

    OCMExpect([actionMock setIdentifier:@"MyId"]);
    OCMExpect([actionMock setTitle:@"Title"]);

    XCTAssertEqual([self.subject decodeObject:(void *)&actionContext], actionMock);

    OCMVerifyAll(actionMock);

    [actionMock stopMocking];
}

@end
