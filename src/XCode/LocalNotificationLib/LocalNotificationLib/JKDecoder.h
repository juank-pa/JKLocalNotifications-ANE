//
//  JKDecoder.h
//  LocalNotificationLib
//
//  Created by Juan Carlos Pazmiño on 11/27/17.
//
//

#import <Foundation/Foundation.h>
#import "FlashRuntimeExtensions.h"

@protocol JKDecoder <NSObject>
- (id)decodeObject:(FREObject)freObject;
@end
