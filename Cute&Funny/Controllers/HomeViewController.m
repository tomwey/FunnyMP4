//
//  HomeViewController.m
//  Cute&Funny
//
//  Created by tangwei1 on 15-4-20.
//  Copyright (c) 2015年 tangwei1. All rights reserved.
//

#import "HomeViewController.h"
#import "Defines.h"

@interface HomeViewController () <MMMediaViewDelegate>

@property (nonatomic, assign) NSUInteger totalRecord;

@property (nonatomic, assign) NSInteger totalPages;

@property (nonatomic, assign) Media* currentMedia;

@end

@implementation HomeViewController
{
    CGFloat   _topButtonsMaxY;
    
    MMDraggableView* _upView;
    MMDraggableView* _bottomView;
    
    CGRect           _originFrame;
    
    SocialButton*    _dislikeButton;
    SocialButton*    _likeButton;
    UIButton*        _shareButton;
    
    UIView*          _contentView;
    
    MediaInfoType    _currentMediaType;
    
    int              _showingAdsCount;
}

- (void)dealloc
{
    [[CategoryButtonGroup sharedInstance] removeAllButtons];
    
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _showingAdsCount = 0;
    
    _contentView = [[UIView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:_contentView];
    [_contentView release];
    
    [self initTopButtons];
    
    CGFloat width = AWFullScreenWidth() - 18 * 2;
    
    CGFloat height = AWFullScreenHeight() - _topButtonsMaxY - 15 - 50 - 100;
    
    MMDraggableView* draggableView1 = [[[MMDraggableView alloc] init] autorelease];
    draggableView1.frame = CGRectMake(18, _topButtonsMaxY + 15, width, height);
    
    [_contentView addSubview:draggableView1];
    _upView = draggableView1;
    
    _originFrame = _upView.frame;
    
    MMDraggableView* draggableView2 = [[[MMDraggableView alloc] init] autorelease];
    draggableView2.frame = draggableView1.frame;
    
    [_contentView addSubview:draggableView2];
    _bottomView = draggableView2;
    
    _bottomView.userInteractionEnabled = NO;
    
    [_contentView bringSubviewToFront:_upView];
    
    _upView.delegate = self;
    _bottomView.delegate = self;
    
    MMMediaView* aMediaView = [[[MMMediaView alloc] initWithFrame:_upView.bounds] autorelease];
    [_upView addSubview:aMediaView];
    aMediaView.tag = 1000;
    
    aMediaView = [[[MMMediaView alloc] initWithFrame:_upView.bounds] autorelease];
    [_bottomView addSubview:aMediaView];
    aMediaView.tag = 1000;
    
    [self showGifsForType:MediaInfoTypeRecent];
    
    [self initSocialButtons];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didBecomeActive)
                                                 name:UIApplicationWillEnterForegroundNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(bannerDidLoad)
                                                 name:@"bannerAdDidLoad"
                                               object:nil];
}

- (void)didBecomeActive
{
    [self showGifsForType:_currentMediaType];
}

- (void)showGifsForType:(MediaInfoType)type
{
    _upView.hidden = _bottomView.hidden = YES;
    
    _currentMediaType = type;
    
    [[MediaTypeLoadInfoManager sharedInstance] startLoadingMediaInfos:^(MediaTypeLoadInfo *info, BOOL succeed) {
        if ( succeed ) {
            [self showGifForLoadInfo:info];
        }
    } forType:type];
}

- (void)initSocialButtons
{
    // 不喜欢
    SocialButton* dislikeButton = [[[SocialButton alloc] init] autorelease];
    [self.view addSubview:dislikeButton];
    dislikeButton.backgroundColor = RGB(72, 81, 113);
    dislikeButton.iconImage = [UIImage imageNamed:@"btn_dislike.png"];
    
    dislikeButton.digitLabel.hidden = YES;

    _dislikeButton = dislikeButton;
    
    CGRect frame = dislikeButton.frame;
    frame.origin = CGPointMake(15, AWFullScreenHeight() - 50 - CGRectGetHeight(frame) - 30);
    dislikeButton.frame = frame;
    
    [dislikeButton addTarget:self action:@selector(dislike)];
    
    // 喜欢过
    SocialButton* likedButton = [[[SocialButton alloc] init] autorelease];
    [self.view addSubview:likedButton];
    likedButton.backgroundColor = RGB(252, 130, 21);
    likedButton.iconImage = [UIImage imageNamed:@"btn_like.png"];
    likedButton.digit = 18000;
    
    _likeButton = likedButton;
    
    frame = dislikeButton.frame;
    frame.origin.x = AWFullScreenWidth() - CGRectGetMinX(dislikeButton.frame) - CGRectGetWidth(frame);
    likedButton.frame = frame;
    
    [likedButton addTarget:self action:@selector(like)];
    
    // 分享按钮
    UIButton* shareBtn = createImageButton(@"btn_share.png", self, @selector(gotoShare));
    [self.view addSubview:shareBtn];
    
    _shareButton = shareBtn;
    
    shareBtn.center = CGPointMake(CGRectGetMidX(self.view.bounds),
                                  CGRectGetMidY(dislikeButton.frame));
}

- (void)dislike
{
    _dislikeButton.userInteractionEnabled = NO;
    _likeButton.userInteractionEnabled = NO;
    
    [_upView moveOutFromLeft];
}

- (void)like
{
    _dislikeButton.userInteractionEnabled = NO;
    _likeButton.userInteractionEnabled = NO;
    
    [_upView moveOutFromRight];
}

- (void)gotoShare
{
    ShareViewController* svc = [[ShareViewController alloc] init];
    svc.media = self.currentMedia;
    [self presentViewController:svc animated:YES completion:nil];
}

- (void)draggableViewDidMoveOut:(MMDraggableView *)view
{
    _dislikeButton.userInteractionEnabled = YES;
    _likeButton.userInteractionEnabled = YES;
    
    [_likeButton resetAnimation:YES];
    [_dislikeButton resetAnimation:YES];
    
    MMDraggableView* temp = _upView;
    _upView = _bottomView;
    _bottomView = temp;
    
    _bottomView.userInteractionEnabled = NO;
    _bottomView.frame = _originFrame;
    
    _upView.userInteractionEnabled = YES;
    _upView.frame = _originFrame;
    
    [_contentView bringSubviewToFront:_upView];
    
    
    MediaTypeLoadInfo* info = [[MediaTypeLoadInfoManager sharedInstance] currentMediaInfoForType:_currentMediaType];
    
    info.currentMediaIndex ++;
    
    [self showGifForLoadInfo:info];
    
    // 如果需要就加载下一页数据
    [[MediaTypeLoadInfoManager sharedInstance] loadNextPageMediaInfosIfNeededForType:^(MediaTypeLoadInfo *info, BOOL succeed) {
        
    } forType:_currentMediaType];
    
}

- (void)draggableView:(MMDraggableView *)view positionDidChange:(CGPoint)position
{
//    CGFloat rotationStrength = MIN(position.x / AWFullScreenWidth(), 1);
    CGFloat scaleStrength = 1 + fabs(position.x / AWFullScreenWidth());
    CGFloat scale = MIN(scaleStrength, 1.20);
    
    if ( position.x > 0 ) {
        // 向右
        [_dislikeButton resetAnimation:NO];
        [_likeButton zoomIn:scale];
    } else {
        // 向左
        [_likeButton resetAnimation:NO];
        [_dislikeButton zoomIn:scale];
    }
}

- (void)draggableViewDidResetState:(MMDraggableView *)view
{
    [_likeButton resetAnimation:YES];
    [_dislikeButton resetAnimation:YES];
}

#define kButtonsCount 2
static NSString* buttonNames[kButtonsCount] = { @"daily", @"popular"};
- (void)initTopButtons
{
    CGFloat width = ( AWFullScreenWidth() - 20 * 2 ) / 4;
    CGFloat height = width * 0.6;
    for (int i=0; i<kButtonsCount; i++) {
        CategoryButton* cb = [[[CategoryButton alloc] init] autorelease];
        [self.view addSubview:cb];
        
        if ( i == 0 ) {
            cb.selected = YES;
        } else {
            cb.selected = NO;
        }
        
        cb.showingLeftSpliter = NO;
//        if ( i == kButtonsCount - 1 ) {
//            cb.showingRightSpliter = NO;
//        } else {
        cb.showingRightSpliter = YES;
//        }
        
        cb.normalImage = [UIImage imageNamed:[NSString stringWithFormat:@"btn_%@_blue.png", buttonNames[i]]];
        cb.selectedImage = [UIImage imageNamed:[NSString stringWithFormat:@"btn_%@_white.png", buttonNames[i]]];
        
        cb.frame = CGRectMake(20 + width * i, 56, width, height);
        
        [cb addTarget:self action:@selector(btnClicked:)];
        
        cb.tag = i + 100;
        
        _topButtonsMaxY = CGRectGetMaxY(cb.frame);
    }
    
    UIButton* likeBtn = createImageButton(@"btn_liked_blue.png", self, @selector(gotoFavorites));
    [likeBtn setImage:[UIImage imageNamed:@"btn_liked_white.png"] forState:UIControlStateHighlighted];
    [self.view addSubview:likeBtn];
    
    CGFloat btnHeight = CGRectGetHeight(likeBtn.bounds);
    
    likeBtn.frame = CGRectMake(20 + width * 2, 56, width, height);
    
    UIView* spliter = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(likeBtn.frame) - 1,
                                                               CGRectGetMidY(likeBtn.frame) - btnHeight / 2,
                                                               1,
                                                               btnHeight)];
    spliter.backgroundColor = RGB(56, 61, 78);
    [self.view addSubview:spliter];
    [spliter release];
    
    UIButton* settingBtn = createImageButton(@"btn_setting_blue.png", self, @selector(gotoSetting));
    [settingBtn setImage:[UIImage imageNamed:@"btn_setting_white.png"] forState:UIControlStateHighlighted];
    [self.view addSubview:settingBtn];
    settingBtn.frame = CGRectMake(20 + width * 3, 56, width, height);
}

- (void)gotoSetting
{
    SettingsViewController* svc = [[[SettingsViewController alloc] init] autorelease];
    [self presentViewController:svc animated:YES completion:nil];
}

- (void)gotoFavorites
{
    LikeListViewController* llvc = [[[LikeListViewController alloc] init] autorelease];
    [self presentViewController:llvc animated:YES completion:nil];
}

- (void)btnClicked:(CategoryButton *)sender
{
    NSInteger type = sender.tag - 100;
    if ( type < 2 ) {
//        [[AdsPopupManager sharedManager] showInterstitial];
        if ( ++_showingAdsCount == 3 ) {
            _showingAdsCount = 0;
            [[AdsPopupManager sharedManager] showInterstitial];
        }
        [self showGifsForType:type];
    } else {
        
    }
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    MMMediaView* upMediaView = (MMMediaView *)[_upView viewWithTag:1000];
    MMMediaView* bottomMediaView = (MMMediaView *)[_bottomView viewWithTag:1000];
    
    [upMediaView startPlayIfNeeded];
    [bottomMediaView startPlayIfNeeded];
    
    [[AdsPopupManager sharedManager] setViewController:[AWAppWindow() rootViewController]];
    
    [self bannerDidLoad];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    MMMediaView* upMediaView = (MMMediaView *)[_upView viewWithTag:1000];
    MMMediaView* bottomMediaView = (MMMediaView *)[_bottomView viewWithTag:1000];
    
    [upMediaView stopPlayIfNeeded];
    [bottomMediaView stopPlayIfNeeded];
}

- (void)bannerDidLoad
{
    CGRect bounds = [UIScreen mainScreen].bounds;
    
    if ( isLoad ) {
        [[AdsPopupManager sharedManager] showBannerAdAt:CGPointMake(0, CGRectGetHeight(bounds) - 50) ];
    } else {
        
    }
}

- (void)didStartLoading:(MMMediaView *)view
{
    _shareButton.enabled = NO;
}

- (void)mediaView:(MMMediaView *)view didFinishLoading:(BOOL)succeed
{
    _shareButton.enabled = succeed;
}

- (void)showGifForLoadInfo:(MediaTypeLoadInfo *)info
{
    _upView.hidden = _bottomView.hidden = NO;
    
    _shareButton.enabled = YES;
    
    static NSOperationQueue* _operationQueue = nil;
    if ( !_operationQueue ) {
        _operationQueue = [[NSOperationQueue alloc] init];
    }
    
    self.currentMedia = nil;
    _upView.currentMedia = nil;
    
    if ( info.currentMediaIndex + 1 < [info.dataSource count] ) {
        
        Media* firstMedia = [[[Media alloc] initWithDictionary:info.dataSource[info.currentMediaIndex]] autorelease];
        Media* nextMedia = [[[Media alloc] initWithDictionary:info.dataSource[info.currentMediaIndex + 1]] autorelease];
        
        self.currentMedia = firstMedia;
        
        _dislikeButton.digit = [firstMedia.dislikeCount integerValue];
        _likeButton.digit = [firstMedia.likeCount integerValue];
        
        MMMediaView* upMediaView = (MMMediaView *)[_upView viewWithTag:1000];
        MMMediaView* bottomMediaView = (MMMediaView *)[_bottomView viewWithTag:1000];
        
        upMediaView.delegate = self;
        bottomMediaView.delegate = nil;
        
        upMediaView.media = firstMedia;
        bottomMediaView.media = nextMedia;
        
        _upView.currentMedia = firstMedia;
        
        if ( upMediaView.operation && bottomMediaView.operation ) {
            [bottomMediaView.operation addDependency:upMediaView.operation];
        }
        
        NSMutableArray* operations = [NSMutableArray array];
        if ( upMediaView.operation ) {
            [operations addObject:upMediaView.operation];
        }
        
        if ( bottomMediaView.operation ) {
            [operations addObject:bottomMediaView.operation];
        }
        
        [_operationQueue addOperations:operations waitUntilFinished:NO];
    }
}

@end
