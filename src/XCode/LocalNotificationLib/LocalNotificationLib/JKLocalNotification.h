//
//  JKLocalNotification.h
//  LocalNotificationLib
//
//  Created by Juan Carlos Pazmino on 10/1/17.
//
//

#import <Foundation/Foundation.h>
#import "JKCalendarUnit.h"

@interface JKLocalNotification : NSObject
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
@property(nonatomic, assign) JKCalendarUnit repeatInterval;
@property(nonatomic, readonly) NSDictionary *userInfo;
@property(nonatomic, copy) NSString *launchImage;

@end

