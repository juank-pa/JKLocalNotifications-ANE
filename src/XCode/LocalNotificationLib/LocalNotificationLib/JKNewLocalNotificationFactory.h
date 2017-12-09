//
//  JKNewLocalNotificationFactory.h
//  LocalNotificationLib
//
//  Created by Juan Carlos Pazmino on 9/30/17.
//
//

#import <UserNotifications/UserNotifications.h>
#import "JKNotificationFactory.h"
#import "JKNotificationRequestBuilder.h"
#import "JKNewCategoryBuilder.h"

@interface JKNewLocalNotificationFactory : JKNotificationFactory
- (JKNewCategoryBuilder *)createCategoryBuilder;
- (JKNotificationRequestBuilder *)createRequestBuilder;
@end
