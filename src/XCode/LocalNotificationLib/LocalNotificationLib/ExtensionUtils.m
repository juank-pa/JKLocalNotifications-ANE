/*************************************************************************
 *
 * ADOBE CONFIDENTIAL
 * ___________________
 *
 *  Copyright 2011 Adobe Systems Incorporated
 *  All Rights Reserved.
 *
 * NOTICE:  All information contained herein is, and remains
 * the property of Adobe Systems Incorporated and its suppliers,
 * if any.  The intellectual and technical concepts contained
 * herein are proprietary to Adobe Systems Incorporated and its
 * suppliers and are protected by trade secret or copyright law.
 * Dissemination of this information or reproduction of this material
 * is strictly forbidden unless prior written permission is obtained
 * from Adobe Systems Incorporated.
 **************************************************************************/


#import "ExtensionUtils.h"
#import "JKDecoder.h"

@implementation ExtensionUtils

#ifndef SAMPLE

+ (void)setContextID:(id)contextID forFREContext:(FREContext)freContext {
    FRESetContextNativeData(freContext, (__bridge void *)(contextID));
}

+ (id)getContextID:(FREContext)ctx {
    // Retrive our obj-c context object from the AS side
    id contextID = nil;
    FREResult freReturnCode = FREGetContextNativeData(ctx, (void *)&contextID);
    if (freReturnCode != FRE_OK) {
        contextID = nil;
    }
    
    return contextID;
}

+ (BOOL)freObject:(FREObject)freObject hasProperty:(NSString *)name {
    const uint8_t *propertyName = (const uint8_t *)[name cStringUsingEncoding:NSUTF8StringEncoding];
    FREObject propertyValue = NULL;
    FREResult freReturnCode = FREGetObjectProperty(freObject, propertyName, &propertyValue, nil);
    return freReturnCode != FRE_NO_SUCH_NAME;
}

+ (FREObject)getProperty:(NSString *)name fromObject:(FREObject)freObject {
    const uint8_t *propertyName = (const uint8_t *)[name cStringUsingEncoding:NSUTF8StringEncoding];
    FREObject propertyValue = NULL;
    FREResult freReturnCode = FREGetObjectProperty(freObject, propertyName, &propertyValue, nil);
    return freReturnCode == FRE_OK? propertyValue: NULL;
}

+ (FREObject)getFREObjectFromString:(NSString*)objcString {
	FREObject returnFREobject = NULL;
    
    if ([objcString length] > 0) {
        const uint8_t *strAS = (const uint8_t *)[objcString cStringUsingEncoding:NSUTF8StringEncoding];
        FRENewObjectFromUTF8((uint32_t)strlen((const char *)strAS) + 1, strAS, &returnFREobject);
    }

	return returnFREobject;
}


+ (FREObject)getFREObjectFromInt:(int32_t)objcInt {
	FREObject returnFREobject = NULL;
    
	FRENewObjectFromInt32(objcInt, &returnFREobject);
    
	return returnFREobject;
}

+ (FREObject)getFREObjectFromUInt :(uint32_t)objcUInt {
	FREObject returnFREobject = NULL;
    
	FRENewObjectFromUint32(objcUInt, &returnFREobject);
    
	return returnFREobject;
}

+ (FREObject)getFREObjectFromDouble:(double)objcDouble {
	FREObject returnFREobject = NULL;
    
	FRENewObjectFromDouble(objcDouble, &returnFREobject);
    
	return returnFREobject;
}

+ (FREObject)getFREObjectFromBool:(BOOL)objcBool{
	FREObject returnFREobject = NULL;
    
	FRENewObjectFromBool(objcBool, &returnFREobject);
    
	return returnFREobject;
}


+ (NSString*)getStringFromFREObject:(FREObject)freObject{
    uint32_t        strLen=0;
    const uint8_t   *strAS = nil;
    NSString        *returnString = nil;
    
    FREObjectType   freObjectType = FRE_TYPE_NULL;
    FREGetObjectType(freObject, &freObjectType);
    
    assert(freObjectType == FRE_TYPE_STRING || freObjectType == FRE_TYPE_NULL); // Null string is a valid value
    
    if (freObjectType == FRE_TYPE_STRING) {
        FREGetObjectAsUTF8(freObject, &strLen, &strAS); // NOTE: Memory allocated for strAS is managed by FRE library.
        returnString = [[NSString alloc] initWithBytes:strAS length:strLen encoding:NSUTF8StringEncoding];
    }
    
    return returnString;
}

+ (double)getDoubleFromFREObject:(FREObject)freObject {
    double asNumber = 0;
    
    FREObjectType   freObjectType = FRE_TYPE_NULL;
    FREGetObjectType(freObject, &freObjectType);
    
    assert(freObjectType == FRE_TYPE_NUMBER);
    
    if (freObjectType == FRE_TYPE_NUMBER) {
        FREGetObjectAsDouble(freObject, &asNumber);
    }
    
    return asNumber;
}


+ (int32_t)getIntFromFREObject:(FREObject)freObject {
    int32_t asNumber = 0;
    
    FREObjectType   freObjectType = FRE_TYPE_NULL;
    FREGetObjectType(freObject, &freObjectType);
    
    assert(freObjectType == FRE_TYPE_NUMBER);
    
    if (freObjectType == FRE_TYPE_NUMBER) {
        FREGetObjectAsInt32(freObject, &asNumber);
    }
    
    return asNumber;
}

+ (uint32_t)getUIntFromFREObject:(FREObject)freObject {
    uint32_t asNumber = 0;
    
    FREObjectType   freObjectType = FRE_TYPE_NULL;
    FREGetObjectType(freObject, &freObjectType);
    
    assert(freObjectType == FRE_TYPE_NUMBER);
    
    if (freObjectType == FRE_TYPE_NUMBER) {
        FREGetObjectAsUint32(freObject, &asNumber);
    }
    
    return asNumber;
}

+ (UIColor *)getColorFromFREObject:(FREObject)freObject {
    uint32_t color = [self getUIntFromFREObject:freObject];
    
    double r = ((color >> 16) & 0xFF) / 255.0;
    double g = ((color >> 8) & 0xFF) / 255.0;
    double b = (color >> 16) / 255.0;
    
    return [UIColor colorWithRed:r green:g blue:b alpha:1.0];
}

+ (BOOL)getBoolFromFREObject:(FREObject)freObject {
    uint32_t asBool = 0;
    
    FREObjectType   freObjectType = FRE_TYPE_NULL;
    FREGetObjectType(freObject, &freObjectType);
    
    assert(freObjectType == FRE_TYPE_BOOLEAN);
    
    if (freObjectType == FRE_TYPE_BOOLEAN) {
        FREGetObjectAsBool(freObject, &asBool);
    }
    
    return (BOOL)asBool;
}

+ (NSData *)getDataFromFREObject:(FREObject)freObject {
    FREByteArray byteArray = {1, NULL};
    FREResult freResult = FREAcquireByteArray(freObject, &byteArray);
    NSData *data = nil;

    if (freResult == FRE_OK) {
        data = [NSData dataWithBytes:byteArray.bytes length:byteArray.length];
    }

    FREReleaseByteArray(freObject);
    return data;
}

+ (NSArray *)getArrayFromFREObject:(FREObject)freObject withDecoder:(id<JKDecoder>)decoder {
    NSMutableArray *array = [NSMutableArray array];

    FREObjectType freObjectType = FRE_TYPE_NULL;
    FREGetObjectType(freObject, &freObjectType);

    if (freObjectType == FRE_TYPE_NULL) return [NSArray array];

    assert(freObjectType == FRE_TYPE_ARRAY || freObjectType == FRE_TYPE_VECTOR);

    if (freObjectType == FRE_TYPE_ARRAY || freObjectType == FRE_TYPE_VECTOR) {
        uint32_t arrayLength = 0;
        FREResult freResult = FREGetArrayLength(freObject, &arrayLength);

        if (freResult == FRE_OK) {
            for (int i = 0; i < arrayLength; i++) {
                FREObject arrayItemObject = NULL;
                FREResult freItemResult = FREGetArrayElementAt(freObject, i, &arrayItemObject);

                if (freItemResult == FRE_OK) {
                    [array addObject:[decoder decodeObject:arrayItemObject]];
                }
            }
        }
    }

    return [array copy];
}

+ (FREObject)getFREObjectFromData:(NSData *)data {
    FREResult result;
    FREObject byteArray;
    const uint8_t* className = (uint8_t*)"flash.utils.ByteArray";
    result = FRENewObject(className, 0, nil, &byteArray, nil);
    assert(result == FRE_OK);

    const unsigned char *dataBytes = data.bytes;
    unsigned long dataLength = data.length;

    // Construct an ActionScript ByteArray object containing the action data of the selected notification.
    for (int i = 0; i < dataLength; i++) {
        FREObject arguments[] = {nil};
        arguments[0] = [ExtensionUtils getFREObjectFromInt:dataBytes[i]];

        const uint8_t* methodName = (uint8_t*)"writeByte";
        FREObject methodResult;
        result = FRECallObjectMethod(byteArray, methodName, 1, arguments, &methodResult, nil);
        assert(result == FRE_OK);
    }
    return byteArray;
}

#endif

@end

