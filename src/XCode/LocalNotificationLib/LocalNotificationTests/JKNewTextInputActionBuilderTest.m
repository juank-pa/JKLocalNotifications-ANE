//
//  JKNewTextInputActionBuilderTest.m
//  LocalNotificationTests
//
//  Created by Juan Carlos Pazmiño on 12/16/17.
//

#import <XCTest/XCTest.h>

#import <XCTest/XCTest.h>
#import "JKNewTestCase.h"
#import "JKNewTextInputActionBuilder.h"
#import "JKTextInputLocalNotificationAction.h"

@interface JKNewTextInputActionBuilderTest : JKNewTestCase
@property (nonatomic, strong) JKNewTextInputActionBuilder *subject;
@end

@implementation JKNewTextInputActionBuilderTest

- (void)setUp {
    [super setUp];
    self.subject = [JKNewTextInputActionBuilder new];
}

- (void)tearDown {
    [super tearDown];
}

- (JKTextInputLocalNotificationAction *)actionWithIdentifier:(NSString *)identifier title:(NSString *)title buttonText:(NSString *)buttonText placeholder:(NSString *)placeholder {
    JKTextInputLocalNotificationAction *action = [JKTextInputLocalNotificationAction new];
    action.identifier = identifier;
    action.title = title;
    action.textInputButtonTitle = buttonText;
    action.textInputPlaceholder = placeholder;
    return action;
}

- (void)assertAction:(UNTextInputNotificationAction *)result basedOnAction:(JKTextInputLocalNotificationAction *)action {
    XCTAssertEqualObjects(result.title, action.title);
    XCTAssertEqualObjects(result.identifier, action.identifier);
    XCTAssertEqualObjects(result.textInputButtonTitle, action.textInputButtonTitle);
    XCTAssertEqualObjects(result.textInputPlaceholder, action.textInputPlaceholder);
}

- (void)testBuildFromAction {
    JKTextInputLocalNotificationAction *action = [self actionWithIdentifier:@"actionId"
                                                                      title:@"Action"
                                                                 buttonText:@"Button"
                                                                placeholder:@"Placehoder"];
    action.background = NO;

    UNTextInputNotificationAction *result = (UNTextInputNotificationAction *)[self.subject buildFromAction:action];
    XCTAssertEqual(result.options, UNNotificationActionOptionForeground);
    [self assertAction:result basedOnAction:action];
}

- (void)testBuildFromBackgroundAction {
    JKTextInputLocalNotificationAction *action = [self actionWithIdentifier:@"actionId"
                                                                      title:@"Action"
                                                                 buttonText:@"Button"
                                                                placeholder:@"Placehoder"];
    action.background = YES;

    UNTextInputNotificationAction *result = (UNTextInputNotificationAction *)[self.subject buildFromAction:action];
    XCTAssertEqual(result.options, UNNotificationActionOptionNone);
    [self assertAction:result basedOnAction:action];
}

@end
