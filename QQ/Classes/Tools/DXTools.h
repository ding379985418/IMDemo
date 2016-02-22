//
//  DXTools.h
//  QQ
//
//  Created by simon on 16/1/27.
//  Copyright © 2016年 simon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface DXTools : NSObject
///返回RGB颜色
+ (UIColor *)colorWithR:(CGFloat)R G:(CGFloat)G B:(CGFloat)B;
///保存用户名到偏好设置
+ (void)saveUserName:(NSString *)string;
///从偏好设置中得到用户名
+ (NSString *)userNameForUserDefaults;
///从偏好设置中删除用户名
+ (void)deleteUserNamFromUserDefaults;
///一个选项弹框提示
+ (void)alerViewWithMessage:(NSString *)message title:(NSString *)title actionStr:(NSString *)actionStr handler:(void (^)(UIAlertAction *action))handlerBlock;
///两个选项的弹框提示
+ (void)alerViewWithMessage:(NSString *)message
                      title:(NSString *)title
                  actionStr:(NSString *)actionStr
                    handler:(void (^)(UIAlertAction *action))handlerBlock
            actionSecondStr:(NSString *)actionSecondStr
              handlerSecond:(void (^)(UIAlertAction *action))handlerSecondBlock;
///隐藏底部的ItemBar
+ (void)hidesBottomBar:(BOOL)hide;
///通过JIDBar截取用户名
+ (NSString *)userNameWithJIDBar:(NSString *)bar;
///用户头像barButtonItem
+ (UIBarButtonItem *)myIconBarButtonItem;
@end
