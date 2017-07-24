// ADOBE CONFIDENTIAL
//
// Copyright 2011 Adobe Systems Incorporated All Rights Reserved.
//
// NOTICE: All information contained herein is, and remains the property of
// Adobe Systems Incorporated and its suppliers, if any. The intellectual and
// technical concepts contained herein are proprietary to Adobe Systems
// Incorporated and its suppliers and may be covered by U.S. and Foreign
// Patents, patents in process, and are protected by trade secret or copyright
// law. Dissemination of this information or reproduction of this material
// is strictly forbidden unless prior written permission is obtained from
// Adobe Systems Incorporated.

//
// Methods
// 

#if __cplusplus
extern "C" {
#endif

// Returns a dictionary indicating the reason the application was launched (if any).
// It is the same dictionary passed as parameter to application:didFinishLaunchingWithOptions: 
// message of the application delegate. If the value is nil, 
// this was a standard application start-up. Otherwise, the application 
// was started based on a notification presented to the user.
//
NSDictionary* FRPE_getApplicationLaunchOptions();

#if __cplusplus
}
#endif
		
//
// Notifications
//

// FRPE_ApplicationDidReceiveLocalNotification: Posted when the application 
// receives a local notification. The userInfo dictionary contains the notification. 
// Use the key FRPE_ApplicationDidReceiveLocalNotificationKey to access the value.
//
extern const NSString *const FRPE_ApplicationDidReceiveLocalNotification;

// FRPE_ApplicationDidReceiveRemoteNotification: Posted when the application 
// receives a remote notification. The userInfo dictionary contains the information 
// associated with the remote notification.
// Use the key FRPE_ApplicationDidReceiveRemoteNotificationKey to access the value.
//
extern const NSString *const FRPE_ApplicationDidReceiveRemoteNotification;

// FRPE_ApplicationDidRegisterForRemoteNotificationsWithDeviceToken: Posted when call
// to application:didRegisterForRemoteNotificationsWithDeviceToken: is received. The 
// useInfo dictionary contains the device token passed as argument to the method. 
// Use the FRPE_ApplicationDidRegisterForRemoteNotificationsWithDeviceTokenKey key to access the value.
//
extern const NSString *const FRPE_ApplicationDidRegisterForRemoteNotificationsWithDeviceToken;

// FRPE_ApplicationDidFailToRegisterForRemoteNotificationsWithError: Posted when call to 
// application:didFailToRegisterForRemoteNotificationsWithError: is received. The useInfo 
// dictionary contains the error passed as argument to the method. Use the 
// FRPE_ApplicationDidFailToRegisterForRemoteNotificationsWithErrorKey key to access the value.
//
extern const NSString *const FRPE_ApplicationDidFailToRegisterForRemoteNotificationsWithError;

//
// UserInfo Dictionary Keys 
//

// FRPE_ApplicationDidReceiveRemoteNotificationKey accesses an the UserInfo dictionary of 
// FRPE_ApplicationDidReceiveRemoteNotification
//
extern const NSString *const FRPE_ApplicationDidReceiveRemoteNotificationKey;

// FRPE_ApplicationDidReceiveLocalNotificationKey accesses an the UserInfo dictionary of 
// FRPE_ApplicationDidReceiveLocalNotification
//
extern const NSString *const FRPE_ApplicationDidReceiveLocalNotificationKey;

// FRPE_ApplicationDidRegisterForRemoteNotificationsWithDeviceTokenKey accesses an the 
// UserInfo dictionary of FRPE_ApplicationDidRegisterForRemoteNotificationsWithDeviceToken
//
extern const NSString *const FRPE_ApplicationDidRegisterForRemoteNotificationsWithDeviceTokenKey;

// FRPE_ApplicationDidFailToRegisterForRemoteNotificationsWithErrorKey accesses an the 
// UserInfo dictionary of FRPE_ApplicationDidFailToRegisterForRemoteNotificationsWithError
//
extern const NSString *const FRPE_ApplicationDidFailToRegisterForRemoteNotificationsWithErrorKey;
