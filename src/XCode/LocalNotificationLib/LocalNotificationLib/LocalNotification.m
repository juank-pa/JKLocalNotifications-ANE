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


@synthesize notificationCode, actionLabel, body, hasAction, numberAnnotation, playSound, actionData, repeatInterval, fireDate, soundName;


- (id) init
{
    self = [super init];
    if (self) 
    {
        notificationCode = @"";
        actionLabel = @"";
        body = @"";
        hasAction = YES;
        numberAnnotation = 0;
        playSound = YES;
        actionData = nil;
        repeatInterval = 0;
        fireDate = nil;
        soundName = @"";
    }
    
    return self;
}

#ifdef TEST

-(NSString *)description
{
    return [NSString stringWithFormat:@"notificationCode:%@ actionLabel:%@ body:%@ fireDate:%@ repeatInterval:%d hasAction:%d playSound:%d numberAnnotation:%@", notificationCode, actionLabel, body, fireDate, repeatInterval, hasAction, playSound, numberAnnotation];
}

-(NSString *)debugDescription
{
    return [self description];
}

#endif

- (void) dealloc
{
	[notificationCode release];
	[actionLabel release];
    [body release];
    [actionData release];
    [fireDate release];
    [soundName release];
    	
	[super dealloc];
}


@end

