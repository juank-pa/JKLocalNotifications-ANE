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


#import <UIKit/UIKit.h>
#import "FlashRuntimeExtensions.h"

@interface ExtensionUtils : NSObject 

#ifndef TEST

+ (id)getContextID :(FREContext)ctx;
+ (FREObject) getFREObjectFromString:(NSString *)objcString;
+ (FREObject) getFREObjectFromInt:(int32_t)objcInt;
+ (FREObject) getFREObjectFromUInt :(uint32_t)objcUInt;
+ (FREObject) getFREObjectFromDouble:(double)objcDouble;
+ (FREObject) getFREObjectFromBool:(BOOL)objcBool;

+ (NSString *) getStringFromFREObject:(FREObject)freObject;
+ (int32_t) getIntFromFREObject:(FREObject)freObject;
+ (uint32_t) getUIntFromFREObject:(FREObject)freObject;
+ (double) getDoubleFromFREObject:(FREObject)freObject;
+ (BOOL) getBoolFromFREObject:(FREObject)freObject;
+ (UIColor *) getColorFromFREObject :(FREObject)freObject;

#endif

@end

