//
//  JKNewCategoryBuilder.h
//  LocalNotificationLib
//
//  Created by Juan Carlos Pazmino on 11/28/17.
//
//

#import <UserNotifications/UserNotifications.h>
#import "JKLocalNotificationCategory.h"

@interface JKNewCategoryBuilder : NSObject
- (UNNotificationCategory *)buildFromCategory:(JKLocalNotificationCategory *)category;
- (NSSet<UNNotificationCategory *> *)buildFromCategories:(NSArray<JKLocalNotificationCategory *> *)category;
@end
