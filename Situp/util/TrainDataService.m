//
//  TrainDataService.m
//  Situp
//
//  Created by lepdou on 15/9/20.
//  Copyright (c) 2015年 lepdou. All rights reserved.
//

#import "TrainDataService.h"

@implementation TrainDataService

+(STModelTrainPlan *)getTrainPlanModel{
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *plistPath = [paths objectAtIndex:0];
    //得到完整的文件名
    NSString *filename=[plistPath stringByAppendingPathComponent:@"selected.plist"];
    NSMutableDictionary *trainData = [[NSMutableDictionary alloc] initWithContentsOfFile:filename];
    STModelTrainPlan *plan = [STModelTrainPlan new];
    plan.mainLevel = [trainData objectForKey:@"mainLevel"];
    plan.subLevel  = [trainData objectForKey:@"subLevel"];
    plan.levels = [trainData objectForKey:@"levels"];
    return plan;
}
@end
