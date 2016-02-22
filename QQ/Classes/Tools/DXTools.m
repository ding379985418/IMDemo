//
//  DXTools.m
//  QQ
//
//  Created by simon on 16/1/27.
//  Copyright © 2016年 simon. All rights reserved.
//

#import "DXTools.h"
#import "SSKeychain.h"
#import "DXTabBarController.h"

@implementation DXTools
///返回RGB颜色
+ (UIColor *)colorWithR:(CGFloat)R G:(CGFloat)G B:(CGFloat)B{

    return [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:1];
}
///保存用户名到偏好设置
+ (void)saveUserName:(NSString *)string{
    [[NSUserDefaults standardUserDefaults]setObject:string forKey:DXLogUserNameKey];
}
///从偏好设置中得到用户名
+ (NSString *)userNameForUserDefaults{

   return  [[NSUserDefaults standardUserDefaults]objectForKey:DXLogUserNameKey];
    
}
///从偏好设置中删除用户名
+ (void)deleteUserNamFromUserDefaults{
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:DXLogUserNameKey];

}
///一个选项弹框提示
+ (void)alerViewWithMessage:(NSString *)message title:(NSString *)title actionStr:(NSString *)actionStr handler:(void (^)(UIAlertAction *action))handlerBlock {

    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertController *alerVc = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
        [alerVc addAction:[UIAlertAction actionWithTitle:actionStr style:UIAlertActionStyleDefault handler:handlerBlock]];
        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alerVc animated:YES completion:nil];
        
    });
}
///两个选项的弹框提示
+ (void)alerViewWithMessage:(NSString *)message
                      title:(NSString *)title
                  actionStr:(NSString *)actionStr
                    handler:(void (^)(UIAlertAction *action))handlerBlock
            actionSecondStr:(NSString *)actionSecondStr
                    handlerSecond:(void (^)(UIAlertAction *action))handlerSecondBlock {
             
             dispatch_async(dispatch_get_main_queue(), ^{
                 
            UIAlertController *alerVc = [UIAlertController alertControllerWithTitle:title
                               message:message
                        preferredStyle:UIAlertControllerStyleAlert];
                     [alerVc addAction:[UIAlertAction
                       actionWithTitle:actionStr
                                 style:UIAlertActionStyleDefault
                               handler:handlerBlock]];
                 
                 [alerVc addAction:[UIAlertAction actionWithTitle:actionSecondStr style:UIAlertActionStyleDefault handler:handlerSecondBlock]];
                  
                  [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alerVc animated:YES completion:nil];
                  
                  });
    }

///隐藏底部的ItemBar
+ (void)hidesBottomBar:(BOOL)hide{
   DXTabBarController *tabBarVc = (DXTabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    tabBarVc.tabBar.hidden = hide;
}

///通过JIDBar截取用户名
+ (NSString *)userNameWithJIDBar:(NSString *)bar{
    NSRange range = [bar rangeOfString:DXHostName];
    NSString *friendName;
    if (range.location != NSNotFound) {
        friendName = [bar substringToIndex:range.location - 1];
    }else{
        friendName = @"";
    }
 return friendName;
}

+ (UIBarButtonItem *)myIconBarButtonItem{
    UIImage *myImage = [UIImage imageWithData: [[DXIMManager sharedManager].xmppVCardAvatarModule photoDataForJID:[DXIMManager sharedManager].stream.myJID]];
    UIImageView *iconView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    if (myImage == nil) {
//        SSLog(@"没有头像");
        myImage = [UIImage imageNamed:@"login_avatar_default"];
    }
    iconView.layer.masksToBounds = YES;
    iconView.layer.cornerRadius = 15;
    iconView.image = myImage;
    
    return [[UIBarButtonItem alloc]initWithCustomView:iconView];
}
/////保存用户密码到钥匙串中
//+ (void)savePassword:(NSString *)password{
//
//    
//}
/////从钥匙串中取得密码
//+ (NSString *)passwordFromKeyChain{
//
//
//}
@end
