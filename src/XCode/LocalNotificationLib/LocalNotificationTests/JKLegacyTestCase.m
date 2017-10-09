//
//  JKLegacyTestCase.m
//  LocalNotificationLib
//
//  Created by Juan Carlos Pazmino on 10/9/17.
//
//

#import <UserNotifications/UserNotifications.h>
#import "JKLegacyTestCase.h"

@implementation JKLegacyTestCase

- (void)invokeTest {
    if([UNUserNotificationCenter class] == nil) {
        [super invokeTest];
    }
}

@end
