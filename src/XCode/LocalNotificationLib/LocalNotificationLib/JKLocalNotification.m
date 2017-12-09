//
//  JKLocalNotification.m
//  LocalNotificationLib
//
//  Created by Juan Carlos Pazmino on 10/1/17.
//
//

#import "JKLocalNotification.h"
#import "Constants.h"

@implementation JKLocalNotification

+ (instancetype)localNotification {
    return [self new];
}

- (instancetype)init {
    if (self = [super init]) {
        _notificationCode = @"";
        _actionLabel = nil;
        _title = nil;
        _body = nil;
        _hasAction = YES;
        _numberAnnotation = 0;
        _playSound = YES;
        _actionData = nil;
        _repeatInterval = 0;
        _fireDate = nil;
        _soundName = nil;
        _showInForeground = NO;
        _category = nil;
    }
    return self;
}

- (NSDictionary *)userInfo {
    NSMutableDictionary *infoDict = [NSMutableDictionary dictionaryWithCapacity:2];
    infoDict[JK_NOTIFICATION_CODE_KEY] = self.notificationCode;
    infoDict[JK_NOTIFICATION_SHOW_IN_FOREGROUND] = @(self.showInForeground);

    if(self.actionData) {
        infoDict[JK_NOTIFICATION_DATA_KEY] = self.actionData;
    }
    return [infoDict copy];
}

#ifdef SAMPLE

- (NSString *)description {
    return [NSString stringWithFormat:@"notificationCode:%@ actionLabel:%@ body:%@ fireDate:%@ repeatInterval:%lu hasAction:%d playSound:%d numberAnnotation:%d", self.notificationCode, self.actionLabel, self.body, self.fireDate, (unsigned long)self.repeatInterval, self.hasAction, self.playSound, self.numberAnnotation];
}

- (NSString *)debugDescription{
    return [self description];
}

#endif

@end

