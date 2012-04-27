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


#import <Foundation/Foundation.h>
#import "FlashRuntimeExtensions.h"

#ifdef TEST

@class LocalNotificationsContext;

@protocol LocalNotificationDelegate <NSObject>

-(void)localNotificationContext:(LocalNotificationsContext *)context didReceiveLocalNotification:(UILocalNotification *)notification;

@end

#endif

@class LocalNotificationManager;
@class LocalNotification;

@interface LocalNotificationsContext : NSObject
{    
    @private
        
        FREContext extensionContext;
        LocalNotificationManager *notificationManager;
        NSString *selectedNotificationCode;
        NSData *selectedNotificationData;

}

- (id) initWithContext :(FREContext)ctx;

#ifdef TEST
- (void) createManager;
- (void) notify :(LocalNotification*)localNotification;
- (void) cancel :(NSString*)notificationCode;
- (void) cancelAll;
- (void) checkForNotificationAction;
-(void)checkForNotificationAction;

@property (nonatomic, assign) id<LocalNotificationDelegate> delegate;
#else
- (uint32_t) initExtensionFunctions:(const FRENamedFunction**) namedFunctions;
#endif

@end

