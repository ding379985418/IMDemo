//
//  DXConst.h
//  QQ
//
//  Created by simon on 16/1/24.
//  Copyright © 2016年 simon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DXTools.h"
#import "UIBarButtonItem+DXBarButtonItem.h"
#import "DXIMManager.h"
#import "NSDictionary+DXCaegory.h"
#import "UIView+Toast.h"
/** NSLog 输出宏*/
#ifdef DEBUG
#define SSLog(FORMAT, ...) fprintf(stderr,"%s:%d\t%s\n",[[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String], __LINE__, [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);
#else
#define NSLog(...)
#endif
#define KScreenBounds [UIScreen mainScreen].bounds
#define KScreenWith [UIScreen mainScreen].bounds.size.width
#define KScreenHeight [UIScreen mainScreen].bounds.size.height
#define KScreenSize [UIScreen mainScreen].bounds.size
#define KDefaultColor [DXTools colorWithR:19 G:154 B:234]
#define KDefaultFont [UIFont systemFontOfSize:15]
extern NSString *const DXHostName;
extern NSString *const DXLogPasswordKey;
extern NSString *const DXLogUserNameKey;
extern NSString *const DXNotificationLogInVcSwitchRootVc;
