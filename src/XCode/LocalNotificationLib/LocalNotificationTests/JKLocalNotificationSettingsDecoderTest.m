//
//  JKLocalNotificationSettingsDecoderTest.m
//  LocalNotificationLib
//
//  Created by Juan Carlos Pazmiño on 11/27/17.
//
//

#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>
#import "Stubs.h"
#import "FlashRuntimeExtensions+Private.h"
#import "JKLocalNotificationSettingsDecoder.h"
#import "JKLocalNotificationSettings.h"
#import "JKLocalNotificationCategoryDecoder.h"
#import "ExtensionUtils.h"

@interface JKLocalNotificationSettingsDecoderTest : XCTestCase
@property (nonatomic, strong) JKLocalNotificationSettingsDecoder *subject;
@property (nonatomic, strong) id utilsMock;
@end

@implementation JKLocalNotificationSettingsDecoderTest
{
    int context;
}

- (void)setUp {
    [super setUp];
    self.utilsMock = OCMClassMock([ExtensionUtils class]);
    self.subject = [JKLocalNotificationSettingsDecoder new];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testDecodeObject {
    JKLocalNotificationType types = JKLocalNotificationTypeAlert | JKLocalNotificationTypeBadge;
    NSArray *categories = [NSArray array];

    id settingsMock = OCMClassMock([JKLocalNotificationSettings class]);
    OCMExpect([settingsMock settingsWithLocalNotificationTypes:types]).andReturn(settingsMock);

    id categoryDecoderMock = OCMClassMock([JKLocalNotificationCategoryDecoder class]);
    OCMStub([categoryDecoderMock new]).andReturn(categoryDecoderMock);

    int categoriesContext, flagsContext;

    // Property access
    OCMStub([self.utilsMock getProperty:@"notificationStyleFlags" fromObject:(void *)&context]).andReturn((void *)&flagsContext);
    OCMStub([self.utilsMock getProperty:@"categories" fromObject:&context]).andReturn((void *)&categoriesContext);


    // Value fetch
    OCMStub([self.utilsMock getUIntFromFREObject:(void *)&flagsContext]).andReturn(types);
    OCMStub([self.utilsMock getArrayFromFREObject:&categoriesContext withDecoder:categoryDecoderMock]).andReturn(categories);

    OCMExpect([settingsMock setCategories:categories]);

    XCTAssertEqual([self.subject decodeObject:(void *)&context], settingsMock);

    OCMVerifyAll(settingsMock);

    [settingsMock stopMocking];
    [categoryDecoderMock stopMocking];
}

@end
