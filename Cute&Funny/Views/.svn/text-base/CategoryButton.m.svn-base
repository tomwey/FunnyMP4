//
//  CategoryButton.m
//  Cute&Funny
//
//  Created by tangwei1 on 15/5/18.
//  Copyright (c) 2015年 tangwei1. All rights reserved.
//

#import "CategoryButton.h"
#import "Defines.h"

@implementation CategoryButton
{
    UIView*      _leftSplitView;
    UIView*      _rightSpliteView;
    UIImageView* _button;
    
    id           _target;
    SEL          _action;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if ( self = [super initWithFrame:frame] ) {
        
        _button = createImageView(nil);
        [self addSubview:_button];
        
        _selected = NO;
        
        _showingLeftSpliter = NO;
        _showingRightSpliter = NO;
        
        UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
        [self addGestureRecognizer:tap];
        [tap release];
        
        [[CategoryButtonGroup sharedInstance] addButton:self];
    }
    return self;
}

- (void)tap
{
    if ( self.selected ) {
        return;
    }
    
    for (CategoryButton* btn in [[CategoryButtonGroup sharedInstance] buttons]) {
        btn.selected = NO;
    }
    
    self.selected = YES;
    
    if ( [_target respondsToSelector:_action] ) {
        [_target performSelector:_action withObject:self];
    }
}

- (void)addTarget:(id)target action:(SEL)action
{
    _target = target;
    _action = action;
}

- (void)layoutSubviews
{
    _button.center = AWCenterOfRect(self.bounds);
    
    _leftSplitView.frame = CGRectMake(0, CGRectGetHeight(self.bounds) / 2 - CGRectGetHeight(_button.frame) / 2,
                                      1,
                                      CGRectGetHeight(_button.frame));
    
    _rightSpliteView.frame = CGRectMake(CGRectGetWidth(self.bounds) - 1,
                                        CGRectGetHeight(self.bounds) / 2 - CGRectGetHeight(_button.frame) / 2,
                                        1,
                                        CGRectGetHeight(_button.frame));
    
    
}

- (void)setSelected:(BOOL)selected
{
    _selected = selected;
    
    [self updateContents];
}

- (void)setNormalImage:(UIImage *)normalImage
{
    if ( _normalImage != normalImage ) {
        [_normalImage release];
        _normalImage = [normalImage retain];
        
        [self updateContents];
    }
}

- (void)setSelectedImage:(UIImage *)selectedImage
{
    if ( _selectedImage != selectedImage ) {
        [_selectedImage release];
        _selectedImage = [selectedImage retain];
        
        [self updateContents];
    }
}

- (void)updateContents
{
    if ( _selected ) {
        _button.image = _selectedImage;
    } else {
        _button.image = _normalImage;
    }
    
    [_button sizeToFit];
}

- (void)setShowingLeftSpliter:(BOOL)showingLeftSpliter
{
    _showingLeftSpliter = showingLeftSpliter;
    
    if ( _showingLeftSpliter && !_leftSplitView ) {
        _leftSplitView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 0)];
        [self addSubview:_leftSplitView];
        [_leftSplitView release];
    }
    
    _leftSplitView.backgroundColor = RGB(56, 61, 78);
    
    [self bringSubviewToFront:_leftSplitView];
}

- (void)setShowingRightSpliter:(BOOL)showingRightSpliter
{
    _showingRightSpliter = showingRightSpliter;
    
    if ( _showingRightSpliter && !_rightSpliteView ) {
        _rightSpliteView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 0)];
        [self addSubview:_rightSpliteView];
        [_rightSpliteView release];
    }
    
    _rightSpliteView.backgroundColor = RGB(56, 61, 78);
    
    [self bringSubviewToFront:_rightSpliteView];
}

@end

@implementation CategoryButtonGroup
{
    NSMutableArray* _buttons;
}

AW_SINGLETON_IMPL(CategoryButtonGroup)

- (void)addButton:(id)button
{
    if ( !_buttons ) {
        _buttons = [[NSMutableArray alloc] init];
    }
    
    if ( ![_buttons containsObject:button] ) {
        [_buttons addObject:button];
    }
}

- (NSArray *)buttons
{
    if ( !_buttons ) {
        return nil;
    }
    
    return [NSArray arrayWithArray:_buttons];
}

- (void)removeAllButtons
{
    [_buttons removeAllObjects];
    
    [_buttons release];
    _buttons = nil;
}

@end
