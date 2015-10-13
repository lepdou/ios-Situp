//
//  STLevelSelectorController.m
//  Situp
//
//  Created by lepdou on 15/9/18.
//  Copyright (c) 2015年 lepdou. All rights reserved.
//
#import "SBJson.h"
#import "STLevelSelectorController.h"
#import "STModelLevelInfo.h"
#import "STModelLevelCell.h"
#import "STTrainPlanController.h"


@interface STLevelSelectorController()<UIAlertViewDelegate>

@property(nonatomic, strong) NSMutableArray *levels;
@property(nonatomic, strong) NSIndexPath *selectedItem;

@end

@implementation STLevelSelectorController


-(void)viewDidLoad{
    [super viewDidLoad];
    [self initData];
    self.tableView=[[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];

    self.title = @"选择难度";
    #pragma clang diagnostic ignored"-Wdeprecated-declarations"
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"d" style:UIBarButtonItemStyleBordered target:nil action:nil];
    
}


-(void)initData{
    NSString *levelFilePath = [[NSBundle mainBundle] pathForResource:@"levels" ofType:@"geojson"];
    NSString *parseJason = [[NSString alloc] initWithContentsOfFile:levelFilePath encoding:NSUTF8StringEncoding error:nil];
    SBJsonParser *jsonParser = [[SBJsonParser alloc]init];
    NSMutableArray *levelArray =  [jsonParser objectWithString:parseJason];
    self.levels = [[NSMutableArray alloc]init];
    for (NSMutableDictionary *levelObj in levelArray) {
        STModelLevelInfo *levelModel = [STModelLevelInfo new];
        levelModel.title = [levelObj objectForKey:@"title"];
        levelModel.desc = [levelObj objectForKey:@"desc"];
        NSMutableArray *cellModels = [levelObj objectForKey:@"subLevels"];
        NSMutableArray *cells = [[NSMutableArray alloc]init];
        for (NSMutableDictionary *cellModel in cellModels) {
            STModelLevelCell *cell = [STModelLevelCell new];
            cell.title = [cellModel objectForKey:@"title"];
            cell.times = [cellModel objectForKey:@"times"];
            [cells addObject:cell];
        }
        levelModel.subLevels = cells;
        [self.levels addObject:levelModel];
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    }
    STModelLevelInfo *levelInfo = [self.levels objectAtIndex:indexPath.section];
    STModelLevelCell *cellModel = [levelInfo.subLevels objectAtIndex:indexPath.row];
    cell.textLabel.text = cellModel.title;
    cell.detailTextLabel.text = [self formartLevelInfoWithArray:cellModel.times];
    return cell;
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

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    STModelLevelInfo *levelInfo = [self.levels objectAtIndex:section];
    return [levelInfo.subLevels count];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [self.levels count];
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    STModelLevelInfo *levelInfo = [self.levels objectAtIndex:section];
    return levelInfo.title;
}

-(NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section{
    STModelLevelInfo *levelInfo = [self.levels objectAtIndex:section];
    return levelInfo.desc;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.selectedItem = indexPath;
    STModelLevelInfo *info = [self.levels objectAtIndex:indexPath.section];
    STModelLevelCell *cell = [info.subLevels objectAtIndex:indexPath.row];
    NSMutableString *msg = [[NSMutableString alloc] init];
    [msg appendFormat:@"您选择的级别是:%@ [%@]\n    个数顺序为:%@",info.title,
                                            cell.title,
                                            [self formartLevelInfoWithArray:cell.times]];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"选择级别"
                                                      message:msg
                                                     delegate:self
                                            cancelButtonTitle:@"取消"
                                            otherButtonTitles:@"确定",nil];
    [alertView show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        NSMutableDictionary *selectedLevel = [[NSMutableDictionary alloc]init];
        STModelLevelInfo *info = [self.levels objectAtIndex:self.selectedItem.section];
        STModelLevelCell *cell = [info.subLevels objectAtIndex:self.selectedItem.row];
        [selectedLevel setObject:info.title forKey:@"mainLevel"];
        [selectedLevel setObject:cell.title forKey:@"subLevel"];
        [selectedLevel setObject:cell.times forKey:@"levels"];
        NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
        NSString *plistPath1 = [paths objectAtIndex:0];
        //得到完整的文件名
        NSString *filename=[plistPath1 stringByAppendingPathComponent:@"selected.plist"];
        //输入写入
        [selectedLevel writeToFile:filename atomically:YES];
        NSMutableDictionary *data1 = [[NSMutableDictionary alloc] initWithContentsOfFile:filename];
        NSLog(@"%@", data1);
        //跳转到训练页面
        STTrainPlanController *trainPlanController = [[STTrainPlanController alloc]init];
        [self.navigationController pushViewController:trainPlanController animated:YES];
    }
}
@end
