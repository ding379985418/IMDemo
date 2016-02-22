//
//  DXLogInViewController.m
//  QQ
//
//  Created by simon on 16/1/26.
//  Copyright © 2016年 simon. All rights reserved.
//

#import "DXLogInViewController.h"
#import "SSKeychain.h"

@interface DXLogInViewController ()
@property (weak, nonatomic) IBOutlet UIButton *logInBtn;
@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
- (IBAction)loginBtnClick:(UIButton *)sender;
- (IBAction)registerClick:(UIButton *)sender;

@end

@implementation DXLogInViewController


- (void)viewDidLoad {
    [super viewDidLoad];
   
}
- (void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBar.hidden = YES;
}
- (void)viewWillDisappear:(BOOL)animated{

    self.navigationController.navigationBar.hidden = NO;

}
#pragma mark -登陆
- (IBAction)loginBtnClick:(UIButton *)sender {
    [[DXIMManager sharedManager]connectWithHostName:DXHostName userName:self.userNameTextField.text password:self.passwordTextField.text isSucess:^(BOOL sucess) {
        if (sucess) {
            
//            保存用户名到偏好设置
            [DXTools saveUserName:self.userNameTextField.text];
//            保存密码到钥匙串中
          BOOL isSave = [SSKeychain setPassword:self.passwordTextField.text forService:[NSBundle mainBundle].bundleIdentifier account:self.userNameTextField.text];
            if (isSave) {
                SSLog(@"保存成功");
            }
        
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                UIAlertController *alerVC = [UIAlertController alertControllerWithTitle:@"提示"
                                     message:@"请输入正确的账号和密码"
                            preferredStyle:UIAlertControllerStyleAlert];
                
                [alerVC addAction:[UIAlertAction
                  actionWithTitle:@"确定"
                            style:UIAlertActionStyleDefault
                          handler:nil]];
                
                [self presentViewController:alerVC animated:YES completion:nil];
                
            });
        }
    }];
   
    
}

#pragma mark -注册
- (IBAction)registerClick:(UIButton *)sender {
}

- (IBAction)textFieldVauleChanged:(UITextField *)sender {

    self.logInBtn.enabled = [self.userNameTextField hasText] && [self.passwordTextField hasText];
}
@end
