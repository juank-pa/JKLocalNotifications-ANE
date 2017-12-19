//
//  JKTextInputLocalNotificationAction.h
//  LocalNotificationLib
//
//  Created by Juan Carlos Pazmiño on 12/15/17.
//

#import "JKLocalNotificationAction.h"

@interface JKTextInputLocalNotificationAction : JKLocalNotificationAction
@property (nonatomic, copy) NSString *textInputButtonTitle;
@property (nonatomic, copy) NSString *textInputPlaceholder;
@end
