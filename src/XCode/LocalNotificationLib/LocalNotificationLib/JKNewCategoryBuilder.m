//
//  JKNewCategoryBuilder.m
//  LocalNotificationLib
//
//  Created by Juan Carlos Pazmino on 11/28/17.
//
//

#import "JKNewCategoryBuilder.h"
#import "JKLocalNotificationCategory.h"
#import "JKNewActionBuilder.h"
#import "NSArray+HigherOrder.h"

@implementation JKNewCategoryBuilder

- (NSSet<UNNotificationCategory *> *)buildFromCategories:(NSArray<JKLocalNotificationCategory *> *)categories {
    return [NSSet setWithArray:[categories map:^UNNotificationCategory *(JKLocalNotificationCategory *category) {
        return [self buildFromCategory:category];
    }]];
}

- (UNNotificationCategory *)buildFromCategory:(JKLocalNotificationCategory *)category {
    return [UNNotificationCategory categoryWithIdentifier:category.identifier
                                                  actions:[[JKNewActionBuilder new] buildFromActions:category.actions]
                                        intentIdentifiers:[NSArray array]
                                                  options:UNNotificationCategoryOptionNone];
}

@end
