//
//  JKNotificationBuilder.h
//  LocalNotificationLib
//
//  Created by Juan Carlos Pazmino on 10/11/17.
//
//

#import "JKLocalNotification.h"

@interface JKNotificationBuilder : NSObject
- (UILocalNotification *)buildFromNotification:(JKLocalNotification *)notification;
@end
