//
//  UIWindowAdditions.m
//  Cute&Funny
//
//  Created by tangwei1 on 15-4-17.
//  Copyright (c) 2015年 tangwei1. All rights reserved.
//

#import "UIWindowAdditions.h"

@implementation UIWindow (AWCategory)

/**
 * 在视图层次中递归查找第一响应者，从window开始查找
 */
- (UIView *)findFirstResponder
{
    return [self findFirstResponderInView:self];
}

/**
 * 在视图层次中递归查找第一响应者，从顶层视图开始查找
 */
- (UIView *)findFirstResponderInView:(UIView *)topView
{
    if ( [topView isFirstResponder] ) {
        return topView;
    }
    
    for (UIView* subView in topView.subviews) {
        if ( [subView isFirstResponder] ) {
            return subView;
        }
        
        UIView* firstResponderCheck = [self findFirstResponderInView:subView];
        if ( nil != firstResponderCheck ) {
            return firstResponderCheck;
        }
    }
    
    return nil;
}

@end
