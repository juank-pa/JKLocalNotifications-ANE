//
//  JKLegacyActionBuilderTest.m
//  LocalNotificationLib
//
//  Created by Juan Carlos Pazmino on 12/3/17.
//
//

#import <OCMock/OCMock.h>
#import <XCTest/XCTest.h>
#import "JKLegacyTestCase.h"
#import "JKLegacyActionBuilder.h"
#import "JKTextInputLocalNotificationAction.h"
#import "NSArray+HigherOrder.h"

@interface JKLegacyActionBuilderTest : JKLegacyTestCase
@property (nonatomic, strong) JKLegacyActionBuilder *subject;
@end

@implementation JKLegacyActionBuilderTest

- (void)setUp {
    [super setUp];
    self.subject = [JKLegacyActionBuilder new];
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

- (void)assertAction:(UIUserNotificationAction *)result basedOnAction:(JKLocalNotificationAction *)action {
    XCTAssertEqualObjects(result.title, action.title);
    XCTAssertEqualObjects(result.identifier, action.identifier);
    if ([result respondsToSelector:@selector(behavior)]) {
        XCTAssertEqual(result.behavior, UIUserNotificationActionBehaviorDefault);
    }
    XCTAssertFalse(result.authenticationRequired);
}

- (void)testBuildFromNonBackgroundAction {
    JKLocalNotificationAction *action = [self actionWithIdentifier:@"actionId" title:@"Action"];
    action.background = NO;

    UIUserNotificationAction *result = [self.subject buildFromAction:action];
    XCTAssertEqual(result.activationMode, UIUserNotificationActivationModeForeground);
    [self assertAction:result basedOnAction:action];
}

- (void)testBuildFromBackgroundAction {
    JKLocalNotificationAction *action = [self actionWithIdentifier:@"actionId" title:@"Action"];
    action.background = YES;

    UIUserNotificationAction *result = [self.subject buildFromAction:action];
    XCTAssertEqual(result.activationMode, UIUserNotificationActivationModeBackground);
    [self assertAction:result basedOnAction:action];
}

- (void)testBuildFromActions {
    id action1 = OCMClassMock([JKLocalNotificationAction class]);
    id action2 = OCMClassMock([JKLocalNotificationAction class]);

    id builder1 = OCMClassMock([JKLegacyActionBuilder class]);
    id builder2 = OCMClassMock([JKLegacyActionBuilder class]);

    id nativeAction1 = OCMClassMock([UIUserNotificationAction class]);
    id nativeAction2 = OCMClassMock([UIUserNotificationAction class]);

    OCMStub([action1 builder]).andReturn(builder1);
    OCMStub([action2 builder]).andReturn(builder2);

    OCMStub([builder1 buildFromAction:action1]).andReturn(nativeAction1);
    OCMStub([builder2 buildFromAction:action2]).andReturn(nativeAction2);

    NSArray *actions = @[action1, action2];
    NSArray *expectedActions = @[nativeAction1, nativeAction2];

    NSArray<UIUserNotificationAction *> *result = [JKLegacyActionBuilder buildFromActions:actions];

    XCTAssertEqualObjects(result, expectedActions);
}

@end
