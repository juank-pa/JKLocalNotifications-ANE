//
//  JKNotificationListener+Private.h
//  LocalNotificationLib
//
//  Created by Juan Carlos Pazmino on 12/1/17.
//
//

@interface JKNotificationListener ()
@property (nonatomic, readwrite) NSString *notificationCode;
@property (nonatomic, readwrite) NSData *notificationData;
@property (nonatomic, readwrite) NSString *notificationAction;
@property (nonatomic, readwrite) NSDictionary *userInfo;
@property (nonatomic, readwrite) NSString *userResponse;
@end
