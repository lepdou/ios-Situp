//
//  STNavigationController.m
//  Situp
//
//  Created by lepdou on 15/9/20.
//  Copyright (c) 2015年 lepdou. All rights reserved.
//
#define iOS7 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
#import "STNavigationController.h"
#import "STCommon.h"

@implementation STNavigationController
#pragma mark 一个类只会调用一次
+ (void)initialize
{
    // 1.取出设置主题的对象
    UINavigationBar *navBar = [UINavigationBar appearance];
    
    // 2.设置导航栏的背景图片
    NSString *navBarBg = nil;
    if (iOS7) { // iOS7
        navBarBg = @"NavBar64";
    } else { // 非iOS7
        navBarBg = @"NavBar";
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    }
    
    [navBar setBarTintColor:[UIColor colorWithHexString:@"2a5caa"]];
    [navBar setBackgroundImage:[UIImage imageNamed:navBarBg] forBarMetrics:UIBarMetricsDefault];
    
    // 3.标题
    #pragma clang diagnostic ignored"-Wdeprecated-declarations"
    [navBar setTitleTextAttributes:@{
                                     UITextAttributeTextColor : [UIColor whiteColor]
                                     }];
}

#pragma mark 控制状态栏的样式
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
@end
