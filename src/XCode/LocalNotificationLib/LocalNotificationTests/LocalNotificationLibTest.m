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
    jkNotificationsContext = nil;
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

    id factoryMock = OCMClassMock([JKNotificationFactory class]);
    OCMStub([factoryMock factory:NO]).andReturn(factoryMock);

    id notificationContextMock = OCMClassMock([JKLocalNotificationsContext class]);
    OCMStub([notificationContextMock notificationsContextWithContext:&context factory:factoryMock]).andReturn(notificationContextMock);
    OCMExpect([notificationContextMock initExtensionFunctions:&functions]).andReturn(3);

    ComJkLocalNotificationContextInitializer(NULL, NULL, &context, &functionsToSet, &functions);

    XCTAssertEqual(functionsToSet, 3);
    XCTAssertEqual(jkNotificationsContext, notificationContextMock);
    OCMVerifyAll(notificationContextMock);

    [factoryMock stopMocking];
    [notificationContextMock stopMocking];
}

- (void)testContextInitializerNewApi {
    int context = 1002;
    uint32_t functionsToSet = 0;
    const FRENamedFunction *functions = NULL;

    id factoryMock = OCMClassMock([JKNotificationFactory class]);
    OCMExpect([factoryMock factory:YES]).andReturn(factoryMock);

    id notificationContextMock = OCMClassMock([JKLocalNotificationsContext class]);
    OCMStub([notificationContextMock notificationsContextWithContext:&context factory:factoryMock]).andReturn(notificationContextMock);
    OCMExpect([notificationContextMock initExtensionFunctions:&functions]).andReturn(3);

    ComJkLocalNotificationContextInitializer(NULL, (uint8_t *)"LocalNotificationsContextNew", &context, &functionsToSet, &functions);

    XCTAssertEqual(functionsToSet, 3);
    XCTAssertEqual(jkNotificationsContext, notificationContextMock);
    OCMVerifyAll(notificationContextMock);
    OCMVerifyAll(factoryMock);

    [factoryMock stopMocking];
    [notificationContextMock stopMocking];
}

- (void)testContextFinalizer {
    [DeallocVerify reset];

    @autoreleasepool {
        jkNotificationsContext = (id)[DeallocVerify instance];
        ComJkLocalNotificationContextFinalizer(NULL);
    }

    XCTAssertNil(jkNotificationsContext);
    XCTAssertEqual(DeallocVerify.deallocationCount, 1);
}

@end
