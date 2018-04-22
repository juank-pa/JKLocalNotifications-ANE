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
@property (nonatomic, strong) id categoryMock;
@property (nonatomic, strong) id actionDecoderMock;
@property (nonatomic, strong) NSArray *actions;
@end

typedef NS_ENUM(NSInteger, NotificationCategoryDecoderFlag){
    NotificationCategoryDecoderFlagNone,
    NotificationCategoryDecoderFlagUseCustomDismissAction
};

@implementation JKLocalNotificationCategoryDecoderTest
{
    int categoryContext;
}

- (void)setUp {
    [super setUp];
    self.utilsMock = OCMClassMock([ExtensionUtils class]);
    self.subject = [JKLocalNotificationCategoryDecoder new];

    self.categoryMock = OCMClassMock([JKLocalNotificationCategory class]);
    OCMStub([self.categoryMock new]).andReturn(self.categoryMock);

    self.actionDecoderMock = OCMClassMock([JKLocalNotificationActionDecoder class]);
    OCMStub([self.actionDecoderMock new]).andReturn(self.actionDecoderMock);
}

- (void)tearDown {
    [self.utilsMock stopMocking];
    [self.categoryMock stopMocking];
    [self.actionDecoderMock stopMocking];
    [super tearDown];
}

- (void)setupCategoryDecoder:(NotificationCategoryDecoderFlag)flag {
    int identifierContext, actionsContext, useCustomDismissActionContext;

    self.actions = [NSArray array];

    // Property access
    OCMStub([self.utilsMock getProperty:@"identifier" fromObject:&categoryContext]).andReturn((void *)&identifierContext);
    OCMStub([self.utilsMock getProperty:@"actions" fromObject:&categoryContext]).andReturn((void *)&actionsContext);
    OCMStub([self.utilsMock getProperty:@"useCustomDismissAction" fromObject:&categoryContext]).andReturn((void *)&useCustomDismissActionContext);

    // Value fetch
    OCMStub([self.utilsMock getStringFromFREObject:&identifierContext]).andReturn(@"MyId");
    OCMStub([self.utilsMock getArrayFromFREObject:&actionsContext withDecoder:self.actionDecoderMock]).andReturn(self.actions);
    OCMStub([self.utilsMock getBoolFromFREObject:&useCustomDismissActionContext]).andReturn(flag == NotificationCategoryDecoderFlagUseCustomDismissAction);
}

- (void)testDecodeObject {
    [self setupCategoryDecoder:(NotificationCategoryDecoderFlagNone)];

    OCMExpect([self.categoryMock setIdentifier:@"MyId"]);
    OCMExpect([self.categoryMock setActions:self.actions]);

    XCTAssertEqual([self.subject decodeObject:(void *)&categoryContext], self.categoryMock);

    OCMVerifyAll(self.categoryMock);
}

- (void)testDecodeObjectUseCustomDismissAction {
    [self setupCategoryDecoder:(NotificationCategoryDecoderFlagUseCustomDismissAction)];

    OCMExpect([self.categoryMock setUseCustomDismissAction:YES]);

    XCTAssertEqual([self.subject decodeObject:(void *)&categoryContext], self.categoryMock);

    OCMVerifyAll(self.categoryMock);
}

@end
