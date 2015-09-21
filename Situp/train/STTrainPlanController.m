//
//  STTrainPlanController.m
//  Situp
//
//  Created by lepdou on 15/9/20.
//  Copyright (c) 2015年 lepdou. All rights reserved.
//

#import "STTrainPlanController.h"
#import "STCommon.h"
#import "TrainDataService.h"
#import "STModelTrainPlan.h"

@interface STTrainPlanController ()

@property(nonatomic, strong) UILabel *levelTitleLbl;
@property(nonatomic, strong) UILabel *levelsLbl;
@property(nonatomic, strong) UILabel *sum;
@property(nonatomic, strong) UIButton *trainBtn;
@property(nonatomic, strong) UIButton *selectLevelBtn;
@property(nonatomic, strong) STModelTrainPlan *plan;

@end

@implementation STTrainPlanController

- (void)viewDidLoad {
    [super viewDidLoad];
    _plan = [TrainDataService getTrainPlanModel];
    self.title = [[NSString alloc] initWithFormat:@"%@(%@)", _plan.mainLevel, _plan.subLevel];
    #pragma clang diagnostic ignored"-Wdeprecated-declarations"
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleBordered target:nil action:nil];
    UIView *rootView = self.view;
    rootView.backgroundColor = [UIColor colorWithHexString:@"F0F0F0"];
    
//    _levelTitleLbl = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, [UIScreen width], 100)];
//    _levelTitleLbl.backgroundColor = [UIColor whiteColor];
//    _levelTitleLbl.font = [UIFont systemFontOfSize:30];
//    _levelTitleLbl.textAlignment = UITextAlignmentCenter;
//    _levelTitleLbl.textColor = [UIColor blackColor];
//    [self.view addSubview:_levelTitleLbl];
    
    _levelsLbl = [[UILabel alloc]initWithFrame:CGRectMake(0, 150, [UIScreen width], 100)];
    _levelsLbl.backgroundColor = [UIColor whiteColor];
    _levelsLbl.font = [UIFont systemFontOfSize:50];
    _levelsLbl.textAlignment = UITextAlignmentCenter;
    _levelsLbl.textColor = [UIColor blackColor];
    _levelsLbl.text = [self formartLevelInfoWithArray:_plan.levels];
    [self.view addSubview:_levelsLbl];
    
    CGRect trainBtnFrame = CGRectMake([self btnMarginToLeft],
                            [UIScreen height] - [self btnHeight] -[self btnMarginToBottom],
                            [self btnWidth],
                            [self btnHeight]);
    _trainBtn = [self btnWithText:@"开始" frame:trainBtnFrame selector:nil];
    [self.view addSubview:_trainBtn];
    
    CGRect selectBtnFrame = CGRectMake([self btnMarginToLeft] + [self btnWidth] + [self spaceBetweenBtn],
                                       [UIScreen height] - [self btnHeight] -[self btnMarginToBottom],
                                       [self btnWidth], [self btnHeight]);
    _selectLevelBtn = [self btnWithText:@"重选级别" frame:selectBtnFrame selector:nil];
    [self.view addSubview:_selectLevelBtn];
}

-(UIButton *)btnWithText:(NSString *)text frame:(CGRect) frame selector:(SEL)sel{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        btn.frame = frame;
    [btn setTitle:text forState:UIControlStateNormal];
    [btn.layer setMasksToBounds:YES];
    [btn.layer setCornerRadius:[self cornerRadius]];
    btn.titleLabel.font = [self textSize];
    [btn setTitleColor:[self textColor] forState:UIControlStateNormal];
    btn.backgroundColor = [self btnBgColor];
    [btn setBackgroundImage:[UIImage imageWithColor:[self btnBgColor]] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageWithColor:[self btnHeightlightBgColor]] forState:UIControlStateHighlighted];
    [btn addTarget:self action:sel forControlEvents:UIControlEventTouchUpInside];
    return btn;
}

-(NSMutableString *)formartLevelInfoWithArray:(NSMutableArray *)array{
    NSMutableString *timesStr = [NSMutableString new];
    [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if (idx == 0) {
            [timesStr appendFormat:@"%@",obj];
        }else{
            [timesStr appendFormat:@"-%@",obj];
        }
    }];
    return timesStr;
}

-(CGFloat)btnHeight{
    return 75;
}

-(CGFloat)btnWidth{
    return ([UIScreen width] - ([self spaceBetweenBtn] + 2*[self btnMarginToLeft]))/2;
}

-(CGFloat)btnMarginToBottom{
    return 50;
}

-(CGFloat)btnMarginToLeft{
    return 25;
}

-(CGFloat)spaceBetweenBtn{
    return 25;
}

-(UIColor *)textColor{
    return [UIColor whiteColor];
}

-(UIFont *)textSize{
    return [UIFont systemFontOfSize:30];
}

-(CGFloat)cornerRadius{
    return 10.0;
}

-(UIColor *)btnBgColor{
    return [UIColor colorWithHexString:@"8E8E8E"];
}

-(UIColor *)btnHeightlightBgColor{
    return [UIColor colorWithHexString:@"3C3C3C"];
}

@end
