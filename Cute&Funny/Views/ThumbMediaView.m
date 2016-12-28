//
//  MediaView.m
//  Cute&Funny
//
//  Created by tangwei1 on 15-4-22.
//  Copyright (c) 2015年 tangwei1. All rights reserved.
//

#import "ThumbMediaView.h"
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "Defines.h"

@interface ThumbMovieView : UIView

- (void)setMovieURL:(NSURL *)fileURL;

@property (nonatomic, assign, readonly) CGSize naturalSize;

@property (nonatomic, assign) BOOL isThumb;

@end

@interface ThumbMovieView ()

@property (nonatomic, retain) AVQueuePlayer* player;
@property (nonatomic, assign) BOOL isPlaying;

@property (nonatomic, retain) AVPlayerItem* currentPlayerItem;

@property (nonatomic, assign) CMTime time;

@property (nonatomic, retain) AVAssetImageGenerator* generator;

- (void)startPlay;
- (void)stopPlay;

@end

@implementation ThumbMovieView
{
    UIImageView* _thumbnailView;
}

@synthesize naturalSize = _naturalSize;

- (instancetype)initWithFrame:(CGRect)frame
{
    if ( self = [super initWithFrame:frame] ) {
        self.isPlaying = NO;
        
        self.time = kCMTimeZero;
        
        _thumbnailView = createImageView(nil);
        [self addSubview:_thumbnailView];
        
        _thumbnailView.frame = self.bounds;
        
        _thumbnailView.contentMode = UIViewContentModeScaleAspectFill;
        _thumbnailView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        _naturalSize = CGSizeZero;
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(didBecomeActive)
                                                     name:UIApplicationWillEnterForegroundNotification
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(didResignActive)
                                                     name:UIApplicationDidEnterBackgroundNotification
                                                   object:nil];
    }
    return self;
}

+ (Class)layerClass
{
    return [AVPlayerLayer class];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.currentPlayerItem removeObserver:self forKeyPath:@"status"];
    
    self.currentPlayerItem = nil;
    self.player = nil;
    
    [super dealloc];
}

- (void)didBecomeActive
{
    [self startPlay];
}

- (void)didResignActive
{
    [self stopPlay];
}

- (void)setIsThumb:(BOOL)isThumb
{
    _isThumb = isThumb;
    
    if ( _isThumb ) {
        _thumbnailView.contentMode = UIViewContentModeScaleAspectFill;
    } else {
        _thumbnailView.contentMode = UIViewContentModeScaleAspectFit;
    }
}

- (void)setMovieURL:(NSURL *)fileURL
{
    if ( self.isThumb ) {
        UIActivityIndicatorView* spinner = (UIActivityIndicatorView *)[self.superview viewWithTag:1042];
        
        [spinner startAnimating];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            AVAsset* asset = [AVAsset assetWithURL:fileURL];
            
            AVAssetImageGenerator* imageGenerator = [AVAssetImageGenerator assetImageGeneratorWithAsset:asset];
            CGImageRef cgImage = [imageGenerator copyCGImageAtTime:CMTimeMake(0, 1) actualTime:nil error:nil];
            UIImage* image = [UIImage imageWithCGImage:cgImage];
            AW_RELEASE_CF_SAFELY(cgImage);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [spinner stopAnimating];
                
                _thumbnailView.image = image;
            });
            //        self.generator = imageGenerator;
        });
    } else {

    AVAsset* asset = [AVAsset assetWithURL:fileURL];
    
    // 生成缩略图
    AVAssetImageGenerator* imageGenerator = [AVAssetImageGenerator assetImageGeneratorWithAsset:asset];
    CGImageRef cgImage = [imageGenerator copyCGImageAtTime:CMTimeMake(0, 1) actualTime:nil error:nil];
    UIImage* image = [UIImage imageWithCGImage:cgImage];
    AW_RELEASE_CF_SAFELY(cgImage);
    _thumbnailView.image = image;
    
    self.generator = imageGenerator;
    
    
    // 异步装载视频并播放
    [asset loadValuesAsynchronouslyForKeys:@[@"playable"]
                         completionHandler:^{
                             dispatch_async(dispatch_get_main_queue(), ^{

                                 if ( self.currentPlayerItem ) {
                                     [self.currentPlayerItem removeObserver:self forKeyPath:@"status"];

                                     [[NSNotificationCenter defaultCenter] removeObserver:self
                                                                                     name:AVPlayerItemDidPlayToEndTimeNotification
                                                                                   object:self.currentPlayerItem];
                                 }
                                 
                                 AVPlayerItem* playerItem = [AVPlayerItem playerItemWithAsset:asset];
                                 self.currentPlayerItem = playerItem;
                                 
                                 [self.currentPlayerItem addObserver:self
                                                          forKeyPath:@"status"
                                                             options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew
                                                             context:NULL];
                                 [[NSNotificationCenter defaultCenter] addObserver:self
                                                                          selector:@selector(playerItemDidReachEnd:)
                                                                              name:AVPlayerItemDidPlayToEndTimeNotification
                                                                            object:self.currentPlayerItem];
                                 
                                 if ( !self.player ) {
                                     self.player = [AVQueuePlayer playerWithPlayerItem:playerItem];
                                     self.player.actionAtItemEnd = AVPlayerActionAtItemEndNone;
                                     AVPlayerLayer* layer = (AVPlayerLayer*)[self layer];
                                     
                                     layer.videoGravity = AVLayerVideoGravityResizeAspect;
                                     layer.player = self.player;
                                 } else {
                                     [self.player replaceCurrentItemWithPlayerItem:playerItem];
                                 }

                             });
                         }];
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    AVPlayerItemStatus status = [[change objectForKey:NSKeyValueChangeNewKey] integerValue];
    switch (status) {
        case AVPlayerItemStatusUnknown:
        {
//            NSLog(@"Player Item status unknown");
        }
            break;
        case AVPlayerItemStatusFailed:
        {
//            NSLog(@"Player Item status failed");
        }
            break;
        case AVPlayerItemStatusReadyToPlay:
        {
            _thumbnailView.hidden = YES;
            
            self.isPlaying = YES;
            
            [self.player play];
            
        }
            break;
            
        default:
            break;
    }
}

- (void)startPlay
{
    if ( !self.isPlaying ) {
        self.isPlaying = YES;
        
//        _thumbnailView.hidden = YES;
        
        [[NSNotificationCenter defaultCenter] removeObserver:self];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(playerItemDidReachEnd:)
                                                     name:AVPlayerItemDidPlayToEndTimeNotification
                                                   object:[self.player currentItem]];
        
        if ( CMTIME_IS_VALID(self.time) ) {
            [self.currentPlayerItem seekToTime:self.time];
        }
        
        [self.player replaceCurrentItemWithPlayerItem:self.currentPlayerItem];
        
        [self.player play];
    }
}

- (void)stopPlay
{
    if ( self.isPlaying ) {
        self.isPlaying = NO;
        
        _thumbnailView.hidden = NO;
        
        CGImageRef cgImage = [self.generator copyCGImageAtTime:self.player.currentTime actualTime:nil error:nil];
        UIImage* image = [UIImage imageWithCGImage:cgImage];
        AW_RELEASE_CF_SAFELY(cgImage);
        _thumbnailView.image = image;
        
        [[NSNotificationCenter defaultCenter] removeObserver:self];
        
        [self.player pause];
        
        self.time = self.player.currentTime;
        [self.player replaceCurrentItemWithPlayerItem:nil];
    }
}

- (void)playerItemDidReachEnd:(NSNotification *)noti
{
    if ( self.isPlaying ) {
        AVPlayerItem* item = [noti object];
        [item seekToTime:kCMTimeZero];
        [self.player play];
    }
}

@end
///////////////////////////////////////////////////////////
@interface ThumbMediaView ()

@property (nonatomic, retain) UILabel* titleLabel;
@property (nonatomic, retain) UIImageView* gifView;
@property (nonatomic, retain) ThumbMovieView*   movieView;

@property (nonatomic, retain) UIActivityIndicatorView* spinner;

@property (nonatomic, retain) AFHTTPRequestOperation* requestOperation;

@property (nonatomic, assign) BOOL prepareForPlaying;

@property (nonatomic, assign) BOOL loading;

@property (nonatomic, retain) UIImageView *editingView;

@property (nonatomic, retain) UIButton* reloadButton;

@end

#define kLeftMargin 8

NSString * const kThumbMediaViewDidCancelEditingNotification = @"kThumbMediaViewDidCancelEditingNotification";
NSString * const kThumbMediaViewWillEditingNotification = @"kThumbMediaViewWillEditingNotification";

@implementation ThumbMediaView
{
    id _target;
    SEL _action;
}

+ (NSOperationQueue *)sharedRequestOperationQueue {
    static NSOperationQueue *_sharedRequestOperationQueue = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedRequestOperationQueue = [[NSOperationQueue alloc] init];
        _sharedRequestOperationQueue.maxConcurrentOperationCount = NSOperationQueueDefaultMaxConcurrentOperationCount;
    });
    
    return _sharedRequestOperationQueue;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if ( self = [super initWithFrame:frame] ) {
        
        self.clipsToBounds = YES;
        
        self.backgroundColor = [UIColor blackColor];
        
        self.spinner = [[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite] autorelease];
        [self addSubview:self.spinner];
        self.spinner.center = AWCenterOfRect(self.bounds);
        self.spinner.tag = 1042;
        self.spinner.hidesWhenStopped = YES;
        
        self.prepareForPlaying = NO;
        self.loading = NO;
        
        self.editing = self.selected = NO;
        
        self.reloadButton = createImageButton(@"btn_reload.png", self, @selector(updateContents));
        [self addSubview:self.reloadButton];
        self.reloadButton.hidden = YES;
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(willEditing)
                                                     name:kThumbMediaViewWillEditingNotification
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(cancelEditing)
                                                     name:kThumbMediaViewDidCancelEditingNotification
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(selectAll:)
                                                     name:@"kMediaDidSelectAllNotification"
                                                   object:nil];
        
        UITapGestureRecognizer* tap = [[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)] autorelease];
        [self addGestureRecognizer:tap];
    }
    
    return self;
}

- (void)tap
{
    if ( [_target respondsToSelector:_action] ) {
        [_target performSelector:_action withObject:self];
    }
}

- (void)addTarget:(id)target action:(SEL)action
{
    _target = target;
    _action = action;
}

- (void)selectAll:(NSNotification *)sender
{
    self.selected = [sender.object boolValue];
}

- (void)willEditing
{
    self.editing = YES;
}

- (void)cancelEditing
{
    self.editing = NO;
    self.selected = NO;
}

- (void)setSelected:(BOOL)selected
{
    _selected = selected;
    
    if ( !_selected ) {
        [self.editingView removeFromSuperview];
        self.editingView = nil;
    } else {
        if ( !self.editingView ) {
            self.editingView = createImageView(@"liked_edit_selected.png");
            [self addSubview:self.editingView];
        }
        
        [self bringSubviewToFront:self.editingView];
    }
}

- (void)setMedia:(Media *)media
{
    if ( _media != media ) {
        [_media release];
        _media = [media retain];
        
        [self updateContents];
//        NSLog(@"不相等");
    } else {
        if ( self.loading ) {
            [self.spinner startAnimating];
        }
//        NSLog(@"相等");
    }
    
    if ( self.selected ) {
        [self bringSubviewToFront:self.editingView];
    }
}

- (void)stopPlayIfNeeded
{
    [self.movieView stopPlay];
}

- (void)startPlayIfNeeded
{
    if ( self.prepareForPlaying ) {
        [self.movieView startPlay];
    }
}

- (void)layoutSubviews
{
    self.spinner.center = self.editingView.center = self.reloadButton.center = AWCenterOfRect(self.bounds);
}

- (void)updateContents
{
    self.reloadButton.hidden = YES;
    
    if ( self.media.mp4Url && [self.media.mp4Url hasPrefix:@"http://"] ) {
        
        [self.gifView removeFromSuperview];
        self.gifView = nil;
        
        // 播放视频
        if ( !self.movieView ) {
            self.movieView = [[[ThumbMovieView alloc] init] autorelease];
            self.movieView.isThumb = self.isThumb;
            self.movieView.frame = self.bounds;
            [self addSubview:self.movieView];
        }
        
        NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.media.mp4Url]];
        NSData* cachedData = [[MediaCache sharedCache] cachedDataForRequest:request];
        if ( cachedData ) {
            
            self.loading = NO;
            
            self.prepareForPlaying = YES;
            [self.spinner stopAnimating];
            
            [self cancelRequestOperation];
            
            [self startPlayForURL:[[MediaCache sharedCache] cachedFileURLForRequest:request]];
            
        } else {
            
            self.movieView.hidden = YES;
            
            self.loading = YES;
            
            self.prepareForPlaying = NO;
            
            [self loadMediaDataForURLRequest:request success:^(id responseObject) {
                
                self.prepareForPlaying = YES;
                
                [self startPlayForURL:[[MediaCache sharedCache] cachedFileURLForRequest:request]];
            }];
        }

    } else {
        // 显示静态图片
        [self.movieView removeFromSuperview];
        self.movieView = nil;
        
        if ( !self.gifView ) {
            self.gifView = createImageView(nil);
            self.gifView.frame = self.bounds;
            
            self.gifView.contentMode = UIViewContentModeScaleAspectFill;
            
            [self addSubview:self.gifView];
        }
        
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.media.gifUrl]];
        NSData* cachedData = [[MediaCache sharedCache] cachedDataForRequest:request];
        if ( cachedData ) {
            [self.spinner stopAnimating];
            self.loading = NO;
            [self cancelRequestOperation];
            
            [self showImage:cachedData];
        } else {
            self.gifView.hidden = YES;
            
            self.loading = YES;
            
            [self loadMediaDataForURLRequest:request success:^(id responseObject) {
                [self showImage:responseObject];
            }];
        }
    }
}

- (void)setIsThumb:(BOOL)isThumb
{
    _isThumb = isThumb;
    
    if ( _isThumb ) {
        self.gifView.contentMode = UIViewContentModeScaleAspectFill;
    } else {
        self.gifView.contentMode = UIViewContentModeScaleAspectFit;
    }
}

- (void)showImage:(NSData *)imageData
{
    self.gifView.image = [UIImage imageWithData:imageData];

    self.gifView.hidden = NO;
    
}

- (void)startPlayForURL:(NSURL *)fileURL
{
    [self.movieView setMovieURL:fileURL];
    
    self.movieView.hidden = NO;
}

- (void)loadMediaDataForURLRequest:(NSURLRequest *)urlRequest success:( void (^)( id responseObject ) )success
{
    [self cancelRequestOperation];
    
    if ( [self.delegate respondsToSelector:@selector(didStartLoading:)] ) {
        [self.delegate didStartLoading:self];
    }
    
    self.loading = YES;
    
    [self.spinner startAnimating];
    
    __block ThumbMediaView* me = self;
    self.requestOperation = [[[AFHTTPRequestOperation alloc] initWithRequest:urlRequest] autorelease];
    [self.requestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        self.loading = NO;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.reloadButton.hidden = YES;
            
            [self.spinner stopAnimating];
            [[MediaCache sharedCache] cacheData:responseObject forRequest:urlRequest];
            
            if ( [[urlRequest URL] isEqual:[me.requestOperation.request URL]] ) {
                if ( success ) {
                    success( responseObject );
                }
                
                if ( operation == me.requestOperation ) {
                    me.requestOperation = nil;
                }
            }
            
            if ( [self.delegate respondsToSelector:@selector(mediaView:didFinishLoading:)] ) {
                [self.delegate mediaView:self didFinishLoading:YES];
            }
        });
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        self.loading = NO;
        
        if ( !operation.isCancelled ) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.reloadButton.hidden = NO;
                [self bringSubviewToFront:self.reloadButton];
                
                if ( [self.delegate respondsToSelector:@selector(mediaView:didFinishLoading:)] ) {
                    [self.delegate mediaView:self didFinishLoading:NO];
                }
                
                [self.spinner stopAnimating];
                if ( operation == me.requestOperation ) {
                    me.requestOperation = nil;
                }
                
                if ( me.movieView ) {
                    me.movieView.hidden = YES;
                } else if ( me.gifView ) {
                    me.gifView.hidden = YES;
                }
            });
            AW_LOG(@"加载失败：%@", [operation.request URL]);
        } else {
            AW_LOG(@"取消加载：%@", [operation.request URL]);
        }
    }];
    
    [[[self class] sharedRequestOperationQueue] addOperation:self.requestOperation];
}

- (void)cancelRequestOperation
{
    [self.requestOperation cancel];
    self.requestOperation = nil;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [self cancelRequestOperation];
    
    self.titleLabel = nil;
    [_media release];
    
    self.movieView = nil;
    self.gifView = nil;
    self.spinner = nil;
    
    [super dealloc];
}

@end
