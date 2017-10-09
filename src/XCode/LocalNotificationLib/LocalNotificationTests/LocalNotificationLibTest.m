//
//  LocalNotificationTests.m
//  LocalNotificationTests
//
//  Created by Juan Carlos Pazmino on 7/21/17.
//
//

#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>
#include <string.h>
#import "Stubs.h"
#import "JKLocalNotificationsContext.h"
#import "JKNotificationFactory.h"
#import "ExtensionUtils.h"
#import "DeallocVerify.h"

void ComJkLocalNotificationContextInitializer(void* extData, const uint8_t* ctxType, FREContext ctx,
                                              uint32_t* numFunctionsToTest, const FRENamedFunction** functionsToSet);
void ComJkLocalNotificationContextFinalizer(FREContext ctx);
void ComJkLocalNotificationExtInitializer(void** extDataToSet, FREContextInitializer* ctxInitializerToSet,
                                          FREContextFinalizer* ctxFinalizerToSet);

@interface JKLocalNotificationsContext ()
@property (nonatomic, assign) FREContext extensionContext;
@end

@interface LocalNotificationLibTests : XCTestCase

@end

@implementation LocalNotificationLibTests

- (void)setUp {
    [super setUp];
    sentFreContext = NULL;
    nativeContext = NULL;
}

- (void)tearDown {
    [super tearDown];
}

- (void)testExtInitializer {
    FREContextInitializer ctxInitializerToSet = NULL;
    FREContextFinalizer ctxFinalizerToSet = NULL;
    void* extDataToSet = NULL;

    ComJkLocalNotificationExtInitializer(&extDataToSet, &ctxInitializerToSet, &ctxFinalizerToSet);

    XCTAssertEqual(extDataToSet, NULL);
    XCTAssertEqual(ctxInitializerToSet, &ComJkLocalNotificationContextInitializer);
    XCTAssertEqual(ctxFinalizerToSet, &ComJkLocalNotificationContextFinalizer);
}

- (void)testContextInitializer {
    int context = 1002;
    uint32_t functionsToSet = 0;
    const FRENamedFunction *functions = NULL;

    id factoryMock = [OCMClassMock([JKNotificationFactory class]) autorelease];
    OCMStub([factoryMock factory]).andReturn(factoryMock);

    id notificationContextMock = [OCMClassMock([JKLocalNotificationsContext class]) autorelease];
    OCMStub([notificationContextMock notificationsContextWithContext:&context factory:factoryMock]).andReturn(notificationContextMock);
    OCMExpect([notificationContextMock initExtensionFunctions:&functions]).andReturn(3);

    id utilMock = OCMClassMock([ExtensionUtils class]);
    OCMExpect([utilMock setContextID:notificationContextMock forFREContext:&context]);

    ComJkLocalNotificationContextInitializer(NULL, NULL, &context, &functionsToSet, &functions);

    XCTAssertEqual(functionsToSet, 3);
    OCMVerifyAll(notificationContextMock);
    OCMVerifyAll(utilMock);

    [(id)nativeContext release];
    [(id)factoryMock release];
}

- (void)testContextFinalizer {
    [DeallocVerify reset];
    int context = 1002;
    DeallocVerify *verify = [[DeallocVerify instance] retain];

    id utilMock = OCMClassMock([ExtensionUtils class]);
    OCMExpect([utilMock getContextID:&context]).andReturn(verify);

    ComJkLocalNotificationContextFinalizer(&context);
    XCTAssertEqual(DeallocVerify.deallocationCount, 1);
}

@end
