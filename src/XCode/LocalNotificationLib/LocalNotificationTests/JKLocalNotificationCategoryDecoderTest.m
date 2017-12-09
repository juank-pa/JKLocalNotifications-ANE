//
//  JKLocalNotificationCategoryDecoderTest.m
//  LocalNotificationLib
//
//  Created by Juan Carlos Pazmino on 11/28/17.
//
//

#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>
#import "Stubs.h"
#import "FlashRuntimeExtensions+Private.h"
#import "JKLocalNotificationCategoryDecoder.h"
#import "JKLocalNotificationCategory.h"
#import "JKLocalNotificationActionDecoder.h"
#import "ExtensionUtils.h"

@interface JKLocalNotificationCategoryDecoderTest : XCTestCase
@property (nonatomic, strong) id utilsMock;
@property (nonatomic, strong) JKLocalNotificationCategoryDecoder *subject;
@end

@implementation JKLocalNotificationCategoryDecoderTest
{
    int categoryContext;
}

- (void)setUp {
    [super setUp];
    self.utilsMock = OCMClassMock([ExtensionUtils class]);
    self.subject = [JKLocalNotificationCategoryDecoder new];
}

- (void)tearDown {
    [self.utilsMock stopMocking];
    [super tearDown];
}

- (void)testDecodeObject {
    id categoryMock = OCMClassMock([JKLocalNotificationCategory class]);
    OCMStub([categoryMock new]).andReturn(categoryMock);

    id actionDecoder = OCMClassMock([JKLocalNotificationActionDecoder class]);
    OCMStub([actionDecoder new]).andReturn(actionDecoder);

    NSArray *actions = [NSArray array];

    int identifierContext, actionsContext;

    // Property access
    OCMStub([self.utilsMock getProperty:@"identifier" fromObject:&categoryContext]).andReturn((void *)&identifierContext);
    OCMStub([self.utilsMock getProperty:@"actions" fromObject:&categoryContext]).andReturn((void *)&actionsContext);


    // Value fetch
    OCMStub([self.utilsMock getStringFromFREObject:&identifierContext]).andReturn(@"MyId");
    OCMStub([self.utilsMock getArrayFromFREObject:&actionsContext withDecoder:actionDecoder]).andReturn(actions);

    OCMExpect([categoryMock setIdentifier:@"MyId"]);
    OCMExpect([categoryMock setActions:actions]);

    XCTAssertEqual([self.subject decodeObject:(void *)&categoryContext], categoryMock);

    OCMVerifyAll(categoryMock);
    
    [categoryMock stopMocking];
    [actionDecoder stopMocking];
}

@end
