//
//  UIImageAdditions.h
//  Cute&Funny
//
//  Created by tangwei1 on 15/6/2.
//  Copyright (c) 2015年 tangwei1. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (ImageBlur)

/**
 * 对图片进行高斯模糊
 * 
 * 如果想要加深模糊，可以多次调用该方法
 */
- (UIImage *)imageWithGaussianBlur;

@end
