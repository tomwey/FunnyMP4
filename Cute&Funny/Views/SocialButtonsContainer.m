//
//  SocialButtonsContainer.m
//  Cute&Funny
//
//  Created by tangwei1 on 15-4-22.
//  Copyright (c) 2015年 tangwei1. All rights reserved.
//

#import "SocialButtonsContainer.h"
#import "Defines.h"

@implementation SocialButtonsContainer

@synthesize maskView = _maskView;

- (instancetype)initWithFrame:(CGRect)frame
{
    if ( self = [super initWithFrame:frame] ) {
        self.frame = CGRectMake(0, 0, AWFullScreenWidth(), 56);
        
        self.backgroundColor = [UIColor clearColor];
        
        _maskView = [[UIView alloc] initWithFrame:self.bounds];
        [self addSubview:_maskView];
        [_maskView release];
        
        _maskView.backgroundColor = [UIColor clearColor];
//        _maskView.alpha = .6;
        
        for (int i=0; i<2; i++) {
            SocialButton* btn = [[[SocialButton alloc] init] autorelease];
            [self addSubview:btn];
            
            btn.tag = 100 + i;
            
            CGFloat padding = ( AWFullScreenWidth() - CGRectGetWidth(btn.frame) * 2 ) / 3;
            
            CGRect frame = btn.frame;
            frame.origin.x = padding + ( padding + CGRectGetWidth(btn.frame) ) * i;
            frame.origin.y = 6;
            btn.frame = frame;

//            if ( i == 0 ) {
//                btn.normalColor = RGB(252, 156, 24);
//                btn.digit = [self.media.cuteCount integerValue];
//                btn.name = @"CUTE";
//                btn.type = 0;
//                btn.selected = [self.media.bcute boolValue];
//            } else {
//                btn.normalColor = RGB(225, 15, 52);
//                btn.digit = [self.media.funnyCount integerValue];
//                btn.name = @"FUNNY";
//                btn.type = 1;
//                btn.selected = [self.media.bfunny boolValue];
//            }
//            
//            btn.selectedColor = RGB(245, 245, 245);
//            
//            btn.selected = NO;
//            btn.media = self.media;
        }
    }
    
    return self;
}

- (void)setMedia:(Media *)media
{
    if ( _media != media ) {
        [_media release];
        _media = [media retain];
        
        SocialButton* cuteBtn = (SocialButton *)[self viewWithTag:100];
        SocialButton* funnyBtn = (SocialButton *)[self viewWithTag:101];
        
//        cuteBtn.media = media;
//        funnyBtn.media = media;
        
//        cuteBtn.digit = [media.cuteCount integerValue];
//        funnyBtn.digit = [media.funnyCount integerValue];
        
        self.funny = [_media.bfunny boolValue];
        self.cute = [_media.bcute boolValue];
    }

}

- (void)setFunny:(BOOL)funny
{
    _funny = funny;
    
//    SocialButton* sb = (SocialButton *)[self viewWithTag:101];
//    sb.selected = _funny;
}

- (void)setCute:(BOOL)cute
{
    _cute = cute;
    
//    SocialButton* sb = (SocialButton *)[self viewWithTag:100];
//    sb.selected = _cute;
}

- (void)dealloc
{
    self.media = nil;
    [super dealloc];
}

@end
