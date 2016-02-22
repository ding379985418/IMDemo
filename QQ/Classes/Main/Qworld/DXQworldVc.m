//
//  DXQworldVc.m
//  QQ
//
//  Created by simon on 16/1/30.
//  Copyright © 2016年 simon. All rights reserved.
//

#import "DXQworldVc.h"

@interface DXQworldVc ()

@end

@implementation DXQworldVc

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"动态";
    self.navigationItem.leftBarButtonItem = [DXTools myIconBarButtonItem];
//    [UINavigationBar appearance].barTintColor = KDefaultColor;
    self.navigationController.navigationBar.barTintColor = KDefaultColor;
    self.navigationController.navigationBar.titleTextAttributes = [NSDictionary attributeDicWithFontSize:16 color:[UIColor whiteColor]];
    [[UINavigationBar appearance]setTintColor:[UIColor whiteColor]];
    self.tableView.tableFooterView = [[UIView alloc]init];
    
 
}



@end
