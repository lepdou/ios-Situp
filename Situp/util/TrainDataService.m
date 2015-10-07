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

+(void)saveTrainInfoWithCount:(int)count{
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *plistPath1 = [paths objectAtIndex:0];
    //得到完整的文件名
    NSString *filename=[plistPath1 stringByAppendingPathComponent:@"trainlog.plist"];
    //输入写入
    NSMutableArray *trainLogs = [[NSMutableArray alloc] initWithContentsOfFile:filename];
//    NSMutableDictionary *info = [[NSMutableDictionary alloc] initWithContentsOfFile:filename];
    if (trainLogs == nil) {
        trainLogs = [[NSMutableArray alloc]init];
    }
    NSTimeInterval time = [[NSDate date]timeIntervalSince1970];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:time];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *currentDate = [formatter stringFromDate:date];
//    NSString *currentDate = @"2015-10-13";
    if ([trainLogs count] == 0) {
        [self addNewLog:trainLogs withDate:currentDate andCount:count];
    }else{
        NSMutableDictionary *lastLog = [trainLogs objectAtIndex:[trainLogs count] -1];
        if ([[lastLog objectForKey:@"date"] isEqualToString:currentDate]) {
            count += [[lastLog objectForKey:@"counter"]intValue];
            [lastLog setObject:[NSNumber numberWithInt:count] forKey:@"counter"];
        }else{
            [self addNewLog:trainLogs withDate:currentDate andCount:count];
        }
       
    }
    [trainLogs writeToFile:filename atomically:YES];
}

+(void)addNewLog:(NSMutableArray *)trainLogs withDate:(NSString *)date andCount:(int)count{
    NSMutableDictionary *lastLog = [[NSMutableDictionary alloc]init];
    [lastLog setObject:[NSNumber numberWithInt:count] forKey:@"counter"];
    [lastLog setObject:date forKey:@"date"];
    [trainLogs addObject:lastLog];
}

+(NSArray *)getTrainInfo{
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *plistPath1 = [paths objectAtIndex:0];
    //得到完整的文件名
    NSString *filename=[plistPath1 stringByAppendingPathComponent:@"trainlog.plist"];
    //输入写入
    return [[NSArray alloc] initWithContentsOfFile:filename];
    
}

@end
