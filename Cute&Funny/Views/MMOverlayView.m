//
//  MMOverlayView.m
//  Cute&Funny
//
//  Created by tangwei1 on 15/5/20.
//  Copyright (c) 2015年 tangwei1. All rights reserved.
//

#import "MMOverlayView.h"

@interface MMOverlayView ()

@end

@implementation MMOverlayView

- (instancetype)initWithFrame:(CGRect)frame
{
    if ( self = [super initWithFrame:frame] ) {
        self.backgroundColor = [UIColor whiteColor];
    }
    
    return self;
}

- (void)setMode:(MMOverlayViewMode)mode
{
    if ( _mode == mode ) {
        return;
    }
    
    _mode = mode;
    
}

@end
