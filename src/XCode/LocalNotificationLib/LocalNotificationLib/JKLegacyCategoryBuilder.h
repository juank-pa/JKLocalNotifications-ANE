//
//  JKLegacyCategoryBuilder.h
//  LocalNotificationLib
//
//  Created by Juan Carlos Pazmiño on 11/28/17.
//
//

#import <UIKit/UIKit.h>
#import "JKLocalNotificationCategory.h"

@interface JKLegacyCategoryBuilder : NSObject
- (NSSet<UIUserNotificationCategory *> *)buildFromCategories:(NSArray<JKLocalNotificationCategory *> *)categories;
- (UIUserNotificationCategory *)buildFromCategory:(JKLocalNotificationCategory *)category;
@end
