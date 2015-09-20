//
//  HomeViewController.m
//  Situp
//
//  Created by lepdou on 15/9/18.
//  Copyright (c) 2015年 lepdou. All rights reserved.
//

#import "HomeViewController.h"
#import "STCommon.h"

@interface HomeViewController()

@property(nonatomic, strong) UIToolbar *suToolbar;

@end


@implementation HomeViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    UIView *rootView = self.view;
    rootView.backgroundColor = [UIColor whiteColor];
    
    self.suToolbar = [[UIToolbar alloc] toolbarWithSitup:2];
    [rootView addSubview:self.suToolbar];
        
}

@end
