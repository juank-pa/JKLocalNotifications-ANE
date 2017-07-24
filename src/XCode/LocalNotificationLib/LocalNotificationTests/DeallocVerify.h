//
//  DeallocVerify.h
//  LocalNotificationLib
//
//  Created by Juan Carlos Pazmino on 7/21/17.
//
//

#import <Foundation/Foundation.h>

@interface DeallocVerify : NSObject
+ (void)reset;
+ (instancetype)instance;
@property (class, nonatomic, readonly) NSInteger deallocationCount;
@end
