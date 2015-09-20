//
//  UIColor+Util.h
//  Situp
//
//  Created by lepdou on 15/9/17.
//  Copyright (c) 2015年 lepdou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Util)

+ (UIColor *)colorWithHexString:(NSString *)hexString;

+ (UIColor *)colorWithIntRed:(NSInteger)r green:(NSInteger)g blue:(NSInteger)b;
+ (UIColor *)colorWithIntRed:(NSInteger)r green:(NSInteger)g blue:(NSInteger)b alpha:(NSInteger)a;

@end
