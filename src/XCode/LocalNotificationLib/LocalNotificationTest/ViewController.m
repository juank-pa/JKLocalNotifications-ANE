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
@property (retain, nonatomic) IBOutlet UITextView *debugText;
@property (nonatomic, retain) LocalNotificationsContext *context;
@end

@implementation ViewController

@synthesize debugText = _debugText;
@synthesize context = _context;

-(void)dealloc
{
    [_context release];
    [_debugText release];
    [super dealloc];
}
- (IBAction)cancelAll:(id)sender {
    [self.context cancelAll];
}
- (IBAction)celarBadge:(id)sender {
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
}
- (IBAction)postNotification:(id)sender 
{
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.context = [[LocalNotificationsContext alloc] initWithContext:NULL];
    [self.context createManager];
    
    self.debugText.text = [NSString stringWithFormat:@"%@BeforeDelegate\n-----\n", self.debugText.text];
    
    self.context.delegate = self;
    [self.context checkForNotificationAction];
    
    self.debugText.text = [NSString stringWithFormat:@"%@AfterDelegate\n-----\n", self.debugText.text];
}

-(void)localNotificationContext:(LocalNotificationsContext *)context didReceiveLocalNotification:(UILocalNotification *)notification
{
    self.debugText.text = [NSString stringWithFormat:@"%@%@ %@\n-----\n", self.debugText.text, notification, notification.userInfo];
    
    //[self.context cancel:[notification.userInfo objectForKey:NOTIFICATION_CODE_KEY]];
}

- (void)viewDidUnload
{
    [self setDebugText:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

@end
