//
//  JKNewActionBuilderTest.m
//  LocalNotificationLib
//
//  Created by Juan Carlos Pazmino on 12/3/17.
//
//

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

- (void)assertActions:(NSArray <UNNotificationAction *> *)results basedOnActions:(NSArray <JKLocalNotificationAction *> *)actions {
    XCTAssertEqual(results.count, actions.count);
    for (int i = (int)results.count - 1; i >= 0; i--) {
        [self assertAction:results[i] basedOnAction:actions[i]];
    }
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
    JKLocalNotificationAction *action1 = [self actionWithIdentifier:@"actionId1" title:@"Action 1"];
    JKLocalNotificationAction *action2 = [self actionWithIdentifier:@"actionId2" title:@"Action 2"];
    NSArray *actions = @[action1, action2];

    [self assertActions:[self.subject buildFromActions:actions] basedOnActions:actions];
}

@end
