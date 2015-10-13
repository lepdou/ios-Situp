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
#import "STLevelSelectorController.h"
#import "AVFoundation/AVAudioPlayer.h"

int const REST_TIME = 60;

typedef NS_ENUM(NSInteger,TrainButtonActionType){
    Train = 1,
    GiveUp = 2,
    ReTrain = 3
};

@interface STTrainPlanController ()

@property(nonatomic, strong) UILabel *levelTitleLbl;
@property(nonatomic, strong) UILabel *levelsLbl;
@property(nonatomic, strong) UILabel *counterLbl;
@property(nonatomic, strong) UIButton *trainBtn;
@property(nonatomic, strong) UIButton *selectLevelBtn;
@property(nonatomic, strong) UIProgressView *progressView;

@property(nonatomic, strong) STModelTrainPlan *plan;
@property(nonatomic) NSInteger currentLevelIdx;
@property(nonatomic) long currentLevelCount;//当前仰卧起坐个数
@property(nonatomic) int doCounter;

@property(nonatomic, strong) NSTimer *timer;
@property(nonatomic) int restTime;
@property(nonatomic) bool isPause;
@property(nonatomic) bool isAleadyStarted;

//1-开始训练 2-放弃 3-重做
@property(nonatomic) TrainButtonActionType trainBtnAction;

@end

@implementation STTrainPlanController


- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    self.title = [[NSString alloc] initWithFormat:@"%@(%@)", _plan.mainLevel, _plan.subLevel];
#pragma clang diagnostic ignored"-Wdeprecated-declarations"
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleBordered target:nil action:nil];
    UIView *rootView = self.view;
    rootView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"common_background"]];
    _levelsLbl = [[UILabel alloc]initWithFrame:CGRectMake(0, 150, [UIScreen width], 100)];
    _levelsLbl.backgroundColor = [UIColor whiteColor];
    _levelsLbl.font = [UIFont systemFontOfSize:40];
    _levelsLbl.textAlignment = UITextAlignmentCenter;
    _levelsLbl.textColor = [UIColor blackColor];
    _levelsLbl.text = [self formartLevelInfoWithArray:_plan.levels];
    [self.view addSubview:_levelsLbl];
    
    _counterLbl = [[UILabel alloc]initWithFrame:CGRectMake(0, 250, [UIScreen width], 200)];
    _counterLbl.font = [UIFont systemFontOfSize:200];
    _counterLbl.textAlignment = UITextAlignmentCenter;
    _counterLbl.textColor = [UIColor orangeColor];
    _counterLbl.text = [[NSString alloc] initWithFormat:@"%ld", _currentLevelCount];
    _counterLbl.hidden = YES;
    _counterLbl.shadowColor = [UIColor redColor];
    _counterLbl.shadowOffset = CGSizeMake(1.0, 1.0);
    _counterLbl.layer.cornerRadius = 50;
    [self.view addSubview:_counterLbl];
    
    _progressView = [[UIProgressView alloc]initWithProgressViewStyle:UIProgressViewStyleDefault];
    _progressView.frame = CGRectMake(0, [self navBarHeight] + _levelsLbl.frame.size.height, [UIScreen width], 50);
    _progressView.transform = CGAffineTransformMakeScale(1.0, 6.0);
    _progressView.progressTintColor = [UIColor orangeColor];
    _progressView.trackTintColor = [UIColor grayColor];
    _progressView.progress = 0.0;
    _progressView.hidden = YES;
    [self.view addSubview:_progressView];
    
    CGRect trainBtnFrame = CGRectMake([self btnMarginToLeft],
                                      [UIScreen height] - [self btnHeight] -[self btnMarginToBottom],
                                      [self btnWidth],
                                      [self btnHeight]);
    _trainBtn = [self btnWithText:@"开始" frame:trainBtnFrame selector:@selector(startTrainBtnClickEvent)];
    [self.view addSubview:_trainBtn];
    
    CGRect selectBtnFrame = CGRectMake([self btnMarginToLeft] + [self btnWidth] + [self spaceBetweenBtn],
                                       [UIScreen height] - [self btnHeight] -[self btnMarginToBottom],
                                       [self btnWidth], [self btnHeight]);
    _selectLevelBtn = [self btnWithText:@"重选级别" frame:selectBtnFrame selector:@selector(reSelectLevelBtnClickEvent)];
    [self.view addSubview:_selectLevelBtn];
}

-(void)viewWillAppear:(BOOL)animated{
    _doCounter = 0;
}

-(void)viewWillDisappear:(BOOL)animated{
    //记录此处训练记录
    [TrainDataService saveTrainInfoWithCount:_doCounter];
    [UIDevice currentDevice].proximityMonitoringEnabled = NO;
}

-(void)initData{
    [self initTimer];
    _plan = [TrainDataService getTrainPlanModel];
    _currentLevelIdx = 0;
    _trainBtnAction = Train;
    
    _currentLevelCount = [self getNextTrainCountInfo];
    _isPause = false;
    _isAleadyStarted = false;
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


-(void)initTimer{
    self.restTime = REST_TIME;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerFunction) userInfo:nil repeats:YES];
    [self.timer setFireDate:[NSDate distantFuture]];
}

-(void)timerFunction{
    self.counterLbl.text = [[NSString alloc]initWithFormat:@"%d",self.restTime];
    [self refreshwithView:self.counterLbl];
    if (self.restTime == 0) {
        self.restTime = REST_TIME;
        [self.timer setFireDate:[NSDate distantFuture]];
        //开启下一轮训练
    }
    self.restTime --;
}

-(long)getNextTrainCountInfo{
    NSNumber *num = _plan.levels[_currentLevelIdx];
    return num.longValue;
}


-(void)startTrainBtnClickEvent{
    switch (self.trainBtnAction) {
        case Train:
            [self trainAction];
            break;
        case GiveUp:
            [self giveUpAction];
            break;
        case ReTrain:
            [self reTrainAction];
            break;
            
        default:
            break;
    }
}

-(void)reSelectLevelBtnClickEvent{
    STLevelSelectorController *selectPage = [[STLevelSelectorController alloc] init];
    [UIDevice currentDevice].proximityMonitoringEnabled = NO;
    [self.navigationController pushViewController:selectPage animated:YES];
}

-(void)trainAction{
    if (self.currentLevelIdx == 0) {//第一次启动
        self.levelsLbl.frame = CGRectMake(0, [self navBarHeight], [UIScreen width], 100);
        
        self.counterLbl.hidden = NO;
        self.progressView.hidden = NO;
        self.selectLevelBtn.hidden = YES;
        //        [self refreshwithView:self.selectLevelBtn];
        //开始按钮调整
        _trainBtn.frame = CGRectMake([self btnMarginToLeft],
                                     [UIScreen height] - [self btnHeight] -[self btnMarginToBottom],
                                     [UIScreen width] - 2*[self btnMarginToLeft],
                                     [self btnHeight]);
        if (!_isAleadyStarted) {
            //开启距离感应
            [UIDevice currentDevice].proximityMonitoringEnabled = YES;
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(situp) name:UIDeviceProximityStateDidChangeNotification object:nil];
            _isAleadyStarted = YES;
        }
    }else{
        //如果有定时器，则关闭
        self.restTime = REST_TIME;
        [self.timer setFireDate:[NSDate distantFuture]];
        [self onProximityMonitor];
    }
    
    //获取下一组训练
    _currentLevelCount = [self getNextTrainCountInfo];
    _counterLbl.text = [[NSString alloc] initWithFormat:@"%ld", _currentLevelCount];
    [self refreshwithView:_counterLbl];
    
    //调整按钮
    [_trainBtn setTitle:@"放弃" forState:UIControlStateNormal];
    _trainBtnAction = GiveUp;
}

-(void)giveUpAction{
    [UIDevice currentDevice].proximityMonitoringEnabled = NO;
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)reTrainAction{
    _currentLevelIdx = 0;
    [self onProximityMonitor];
    [self trainAction];
    
}

//开启距离感应
-(void)onProximityMonitor{
    [UIDevice currentDevice].proximityMonitoringEnabled = YES;
    _isPause = false;
}

//关闭距离感应
-(void)offProximityMonitor{
    _isPause = true;
}

-(void)refreshwithView:(id)view{
    [view setNeedsDisplay];
    [view setNeedsLayout];
}

-(void)situp{
    if ([UIDevice currentDevice].proximityState == NO || _isPause) {
        return;
    }
    self.doCounter++;
    self.currentLevelCount --;
    self.counterLbl.text = [[NSString alloc]initWithFormat:@"%ld",self.currentLevelCount];
    if (self.currentLevelCount == 0) {
        //设置进度条
        self.currentLevelIdx +=1;
        self.progressView.progress = (self.currentLevelIdx * 1.0/[self.plan.levels count]);
        [self offProximityMonitor];
        if (self.currentLevelIdx == [self.plan.levels count]) {
            [self endTrain];
        }else{
            //休息一下
            [self rest];
        }
    }
}

-(void)rest{
    
    //开启定时器
    [self.timer setFireDate:[NSDate distantPast]];
    //更改按钮样式
    [self.trainBtn setTitle:@"休息一下吧(点击继续)" forState:UIControlStateNormal];
    _trainBtnAction = Train;
}

-(void)endTrain{
    [self.counterLbl setText:@"^_^"];
    self.selectLevelBtn.hidden = NO;
    
    [self.trainBtn setTitle:@"重做" forState:UIControlStateNormal];
    _trainBtn.frame = CGRectMake([self btnMarginToLeft],
                                 [UIScreen height] - [self btnHeight] -[self btnMarginToBottom],
                                 [self btnWidth],
                                 [self btnHeight]);
    _trainBtnAction = ReTrain;
    
    
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

-(CGFloat)navBarHeight{
    return 65;
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
    return [UIColor colorWithHexString:@"2a5caa"];
}

-(UIColor *)btnHeightlightBgColor{
    return [UIColor colorWithHexString:@"3C3C3C"];
}

@end
