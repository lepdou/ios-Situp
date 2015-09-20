//
//  UIScreen+Adapter.m
//  Situp
//
//  Created by lepdou on 15/9/17.
//  Copyright (c) 2015年 lepdou. All rights reserved.
//

#import "UIScreen+Adapter.h"

@implementation UIScreen(Adapter)
+ (CGFloat)width {
    return [self mainScreen].bounds.size.width;
}

+ (CGFloat)height {
    return [self mainScreen].bounds.size.height;
}

+ (CGFloat)scale {
    return [self width] / 320.0f;
}

@end
