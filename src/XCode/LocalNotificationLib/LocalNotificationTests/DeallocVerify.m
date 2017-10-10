//
//  DeallocVerify.m
//  LocalNotificationLib
//
//  Created by Juan Carlos Pazmino on 7/21/17.
//
//

#import "DeallocVerify.h"

NSInteger deallocationCount = 0;

@implementation DeallocVerify
+ (void)reset {
    deallocationCount = 0;
}

+ (instancetype)instance {
    return [self new];
}

+ (NSInteger)deallocationCount {
    return deallocationCount;
}

/*- (oneway void)release {
    deallocationCount++;
    [super release];
}*/

@end
