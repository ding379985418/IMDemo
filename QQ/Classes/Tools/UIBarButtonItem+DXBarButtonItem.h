//
//  UIBarButtonItem+DXBarButtonItem.h
//  QQ
//
//  Created by simon on 16/1/27.
//  Copyright © 2016年 simon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (DXBarButtonItem)

+ (UIBarButtonItem *)barButtonItemName:(NSString *)name imgName:(NSString *)imgName addTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents;
@end
