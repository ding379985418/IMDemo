//
//  AppDelegate.m
//  QQ
//
//  Created by simon on 16/1/24.
//  Copyright © 2016年 simon. All rights reserved.
//

#import "AppDelegate.h"
#import <XMPPFramework.h>
#import "DXIMManager.h"
#import "SSKeychain.h"
#import "ViewController.h"
#import "DXTabBarController.h"
#import "DXAudioTools.h"
#define KUserName @"sun"
@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.isbackGround = NO;
    UIViewController *rootVC;

    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeRootVc:) name:DXNotificationLogInVcSwitchRootVc object:nil];
    
   NSString *userName =[DXTools userNameForUserDefaults];
    if (userName.length != 0) {
       rootVC = [DXTabBarController tabBarVc];
        [self connectWith:(NSString *)userName tip:nil];
    }else{
     rootVC = [UIStoryboard storyboardWithName:@"LogIn" bundle:nil].instantiateInitialViewController;
    }
  
    self.window = [[UIWindow alloc]initWithFrame:KScreenBounds];
    self.window.rootViewController = rootVC;
    [self.window makeKeyAndVisible];
    
    if ([UIApplication instancesRespondToSelector:@selector(registerUserNotificationSettings:)]){
        
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound categories:nil]];
        
    }
    [[UIApplication sharedApplication]setApplicationIconBadgeNumber:0];
     return YES;
   }
///连接服务器
- (void)connectWith:(NSString *)userName tip:(NSString *)tipString{
    
    NSString *password = [SSKeychain passwordForService:[NSBundle mainBundle].bundleIdentifier account:userName];
    [[DXIMManager sharedManager]connectWithHostName:DXHostName userName:userName password:password isSucess:^(BOOL sucess) {
        if (!sucess && tipString) {
           dispatch_async(dispatch_get_main_queue(), ^{
               UIAlertController *alerVC = [UIAlertController alertControllerWithTitle:@"提示" message:tipString preferredStyle:UIAlertControllerStyleAlert];
               [alerVC addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
               [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alerVC animated:YES completion:nil];
           });
        }
    }];
    
}
///改变根控制器
- (void)changeRootVc:(NSNotification *)notify{
    dispatch_async(dispatch_get_main_queue(), ^{
//        SSLog(@"**********%@",notify.object);
        self.window.rootViewController = (BOOL)[notify.object intValue]?[DXTabBarController tabBarVc]:[UIStoryboard storyboardWithName:@"LogIn" bundle:nil].instantiateInitialViewController;
    });
}
- (void)applicationWillResignActive:(UIApplication *)application {
    self.isbackGround = YES;
}
- (void)applicationDidBecomeActive:(UIApplication *)application {
    self.isbackGround = NO;
      [[UIApplication sharedApplication]setApplicationIconBadgeNumber:0];
    NSString *userName =[DXTools userNameForUserDefaults];
    if (userName.length != 0) {
        [self connectWith:(NSString *)userName tip:@"您的账号密码已经被修改，请重新登陆。如不是本人操作，请立即修改密码！"];
   }
    
}
- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application{

    [DXAudioTools clearMemory];
}


@end
