//
//  DXBaseViewController.m
//  QQ
//
//  Created by simon on 16/1/27.
//  Copyright © 2016年 simon. All rights reserved.
//

#import "DXBaseViewController.h"

@interface DXBaseViewController ()

@end

@implementation DXBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    
  
    self.navigationController.navigationBar.barTintColor = KDefaultColor;
    self.navigationController.navigationBar.titleTextAttributes = [NSDictionary attributeDicWithFontSize:16 color:[UIColor whiteColor]];
    
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:[NSDictionary attributeDicWithFontSize:14 color:[UIColor whiteColor]] forState:UIControlStateNormal];
    
  
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
