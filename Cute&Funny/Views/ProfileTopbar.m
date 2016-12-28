//
//  ProfileTopbar.m
//  Cute&Funny
//
//  Created by tangwei1 on 15-4-24.
//  Copyright (c) 2015年 tangwei1. All rights reserved.
//

#import "ProfileTopbar.h"
#import "Defines.h"

@implementation ProfileTopbar

- (instancetype)initWithFrame:(CGRect)frame
{
    if ( self = [super initWithFrame:frame] ) {
        if ( AWOSVersionIsLower(7.0) ) {
            self.frame = CGRectMake(0, 0, AWFullScreenWidth(), 50);
        } else {
            self.frame = CGRectMake(0, 20, AWFullScreenWidth(), 70);
        }
        
        UIImageView* topbar = createImageView(nil);
        topbar.frame = self.bounds;
        [self addSubview:topbar];
        
        NSString* fileName = @"profile_topbar.png";
        if ( AWFullScreenWidth() > 320 ) {
            fileName = @"profile_topbar_i6.png";
        }
        
        if ( AWFullScreenWidth() > 375 ) {
            fileName = @"profile_topbar_i6+.png";
        }
        
        topbar.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:fileName ofType:nil]];
        
        // 返回按钮
        UIButton* backBtn = createImageButton(@"profile_pulldown.png", self, @selector(btnClicked:));
        [self addSubview:backBtn];
        backBtn.center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetHeight(self.bounds) - CGRectGetHeight(backBtn.bounds));
    }
    
    return self;
}

- (void)btnClicked:(id)sender
{
    if ( [self.delegate respondsToSelector:@selector(back:)] ) {
        [self.delegate performSelector:@selector(back:) withObject:self];
    }
}

@end
