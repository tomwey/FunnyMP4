//
//  MMDraggableView.h
//  Cute&Funny
//
//  Created by tangwei1 on 15/5/20.
//  Copyright (c) 2015年 tangwei1. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MMDraggableView;
@class Media;

@protocol MMDraggableViewDelegate <NSObject>

@optional
- (void)draggableViewDidMoveOut:(MMDraggableView *)view;

- (void)draggableView:(MMDraggableView *)view positionDidChange:(CGPoint)position;

- (void)draggableViewDidResetState:(MMDraggableView *)view;

@end

@interface MMDraggableView : UIView

@property (nonatomic, assign) id delegate;

@property (nonatomic, retain) Media* currentMedia;

- (void)moveOutFromLeft;
- (void)moveOutFromRight;

- (void)resetState;

@end
