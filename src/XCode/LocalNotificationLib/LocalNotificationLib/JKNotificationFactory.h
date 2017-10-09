//
//  JKLocalNotificationFactory.h
//  LocalNotificationLib
//
//  Created by Juan Carlos Pazmino on 9/30/17.
//
//

#import "JKAuthorizer.h"
#import "JKNotificationListener.h"
#import "JKLocalNotificationManager.h"

@interface JKNotificationFactory : NSObject
+ (instancetype)factory;

- (id<JKAuthorizer>)createAuthorizer;
- (JKNotificationListener *)createListener;
- (JKLocalNotificationManager *)createManager;
@end
