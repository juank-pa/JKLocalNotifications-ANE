//
//  JKFREDecoder.m
//  LocalNotificationLib
//
//  Created by Juan Carlos Pazmiño on 11/27/17.
//
//

#import "JKFREDecoder.h"
#import "ExtensionUtils.h"

@interface JKFREDecoder ()
@property (nonatomic, readwrite) FREObject freObject;
@end

@implementation JKFREDecoder

- (id)decodeObject:(FREObject)freObject {
    self.freObject = freObject;
    return [self decode];
}

- (id)decode {
    return nil;
}

- (FREObject)propertyValueObject:(NSString *)property {
    return [ExtensionUtils getProperty:property fromObject:self.freObject];
}

- (NSString *)decodeStringProperty:(NSString *)property withDefault:(NSString *)defaultValue {
    FREObject valueObject = [self propertyValueObject:property];
    if(valueObject == NULL) return defaultValue;
    return [ExtensionUtils getStringFromFREObject:valueObject];
}

- (uint32_t)decodeUIntProperty:(NSString *)property withDefault:(uint32_t)defaultValue {
    FREObject valueObject = [self propertyValueObject:property];
    if(valueObject == NULL) return defaultValue;
    return [ExtensionUtils getUIntFromFREObject:valueObject];
}

- (double)decodeDoubleProperty:(NSString *)property withDefault:(double)defaultValue {
    FREObject valueObject = [self propertyValueObject:property];
    if(valueObject == NULL) return defaultValue;
    return [ExtensionUtils getDoubleFromFREObject:valueObject];
}

- (BOOL)decodeBoolProperty:(NSString *)property withDefault:(BOOL)defaultValue {
    FREObject valueObject = [self propertyValueObject:property];
    if(valueObject == NULL) return defaultValue;
    return [ExtensionUtils getBoolFromFREObject:valueObject];
}

- (NSData *)decodeDataProperty:(NSString *)property withDefault:(NSData *)defaultValue {
    FREObject valueObject = [self propertyValueObject:property];
    if(valueObject == NULL) return defaultValue;
    return [ExtensionUtils getDataFromFREObject:valueObject];
}

- (NSDate *)decodeDateProperty:(NSString *)property withDefault:(NSDate *)defaultValue {
    FREObject dateObject = [self propertyValueObject:property];
    if (dateObject == NULL) return defaultValue;

    FREObject timeObject = [ExtensionUtils getProperty:@"time" fromObject:dateObject];
    double time = [ExtensionUtils getDoubleFromFREObject:timeObject];

    if ((uint32_t)time <= 0) return defaultValue;
    return [NSDate dateWithTimeIntervalSince1970:time / 1000.0];
}

- (NSArray *)decodeArrayProperty:(NSString *)property withDecoder:(id<JKDecoder>)decoder {
    FREObject arrayObject = [self propertyValueObject:property];
    if (arrayObject == NULL) return [NSArray array];
    return [ExtensionUtils getArrayFromFREObject:arrayObject withDecoder:decoder];
}

@end
