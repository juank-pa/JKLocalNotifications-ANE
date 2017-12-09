//
//  JKNewActionBuilder.m
//  LocalNotificationLib
//
//  Created by Juan Carlos Pazmiño on 11/28/17.
//
//

#import "JKNewActionBuilder.h"
#import "NSArray+HigherOrder.h"

@implementation JKNewActionBuilder

- (UNNotificationAction *)buildFromAction:(JKLocalNotificationAction *)action {
    return [UNNotificationAction actionWithIdentifier:action.identifier
                                                title:action.title
                                              options:UNNotificationActionOptionForeground];
}

- (NSArray <UNNotificationAction *> *)buildFromActions:(NSArray <JKLocalNotificationAction *> *)actions {
    return [actions map:^UNNotificationAction *(JKLocalNotificationAction *action) {
        return [self buildFromAction:action];
    }];
}

@end
