//
//  UIScreen+Adapter.h
//  Situp
//
//  Created by lepdou on 15/9/17.
//  Copyright (c) 2015年 lepdou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UIScreen (Adapter)

/**
 *  same as [UIScreen mainScreen].bounds.size.width
 *
 */
+ (CGFloat)width;

/**
 * same as [UIScreen mainScreen].bounds.size.height
 *
 */
+ (CGFloat)height;
/**
 * the screen enlarge scale relative to original width 320
 *
 */
+ (CGFloat)scale;

@end
