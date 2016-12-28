//
//  AWPageView.m
//  Cute&Funny
//
//  Created by tangwei1 on 15-4-28.
//  Copyright (c) 2015年 tangwei1. All rights reserved.
//

#import "AWPageView.h"
#import "AWPageViewCell.h"

@interface AWPageView () <UIScrollViewDelegate>

@property (nonatomic, retain) UIScrollView* pagingScrollView;

@property (nonatomic, retain) NSMutableSet* reusableViews;
@property (nonatomic, retain) NSMutableSet* internalVisibleViews;

@end

@implementation AWPageView

- (instancetype)initWithFrame:(CGRect)frame
{
    if ( self = [super initWithFrame:frame] ) {
        [self commonInit];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if ( self = [super initWithCoder:aDecoder] ) {
        [self commonInit];
    }
    return self;
}

- (void)dealloc
{
    self.pagingScrollView = nil;
    self.internalVisibleViews = nil;
    self.reusableViews = nil;
    
    [super dealloc];
}

- (void)commonInit
{
    self.pagingScrollView = [[[UIScrollView alloc] init] autorelease];
    [self addSubview:self.pagingScrollView];
    
    self.pagingScrollView.frame = self.bounds;
    self.pagingScrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    self.pagingScrollView.pagingEnabled = YES;
    self.pagingScrollView.showsHorizontalScrollIndicator =
    self.pagingScrollView.showsVerticalScrollIndicator = NO;
    
    self.pagingScrollView.delegate = self;
    
    self.pagingScrollView.contentInset = UIEdgeInsetsZero;
    self.pagingScrollView.contentOffset = CGPointZero;
    
    self.internalVisibleViews = [NSMutableSet setWithCapacity:3];
    self.reusableViews = [NSMutableSet setWithCapacity:3];
}

- (void)setDataSource:(id<AWPageViewDataSource>)dataSource
{
    _dataSource = dataSource;
    
    [self reloadData];
}

- (void)reloadData
{
    // 移除所有子视图
//    [self.internalVisibleViews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    for (UIView* view in self.internalVisibleViews) {
        [view removeFromSuperview];
    }
    
    [self.internalVisibleViews removeAllObjects];
    [self.reusableViews removeAllObjects];
    
    self.pagingScrollView.contentOffset = CGPointZero;
    
    [self showContents];
}

- (void)showContents
{
    CGRect visibleBounds = self.pagingScrollView.bounds;
    
    NSInteger firstNeededIndex = floorf( CGRectGetMinX(visibleBounds) / CGRectGetWidth(self.pagingScrollView.frame) );
    NSInteger lastNeededIndex = ( floorf( CGRectGetMaxX(visibleBounds) - 1 ) / CGRectGetWidth(self.pagingScrollView.frame) );
    
    CGFloat numberOfPages = [self.dataSource numberOfPagesInPageView:self];
    
    _pagingScrollView.contentSize = CGSizeMake(CGRectGetWidth(_pagingScrollView.frame) * numberOfPages, CGRectGetHeight(_pagingScrollView.frame));
    
    firstNeededIndex = MAX(firstNeededIndex, 0);
    lastNeededIndex = MIN(lastNeededIndex, numberOfPages - 1);
    
    // remove and queue reusable pages
    for (AWPageViewCell* visiblePage in self.internalVisibleViews) {
        if ( visiblePage.index < firstNeededIndex || visiblePage.index > lastNeededIndex ) {
            [visiblePage removeFromSuperview];
            [self.reusableViews addObject:visiblePage];
            if ( [self.delegate respondsToSelector:@selector(pageView:didEndDisplayingCell:atIndex:)] ) {
                [self.delegate pageView:self didEndDisplayingCell:visiblePage atIndex:visiblePage.index];
            }
        }
    }
    
    [self.internalVisibleViews minusSet:self.reusableViews];
    
    // layout visible pages
    if ( numberOfPages > 0 ) {
        for (NSInteger idx = firstNeededIndex; idx <= lastNeededIndex; idx++) {
            [self showCellAtIndex:idx];
        }
    }
}

//- (void)scrollViewDidScroll:(UIScrollView *)scrollView
//{
//    [self showContents];
//}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self showContents];
}

- (BOOL)isDisplayingPageAtIndex:(NSInteger)idx
{
    BOOL isDisplayingPage = NO;
    for (AWPageViewCell* cell in self.internalVisibleViews) {
        if ( cell.index == idx ) {
            isDisplayingPage = YES;
            break;
        }
    }
    return isDisplayingPage;
}

- (CGRect)frameForIndex:(NSInteger)index
{
    CGRect frame = CGRectZero;
    
    frame.size = self.pagingScrollView.frame.size;
    frame.origin.x = frame.size.width * index;
    
    return frame;
}

- (void)queueReusablePage:(AWPageViewCell *)page
{
    if ( ![self.reusableViews containsObject:page] ) {
        [self.reusableViews addObject:page];
    }
}

- (void)showCellAtIndex:(NSInteger)idx
{
    if ( [self isDisplayingPageAtIndex:idx] == NO ) {
        AWPageViewCell* cell = [self.dataSource pageView:self cellAtIndex:idx];
        
        if ( cell == nil ) {
            cell = [[[AWPageViewCell alloc] init] autorelease];
        }
        
        NSAssert(!!cell, @"AWPageViewCell must be not nil.");
        
        if ( [self.delegate respondsToSelector:@selector(pageView:willDisplayCell:atIndex:)] ) {
            [self.delegate pageView:self willDisplayCell:cell atIndex:idx];
        }
        
        cell.frame = [self frameForIndex: idx];
        cell.index = idx;
        
//        [self.pagingScrollView insertSubview:cell atIndex:0];
        [self.pagingScrollView addSubview:cell];
        [self.internalVisibleViews addObject:cell];
    }
    
//    self.pagingScrollView.contentOffset = CGPointMake(CGRectGetWidth(self.pagingScrollView.frame) * idx, 0);
}

- (NSArray *)visibleViews
{
    return [NSArray arrayWithArray:[self.internalVisibleViews allObjects]];
}

- (AWPageViewCell *)dequeueReusableView
{
    AWPageViewCell* cell = [self.reusableViews anyObject];
    
    if ( cell ) {
        [[cell retain] autorelease];
        [self.reusableViews removeObject:cell];
    }
    
    return cell;
}

@end
