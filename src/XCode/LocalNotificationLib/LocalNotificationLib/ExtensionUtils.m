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

@implementation ExtensionUtils

#ifndef TEST

+ (id)getContextID:(FREContext)ctx
{
    // Retrive our obj-c context object from the AS side
    id contextID = nil;
    FREResult freReturnCode = FREGetContextNativeData(ctx, (void **)&contextID);
    if (freReturnCode != FRE_OK)
    {
        contextID = nil;
    }
    
    return contextID;
}

+ (FREObject) getFREObjectFromString :(NSString*)objcString
{
	FREObject returnFREobject = NULL;
    
    if ([objcString length] > 0)
    {
        const uint8_t   *strAS = (const uint8_t *)[objcString cStringUsingEncoding:NSUTF8StringEncoding];
        FRENewObjectFromUTF8(strlen((const char *)strAS)+1, strAS, &returnFREobject);
    }
	
	return returnFREobject;
}


+ (FREObject) getFREObjectFromInt :(int32_t)objcInt
{
	FREObject returnFREobject = NULL;
    
	FRENewObjectFromInt32(objcInt, &returnFREobject);
    
	return returnFREobject;
}

+ (FREObject) getFREObjectFromUInt :(uint32_t)objcUInt
{
	FREObject returnFREobject = NULL;
    
	FRENewObjectFromUint32(objcUInt, &returnFREobject);
    
	return returnFREobject;
}

+ (FREObject) getFREObjectFromDouble:(double)objcDouble
{
	FREObject returnFREobject = NULL;
    
	FRENewObjectFromDouble(objcDouble, &returnFREobject);
    
	return returnFREobject;
}

+ (FREObject) getFREObjectFromBool :(BOOL)objcBool
{
	FREObject returnFREobject = NULL;
    
	FRENewObjectFromBool(objcBool, &returnFREobject);
    
	return returnFREobject;
}


+ (NSString*) getStringFromFREObject :(FREObject)freObject
{    
    uint32_t        strLen=0;
    const uint8_t   *strAS = nil;
    NSString        *returnString = nil;
    
    FREObjectType   freObjectType = FRE_TYPE_NULL;
    FREGetObjectType(freObject, &freObjectType);
    
    assert(freObjectType == FRE_TYPE_STRING || freObjectType == FRE_TYPE_NULL); // Null string is a valid value
    
    if (freObjectType == FRE_TYPE_STRING)
    {
        FREGetObjectAsUTF8(freObject, &strLen, &strAS); // NOTE: Memory allocated for strAS is managed by FRE library.
        returnString = [[[NSString alloc] initWithBytes:strAS length:strLen encoding:NSUTF8StringEncoding] autorelease];
    }
    
    return returnString;
}

+ (double) getDoubleFromFREObject:(FREObject)freObject
{
    double asNumber = 0;
    
    FREObjectType   freObjectType = FRE_TYPE_NULL;
    FREGetObjectType(freObject, &freObjectType);
    
    assert(freObjectType == FRE_TYPE_NUMBER);
    
    if (freObjectType == FRE_TYPE_NUMBER)
    {
        FREGetObjectAsDouble(freObject, &asNumber);
    }
    
    return asNumber;
}


+ (int32_t) getIntFromFREObject :(FREObject)freObject
{    
    int32_t asNumber = 0;
    
    FREObjectType   freObjectType = FRE_TYPE_NULL;
    FREGetObjectType(freObject, &freObjectType);
    
    assert(freObjectType == FRE_TYPE_NUMBER);
    
    if (freObjectType == FRE_TYPE_NUMBER)
    {
        FREGetObjectAsInt32(freObject, &asNumber);
    }
    
    return asNumber;
}

+ (uint32_t) getUIntFromFREObject :(FREObject)freObject
{    
    uint32_t asNumber = 0;
    
    FREObjectType   freObjectType = FRE_TYPE_NULL;
    FREGetObjectType(freObject, &freObjectType);
    
    assert(freObjectType == FRE_TYPE_NUMBER);
    
    if (freObjectType == FRE_TYPE_NUMBER)
    {
        FREGetObjectAsUint32(freObject, &asNumber);
    }
    
    return asNumber;
}

+ (UIColor *) getColorFromFREObject :(FREObject)freObject
{    
    uint32_t color = [self getUIntFromFREObject:freObject];
    
    double r = ((color >> 16) & 0xFF) / 255.0;
    double g = ((color >> 8) & 0xFF) / 255.0;
    double b = (color >> 16) / 255.0;
    
    return [UIColor colorWithRed:r green:g blue:b alpha:1.0];
}

+ (BOOL) getBoolFromFREObject :(FREObject)freObject
{    
    uint32_t asBool = 0;
    
    FREObjectType   freObjectType = FRE_TYPE_NULL;
    FREGetObjectType(freObject, &freObjectType);
    
    assert(freObjectType == FRE_TYPE_BOOLEAN);
    
    if (freObjectType == FRE_TYPE_BOOLEAN)
    {
        FREGetObjectAsBool(freObject, &asBool);
    }
    
    return (BOOL)asBool;
}

#endif

@end

