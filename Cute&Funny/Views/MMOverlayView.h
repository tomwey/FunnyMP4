//
//  MMOverlayView.h
//  Cute&Funny
//
//  Created by tangwei1 on 15/5/20.
//  Copyright (c) 2015年 tangwei1. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, MMOverlayViewMode) {
    MMOverlayViewModeLeft,
    MMOverlayViewModeRight
};

@interface MMOverlayView : UIView

@property (nonatomic) MMOverlayViewMode mode;

@end
