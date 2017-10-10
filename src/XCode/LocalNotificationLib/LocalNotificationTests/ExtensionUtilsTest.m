//
//  ExtensionUtilsTest.m
//  LocalNotificationLib
//
//  Created by Juan Carlos Pazmino on 7/21/17.
//
//

#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>
#import "Stubs.h"
#import "FlashRuntimeExtensions+Private.h"
#import "ExtensionUtils.h"

@interface ExtensionUtilsTest : XCTestCase

@end

@implementation ExtensionUtilsTest

- (void)setUp {
    [super setUp];
    nativeContext = NULL;
    sentFreContext = NULL;
    freObjectArgument = NULL;
    propertyName = NULL;
}

- (void)tearDown {
    [super tearDown];
}

- (void)testSetContextId {
    NSString *newNativeContext = @"nativeContext";
    int freContext;

    XCTAssertNil((__bridge id)nativeContext);
    [ExtensionUtils setContextID:newNativeContext forFREContext:&freContext];
    XCTAssertEqual(sentFreContext, &freContext);
    XCTAssertEqual((__bridge id)nativeContext, newNativeContext);
}

- (void)testGetContextId {
    nativeContext = @"nativeContext";
    int freContext;

    id contextData = [ExtensionUtils getContextID:&freContext];
    XCTAssertEqual(sentFreContext, &freContext);
    XCTAssertEqual((__bridge id)nativeContext, contextData);
}

- (void)testGetPropertyFromObject {
    NSString *propName = @"propName";
    FREObject result = [ExtensionUtils getProperty:propName fromObject:freObjectBoolean];

    XCTAssertEqual(strcmp((char *)propertyName, "propName"), 0);
    XCTAssertEqual(result, freObjectString);
    XCTAssertEqual(freObjectArgument, freObjectBoolean);
}

- (void)testGetFREObjectFromString {
    XCTAssertNil([ExtensionUtils getFREObjectFromString:@""]);

    NSString *argument = @"hello";
    FREObject result = [ExtensionUtils getFREObjectFromString:argument];

    XCTAssertEqual(result, freObjectResult);
    XCTAssertEqual(strcmp("hello", freObjectArgument), 0);
}

- (void)testGetFREObjectFromInt {
    FREObject result = [ExtensionUtils getFREObjectFromInt:-30];

    XCTAssertEqual(result, freObjectResult);
    XCTAssertEqual(freObjectArgument, &freObjectIntArgument);
    XCTAssertEqual(freObjectIntArgument, -30);
}

- (void)testGetFREObjectFromUInt {
    FREObject result = [ExtensionUtils getFREObjectFromUInt:35];

    XCTAssertEqual(result, freObjectResult);
    XCTAssertEqual(freObjectArgument, &freObjectUIntArgument);
    XCTAssertEqual(freObjectUIntArgument, 35);
}

- (void)testGetFREObjectFromDouble {
    FREObject result = [ExtensionUtils getFREObjectFromDouble:3.5];

    XCTAssertEqual(result, freObjectResult);
    XCTAssertEqual(freObjectArgument, &freObjectDoubleArgument);
    XCTAssertEqual(freObjectDoubleArgument, 3.5);
}

- (void)testGetFREObjectFromBool {
    FREObject result = [ExtensionUtils getFREObjectFromBool:YES];

    XCTAssertEqual(result, freObjectResult);
    XCTAssertEqual(freObjectArgument, &freObjectBoolArgument);
    XCTAssertEqual(freObjectBoolArgument, 1);

    [ExtensionUtils getFREObjectFromBool:NO];
    XCTAssertEqual(freObjectBoolArgument, 0);
}

- (void)testGetStringFromFREObject {
    XCTAssertNil([ExtensionUtils getStringFromFREObject:freObjectNull]);
    XCTAssertEqualObjects([ExtensionUtils getStringFromFREObject:freObjectString], @"result string");
    XCTAssertEqual(freObjectArgument, freObjectString);
}

- (void)testGetIntFromFREObject {
    XCTAssertEqual([ExtensionUtils getIntFromFREObject:freObjectNumber], -30);
    XCTAssertEqual(freObjectArgument, freObjectNumber);
}

- (void)testGetUIntFromFREObject {
    XCTAssertEqual([ExtensionUtils getUIntFromFREObject:freObjectNumber], 35);
    XCTAssertEqual(freObjectArgument, freObjectNumber);
}

- (void)testGetDoubleFromFREObject {
    XCTAssertEqual([ExtensionUtils getDoubleFromFREObject:freObjectNumber], 3.5);
    XCTAssertEqual(freObjectArgument, freObjectNumber);
}

- (void)testGetBoolFromFREObject {
    XCTAssertEqual([ExtensionUtils getBoolFromFREObject:freObjectBoolean], YES);
    XCTAssertEqual(freObjectArgument, freObjectBoolean);
}

- (void)testGetColorFromFREObject {
    XCTAssertEqualObjects([ExtensionUtils getColorFromFREObject:freObjectNumber], [UIColor colorWithRed:0 green:0 blue:0 alpha:1.0]);
    XCTAssertEqual(freObjectArgument, freObjectNumber);
}

- (void)testGetByteArrayFromObject {
    XCTAssertNil([ExtensionUtils getDataFromFREObject:NULL]);
    NSData *byteArray = [ExtensionUtils getDataFromFREObject:freObjectBoolean];
    NSString *string = [[NSString alloc] initWithBytes:byteArray.bytes
                                                length:byteArray.length - 1
                                              encoding:NSUTF8StringEncoding];
    XCTAssertEqualObjects(string, @"result");
    XCTAssertEqual(freObjectArgument, freObjectBoolean);
    XCTAssertEqual(byteArrayReleased, freObjectBoolean);
}

- (void)testGetFREObjectFromData {
    const char rawData[] = "hi";
    NSData *data = [NSData dataWithBytes:rawData length:3];

    id utilsMock = OCMClassMock([ExtensionUtils class]);
    OCMStub([utilsMock getFREObjectFromData:[OCMArg any]]).andForwardToRealObject();

    OCMStub([utilsMock getFREObjectFromInt:'h']).andReturn((FREObject)rawData);
    OCMStub([utilsMock getFREObjectFromInt:'i']).andReturn((FREObject)(rawData + 1));
    OCMStub([utilsMock getFREObjectFromInt:'\0']).andReturn((FREObject)(rawData + 2));

    FREObject ret = [ExtensionUtils getFREObjectFromData: data];
    XCTAssertEqual(strcmp(rawData, ret), 0);
}

@end
