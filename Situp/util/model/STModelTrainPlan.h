//
//  STModelTrainPlan.h
//  Situp
//
//  Created by lepdou on 15/9/20.
//  Copyright (c) 2015年 lepdou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface STModelTrainPlan : NSObject

@property(nonatomic, strong) NSString *mainLevel;
@property(nonatomic, strong) NSString *subLevel;
@property(nonatomic, strong) NSMutableArray *levels;

@end
