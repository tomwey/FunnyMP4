//
//  MediaView.h
//  Cute&Funny
//
//  Created by tangwei1 on 15-4-22.
//  Copyright (c) 2015年 tangwei1. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString * const kThumbMediaViewDidCancelEditingNotification;
extern NSString * const kThumbMediaViewWillEditingNotification;

@class Media;
@class ThumbMediaView;

@protocol ThumbMediaViewDelegate <NSObject>

@optional
- (void)didStartLoading:(ThumbMediaView *)view;
- (void)mediaView:(ThumbMediaView *)view didFinishLoading:(BOOL)succeed;

@end

@interface ThumbMediaView : UIView

@property (nonatomic, retain) Media* media;

@property (nonatomic, assign) id <ThumbMediaViewDelegate> delegate;

@property (nonatomic, assign) BOOL editing;

@property (nonatomic, assign) BOOL selected;

@property (nonatomic, assign) BOOL isThumb;

- (void)addTarget:(id)target action:(SEL)action;

- (void)stopPlayIfNeeded;

- (void)startPlayIfNeeded;

@end
