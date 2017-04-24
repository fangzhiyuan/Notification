//
//  ViewController.m
//  Notification
//
//  Created by 威盛电气 on 2017/4/24.
//  Copyright © 2017年 GG. All rights reserved.
//

#import "ViewController.h"
#define Height self.view.frame.size.height
#define Width self.view.frame.size.width
@interface ViewController ()
{

    UIButton *startBtn;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"本地推送";
    
    startBtn = [self buttonInitWith:CGRectMake((Width-100)/2,200, 100, 45) withTitle:@"确定" withBlock:^{
        
    }];
}

-(UIButton *)buttonInitWith:(CGRect)frame withTitle:(NSString *)name withBlock:(void(^)())block{
    UIButton *button=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.frame=frame;
    [button setTitle:name forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    block();
    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    return button;
}


-(void)buttonClick:(UIButton *)sender{
      [self registerLocalNotification:4];
}



- (void)registerLocalNotification:(NSInteger)alertTime {
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    
    NSDate *fireDate = [NSDate dateWithTimeIntervalSinceNow:alertTime];
    NSLog(@"fireDate=%@",fireDate);
    
    notification.fireDate = fireDate;
    
    notification.timeZone = [NSTimeZone defaultTimeZone];
    
    notification.repeatInterval = kCFCalendarUnitSecond;

    notification.alertBody =  @"哈喽....";
    notification.applicationIconBadgeNumber = 1;
    
    notification.soundName = UILocalNotificationDefaultSoundName;
    
    NSDictionary *userDict = [NSDictionary dictionaryWithObject:@"来了。" forKey:@"key"];
    notification.userInfo = userDict;
    
    
    if ([[UIApplication sharedApplication] respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        UIUserNotificationType type =  UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound;
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:type
                                                                                 categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
        
        notification.repeatInterval = NSCalendarUnitDay;
    } else {
        
        notification.repeatInterval = NSCalendarUnitDay;
    }
    
    
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
}


- (void)cancelLocalNotificationWithKey:(NSString *)key {
    
    NSArray *localNotifications = [UIApplication sharedApplication].scheduledLocalNotifications;
    
    for (UILocalNotification *notification in localNotifications) {
        NSDictionary *userInfo = notification.userInfo;
        if (userInfo) {
            
            NSString *info = userInfo[key];

            if (info != nil) {
                [[UIApplication sharedApplication] cancelLocalNotification:notification];
                break;
            }
        }
    }
}


@end
