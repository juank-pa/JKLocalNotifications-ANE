//
//  NSArray+HigherOrder.h
//  LocalNotificationLib
//
//  Created by Juan Carlos Pazmino on 11/27/17.
//
//

#import <Foundation/Foundation.h>

@interface NSArray (HigherOrder)
- (NSArray *)map:(id (^)(id))block;
@end
