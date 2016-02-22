//
//  DXAddContactVc.m
//  QQ
//
//  Created by simon on 16/1/28.
//  Copyright © 2016年 simon. All rights reserved.
//

#import "DXAddContactVc.h"

@interface DXAddContactVc ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *addContactTextField;

@end

@implementation DXAddContactVc

- (void)viewDidLoad {
    [super viewDidLoad];
    
}
- (IBAction)backBtnClick:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

//textField的代理方法
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField.text.length >0) {
        NSString *JIDString = [NSString stringWithFormat:@"%@@%@",textField.text,DXHostName];
        XMPPJID *friedJID = [XMPPJID jidWithString:JIDString];
        
      BOOL isExists = [[DXIMManager sharedManager].xmppRosterCoreDataStorage userExistsWithJID:friedJID xmppStream:[DXIMManager sharedManager].stream];
        if (isExists) {
            [DXTools alerViewWithMessage:@"该好友已经存在，不需要重复添加！" title:@"提示" actionStr:@"确定" handler:nil];
        }else{
//        添加好友
        [[DXIMManager sharedManager].xmppRoster subscribePresenceToUser:friedJID];
//         [self.navigationController popViewControllerAnimated:YES];
      }
    }
    return YES;
}

@end
