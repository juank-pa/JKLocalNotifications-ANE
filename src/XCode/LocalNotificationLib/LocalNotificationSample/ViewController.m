//
//  ViewController.m
//  LocalNotificationTest
//
//  Created by Juan Pazmino on 3/23/12.
//  Copyright (c) 2012 KaribuGames. All rights reserved.
//

#import "ViewController.h"
#import "JKLocalNotificationsContext.h"
#import "JKLocalNotification.h"
#import "JKNotificationFactory.h"
#import "JKLocalNotificationCategory.h"
#import "JKTextInputLocalNotificationAction.h"
#import "JKLocalNotificationSettings.h"
#import "FlashRuntimeExtensions+Private.h"

@interface ViewController ()
@property (nonatomic, weak) IBOutlet UITextView *debugText;
@property (nonatomic, strong) JKLocalNotificationsContext *context;
@end

@implementation ViewController

@synthesize debugText = _debugText;
@synthesize context = _context;

- (void)dealloc {
    self.context.delegate = nil;
}

- (IBAction)cancelByCode:(id)sender {
    [self.context cancel:@"JKCode"];
}

- (IBAction)cancelAll:(id)sender {
    [self.context cancelAll];
}

- (IBAction)clearBadge:(id)sender {
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
}

- (IBAction)postNotification:(id)sender {
    JKLocalNotification *notification = [JKLocalNotification new];
    
    notification.notificationCode = @"JKCode";
    notification.playSound = YES;
    notification.body = @"Hello";
    notification.actionLabel = @"Rock";
    notification.fireDate = [NSDate dateWithTimeIntervalSinceNow:5];
    notification.numberAnnotation = 2;
    //notification.repeatInterval = NSSecondCalendarUnit;
    notification.showInForeground = YES;
    notification.category = @"CategoryX";
    
    [self.context notify:notification];
}

- (IBAction)clearText:(id)sender {
    self.debugText.text = @"";
}

- (void)viewDidLoad {
    [super viewDidLoad];

    JKNotificationFactory *factory = [JKNotificationFactory factory];
    self.context = [JKLocalNotificationsContext notificationsContextWithContext:NULL factory:factory];

    [self printMessage:@"Before Delegate"];
    self.context.delegate = self;
    [self printMessage:@"After Delegate"];

    JKLocalNotificationSettings *settings = [JKLocalNotificationSettings settingsWithLocalNotificationTypes: UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert];

    JKLocalNotificationAction *action1 = [JKLocalNotificationAction new];
    action1.identifier = @"okAction";
    action1.title = @"OK";

    JKTextInputLocalNotificationAction *action2 = [JKTextInputLocalNotificationAction new];
    action2.identifier = @"cancelAction";
    action2.title = @"Cancel";
    action2.background = YES;
    action2.textInputPlaceholder = @"What's up...";
    action2.textInputButtonTitle = @"Fight!";

    JKLocalNotificationAction *action3 = [JKLocalNotificationAction new];
    action3.identifier = @"test1Action";
    action3.title = @"Test1";

    JKLocalNotificationAction *action4 = [JKLocalNotificationAction new];
    action4.identifier = @"test2Action";
    action4.title = @"Test2";

    JKLocalNotificationCategory *category = [JKLocalNotificationCategory new];
    category.identifier = @"CategoryX";
    category.actions = @[action1, action2, action3, action4];
    category.useCustomDismissAction = YES;

    settings.categories = @[category];

    [self.context authorizeWithSettings:settings];

    [self.context checkForNotificationAction];
}

- (void)printMessage:(NSString*)message {
    [self printMessage:message title: nil];
}

- (void)printMessage:(NSString*)message title:(NSString *)title {
    NSString *newTitle = (title? [title stringByAppendingString:@"\n"] : @"");
    self.debugText.text = [NSString stringWithFormat:@"%@-----\n%@%@\n", self.debugText.text, newTitle, message];
}

- (void)localNotificationContext:(JKLocalNotificationsContext *)context didReceiveNotificationFromListener:(JKNotificationListener *)listener {
    NSString *string = [NSString stringWithFormat:@"%@\n%@\n%@", listener.notificationCode, listener.notificationAction, listener.userResponse];
    [self printMessage:string title:@"Local Notification"];
}

- (void)localNotificationContext:(JKLocalNotificationsContext *)context didRegisterSettings:(JKLocalNotificationSettings *)settings {
    [self printMessage:@(settings.types).description title:@"Register settings"];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

@end
