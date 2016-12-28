//
//  SocialButton.m
//  Cute&Funny
//
//  Created by tangwei1 on 15-4-22.
//  Copyright (c) 2015年 tangwei1. All rights reserved.
//

#import "SocialButton.h"
#import "Defines.h"
#import "OpenUDID.h"

@implementation SocialButton
{
    UIView*      _backgroundView;
    UIView*      _maskView;
    
    UIImageView* _iconView;
    
    UILabel*     _digitLabel;
    
    id  _target;
    SEL _action;
}

@synthesize digitLabel = _digitLabel;
//@synthesize iconView = _iconView;

- (instancetype)initWithFrame:(CGRect)frame
{
    if ( self = [super initWithFrame:frame] ) {
        
        CGFloat width = AWFullScreenWidth() / 414 * 140;
        CGFloat height = width * 60 / 140;
        self.frame = CGRectMake(0, 0, width, height);
        
        self.layer.cornerRadius = CGRectGetHeight(self.bounds) / 2.0;
        self.clipsToBounds = YES;
        
        _backgroundView = [[[UIView alloc] initWithFrame:self.bounds] autorelease];
        [self addSubview:_backgroundView];
        
        _iconView = createImageView(nil);
        [self addSubview:_iconView];
        
        _digitLabel = createLabel(CGRectZero,
                                  NSTextAlignmentCenter,
                                  [UIFont boldSystemFontOfSize:18],
                                  [UIColor whiteColor]);
        [self addSubview:_digitLabel];
        
        _maskView = [[[UIView alloc] initWithFrame:self.bounds] autorelease];
        [self addSubview:_maskView];
        _maskView.backgroundColor = [UIColor blackColor];
        _maskView.alpha = .6;
        
        _maskView.hidden = YES;
        
        self.exclusiveTouch = YES;
        self.multipleTouchEnabled = NO;
        
//        UIButton* btn = createImageButton(nil, self, @selector(btnClicked));
//        [self addSubview:btn];
//        btn.frame = self.bounds;
    }
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if ( _digitLabel.hidden ) {
        _iconView.center = AWCenterOfRect(self.bounds);
    } else {
        _iconView.center = CGPointMake(36, CGRectGetMidY(self.bounds));
    }
    
    _digitLabel.frame = CGRectMake(CGRectGetMaxX(_iconView.frame),
                                   0,
                                   CGRectGetWidth(self.bounds) - CGRectGetMaxX(_iconView.frame),
                                   CGRectGetHeight(self.bounds));
}

- (void)btnClicked
{
    if ( [_target respondsToSelector:_action] ) {
        [_target performSelector:_action withObject:self];
    }
}

- (void)zoomIn:(CGFloat)scale
{
    self.transform = CGAffineTransformMakeScale(scale, scale);
}

- (void)resetAnimation:(BOOL)animated
{
    if ( !animated ) {
        self.transform = CGAffineTransformMakeScale(1.0, 1.0);
    } else {
        [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
        
        [UIView animateWithDuration:.2 animations:^{
            self.transform = CGAffineTransformMakeScale(1.0, 1.0);
        } completion:^(BOOL finished) {
            [[UIApplication sharedApplication] endIgnoringInteractionEvents];
        }];
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self bringSubviewToFront:_maskView];
//    _maskView.hidden = NO;
    
    [UIView animateWithDuration:.2 animations:^{
        self.transform = CGAffineTransformMakeScale(1.2, 1.2);
    } completion:^(BOOL finished) {
        
    }];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
//    _maskView.hidden = YES;
    
    [self resetAnimation:YES];
    
    [self btnClicked];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    _maskView.hidden = YES;
}

- (void)addTarget:(id)target action:(SEL)action
{
    _target = target;
    _action = action;
}

- (void)setIconImage:(UIImage *)iconImage
{
    [_iconImage release];
    _iconImage = [iconImage retain];
    
    _iconView.image = _iconImage;
    [_iconView sizeToFit];
}

- (void)setBackgroundColor:(UIColor *)backgroundColor
{
    _backgroundView.backgroundColor = backgroundColor;
}

- (UIColor *)backgroundColor { return _backgroundView.backgroundColor; }

- (void)setDigit:(NSInteger)digit
{
    _digit = digit;
    
    if ( _digit < 1000 ) {
        _digitLabel.text = [NSString stringWithFormat:@"%ld", (long)digit];
    } else {
        if ( _digit % 1000 == 0 ) {
            _digitLabel.text = [NSString stringWithFormat:@"%ldK", (long)digit / 1000];
        } else {
            _digitLabel.text = [NSString stringWithFormat:@"%.1fK", (long)digit / 1000.0];
        }
    }
    
}

- (void)dealloc
{
    [_iconImage release];
    
    [super dealloc];
}

@end
