//
//  JKLocalNotificationDecoder.h
//  LocalNotificationLib
//
//  Created by Juan Carlos Pazmiño on 11/27/17.
//
//

#import "JKFREDecoder.h"
#import "FlashRuntimeExtensions.h"

@interface JKLocalNotificationDecoder : JKFREDecoder
- (instancetype)initWithFREObject:(FREObject)freObject;
@end
