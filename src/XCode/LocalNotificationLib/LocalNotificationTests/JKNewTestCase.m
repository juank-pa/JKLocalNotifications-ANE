//
//  JKNewTestCase.m
//  LocalNotificationLib
//
//  Created by Juan Carlos Pazmino on 10/10/17.
//
//

#import <UserNotifications/UserNotifications.h>
#import "JKNewTestCase.h"

@implementation JKNewTestCase

- (void)invokeTest {
    if([UNUserNotificationCenter class]) {
        [super invokeTest];
    }
}

@end
