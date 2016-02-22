//
//  DXRegisterViewController.m
//  QQ
//
//  Created by simon on 16/1/26.
//  Copyright © 2016年 simon. All rights reserved.
//

#import "DXRegisterViewController.h"

@interface DXRegisterViewController ()
@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *registerBtn;
@property (weak, nonatomic) IBOutlet UIButton *protocolBtn;

@end

@implementation DXRegisterViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpUI];
    
  }
///初始化UI
- (void)setUpUI{
    self.navigationController.navigationBar.barTintColor = KDefaultColor;
    NSDictionary *attribute = @{NSFontAttributeName:[UIFont systemFontOfSize:15],NSForegroundColorAttributeName:[UIColor whiteColor]};
    self.navigationController.navigationBar.titleTextAttributes = attribute;
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem barButtonItemName:@"返回" imgName:nil addTarget:self action:@selector(backItemClick) forControlEvents:UIControlEventTouchUpInside];
}

- (void)backItemClick{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark -点击注册
- (IBAction)registerBtnClick:(UIButton *)sender {
    [DXIMManager sharedManager].isRegister = YES;
    [[DXIMManager sharedManager]connectWithHostName:DXHostName userName:self.userNameTextField.text password:self.passwordTextField.text isSucess:^(BOOL sucess) {
            dispatch_async(dispatch_get_main_queue(), ^{
        if (sucess) {
        
                [self.view makeToast:@"注册成功,请登陆！" duration:0.8 position:@"center"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
            
            
        }else{
            [self.view makeToast:@"注册失败,用户名已经占用！"];
        }
                      });
    }];
    
}
#pragma mark -textField值改变
- (IBAction)textFieldChanged:(UITextField *)sender {
    self.registerBtn.enabled = self.userNameTextField.hasText && self.passwordTextField.hasText && self.protocolBtn.selected;
}
- (IBAction)protocolBtnClick:(UIButton *)sender {
    sender.selected = !sender.selected;
     self.registerBtn.enabled = self.userNameTextField.hasText && self.passwordTextField.hasText && self.protocolBtn.selected;
}
@end
