//
//  JKLegacyCategoryBuilderTest.m
//  LocalNotificationLib
//
//  Created by Juan Carlos Pazmino on 12/3/17.
//
//

#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>
#import "JKLegacyTestCase.h"
#import "JKLegacyCategoryBuilder.h"
#import "JKLegacyActionBuilder.h"

@interface JKLegacyCategoryBuilderTest : JKLegacyTestCase
@property (nonatomic, strong) JKLegacyCategoryBuilder *subject;
@property (nonatomic, strong) id actionBuilderMock;
@end

@implementation JKLegacyCategoryBuilderTest

- (void)setUp {
    [super setUp];
    self.subject = [JKLegacyCategoryBuilder new];

    self.actionBuilderMock = OCMClassMock([JKLegacyActionBuilder class]);
    OCMStub([self.actionBuilderMock new]).andReturn(self.actionBuilderMock);
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

    id categoryMock = OCMClassMock([UIMutableUserNotificationCategory class]);
    OCMStub([categoryMock new]).andReturn(categoryMock);
    OCMExpect([categoryMock setIdentifier:@"catId"]);
    OCMExpect([categoryMock setActions:actions forContext:UIUserNotificationActionContextDefault]);
    OCMExpect([categoryMock setActions:actions forContext:UIUserNotificationActionContextMinimal]);

    XCTAssertEqual([self.subject buildFromCategory:category], categoryMock);

    OCMVerifyAll(categoryMock);
    [categoryMock stopMocking];
}

@end
