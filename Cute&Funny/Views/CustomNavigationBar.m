//
//  CustomNavigationBar.m
//  Cute&Funny
//
//  Created by tangwei1 on 15-4-20.
//  Copyright (c) 2015年 tangwei1. All rights reserved.
//

#import "CustomNavigationBar.h"
#import "Defines.h"

@implementation CustomNavigationBar

- (instancetype)initWithFrame:(CGRect)frame
{
    if ( self = [super initWithFrame:frame] ) {
        self.backgroundColor = RGB(225, 15, 52);
        
        if ( AWOSVersionIsLower(7.0) ) {
            self.frame = CGRectMake(0, 0, AWFullScreenWidth(), 44);
        } else {
            self.frame = CGRectMake(0, 0, AWFullScreenWidth(), 64);
        }
    }
    
    return self;
}

@end
