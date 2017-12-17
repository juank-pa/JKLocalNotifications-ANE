//
//  JKActionBuilder.h
//  LocalNotificationLib
//
//  Created by Juan Carlos Pazmiño on 12/16/17.
//

#import <Foundation/Foundation.h>
@class JKLocalNotificationAction;

@protocol JKActionBuilder <NSObject>
- (id)buildFromAction:(JKLocalNotificationAction *)action;
@end
