//
//  JKLocalNotificationCategory.h
//  LocalNotificationLib
//
//  Created by Juan Carlos Pazmiño on 11/27/17.
//
//

#import <Foundation/Foundation.h>
@class JKLocalNotificationAction;

@interface JKLocalNotificationCategory : NSObject
@property (nonatomic, copy) NSString *identifier;
@property (nonatomic, copy) NSArray<JKLocalNotificationAction *> *actions;
@property (nonatomic) BOOL useCustomDismissAction;
@end
