//
//  NSDictionary+DXCaegory.m
//  QQ
//
//  Created by simon on 16/1/27.
//  Copyright © 2016年 simon. All rights reserved.
//

#import "NSDictionary+DXCaegory.h"

@implementation NSDictionary (DXCaegory)
+ (instancetype)attributeDicWithFontSize:(CGFloat)size color:(UIColor *)color{
return  @{NSFontAttributeName:[UIFont systemFontOfSize:size],NSForegroundColorAttributeName:color};
}
@end
