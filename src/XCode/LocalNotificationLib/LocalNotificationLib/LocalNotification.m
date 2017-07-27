/*************************************************************************
 *
 * ADOBE CONFIDENTIAL
 * ___________________
 *
 *  Copyright 2011 Adobe Systems Incorporated
 *  All Rights Reserved.
 *
 * NOTICE:  All information contained herein is, and remains
 * the property of Adobe Systems Incorporated and its suppliers,
 * if any.  The intellectual and technical concepts contained
 * herein are proprietary to Adobe Systems Incorporated and its
 * suppliers and are protected by trade secret or copyright law.
 * Dissemination of this information or reproduction of this material
 * is strictly forbidden unless prior written permission is obtained
 * from Adobe Systems Incorporated.
 **************************************************************************/


#import "LocalNotification.h"


@implementation LocalNotification

+ (instancetype)localNotification {
    return [[[LocalNotification alloc] init] autorelease];
}

- (instancetype) init {
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
    [self.notificationCode release];
    [self.actionLabel release];
    [self.title release];
    [self.body release];
    [self.actionData release];
    [self.fireDate release];
    [self.soundName release];

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

