//
//  AWUICommon.h
//  Cute&Funny
//
//  Created by tangwei1 on 15-4-17.
//  Copyright (c) 2015年 tangwei1. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "UIWindowAdditions.h"

#import "AWBaseViewController.h"

/**
 * 返回当前设备运行的iOS版本
 */
float AWOSVersion();

/**
 * 检查当前设备运行的iOS版本是否小于给定的版本
 */
BOOL AWOSVersionIsLower(float version);

/**
 * 判断设备是否是iPad
 */
BOOL AWIsPad();

/**
 * 判断键盘是否显示
 */
BOOL AWIsKeyboardVisible();

/**
 * 返回全屏大小
 */
CGRect AWFullScreenBounds();

/**
 * 全屏宽
 */
CGFloat AWFullScreenWidth();

/**
 * 全屏高
 */
CGFloat AWFullScreenHeight();

/**
 * 获取一个矩形的中心点
 */
CGPoint AWCenterOfRect(CGRect aRect);

/**
 * 获取当前app的window
 */

UIWindow* AWAppWindow();

/**
 * 获取字体
 */
UIFont* AWCustomFont(NSString* fontName, CGFloat fontSize);
