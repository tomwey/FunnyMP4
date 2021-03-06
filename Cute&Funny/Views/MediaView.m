//
//  MediaView.m
//  Cute&Funny
//
//  Created by tangwei1 on 15-4-22.
//  Copyright (c) 2015年 tangwei1. All rights reserved.
//

#import "MediaView.h"
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "Defines.h"

@interface MovieView : UIView

- (void)setMovieURL:(NSURL *)fileURL;

@property (nonatomic, assign, readonly) CGSize naturalSize;

@end

@interface MovieView ()

@property (nonatomic, retain) AVQueuePlayer* player;
@property (nonatomic, assign) BOOL isPlaying;

@property (nonatomic, retain) AVPlayerItem* currentPlayerItem;

@property (nonatomic, assign) CMTime time;

@property (nonatomic, retain) AVAssetImageGenerator* generator;

- (void)startPlay;
- (void)stopPlay;

@end

@implementation MovieView
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

- (void)setMovieURL:(NSURL *)fileURL
{
    AVAsset* asset = [AVAsset assetWithURL:fileURL];
    
    // 生成缩略图
    AVAssetImageGenerator* imageGenerator = [AVAssetImageGenerator assetImageGeneratorWithAsset:asset];
    CGImageRef cgImage = [imageGenerator copyCGImageAtTime:CMTimeMake(0, 1) actualTime:nil error:nil];
    UIImage* image = [UIImage imageWithCGImage:cgImage];
    AW_RELEASE_CF_SAFELY(cgImage);
    _thumbnailView.image = image;
    
    self.generator = imageGenerator;
    
    // 获取宽高
    AVAssetTrack *vT = nil;
    if ([[asset tracksWithMediaType:AVMediaTypeVideo] count] != 0)
    {
        vT = [[asset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0];
    }
    if (vT != nil)
    {
        _naturalSize = CGSizeMake(vT.naturalSize.width, vT.naturalSize.height);
    }
    
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
        
        [self.currentPlayerItem seekToTime:self.time];
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
@interface MediaView () <UIScrollViewDelegate>

@property (nonatomic, retain) UILabel* titleLabel;
@property (nonatomic, retain) UIImageView* gifView;
@property (nonatomic, retain) MovieView*   movieView;

@property (nonatomic, retain) UIActivityIndicatorView* spinner;

@property (nonatomic, retain) AFHTTPRequestOperation* requestOperation;

@property (nonatomic, assign) BOOL prepareForPlaying;

@end

#define kLeftMargin 8

static inline CGSize CalcuSize(CGSize containerSize, CGSize srcSize) {
    if ( srcSize.width == 0 && srcSize.height == 0 ) {
        return containerSize;
    }
    
    if ( containerSize.width > srcSize.width ) {
        return srcSize;
    }
    
    CGFloat height = containerSize.width * srcSize.height / srcSize.width;
    return CGSizeMake(containerSize.width, height);
};

@implementation MediaView
{
    UIScrollView* _scrollView;
    UIView*       _mediaContentView;
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
        
        _scrollView = [[[UIScrollView alloc] init] autorelease];
        
        [self addSubview:_scrollView];
        _scrollView.delegate = self;
        
        _scrollView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        
        _scrollView.frame = self.bounds;
        
        self.spinner = [[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite] autorelease];
        [self addSubview:self.spinner];
        self.spinner.center = AWCenterOfRect(self.bounds);
        
        self.spinner.hidesWhenStopped = YES;
        
        self.prepareForPlaying = NO;
        
    }
    
    return self;
}

- (void)setMedia:(Media *)media
{
    if ( _media != media ) {
        [_media release];
        _media = [media retain];
        
        [self updateContents];
//        NSLog(@"不相等");
    } else {
//        NSLog(@"相等");
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

- (void)updateContents
{
    self.spinner.center = CGPointMake(CGRectGetWidth(self.bounds) / 2, CGRectGetHeight(self.bounds) / 2.5);//AWCenterOfRect(self.bounds);
    
    if ( self.media.mp4Url && [self.media.mp4Url hasPrefix:@"http://"] ) {
        
        [self.gifView removeFromSuperview];
        self.gifView = nil;
        
        // 播放视频
        if ( !self.movieView ) {
            self.movieView = [[[MovieView alloc] init] autorelease];
            [_scrollView addSubview:self.movieView];
        }
        
        NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.media.mp4Url]];
        NSData* cachedData = [[MediaCache sharedCache] cachedDataForRequest:request];
        if ( cachedData ) {
            
            self.prepareForPlaying = YES;
            [self.spinner stopAnimating];
            
            [self cancelRequestOperation];
            
            [self startPlayForURL:[[MediaCache sharedCache] cachedFileURLForRequest:request]];
            
        } else {
            
            self.movieView.hidden = YES;
            
            self.prepareForPlaying = NO;
            
            [self loadMediaDataForURLRequest:request success:^(id responseObject) {
                
                self.prepareForPlaying = YES;
                
                [self startPlayForURL:[[MediaCache sharedCache] cachedFileURLForRequest:request]];
            }];
        }
        
        _mediaContentView = self.movieView;
        
    } else {
        // 显示静态图片
        [self.movieView removeFromSuperview];
        self.movieView = nil;
        
        if ( !self.gifView ) {
            self.gifView = createImageView(nil);
            [_scrollView addSubview:self.gifView];
        }
        
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.media.gifUrl]];
        NSData* cachedData = [[MediaCache sharedCache] cachedDataForRequest:request];
        if ( cachedData ) {
            [self.spinner stopAnimating];
            
            [self cancelRequestOperation];
            
            [self showImage:cachedData];
        } else {
            self.gifView.hidden = YES;
            
            [self loadMediaDataForURLRequest:request success:^(id responseObject) {
                [self showImage:responseObject];
            }];
        }
        
        _mediaContentView = self.gifView;
    }
}

- (void)updateTitleFrameForRelativeView:(UIView *)relativeView
{ 
//    self.titleLabel.text = self.media.title;
//    CGSize textSize = [self.media.title sizeWithFont:self.titleLabel.font
//                                   constrainedToSize:CGSizeMake(CGRectGetWidth(self.bounds) - kLeftMargin * 2, 500)];
//    self.titleLabel.frame = CGRectMake(kLeftMargin, CGRectGetMaxY(relativeView.frame) + 8,
//                                       CGRectGetWidth(self.bounds) - kLeftMargin * 2, textSize.height);
    _scrollView.contentSize = CGSizeMake(CGRectGetWidth(_scrollView.frame),
                                         CGRectGetMaxY(relativeView.frame) + 5);
}

- (void)showImage:(NSData *)imageData
{
    self.gifView.image = [UIImage imageWithData:imageData];

    self.gifView.hidden = NO;
    
    CGSize scrollViewSize = _scrollView.frame.size;
    scrollViewSize.width -= kLeftMargin * 2;
    
    CGSize newSize = CalcuSize(scrollViewSize, self.gifView.image.size);
    
    self.gifView.frame = CGRectMake(CGRectGetWidth(_scrollView.frame) / 2 - newSize.width / 2, 0,
                                      newSize.width,
                                      newSize.height);
    
    if ( CGRectGetHeight(self.bounds) > newSize.height ) {
        self.gifView.center = CGPointMake(CGRectGetWidth(_scrollView.frame) / 2,
                                          CGRectGetHeight(_scrollView.frame) / 2 - 50);//AWCenterOfRect(self.bounds);
    }
    
    [self updateTitleFrameForRelativeView:self.gifView];
}

- (void)startPlayForURL:(NSURL *)fileURL
{
    [self.movieView setMovieURL:fileURL];
    
    self.movieView.hidden = NO;
    
    CGSize scrollViewSize = _scrollView.frame.size;
    scrollViewSize.width -= kLeftMargin * 2;
    
    CGSize newSize = CalcuSize(scrollViewSize, self.movieView.naturalSize);
    
    self.movieView.frame = CGRectMake(CGRectGetWidth(_scrollView.frame) / 2 - newSize.width / 2, 0,
                                      newSize.width,
                                      newSize.height);
    if ( CGRectGetHeight(self.bounds) > newSize.height ) {
        self.movieView.center = CGPointMake(CGRectGetWidth(_scrollView.frame) / 2,
                                            CGRectGetHeight(_scrollView.frame) / 2 - 50);
//        self.movieView.center = AWCenterOfRect(self.bounds);
    }
    
//    [self.movieView startPlay];
    
    [self updateTitleFrameForRelativeView:self.movieView];
}

- (void)loadMediaDataForURLRequest:(NSURLRequest *)urlRequest success:( void (^)( id responseObject ) )success
{
    [self cancelRequestOperation];
    
    if ( [self.delegate respondsToSelector:@selector(didStartLoading:)] ) {
        [self.delegate didStartLoading:self];
    }
    
    [self.spinner startAnimating];
    
    __block MediaView* me = self;
    self.requestOperation = [[[AFHTTPRequestOperation alloc] initWithRequest:urlRequest] autorelease];
    [self.requestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
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
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
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
        
        AW_LOG(@"加载失败：%@", [operation.request URL]);
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

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return _mediaContentView;
}

@end
