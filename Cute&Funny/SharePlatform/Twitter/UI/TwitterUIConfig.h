//
//  TwitterUIConfig.h
//
//  Created by yanglei on 12-8-27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//


typedef enum{
    /*无动画效果*/
    TWAnimationNone = 0,
    
    /*从下到上动画*/
    TWAnimationBottomTop,
    
    /*从上到下动画*/
    TWAnimationTopBottom,
    
    /*从左到右动画*/
    TWAnimationLeftRight,
    
    /*从右到左动画*/
    TWAnimationRightLeft,
    
    /*弹出式动画*/
    TWAnimationAlert
    
}TWAnimationType;

typedef enum {
    /*Iphone横屏*/
    TWDisplayIphoneLandscape = 0,
    
    /*Iphone竖屏*/
    TWDisplayIphoneportrait,
    
    /*Iphone5横屏*/
    TWDisplayIphone5Landscape,
    
    /*Iphone5竖屏*/
    TWDisplayIphone5portrait,
    
    /*Ipad横屏*/
    TWDisplayIpadLandscape,
    
    /*Ipad竖屏*/
    TWDisplayIpadportrait
    
}TWDisplayType;