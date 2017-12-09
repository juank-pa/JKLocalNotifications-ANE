//
//  LocalNotificationDecoderTest.m
//  LocalNotificationLib
//
//  Created by Juan Carlos Pazmiño on 11/27/17.
//
//

#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>
#import "Stubs.h"
#import "FlashRuntimeExtensions+Private.h"
#import "JKLocalNotificationDecoder.h"
#import "JKLocalNotification.h"
#import "ExtensionUtils.h"

@interface JKLocalNotificationDecoderTest : XCTestCase
@property (nonatomic, strong) id notificationMock;
@property (nonatomic, strong) id utilsMock;
@property (nonatomic, strong) JKLocalNotificationDecoder *subject;
@property (nonatomic, strong) NSDate *date;
@property (nonatomic, strong) NSData *data;
@end

@implementation JKLocalNotificationDecoderTest
{
    int codeContext;
    int notificationContext;
}

typedef NS_ENUM(NSInteger, NotificationFlag){
    NotificationFlagNone,
    NotificationFlagHasAction,
    NotificationFlagPlaySound,
    NotificationFlagShowInForeground
};

- (void)setUp {
    [super setUp];
    self.utilsMock = OCMClassMock([ExtensionUtils class]);
    OCMStub([self.utilsMock getStringFromFREObject:(void *)&codeContext]).andReturn(@"code");
    self.subject = [[JKLocalNotificationDecoder alloc] initWithFREObject:(void *)&codeContext];
}

- (void)setUpNotification {
    [self setUpNotificationWithFlag:NotificationFlagNone];
}

- (void)setUpNotificationWithFlag:(NotificationFlag)flag {
    self.notificationMock = OCMClassMock([JKLocalNotification class]);
    OCMStub([self.notificationMock localNotification]).andReturn(self.notificationMock);

    //10/17/17, 8:50 PM
    self.date = [NSDate dateWithTimeIntervalSince1970:(int)NSDate.date.timeIntervalSince1970];
    self.data = [NSData data];

    int fireDateContext, timeContext, repeatIntervalContext, actionLabelContext;
    int bodyContext, hasActionContext, numberAnnotationContext, playSoundContext;
    int soundNameContext, actionDataContext, titleContext, launchImageContext, showInForegroundContext, categoryContext;

    // Property access
    OCMStub([self.utilsMock getProperty:@"fireDate" fromObject:&notificationContext]).andReturn((void *)&fireDateContext);
    OCMStub([self.utilsMock getProperty:@"time" fromObject:&fireDateContext]).andReturn((void *)&timeContext);
    OCMStub([self.utilsMock getProperty:@"repeatInterval" fromObject:&notificationContext]).andReturn((void *)&repeatIntervalContext);
    OCMStub([self.utilsMock getProperty:@"actionLabel" fromObject:&notificationContext]).andReturn((void *)&actionLabelContext);
    OCMStub([self.utilsMock getProperty:@"body" fromObject:&notificationContext]).andReturn((void *)&bodyContext);
    OCMStub([self.utilsMock getProperty:@"title" fromObject:&notificationContext]).andReturn((void *)&titleContext);
    OCMStub([self.utilsMock getProperty:@"hasAction" fromObject:&notificationContext]).andReturn((void *)&hasActionContext);
    OCMStub([self.utilsMock getProperty:@"numberAnnotation" fromObject:&notificationContext]).andReturn((void *)&numberAnnotationContext);
    OCMStub([self.utilsMock getProperty:@"playSound" fromObject:&notificationContext]).andReturn((void *)&playSoundContext);
    OCMStub([self.utilsMock getProperty:@"soundName" fromObject:&notificationContext]).andReturn((void *)&soundNameContext);
    OCMStub([self.utilsMock getProperty:@"actionData" fromObject:&notificationContext]).andReturn((void *)&actionDataContext);
    OCMStub([self.utilsMock getProperty:@"launchImage" fromObject:&notificationContext]).andReturn((void *)&launchImageContext);
    OCMStub([self.utilsMock getProperty:@"showInForeground" fromObject:&notificationContext]).andReturn((void *)&showInForegroundContext);
    OCMStub([self.utilsMock getProperty:@"category" fromObject:&notificationContext]).andReturn((void *)&categoryContext);


    // Value fetch
    OCMStub([self.utilsMock getDoubleFromFREObject:&timeContext]).andReturn(self.date.timeIntervalSince1970 * 1000);
    OCMStub([self.utilsMock getUIntFromFREObject:&repeatIntervalContext]).andReturn(NSCalendarUnitWeekday);
    OCMStub([self.utilsMock getStringFromFREObject:&actionLabelContext]).andReturn(@"actionLabel");
    OCMStub([self.utilsMock getStringFromFREObject:&bodyContext]).andReturn(@"body");
    OCMStub([self.utilsMock getStringFromFREObject:&titleContext]).andReturn(@"title");
    OCMStub([self.utilsMock getBoolFromFREObject:&hasActionContext]).andReturn(flag == NotificationFlagHasAction);
    OCMStub([self.utilsMock getUIntFromFREObject:&numberAnnotationContext]).andReturn(15);
    OCMStub([self.utilsMock getBoolFromFREObject:&playSoundContext]).andReturn(flag == NotificationFlagPlaySound);
    OCMStub([self.utilsMock getStringFromFREObject:&soundNameContext]).andReturn(@"soundName");
    OCMStub([self.utilsMock getDataFromFREObject:&actionDataContext]).andReturn(self.data);
    OCMStub([self.utilsMock getStringFromFREObject:&launchImageContext]).andReturn(@"launchImage.png");
    OCMStub([self.utilsMock getBoolFromFREObject:&showInForegroundContext]).andReturn(flag == NotificationFlagShowInForeground);
    OCMStub([self.utilsMock getStringFromFREObject:&categoryContext]).andReturn(@"Category");
}

- (void)tearDown {
    [self.utilsMock stopMocking];
    [self.notificationMock stopMocking];
    [super tearDown];
}

- (void)testDecodeObject {
    [self setUpNotification];

    OCMExpect([self.notificationMock setNotificationCode:@"code"]);
    OCMExpect([self.notificationMock setFireDate:self.date]);
    OCMExpect([self.notificationMock setRepeatInterval:NSCalendarUnitWeekday]);
    OCMExpect([self.notificationMock setActionLabel:@"actionLabel"]);
    OCMExpect([self.notificationMock setBody:@"body"]);
    OCMExpect([self.notificationMock setTitle:@"title"]);
    OCMExpect([self.notificationMock setNumberAnnotation:15]);
    OCMExpect([self.notificationMock setSoundName:@"soundName"]);
    OCMExpect([self.notificationMock setActionData:self.data]);
    OCMExpect([self.notificationMock setLaunchImage:@"launchImage.png"]);
    OCMExpect([self.notificationMock setCategory:@"Category"]);

    XCTAssertEqual([self.subject decodeObject:(void *)&notificationContext], self.notificationMock);

    OCMVerifyAll(self.notificationMock);
}

- (void)testDecodeObjectHasAction {
    [self setUpNotificationWithFlag:NotificationFlagHasAction];

    OCMExpect([self.notificationMock setHasAction:YES]);
    OCMExpect([self.notificationMock setPlaySound:NO]);
    OCMExpect([self.notificationMock setShowInForeground:NO]);

    XCTAssertEqual([self.subject decodeObject:(void *)&notificationContext], self.notificationMock);

    OCMVerifyAll(self.notificationMock);
}

- (void)testDecodeObjectPlaySound {
    [self setUpNotificationWithFlag:NotificationFlagPlaySound];

    OCMExpect([self.notificationMock setHasAction:NO]);
    OCMExpect([self.notificationMock setPlaySound:YES]);
    OCMExpect([self.notificationMock setShowInForeground:NO]);

    XCTAssertEqual([self.subject decodeObject:(void *)&notificationContext], self.notificationMock);

    OCMVerifyAll(self.notificationMock);
}

- (void)testDecodeObjectShowInForeground {
    [self setUpNotificationWithFlag:NotificationFlagShowInForeground];

    OCMExpect([self.notificationMock setHasAction:NO]);
    OCMExpect([self.notificationMock setPlaySound:NO]);
    OCMExpect([self.notificationMock setShowInForeground:YES]);

    XCTAssertEqual([self.subject decodeObject:(void *)&notificationContext], self.notificationMock);

    OCMVerifyAll(self.notificationMock);
}

@end
