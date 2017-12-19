//
//  JKNewActionBuilderTest.m
//  LocalNotificationLib
//
//  Created by Juan Carlos Pazmino on 12/3/17.
//
//

#import <OCMock/OCMock.h>
#import <XCTest/XCTest.h>
#import "JKNewTestCase.h"
#import "JKNewActionBuilder.h"

@interface JKNewActionBuilderTest : JKNewTestCase
@property (nonatomic, strong) JKNewActionBuilder *subject;
@end

@implementation JKNewActionBuilderTest

- (void)setUp {
    [super setUp];
    self.subject = [JKNewActionBuilder new];
}

- (void)tearDown {
    [super tearDown];
}

- (JKLocalNotificationAction *)actionWithIdentifier:(NSString *)identifier title:(NSString *)title {
    JKLocalNotificationAction *action = [JKLocalNotificationAction new];
    action.identifier = identifier;
    action.title = title;
    return action;
}

- (void)assertAction:(UNNotificationAction *)result basedOnAction:(JKLocalNotificationAction *)action {
    XCTAssertEqualObjects(result.title, action.title);
    XCTAssertEqualObjects(result.identifier, action.identifier);
}

- (void)testBuildFromNonBackgroundAction {
    JKLocalNotificationAction *action = [self actionWithIdentifier:@"actionId" title:@"Action"];
    action.background = NO;

    UNNotificationAction *result = [self.subject buildFromAction:action];
    XCTAssertEqual(result.options, UNNotificationActionOptionForeground);
    [self assertAction:result basedOnAction:action];
}

- (void)testBuildFromBackgroundAction {
    JKLocalNotificationAction *action = [self actionWithIdentifier:@"actionId" title:@"Action"];
    action.background = YES;

    UNNotificationAction *result = [self.subject buildFromAction:action];
    XCTAssertEqual(result.options, UNNotificationActionOptionNone);
    [self assertAction:result basedOnAction:action];
}

- (void)testBuildFromActions {
    id action1 = OCMClassMock([JKLocalNotificationAction class]);
    id action2 = OCMClassMock([JKLocalNotificationAction class]);

    id builder1 = OCMClassMock([JKNewActionBuilder class]);
    id builder2 = OCMClassMock([JKNewActionBuilder class]);

    id nativeAction1 = OCMClassMock([UNNotificationAction class]);
    id nativeAction2 = OCMClassMock([UNNotificationAction class]);

    OCMStub([action1 builder]).andReturn(builder1);
    OCMStub([action2 builder]).andReturn(builder2);

    OCMStub([builder1 buildFromAction:action1]).andReturn(nativeAction1);
    OCMStub([builder2 buildFromAction:action2]).andReturn(nativeAction2);

    NSArray *actions = @[action1, action2];
    NSArray *expectedActions = @[nativeAction1, nativeAction2];

    NSArray<UNNotificationAction *> *result = [JKNewActionBuilder buildFromActions:actions];

    XCTAssertEqualObjects(result, expectedActions);
}

@end
