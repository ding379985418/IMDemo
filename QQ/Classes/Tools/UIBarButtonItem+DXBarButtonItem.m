//
//  UIBarButtonItem+DXBarButtonItem.m
//  QQ
//
//  Created by simon on 16/1/27.
//  Copyright © 2016年 simon. All rights reserved.
//

#import "UIBarButtonItem+DXBarButtonItem.h"

@implementation UIBarButtonItem (DXBarButtonItem)

+ (UIBarButtonItem *)barButtonItemName:(NSString *)name imgName:(NSString *)imgName addTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents{
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn sizeToFit];

    btn.titleLabel.font = [UIFont systemFontOfSize:13];
    [btn setTitle:name forState:UIControlStateNormal];
    [btn addTarget:target action:action forControlEvents:controlEvents];
    if (imgName != nil) {
        [btn setImage:[UIImage imageNamed:imgName] forState:UIControlStateNormal];
    }
    
    
    return [[UIBarButtonItem alloc]initWithCustomView:btn];

}
@end
