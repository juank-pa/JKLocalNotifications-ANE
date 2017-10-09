//
//  JKLocalNotification.m
//  LocalNotificationLib
//
//  Created by Juan Carlos Pazmino on 10/1/17.
//
//

#import "JKLocalNotification.h"

@implementation JKLocalNotification

+ (instancetype)localNotification {
    return [[self new] autorelease];
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
    }
    return self;
}

- (void)dealloc {
    [_notificationCode release];
    [_actionLabel release];
    [_title release];
    [_body release];
    [_actionData release];
    [_fireDate release];
    [_soundName release];

    [super dealloc];
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

