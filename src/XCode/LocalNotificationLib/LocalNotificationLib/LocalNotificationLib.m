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
#import "LocalNotificationsContext.h"
#import "ExtensionUtils.h"

// A native context instance is created
void ComJkLocalNotificationContextInitializer(void* extData, const uint8_t* ctxType, FREContext ctx, 
                            uint32_t* numFunctionsToTest, const FRENamedFunction** functionsToSet) {
    // Initialize the native context.
    LocalNotificationsContext *nativeContextID = [[LocalNotificationsContext notificationsContextWithContext:ctx] retain];

    *numFunctionsToTest = [nativeContextID initExtensionFunctions:functionsToSet];

    // Attach a reference to our native context object so we can clean it up in ADEPContextFinalizer
    [ExtensionUtils setContextID:nativeContextID forFREContext:ctx];
}

// A native context instance is disposed
void ComJkLocalNotificationContextFinalizer(FREContext ctx) {
    // Free pushContext instance attached to ctx here.
    LocalNotificationsContext *contextID = [ExtensionUtils getContextID:ctx];
    [contextID release];
}

// Initialization function of each extension
void ComJkLocalNotificationExtInitializer(void** extDataToSet, FREContextInitializer* ctxInitializerToSet, 
                        FREContextFinalizer* ctxFinalizerToSet) {
	*extDataToSet = NULL;
	*ctxInitializerToSet = &ComJkLocalNotificationContextInitializer;
	*ctxFinalizerToSet = &ComJkLocalNotificationContextFinalizer;
}

// Called when extension is unloaded
void ComJkLocalNotificationExtFinalizer(void* extData) {
	return;
}
