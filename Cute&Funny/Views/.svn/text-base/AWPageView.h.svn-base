//
//  AWPageView.h
//  Cute&Funny
//
//  Created by tangwei1 on 15-4-28.
//  Copyright (c) 2015年 tangwei1. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AWPageView;
@class AWPageViewCell;

@protocol AWPageViewDataSource <NSObject>

@required
- (NSUInteger)numberOfPagesInPageView:(AWPageView *)pageView;

- (AWPageViewCell *)pageView:(AWPageView *)pageView cellAtIndex:(NSInteger)index;

@end

@protocol AWPageViewDelegate <NSObject>

@optional
- (void)pageView:(AWPageView *)pageView didSelectItemAtIndex:(NSInteger)index;
- (void)pageView:(AWPageView *)pageView willDisplayCell:(AWPageViewCell *)cell atIndex:(NSInteger)index;
- (void)pageView:(AWPageView *)pageView didEndDisplayingCell:(AWPageViewCell *)cell atIndex:(NSInteger)index;

@end

@interface AWPageView : UIView

@property (nonatomic, assign) id <AWPageViewDataSource> dataSource;
@property (nonatomic, assign) id <AWPageViewDelegate> delegate;

- (void)reloadData;

- (NSArray *)visibleViews;

- (AWPageViewCell *)dequeueReusableView;

- (void)showCellAtIndex:(NSInteger)index;

@end
