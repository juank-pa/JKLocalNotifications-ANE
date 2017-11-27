//
//  NSArray+HigherOrder.m
//  LocalNotificationLib
//
//  Created by Juan Carlos Pazmino on 11/27/17.
//
//

#import "NSArray+HigherOrder.h"

@implementation NSArray (HigherOrder)

- (NSArray *)map:(id (^)(id))block {
    NSMutableArray *newArray = [NSMutableArray array];
    [self enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [newArray addObject:block(obj)];
    }];
    return [newArray copy];
}

@end
