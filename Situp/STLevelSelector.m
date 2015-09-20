//
//  STLevelSelector.m
//  Situp
//
//  Created by lepdou on 15/9/18.
//  Copyright (c) 2015年 lepdou. All rights reserved.
//

#import "STLevelSelector.h"


@implementation STLevelSelector

-(void)viewDidLoad{
    [super viewDidLoad];
    NSString *levelFilePath = [[NSBundle mainBundle] pathForResource:@"level" ofType:@"plist"];
    NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfFile:levelFilePath];
    NSLog(@"%@", data);
    
}

@end
