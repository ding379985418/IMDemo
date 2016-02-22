//
//  DXTabBarController.m
//  QQ
//
//  Created by simon on 16/1/27.
//  Copyright © 2016年 simon. All rights reserved.
//

#import "DXTabBarController.h"
#import "DXBuddyVc.h"
#import "DXQworldVc.h"
#import "DXRecentVc.h"
#import "DXNavigationController.h"

@interface DXTabBarController ()

@end

@implementation DXTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
}

+ (instancetype)tabBarVc{
    DXTabBarController *barVc = [[DXTabBarController alloc]init];
//    

    
      UIViewController *recentVc =[UIStoryboard storyboardWithName:@"DXRecentVc" bundle:nil].instantiateInitialViewController;
    
       UIViewController *buddyVc =[UIStoryboard storyboardWithName:@"DXBuddyVc" bundle:nil].instantiateInitialViewController;
    
      UIViewController *qworldVc =[UIStoryboard storyboardWithName:@"DXQworldVc" bundle:nil].instantiateInitialViewController;
        
    [barVc addChildViewController:recentVc barTitle:@"消息" barImg:@"tab_recent"];
     [barVc addChildViewController:buddyVc barTitle:@"联系人" barImg:@"tab_buddy"];
     [barVc addChildViewController:qworldVc barTitle:@"动态" barImg:@"tab_qworld"];
    


    return barVc;
}
- (void)addChildViewController:(UIViewController *)childController barTitle:(NSString *)title barImg:(NSString *)imgName{
    [self addChildViewController:childController];
    
    NSString *imgNor = [NSString stringWithFormat:@"%@_nor",imgName];
      NSString *imgPress = [NSString stringWithFormat:@"%@_press",imgName];
    
    childController.tabBarItem.image = [UIImage imageNamed:imgNor];
    childController.tabBarItem.selectedImage = [UIImage imageNamed:imgPress];
    childController.tabBarItem.title = title;

}
@end
