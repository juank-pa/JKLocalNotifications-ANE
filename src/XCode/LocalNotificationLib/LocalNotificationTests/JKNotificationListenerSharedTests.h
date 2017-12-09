//
//  JKNotificationListenerSharedTests.h
//  LocalNotificationLib
//
//  Created by Juan Carlos Pazmino on 12/2/17.
//
//

#import <Foundation/Foundation.h>
@class JKNotificationListener;
@class JKNotificationDispatcher;

@interface JKNotificationListenerSharedTests: NSObject
- (instancetype)initWithSubject:(JKNotificationListener *)subject dispatcher:(JKNotificationDispatcher *)dispatcher;
- (void)checkForNotificationActionDispatchesIfUserInfoWasCached;
- (void)checkForNotificationActionDoesNotDispatchIfUserInfoIsNil;
- (void)checkForNotificationActionOnlyOnce;
@end
