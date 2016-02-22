//
//  DXChatViewController.h
//  QQ
//
//  Created by simon on 16/1/28.
//  Copyright © 2016年 simon. All rights reserved.
//

#import "DXBaseViewController.h"

@interface DXChatViewController : DXBaseViewController

///返回从sb中加载的控制器
+ (instancetype)chatViewControllerWith:(XMPPJID *)xmppJID;
@end
