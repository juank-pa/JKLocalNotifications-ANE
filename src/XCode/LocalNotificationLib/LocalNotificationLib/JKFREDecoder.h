//
//  JKFREDecoder.h
//  LocalNotificationLib
//
//  Created by Juan Carlos Pazmiño on 11/27/17.
//
//

#import "JKDecoder.h"

@interface JKFREDecoder : NSObject<JKDecoder>
- (NSString *)decodeStringProperty:(NSString *)property withDefault:(NSString *)defaultValue;
- (uint32_t)decodeUIntProperty:(NSString *)property withDefault:(uint32_t)defaultValue;
- (double)decodeDoubleProperty:(NSString *)property withDefault:(double)defaultValue;
- (BOOL)decodeBoolProperty:(NSString *)property withDefault:(BOOL)defaultValue;
- (NSDate *)decodeDateProperty:(NSString *)property withDefault:(NSDate *)defaultValue;
- (NSData *)decodeDataProperty:(NSString *)property withDefault:(NSData *)defaultValue;
- (NSArray *)decodeArrayProperty:(NSString *)property withDecoder:(id<JKDecoder>)decoder;
@property (nonatomic, readonly) FREObject freObject;
@end
