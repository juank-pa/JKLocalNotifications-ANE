//
//  JKNotificationListenerSharedTests.m
//  LocalNotificationLib
//
//  Created by Juan Carlos Pazmino on 12/2/17.
//
//

#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>
#import <UserNotifications/UserNotifications.h>
#import "JKNotificationListenerSharedTests.h"
#import "JKNotificationListener.h"
#import "JKNotificationDispatcher.h"

@interface JKNotificationListener (Test)
@property (nonatomic, readwrite) JKNotificationDispatcher *dispatcher;
@property (nonatomic, readwrite) NSString *notificationAction;
@property (nonatomic, readwrite) NSDictionary *userInfo;
@end

@interface JKNotificationListenerSharedTests ()
@property (nonatomic, weak) JKNotificationListener *subject;
@property (nonatomic, weak) id dispatcher;
@end

@implementation JKNotificationListenerSharedTests

- (instancetype)initWithSubject:(JKNotificationListener *)subject dispatcher:(JKNotificationDispatcher *)dispatcher {
    if (self = [super init]) {
        _subject = subject;
        _dispatcher = dispatcher;
    }
    return self;
}

- (void)checkForNotificationActionDispatchesIfUserInfoWasCached {
    NSDictionary *userInfo = @{};
    OCMExpect([self.dispatcher dispatchDidReceiveNotificationWithActionId:@"actionId"
                                                                 userInfo:userInfo
                                                        completionHandler:[OCMArg any]]);

    self.subject.notificationAction = @"actionId";
    self.subject.dispatcher = self.dispatcher;
    self.subject.userInfo = userInfo;
    [self.subject checkForNotificationAction];

    OCMVerifyAll(self.dispatcher);
}

- (void)checkForNotificationActionDoesNotDispatchIfUserInfoIsNil {
    OCMReject([self.dispatcher dispatchDidReceiveNotificationWithActionId:[OCMArg any]
                                                                     userInfo:[OCMArg any]
                                                            completionHandler:[OCMArg any]]);

    self.subject.notificationAction = @"actionId";
    self.subject.dispatcher = self.dispatcher;
    self.subject.userInfo = nil;
    [self.subject checkForNotificationAction];

    OCMVerifyAll(self.dispatcher);
}

- (void)checkForNotificationActionOnlyOnce {
    OCMStub([self.dispatcher dispatchDidReceiveNotificationWithActionId:[OCMArg any]
                                                                   userInfo:[OCMArg any]
                                                          completionHandler:[OCMArg invokeBlock]]);

    self.subject.dispatcher = self.dispatcher;
    self.subject.userInfo = @{};
    [self.subject checkForNotificationAction];
    OCMReject([self.dispatcher dispatchDidReceiveNotificationWithActionId:[OCMArg any]
                                                                     userInfo:[OCMArg any]
                                                            completionHandler:[OCMArg any]]);

    [self.subject checkForNotificationAction];

    OCMVerifyAll(self.dispatcher);
}

@end
