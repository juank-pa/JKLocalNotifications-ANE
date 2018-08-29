//
//  JKNewCategoryBuilderTest.m
//  LocalNotificationLib
//
//  Created by Juan Carlos Pazmino on 12/3/17.
//
//

#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>
#import "JKNewTestCase.h"
#import "JKNewCategoryBuilder.h"
#import "JKNewActionBuilder.h"

@interface JKNewCategoryBuilderTest : JKNewTestCase
@property (nonatomic, strong) JKNewCategoryBuilder *subject;
@property (nonatomic, strong) id actionBuilderMock;
@end

@implementation JKNewCategoryBuilderTest

- (void)setUp {
    [super setUp];
    self.subject = [JKNewCategoryBuilder new];

    self.actionBuilderMock = OCMClassMock([JKNewActionBuilder class]);
}

- (void)tearDown {
    [self.actionBuilderMock stopMocking];
    [super tearDown];
}

- (JKLocalNotificationCategory *)categoryWithIdentifier:(NSString *)identifier actions:(NSArray *)actions {
    JKLocalNotificationCategory *category = [JKLocalNotificationCategory new];
    category.identifier = identifier;
    category.actions = actions;
    return category;
}

- (void)testBuildFromCategory {
    JKLocalNotificationCategory *category = [self categoryWithIdentifier:@"catId" actions:@[]];
    NSArray *actions = [NSArray array];

    OCMStub([self.actionBuilderMock buildFromActions:category.actions]).andReturn(actions);

    id categoryMock = OCMClassMock([UNNotificationCategory class]);
    OCMExpect([categoryMock categoryWithIdentifier:@"catId" actions:actions intentIdentifiers:[NSArray array] options:UNNotificationCategoryOptionNone]).andReturn(categoryMock);

    XCTAssertEqual([self.subject buildFromCategory:category], categoryMock);

    OCMVerifyAll(categoryMock);
    [categoryMock stopMocking];
}

- (void)testBuildFromCategoryForCategoryUsingCustomDismissAction {
    JKLocalNotificationCategory *category = [self categoryWithIdentifier:@"catId" actions:@[]];
    category.useCustomDismissAction = YES;

    OCMStub([self.actionBuilderMock buildFromActions:category.actions]).andReturn([NSArray array]);

    id categoryMock = OCMClassMock([UNNotificationCategory class]);
    OCMExpect([categoryMock categoryWithIdentifier:@"catId" actions:[NSArray array] intentIdentifiers:[NSArray array] options:UNNotificationCategoryOptionCustomDismissAction]).andReturn(categoryMock);

    XCTAssertEqual([self.subject buildFromCategory:category], categoryMock);

    OCMVerifyAll(categoryMock);
    [categoryMock stopMocking];
}

@end
