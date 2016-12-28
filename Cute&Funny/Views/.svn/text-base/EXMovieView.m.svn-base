//
//  MovieView.m
//  Cute&Funny
//
//  Created by tangwei1 on 15/5/5.
//  Copyright (c) 2015年 tangwei1. All rights reserved.
//

#import "EXMovieView.h"
#import <AVFoundation/AVFoundation.h>

@interface EXMovieView ()
{
    UIImageView* _thumbnailView;
}

@property (nonatomic, retain) AVPlayerItem* playerItem;
@property (nonatomic, retain) AVPlayer* player;

@end

static void* MovieViewPlaybackStatusObservationContext = &MovieViewPlaybackStatusObservationContext;
static void* MovieViewPlaybackCurrentItemObservationContext = &MovieViewPlaybackCurrentItemObservationContext;

@implementation EXMovieView

- (id)initWithMovieURL:(NSURL *)movieURL
{
    if ( self = [super init] ) {
        
        _thumbnailView = [[[UIImageView alloc] init] autorelease];
        [self addSubview:_thumbnailView];
        _thumbnailView.frame = self.bounds;
        _thumbnailView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        self.movieURL = movieURL;
    }
    return self;
}

- (void)dealloc
{
    [_movieURL release];
    
    [self.player.currentItem removeObserver:self forKeyPath:@"status"];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [self.player pause];
    
    self.playerItem = nil;
    self.player = nil;
    
    [super dealloc];
}

+ (Class)layerClass
{
    return [AVPlayerLayer class];
}

- (void)setMovieURL:(NSURL *)movieURL
{
    if ( _movieURL != movieURL ) {
        [_movieURL release];
        _movieURL = [movieURL retain];
        
        AVURLAsset* asset = [AVURLAsset URLAssetWithURL:_movieURL options:nil];
        
        // 生成缩略图
        AVAssetImageGenerator* imageGenerator = [AVAssetImageGenerator assetImageGeneratorWithAsset:asset];
        
        CGImageRef cgImage = [imageGenerator copyCGImageAtTime:CMTimeMake(0, 1) actualTime:nil error:nil];
        UIImage* image = [UIImage imageWithCGImage:cgImage];
        CFRelease(cgImage);
        
        _thumbnailView.image = image;
        
        _thumbnailView.hidden = NO;
        
        // 异步加载并播放
        NSArray* requestedKeys = @[@"playable"];
        
        [asset loadValuesAsynchronouslyForKeys:requestedKeys completionHandler:
         ^{
             [self prepareToPlayAsset:asset withKeys:requestedKeys];
         }];
    }
}

- (void)prepareToPlayAsset:(AVURLAsset *)asset withKeys:(NSArray *)requestedKeys
{
    for (NSString* key in requestedKeys) {
        NSError* error = nil;
        AVKeyValueStatus keyStatus = [asset statusOfValueForKey:key error:&error];
        
        if ( keyStatus == AVKeyValueStatusFailed ) {
            NSLog(@"prepare error: %@", error);
            return;
        }
    }
    
    // 检查asset是否可以播放
    if ( !asset.playable ) {
        NSLog(@"该条目不能播放");
        return;
    }
    
    // 停止观察以前的播放条目
    if ( self.playerItem ) {
        [self.playerItem removeObserver:self forKeyPath:@"status"];
        
        [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:self.playerItem];
    }
    
    // 重新创建一个新的播放条目
    self.playerItem = [AVPlayerItem playerItemWithAsset:asset];
    
    [self.playerItem addObserver:self
                      forKeyPath:@"status"
                         options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew
                         context:MovieViewPlaybackStatusObservationContext];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(playItemDidReachEnd:)
                                                 name:AVPlayerItemDidPlayToEndTimeNotification
                                               object:self.playerItem];
    
    // 创建一个播放器
    if ( !self.player ) {
        self.player = [AVPlayer playerWithPlayerItem:self.playerItem];
        
        [self.player addObserver:self
                      forKeyPath:@"currentItem"
                         options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew
                         context:MovieViewPlaybackCurrentItemObservationContext];
        
    }
    
    if ( self.player.currentItem != self.playerItem ) {
        
        [self.player replaceCurrentItemWithPlayerItem:self.playerItem];
        
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    if ( context == MovieViewPlaybackStatusObservationContext ) {
        AVPlayerItemStatus status = [[change objectForKey:NSKeyValueChangeNewKey] integerValue];
        switch (status) {
            case AVPlayerItemStatusUnknown:
            {
                NSLog(@"Player Item status unknown");
            }
                break;
            case AVPlayerItemStatusFailed:
            {
                NSLog(@"Player Item status failed");
            }
                break;
            case AVPlayerItemStatusReadyToPlay:
            {
                _thumbnailView.hidden = YES;
                
                [self.player play];
            }
                break;
                
            default:
                break;
        }
    } else if ( context == MovieViewPlaybackCurrentItemObservationContext ) {
        AVPlayerItem* newPlayerItem = [change objectForKey:NSKeyValueChangeNewKey];
        if ( newPlayerItem == (id)[NSNull null] ) {
            NSLog(@"新条目为空");
        } else {
            [self.player play];
        }
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

- (void)setPlayer:(AVPlayer *)player
{
    AVPlayerLayer* layer = (AVPlayerLayer *)[self layer];
    
    layer.videoGravity = AVLayerVideoGravityResizeAspect;
    
    layer.player = player;
}

- (AVPlayer *)player
{
    AVPlayerLayer* layer = (AVPlayerLayer *)[self layer];
    
    return layer.player;
}

- (AVPlayer *)moviePlayer
{
    return self.player;
}

- (void)playItemDidReachEnd:(NSNotification *)noti
{
    AVPlayerItem* playerItem = noti.object;
    [playerItem seekToTime:kCMTimeZero];
    [self.player play];
}

@end
