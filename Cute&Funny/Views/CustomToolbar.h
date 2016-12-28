//
//  CustomToolbar.h
//  Cute&Funny
//
//  Created by tangwei1 on 15-4-22.
//  Copyright (c) 2015年 tangwei1. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Media;
@interface CustomToolbar : UIView

- (id)initWithItems:(NSArray *)items;

@property (nonatomic, retain) Media* media;

@property (nonatomic, assign) BOOL canShare;
@property (nonatomic, assign) BOOL enabled;

@end
