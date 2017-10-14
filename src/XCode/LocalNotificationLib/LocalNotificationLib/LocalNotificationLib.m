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
#import "JKLocalNotificationsContext.h"
#import "JKNotificationFactory.h"
#import "ExtensionUtils.h"
#import "Constants.h"

JKLocalNotificationsContext * __strong jkNotificationsContext;

// A native context instance is created
void ComJkLocalNotificationContextInitializer(void* extData, const uint8_t* ctxType, FREContext ctx, 
                            uint32_t* numFunctionsToTest, const FRENamedFunction** functionsToSet) {
    BOOL useNewApi = ctxType && strcmp((char *)ctxType, "LocalNotificationsContextNew") == 0 ? YES : NO;

    // Initialize the native context.
    @autoreleasepool {
        JKNotificationFactory *factory = [JKNotificationFactory factory:useNewApi];
        jkNotificationsContext = [JKLocalNotificationsContext notificationsContextWithContext:ctx factory:factory];

        *numFunctionsToTest = [jkNotificationsContext initExtensionFunctions:functionsToSet];
    }
}

// A native context instance is disposed
void ComJkLocalNotificationContextFinalizer(FREContext ctx) {
    // Free pushContext instance attached to ctx here.
    @autoreleasepool {
        jkNotificationsContext = nil;
    }
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
