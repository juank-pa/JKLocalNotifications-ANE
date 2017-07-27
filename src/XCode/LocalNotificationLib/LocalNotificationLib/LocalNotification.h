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


#import <Foundation/Foundation.h>


@interface LocalNotification : NSObject 
+ (instancetype) localNotification;

@property(nonatomic, copy) NSString *notificationCode;
@property(nonatomic, copy) NSString *actionLabel;
@property(nonatomic, copy) NSString *title;
@property(nonatomic, copy) NSString *body;
@property(nonatomic, assign) BOOL hasAction;
@property(nonatomic, assign) int numberAnnotation;
@property(nonatomic, assign) BOOL playSound;
@property(nonatomic, copy) NSData *actionData;
@property(nonatomic, copy) NSDate *fireDate;
@property(nonatomic, copy) NSString *soundName;
@property(nonatomic, assign) NSCalendarUnit repeatInterval;

@end

