//
//  UIWindowAdditions.h
//  Cute&Funny
//
//  Created by tangwei1 on 15-4-17.
//  Copyright (c) 2015年 tangwei1. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UIWindow (AWCategory)

/**
 * 在视图层次中递归查找第一响应者，从window开始查找
 */
- (UIView *)findFirstResponder;

/**
 * 在视图层次中递归查找第一响应者，从顶层视图开始查找
 */
- (UIView *)findFirstResponderInView:(UIView *)topView;

@end
