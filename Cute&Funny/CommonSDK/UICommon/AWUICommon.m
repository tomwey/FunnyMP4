//
//  AWUICommon.m
//  Cute&Funny
//
//  Created by tangwei1 on 15-4-17.
//  Copyright (c) 2015年 tangwei1. All rights reserved.
//

#import "AWUICommon.h"

#import "UIWindowAdditions.h"

#import "AWBaseViewController.h"

/**
 * 返回当前设备运行的iOS版本
 */
float AWOSVersion()
{
    return [[[UIDevice currentDevice] systemVersion] floatValue];
}

/**
 * 检查当前设备运行的iOS版本是否小于给定的版本
 */
BOOL AWOSVersionIsLower(float version)
{
    return AWOSVersion() < version;
}

/**
 * 判断设备是否是iPad
 */
BOOL AWIsPad()
{
    return UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad;
}

BOOL AWIsKeyboardVisible()
{
    UIWindow* window = [[[UIApplication sharedApplication] windows] objectAtIndex:0];
    
    return !![window findFirstResponder];
}

/**
 * 返回全屏大小
 */
CGRect AWFullScreenBounds()
{
    return [[UIScreen mainScreen] bounds];
}

/**
 * 全屏宽
 */
CGFloat AWFullScreenWidth()
{
    return CGRectGetWidth(AWFullScreenBounds());
}

/**
 * 全屏高
 */
CGFloat AWFullScreenHeight()
{
    return CGRectGetHeight(AWFullScreenBounds());
}

/**
 * 获取一个矩形的中心点
 */
CGPoint AWCenterOfRect(CGRect aRect)
{
    return CGPointMake(CGRectGetMidX(aRect), CGRectGetMidY(aRect));
}

UIWindow* AWAppWindow()
{
    return [[[UIApplication sharedApplication] windows] objectAtIndex:0];
}

UIFont* AWCustomFont(NSString* fontName, CGFloat fontSize)
{
    return [UIFont fontWithName:fontName size:fontSize];
}
