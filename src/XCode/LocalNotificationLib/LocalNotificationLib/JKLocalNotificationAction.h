//
//  JKLocalNotificationAction.h
//  LocalNotificationLib
//
//  Created by Juan Carlos Pazmiño on 11/27/17.
//
//

#import <Foundation/Foundation.h>

@interface JKLocalNotificationAction : NSObject
@property (nonatomic, copy) NSString *identifier;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign, getter=isBackground) BOOL background;
@end
