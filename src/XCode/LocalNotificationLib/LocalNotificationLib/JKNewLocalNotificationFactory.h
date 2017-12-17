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
#import "JKNewTextInputActionBuilder.h"

@interface JKNewLocalNotificationFactory : JKNotificationFactory
- (JKNewCategoryBuilder *)createCategoryBuilder;
- (JKNotificationRequestBuilder *)createRequestBuilder;
- (JKNewActionBuilder *)createActionBuilder;
- (JKNewTextInputActionBuilder *)createTextInputActionBuilder;
@end
