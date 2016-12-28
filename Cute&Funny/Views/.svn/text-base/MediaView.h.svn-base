//
//  MediaView.h
//  Cute&Funny
//
//  Created by tangwei1 on 15-4-22.
//  Copyright (c) 2015年 tangwei1. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Media;
@class MediaView;

@protocol MediaViewDelegate <NSObject>

@optional
- (void)didStartLoading:(MediaView *)view;
- (void)mediaView:(MediaView *)view didFinishLoading:(BOOL)succeed;

@end

@interface MediaView : UIView

@property (nonatomic, retain) Media* media;

@property (nonatomic, assign) id <MediaViewDelegate> delegate;

- (void)stopPlayIfNeeded;

- (void)startPlayIfNeeded;

@end
