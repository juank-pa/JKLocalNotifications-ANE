//
//  AppDelegate.h
//  LocalNotificationTest
//
//  Created by Juan Pazmino on 3/23/12.
//  Copyright (c) 2012 KaribuGames. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (retain, nonatomic) UIWindow *window;
@property (retain, nonatomic) ViewController *viewController;
@property (retain, nonatomic) NSDictionary *options;

@end
