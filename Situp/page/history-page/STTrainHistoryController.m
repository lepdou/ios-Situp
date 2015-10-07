//
//  STTrainHistoryController.m
//  Situp
//
//  Created by lepdou on 15/9/29.
//  Copyright © 2015年 lepdou. All rights reserved.
//

#import "STTrainHistoryController.h"
#import "UIKit/UIKit.h"
#import "STCommon.h"
#import "TrainDataService.h"


@interface STTrainHistoryController()

@property(nonatomic, strong) NSArray *xLabelArray;
@property(nonatomic, strong) NSArray *yLabelArray;
@property(nonatomic, strong) UIScrollView *scrollView;
@property(nonatomic, strong) UUChart *chartView;
@end

@implementation STTrainHistoryController

-(void)viewDidLoad{
    [super viewDidLoad];
    UIView *rootView = self.view;
    rootView.backgroundColor = [UIColor whiteColor];
    self.title = @"历史记录";
    
    [self initData];
    
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, ([UIScreen height] - [self chartHeight])/2 - 65, [UIScreen mainScreen].bounds.size.width, [self chartHeight] + 65)];
    _scrollView.contentSize = CGSizeMake([self chartWith], [self chartHeight]);
    _scrollView.scrollEnabled = YES;
    
    [rootView addSubview:_scrollView];
    
    self.chartView = [[UUChart alloc]initwithUUChartDataFrame:CGRectMake(0, 0, [self chartWith], [self chartHeight])
                                                   withSource:self
                                                    withStyle:UUChartLineStyle];
    
    //    self.xLabelArray = @[@"9-23",@"9-24",@"9-25",@"9-26",@"9-27",@"9-28",@"9-23",@"9-24",@"9-25",@"9-26",@"9-27",@"9-28"];
    //    self.yLabelArray = @[@[@"50",@"80",@"90",@"12",@"43",@"55",@"50",@"80",@"90",@"12",@"43",@"55"]];
    
    [self.chartView showInView:_scrollView];
    
    
}

-(void)initData{
    NSArray *trainLog = [TrainDataService getTrainInfo];
    NSMutableArray *x = [NSMutableArray new];
    NSMutableArray *y = [NSMutableArray new];
    [trainLog enumerateObjectsUsingBlock:^(NSMutableDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [x addObject:[obj objectForKey:@"date"]];
        [y addObject:[obj objectForKey:@"counter"]];
    }];
    _xLabelArray = [x copy];
    _yLabelArray = @[[y copy]];
}

-(CGFloat)chartWith{
    NSUInteger xLabelCount = [_xLabelArray count];
    if (xLabelCount <= 5) {
        return [UIScreen width];
    }else{
        return [UIScreen width] /5.0 * 6;
    }
}

-(void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
    self.chartView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width*2, [self chartHeight]);
    switch (toInterfaceOrientation) {
        case UIInterfaceOrientationPortraitUpsideDown:
        case UIInterfaceOrientationPortrait:
            _scrollView.frame = CGRectMake(0, 100, [UIScreen mainScreen].bounds.size.width, [self chartHeight]);
            
            break;
        case UIInterfaceOrientationLandscapeLeft:
        case UIInterfaceOrientationLandscapeRight:
            _scrollView.frame = CGRectMake(0, 100, [UIScreen mainScreen].bounds.size.width*2, [self chartHeight]);
            
        default:
            break;
    }
}

-(NSInteger)UUChart_yPieceCount:(UUChart *)chart{
    return 6;
}

//横坐标标题数组
- (NSArray *)UUChart_xLableArray:(UUChart *)chart{
    return self.xLabelArray;
}

//数值多重数组
- (NSArray *)UUChart_yValueArray:(UUChart *)chart{
    return self.yLabelArray;
}

//显示数值范围
//- (CGRange)UUChartChooseRangeInLineChart:(UUChart *)chart
//{
//    return CGRangeMake(100, 0);
//    
//}

//判断显示横线条
- (BOOL)UUChart:(UUChart *)chart ShowHorizonLineAtIndex:(NSInteger)index
{
    return YES;
}

-(BOOL)showPointValue:(UUChart *)chart{
    return YES;
}

-(CGFloat)chartHeight{
    return 250;
}
@end
