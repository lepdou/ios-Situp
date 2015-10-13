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
@property(nonatomic, strong) UIImageView *image;
@end

@implementation STTrainHistoryController

-(void)viewDidLoad{
    [super viewDidLoad];
    UIView *rootView = self.view;
    rootView.backgroundColor = [UIColor whiteColor];
    self.title = @"历史记录";
    
    [self initData];
    
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 10, [UIScreen mainScreen].bounds.size.width, [self chartHeight] + 65)];
    _scrollView.contentSize = CGSizeMake([self chartWith], [self chartHeight]);
    _scrollView.scrollEnabled = YES;
//    [_scrollView setContentOffset:CGPointMake(_scrollView.contentSize.width-[UIScreen width], 0) animated:YES];
    [_scrollView scrollRectToVisible:CGRectMake(_scrollView.contentSize.width-[UIScreen width], 0,[UIScreen mainScreen].bounds.size.width, [self chartHeight] + 65) animated:YES];
//    [_scrollView set]
    
    [rootView addSubview:_scrollView];
    
    self.chartView = [[UUChart alloc]initwithUUChartDataFrame:CGRectMake(0, 0, [self chartWith], [self chartHeight])
                                                   withSource:self
                                                    withStyle:UUChartLineStyle];
    
    [self.chartView showInView:_scrollView];

    _image = [[UIImageView alloc]initWithFrame:CGRectMake(0, _scrollView.frame.origin.y + _scrollView.frame.size.height + 10,
                                                          [UIScreen width], 300)];
    [_image setImage:[UIImage imageNamed:@"sport2.jpg"]];
    [self.view addSubview:_image];
    
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
        return [UIScreen width] /5.0 * xLabelCount;
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
