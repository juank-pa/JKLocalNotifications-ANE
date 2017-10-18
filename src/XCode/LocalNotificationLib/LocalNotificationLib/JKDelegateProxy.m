//
//  JKDelegateProxy.m
//  LocalNotificationLib
//
//  Created by Juan Carlos Pazmino on 10/3/17.
//
//

#import "JKDelegateProxy.h"

@interface JKDelegateProxy ()
@property (nonatomic, strong) id savedDelegate;
@end

@implementation JKDelegateProxy

- (instancetype)initWithTarget:(id)target {
    if (self = [super init]) {
        _savedDelegate = target;
    }
    return self;
}

- (BOOL)respondsToSelector:(SEL)aSelector {
    return [self.class instancesRespondToSelector:aSelector] || [self.savedDelegate respondsToSelector:aSelector];
}

- (id)forwardingTargetForSelector:(SEL)aSelector {
    return self.savedDelegate;
}

@end
