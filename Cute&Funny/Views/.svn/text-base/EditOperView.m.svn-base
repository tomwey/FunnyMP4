//
//  EditOperView.m
//  Cute&Funny
//
//  Created by tangwei1 on 15/6/9.
//  Copyright (c) 2015年 tangwei1. All rights reserved.
//

#import "EditOperView.h"
#import "Defines.h"

@implementation EditOperView
{
    id  _target;
    SEL _action;
}

- (id)initWithFrame:(CGRect)frame
{
    if ( self = [super initWithFrame:frame] ) {
        
        self.frame = CGRectMake(0, 0, AWFullScreenWidth(), 50);
        
        // select all button
        UIButton* selectAll = createImageButton(nil, self, @selector(selectAll));
        [self addSubview:selectAll];
        
        selectAll.layer.cornerRadius = 4;
        selectAll.layer.borderWidth = 1;
        selectAll.layer.borderColor = [[UIColor whiteColor] CGColor];
        
        selectAll.clipsToBounds = YES;
        
        [selectAll setTitle:@"Select all" forState:UIControlStateNormal];
        [selectAll setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        // delete button
        UIButton* delete = createImageButton(nil, self, @selector(delete));
        [self addSubview:delete];
        
        delete.layer.cornerRadius = 4;
        delete.clipsToBounds = YES;
        
        delete.backgroundColor = RGB(225, 15, 52);
        
        [delete setTitle:@"Delete" forState:UIControlStateNormal];
        [delete setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        // set frame
        CGFloat leftMargin = 12;
        CGFloat padding = 20;
        
        CGFloat width = ( AWFullScreenWidth() - leftMargin * 2 - padding ) / 2;
        selectAll.frame = CGRectMake(leftMargin, 2, width, CGRectGetHeight(self.bounds) - 4);
        
        delete.frame = CGRectMake(AWFullScreenWidth() - leftMargin - width,
                                  CGRectGetMinY(selectAll.frame),
                                  width,
                                  CGRectGetHeight(selectAll.frame));
    }
    
    return self;
}

- (void)addTarget:(id)target action:(SEL)action
{
    _target = target;
    _action = action;
}

- (void)selectAll
{
    _operType = EditOperTypeSelectAll;
    
    if ( [_target respondsToSelector:_action] ) {
        [_target performSelector:_action withObject:self];
    }
}

- (void)delete
{
    _operType = EditOperTypeDelete;
    
    if ( [_target respondsToSelector:_action] ) {
        [_target performSelector:_action withObject:self];
    }
}

- (void)showInView:(UIView *)superView
{
    [[AdsPopupManager sharedManager] hideBannerAd];
    
    if ( !self.superview ) {
        [superView addSubview:self];
    }
    
    [superView bringSubviewToFront:self];
    
    CGRect frame = self.frame;
    frame.origin.y = AWFullScreenHeight();
    self.frame = frame;
    
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    [UIView animateWithDuration:.3 animations:^{
        CGRect inFrame = self.frame;
        inFrame.origin.y = AWFullScreenHeight() - CGRectGetHeight(self.frame);
        self.frame = inFrame;
    } completion:^(BOOL finished) {
        [[UIApplication sharedApplication] endIgnoringInteractionEvents];
    }];
}

- (void)dismiss
{
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    
    [UIView animateWithDuration:.3 animations:^{
        CGRect frame = self.frame;
        frame.origin.y = AWFullScreenHeight();
        self.frame = frame;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        
        [[AdsPopupManager sharedManager] showBannerAd];
        
        [[UIApplication sharedApplication] endIgnoringInteractionEvents];
    }];
}

@end
