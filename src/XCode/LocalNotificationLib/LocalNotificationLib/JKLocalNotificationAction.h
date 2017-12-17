//
//  JKLocalNotificationAction.h
//  LocalNotificationLib
//
//  Created by Juan Carlos Pazmiño on 11/27/17.
//
//

#import <Foundation/Foundation.h>
#import "JKActionBuilder.h"
@class JKLegacyActionBuilder;
@class JKNewActionBuilder;

@interface JKLocalNotificationAction : NSObject
@property (nonatomic, copy) NSString *identifier;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign, getter=isBackground) BOOL background;

@property (nonatomic, assign) id<JKActionBuilder> builder;
@end
