//
//  MediaView.h
//  Cute&Funny
//
//  Created by tangwei1 on 15-4-22.
//  Copyright (c) 2015年 tangwei1. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Media;
@class MMMediaView;

@protocol MMMediaViewDelegate <NSObject>

@optional
- (void)didStartLoading:(MMMediaView *)view;
- (void)mediaView:(MMMediaView *)view didFinishLoading:(BOOL)succeed;

@end

@class AFHTTPRequestOperation;
@interface MMMediaView : UIView

@property (nonatomic, retain) Media* media;

@property (nonatomic, assign) id <MMMediaViewDelegate> delegate;

@property (nonatomic, assign, readonly) AFHTTPRequestOperation* operation;

- (void)stopPlayIfNeeded;

- (void)startPlayIfNeeded;

@end
