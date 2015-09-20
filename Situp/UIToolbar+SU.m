//
//  UIToolbar+SU.m
//  Situp
//
//  Created by lepdou on 15/9/18.
//  Copyright (c) 2015年 lepdou. All rights reserved.
//

#import "UIToolbar+SU.h"
#import "STCommon.h"

@implementation UIToolbar(Situp)

-(UIToolbar *)toolbarWithSitup:(int)withSelectedIndex{
    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, [UIScreen width], 50)];
    toolbar.frame = CGRectMake(0, [UIScreen height] - [self toolbarHeight], [UIScreen width], [self toolbarHeight]);
    [toolbar setBarTintColor:[UIColor colorWithHexString:@"333"]];
    [toolbar setBarStyle:UIBarStyleBlackTranslucent];
//    [toolbar setBackgroundImage:[UIImage imageNamed:@"bg_sets_light.jpg"] forToolbarPosition:UIBarPositionBottom barMetrics:UIBarMetricsDefault];
    
    UIBarButtonItem *space1 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIBarButtonItem *space2 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIBarButtonItem *space3 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    
    UIView *trainTab = [UIView new];
    trainTab.frame = CGRectMake(0, 0, [UIScreen width]/2, 50);
    UIImageView *img1= [UIImageView new];
    img1.image = [UIImage imageNamed:@"situpsicon.png"];
    img1.frame = CGRectMake([self marginLeftInBtnItem], 5, [self itemImgSize], [self itemImgSize]);
    UILabel *train =[UILabel new];
    train.font = [self toolbarTextFont];
    train.text = @"训练";
    train.frame = CGRectMake(0, 7 + [self itemImgSize], [UIScreen width]/2, [self toolbarTextFont].lineHeight);
    train.textAlignment = NSTextAlignmentCenter;
    train.textColor = [UIColor whiteColor];
    [trainTab addSubview: img1];
    [trainTab addSubview:train];
    UIBarButtonItem *begin = [[UIBarButtonItem alloc] initWithCustomView:trainTab];
    
    UIView *historyTab = [UIView new];
    historyTab.frame = CGRectMake([UIScreen width]/2, 0, [UIScreen width]/2, 50);
    UIImageView *historyImg= [UIImageView new];
    historyImg.image = [UIImage imageNamed:@"star_level1.png"];
    historyImg.frame = CGRectMake([self marginLeftInBtnItem], 5, [self itemImgSize], [self itemImgSize]);
    UILabel *hitoryLbl =[UILabel new];
    hitoryLbl.font = [self toolbarTextFont];
    hitoryLbl.text = @"历史";
    hitoryLbl.frame = CGRectMake(0, 7 + [self itemImgSize], [UIScreen width]/2, [self toolbarTextFont].lineHeight);
    hitoryLbl.textAlignment = NSTextAlignmentCenter;
    hitoryLbl.textColor = [UIColor whiteColor];
    [historyTab addSubview: historyImg];
    [historyTab addSubview:hitoryLbl];
    UIBarButtonItem *history = [[UIBarButtonItem alloc] initWithCustomView:historyTab];
    
    NSArray *btnGroup = [[NSArray alloc] initWithObjects:space1, begin, space2, history, space3,nil];
    toolbar.items = btnGroup;
    
//    if (withSelectedIndex == 1) {
//        trainTab.backgroundColor = [self selectedItemColor];
//        historyTab.backgroundColor = [self notSelectedItemColor];
//    }else{
//        trainTab.backgroundColor = [self notSelectedItemColor];
//        historyTab.backgroundColor = [self selectedItemColor];
//    }
//    
    return toolbar;
}

-(UIColor *)selectedItemColor{
    return [UIColor colorWithHexString:@"333"];
}

-(UIColor *)notSelectedItemColor{
    return [UIColor colorWithHexString:@"999"];
}

-(CGFloat)marginLeftInBtnItem{
    return ([UIScreen width]/2 - [self itemImgSize]) /2;
}

-(CGFloat)itemImgSize{
    return 25;
}

-(UIFont *)toolbarTextFont{
    return [UIFont systemFontOfSize:12];
}

-(CGFloat)toolbarHeight{
    return 50;
}
@end
