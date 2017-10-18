//
//  JKAuthorizer.h
//  LocalNotificationLib
//
//  Created by Juan Carlos Pazmino on 9/30/17.
//
//

#import <Foundation/Foundation.h>

@class JKLocalNotificationSettings;
@protocol JKAuthorizer;

@protocol JKAuthorizerDelegate
- (void)notificationAuthorizer:(id<JKAuthorizer>)authorizer didAuthorizeWithSettings:(JKLocalNotificationSettings *)settings;
@end

@protocol JKAuthorizer <NSObject>
- (void)requestAuthorizationWithSettings:(JKLocalNotificationSettings *)settings;
@property (nonatomic, readonly, strong) JKLocalNotificationSettings *settings;
@property (nonatomic, weak) id<JKAuthorizerDelegate>delegate;
@end
