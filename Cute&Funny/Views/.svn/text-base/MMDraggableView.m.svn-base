//
//  MMDraggableView.m
//  Cute&Funny
//
//  Created by tangwei1 on 15/5/20.
//  Copyright (c) 2015年 tangwei1. All rights reserved.
//

#import "MMDraggableView.h"
#import "MMOverlayView.h"
#import "Defines.h"

@interface MMDraggableView ()

@property (nonatomic, retain) UIPanGestureRecognizer* panGestureRecognizer;

@property (nonatomic, assign) CGPoint originalPoint;

@property (nonatomic, retain) MMOverlayView* overlayView;

@end

@implementation MMDraggableView

- (instancetype)initWithFrame:(CGRect)frame
{
    if ( self = [super initWithFrame:frame] ) {
        self.backgroundColor = kMainBackgroundColor;//[UIColor greenColor];
        
        self.panGestureRecognizer = [[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(drag:)] autorelease];
        [self addGestureRecognizer:self.panGestureRecognizer];
        
//        [self loadImageAndStyle];
        
//        self.overlayView = [[MMOverlayView alloc] initWithFrame:self.bounds];
//        self.overlayView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
//        self.overlayView.alpha = 0;
//        
//        self.overlayView.layer.cornerRadius = 8;
//        self.overlayView.layer.shouldRasterize = YES;
//        
//        self.overlayView.clipsToBounds = YES;
//        
//        [self addSubview:self.overlayView];
    }
    
    return self;
}

- (void)loadImageAndStyle
{
    self.layer.borderWidth = 2;
    self.layer.borderColor = [[UIColor blackColor] CGColor];
    
    self.layer.shouldRasterize = YES;
    
    self.layer.cornerRadius = 8;
    self.layer.shadowOffset = CGSizeMake(7, 7);
    self.layer.shadowRadius = 5;
    self.layer.shadowOpacity = 0.5;
}

- (void)drag:(UIPanGestureRecognizer*)gesture
{
    CGFloat xDistance = [gesture translationInView:self].x;
    CGFloat yDistance = [gesture translationInView:self].y;
    
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan:
            self.originalPoint = self.center;
            break;
        case UIGestureRecognizerStateChanged:
        {
            CGFloat rotationStrength = MIN(xDistance / AWFullScreenWidth(), 1);
            CGFloat rotationAngel = (CGFloat)(2 * M_PI * rotationStrength / 16);
            CGFloat scaleStrength = 1 - fabs(rotationStrength) / 4;
            CGFloat scale = MAX(scaleStrength, 0.93);
            self.center = CGPointMake(self.originalPoint.x + xDistance, self.originalPoint.y + yDistance);
            CGAffineTransform transform = CGAffineTransformMakeRotation(rotationAngel);
            CGAffineTransform scaleTransform = CGAffineTransformScale(transform, scale, scale);
            self.transform = scaleTransform;
            
            if ( [self.delegate respondsToSelector:@selector(draggableView:positionDidChange:)] ) {
                [self.delegate draggableView:self positionDidChange:CGPointMake(xDistance, yDistance)];
            }
            
            break;
        }
        
        case UIGestureRecognizerStateEnded:
            
            if ( xDistance < -80 ) {
                [self moveOut:-1];
            } else if ( xDistance > 80 ) {
                [self moveOut:1];
            } else {
                [self resetViewPositionAndTransformations];
            }
            
            break;
        
        case UIGestureRecognizerStatePossible:break;
        case UIGestureRecognizerStateCancelled:break;
        case UIGestureRecognizerStateFailed:break;
            
        default:
            break;
    }
}

- (void)moveOutFromLeft
{
    CGAffineTransform transform = CGAffineTransformMakeRotation(-M_PI / 8 );
    CGAffineTransform scaleTransform = CGAffineTransformScale(transform, 0.93, 0.93);
    [UIView animateWithDuration:.2 animations:^{
        self.transform = scaleTransform;
    }];
    
    [self moveOut:-1];
}

- (void)moveOutFromRight
{
    CGAffineTransform transform = CGAffineTransformMakeRotation(M_PI / 8);
    CGAffineTransform scaleTransform = CGAffineTransformScale(transform, 0.93, 0.93);
    [UIView animateWithDuration:.2 animations:^{
        self.transform = scaleTransform;
    }];
    
    [self moveOut:1];
}

- (void)moveOut:(CGFloat)factor
{
    if ( factor == 1 ) {
        if ( self.currentMedia ) {
            [self sendRequest:[NSString stringWithFormat:@"%@/user/%@/like?user=%@", kDomainURL, self.currentMedia.id, [OpenUDID value]]];
        }
    } else {
        if ( self.currentMedia ) {
            [self sendRequest:[NSString stringWithFormat:@"%@/user/%@/dislike?user=%@", kDomainURL, self.currentMedia.id, [OpenUDID value]]];
        }
    }
    
    CGRect frame = self.frame;
    frame.origin.x = CGRectGetWidth(self.superview.frame) * 1.5 * factor;
    [UIView animateWithDuration:.2 animations:^{ self.frame = frame; } completion:^(BOOL finished) {
        self.center = self.originalPoint;
        self.transform = CGAffineTransformMakeRotation(0);
        if ( [self.delegate respondsToSelector:@selector(draggableViewDidMoveOut:)] ) {
            [self.delegate draggableViewDidMoveOut:self];
        }
    }];
}

- (void)sendRequest:(NSString *)url
{
    [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                               if ( connectionError ) {
                                   AW_LOG(@"network error: %@", url);
                               }
                           }];
}

- (void)updateOverlay:(CGFloat)distance
{
    if ( distance > 0 ) {
        self.overlayView.mode = MMOverlayViewModeRight;
    } else {
        self.overlayView.mode = MMOverlayViewModeLeft;
    }
    
    CGFloat overlayStrength = MIN(fabs(distance) / 100, 0.4);
    self.overlayView.alpha = overlayStrength;
}

- (void)resetViewPositionAndTransformations
{
    if ( [self.delegate respondsToSelector:@selector(draggableViewDidResetState:)] ) {
        [self.delegate draggableViewDidResetState:self];
    }
    
    [UIView animateWithDuration:.2 animations:^{
        self.center = self.originalPoint;
        self.transform = CGAffineTransformMakeRotation(0);
        
        self.overlayView.alpha = 0;
    }];
}

- (void)resetState
{
    [self resetViewPositionAndTransformations];
}

- (void)dealloc
{
    [self removeGestureRecognizer:self.panGestureRecognizer];
    self.panGestureRecognizer = nil;
    
    self.overlayView = nil;
    
    [super dealloc];
}

@end
