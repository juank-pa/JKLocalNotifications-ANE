//
//  ViewController.m
//  LocalNotificationTest
//
//  Created by Juan Pazmino on 3/23/12.
//  Copyright (c) 2012 KaribuGames. All rights reserved.
//

#import "ViewController.h"
#import "LocalNotificationsContext.h"
#import "LocalNotification.h"
#import "LocalNotificationManager.h"
#import "FlashRuntimeExtensions+Private.h"

@interface ViewController ()
@property (nonatomic, assign) IBOutlet UITextView *debugText;
@property (nonatomic, retain) LocalNotificationsContext *context;
@end

@implementation ViewController

@synthesize debugText = _debugText;
@synthesize context = _context;

- (void)dealloc {
    self.context.delegate = nil;
    [self.context release];
    [super dealloc];
}

- (IBAction)cancelByCode:(id)sender {
    [self.context cancel:@"JKCode"];
}

- (IBAction)cancelAll:(id)sender {
    [self.context cancelAll];
}

- (IBAction)celarBadge:(id)sender {
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
}

- (IBAction)postNotification:(id)sender {
    LocalNotification *notification = [[[LocalNotification alloc] init] autorelease];
    
    notification.notificationCode = @"JKCode";
    notification.playSound = YES;
    notification.body = @"Hello";
    notification.actionLabel = @"Rock";
    notification.fireDate = [NSDate dateWithTimeIntervalSinceNow:15];
    notification.numberAnnotation = 2;
    //notification.repeatInterval = NSSecondCalendarUnit;
    notification.playSound = YES;
    
    [self.context notify:notification];
}

- (IBAction)clearText:(id)sender {
    self.debugText.text = @"";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.context = [[[LocalNotificationsContext alloc] initWithContext:NULL] autorelease];
    [self.context createManager];
    
    [self printMessage:@"Before Delegate"];
    
    self.context.delegate = self;

    [self.context registerSettingTypes:(UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert)];
    [self.context checkForNotificationAction];

    [self printMessage:@"After Delegate"];
}

- (void)printMessage:(NSString*)message {
    [self printMessage:message title: nil];
}

- (void)printMessage:(NSString*)message title:(NSString *)title {
    NSString *newTitle = (title? [title stringByAppendingString:@"\n"] : @"");
    self.debugText.text = [NSString stringWithFormat:@"%@-----\n%@%@\n", self.debugText.text, newTitle, message];
}

- (void)localNotificationContext:(LocalNotificationsContext *)context didReceiveLocalNotification:(UILocalNotification *)notification {
    [self printMessage:notification.description title:@"Local Notification"];
    //[self.context cancel:[notification.userInfo objectForKey:NOTIFICATION_CODE_KEY]];
}

- (void)localNotificationContext:(LocalNotificationsContext *)context didRegisterSettings:(UIUserNotificationSettings *)settings {
    [self printMessage:settings.description title:@"Register settings"];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    }
    else {
        return YES;
    }
}

@end
