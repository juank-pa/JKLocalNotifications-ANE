//
//  JKLegacyCategoryBuilder.m
//  LocalNotificationLib
//
//  Created by Juan Carlos Pazmiño on 11/28/17.
//
//

#import "JKLegacyCategoryBuilder.h"
#import "JKLegacyActionBuilder.h"
#import "NSArray+HigherOrder.h"

@implementation JKLegacyCategoryBuilder

- (NSSet<UIUserNotificationCategory *> *)buildFromCategories:(NSArray<JKLocalNotificationCategory *> *)categories {
    return [NSSet setWithArray:[categories map:^UIUserNotificationCategory *(JKLocalNotificationCategory *category) {
        return [self buildFromCategory:category];
    }]];
}

- (UIUserNotificationCategory *)buildFromCategory:(JKLocalNotificationCategory *)category {
    UIMutableUserNotificationCategory *nativeCategory = [UIMutableUserNotificationCategory new];
    NSArray<UIUserNotificationAction *> *actions = [[JKLegacyActionBuilder new] buildFromActions:category.actions];

    nativeCategory.identifier = category.identifier;
    [nativeCategory setActions:actions forContext:UIUserNotificationActionContextDefault];
    [nativeCategory setActions:actions forContext:UIUserNotificationActionContextMinimal];
    return nativeCategory;
}

@end
