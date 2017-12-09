//
//  JKLegacyNotificationSettingsBuilderTest.m
//  LocalNotificationLib
//
//  Created by Juan Carlos Pazmino on 12/3/17.
//
//

#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>
#import "JKLegacyTestCase.h"
#import "JKLegacyNotificationSettingsBuilder.h"
#import "JKLegacyCategoryBuilder.h"

@interface JKLegacyNotificationSettingsBuilderTest : JKLegacyTestCase
@property (nonatomic, strong) JKLegacyNotificationSettingsBuilder *subject;
@property (nonatomic, strong) id actionBuilderMock;
@end

@implementation JKLegacyNotificationSettingsBuilderTest

- (void)setUp {
    [super setUp];
    self.subject = [JKLegacyNotificationSettingsBuilder new];

    self.actionBuilderMock = OCMClassMock([JKLegacyCategoryBuilder class]);
    OCMStub([self.actionBuilderMock new]).andReturn(self.actionBuilderMock);
}

- (void)tearDown {
    [self.actionBuilderMock stopMocking];
    [super tearDown];
}

- (JKLocalNotificationSettings *)settingsWithCategoryTypes:(JKLocalNotificationType)types categories:(NSArray *)categories {
    JKLocalNotificationSettings *settings = [JKLocalNotificationSettings settingsWithLocalNotificationTypes:types];
    settings.categories = categories;
    return settings;
}

- (void)testBuildFromNotificationSettings {
    JKLocalNotificationType types = JKLocalNotificationTypeAlert | JKLocalNotificationTypeBadge;
    JKLocalNotificationSettings *settings = [self settingsWithCategoryTypes:types categories:@[]];
    NSSet *categories = [NSSet set];

    OCMStub([self.actionBuilderMock buildFromCategories:settings.categories]).andReturn(categories);

    id settingsMock = OCMClassMock([UIUserNotificationSettings class]);
    OCMExpect([settingsMock settingsForTypes:UIUserNotificationTypeBadge | UIUserNotificationTypeAlert
                                  categories:categories]).andReturn(settingsMock);

    XCTAssertEqual([self.subject buildFromSettings:settings], settingsMock);

    OCMVerifyAll(settingsMock);
    [settingsMock stopMocking];
}

@end
