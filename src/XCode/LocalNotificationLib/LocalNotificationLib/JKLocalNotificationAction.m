//
//  JKLocalNotificationAction.m
//  LocalNotificationLib
//
//  Created by Juan Carlos Pazmiño on 11/27/17.
//
//

#import "JKLocalNotificationAction.h"
#import "JKLegacyActionBuilder.h"
#import "JKNewActionBuilder.h"
#import "JKNotificationFactory.h"

@implementation JKLocalNotificationAction
- (id<JKActionBuilder>)builder {
    return [[JKNotificationFactory factory] createActionBuilder];
}
@end
