//
//  JKLegacyTextInputActionBuilderTest.m
//  LocalNotificationLib
//
//  Created by Juan Carlos Pazmino on 12/3/17.
//
//

#import <XCTest/XCTest.h>
#import "JKLegacyTestCase.h"
#import "JKLegacyTextInputActionBuilder.h"
#import "JKTextInputLocalNotificationAction.h"

@interface JKLegacyTextInputActionBuilderTest : JKLegacyTestCase
@property (nonatomic, strong) JKLegacyTextInputActionBuilder *subject;
@end

@implementation JKLegacyTextInputActionBuilderTest

- (void)setUp {
    [super setUp];
    self.subject = [JKLegacyTextInputActionBuilder new];
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

- (void)assertAction:(UIUserNotificationAction *)result basedOnAction:(JKTextInputLocalNotificationAction *)action {
    XCTAssertEqualObjects(result.title, action.title);
    XCTAssertEqualObjects(result.identifier, action.identifier);
    if ([result respondsToSelector:@selector(behavior)]) {
        XCTAssertEqual(result.behavior, UIUserNotificationActionBehaviorTextInput);
        XCTAssertEqualObjects(result.parameters,
                              @{
                                UIUserNotificationTextInputActionButtonTitleKey: @"Button"
                                });
    }
    XCTAssertFalse(result.authenticationRequired);
}

- (void)testBuildFromAction {
    JKTextInputLocalNotificationAction *action = [self actionWithIdentifier:@"actionId"
                                                                      title:@"Action"
                                                                 buttonText:@"Button"
                                                                placeholder:@"Placehoder"];
    action.background = NO;

    UIUserNotificationAction *result = [self.subject buildFromAction:action];
    XCTAssertEqual(result.activationMode, UIUserNotificationActivationModeForeground);
    [self assertAction:result basedOnAction:action];
}

- (void)testBuildFromBackgroundAction {
    JKTextInputLocalNotificationAction *action = [self actionWithIdentifier:@"actionId"
                                                                      title:@"Action"
                                                                 buttonText:@"Button"
                                                                placeholder:@"Placehoder"];
    action.background = YES;

    UIUserNotificationAction *result = [self.subject buildFromAction:action];
    XCTAssertEqual(result.activationMode, UIUserNotificationActivationModeBackground);
    [self assertAction:result basedOnAction:action];
}

@end

