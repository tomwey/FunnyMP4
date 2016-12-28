//
//  AdsPopupManager.m
//
//  Created by tang.wei on 13-11-8.
//  Copyright (c) 2013年 yixing. All rights reserved.
//

#import "AdsPopupManager.h"
#import "NewsBlast.h"
#import "MPInterstitialAdController.h"
#import "MPAdView.h"
#import <Chartboost/Chartboost.h>

#define IPHONE_FULLSCREEN_ID @"4f73dc0246da45818921e17cacdae097"
#define IPAD_FULLSCREEN_ID   @""
#define IPHONE_BANNER_ID     @"d09f2c8b25674d77aa502a6de1016c3d"
#define IPAD_BANNER_ID       @""

#define IPHONE_MEDIUM_RECT_ID @""
#define IPAD_MEDIUM_RECT_ID   @""

///////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - BannerContainer class
///////////////////////////////////////////////////////////////////////////////////////////////
/********************** 此类用于处理UITouch向下传递的问题 **************************/
@interface BannerContainer : UIView

@end

@implementation BannerContainer

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
    }
    
    return self;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {}
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {}
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {}

@end

///////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - AdsPopupManager class
///////////////////////////////////////////////////////////////////////////////////////////////
@interface AdsPopupManager () <MPAdViewDelegate, MPInterstitialAdControllerDelegate>
{
    BOOL    _newsBlastIsShowing;
    
    BOOL    _InterstitialIsShowing;
    BOOL    _canShowInterstitial;
    // 用于first load
    BOOL    _shouldShowInterstitial;
    BOOL    _canLoadingInterstitial;
    
    CGFloat         _bannerHeight;
    BOOL            _bannerIsShowing;
    
    BannerContainer *_container;
    BOOL            _bannerHasLoaded;
    
    CGRect          _bannerFrame;
}

// 横幅广告
@property (nonatomic, retain) MPAdView *adView;
// 全屏广告
@property (nonatomic, retain) MPInterstitialAdController *interstitialController;

// 方块广告
@property (nonatomic, retain) MPAdView *rectADView;

@end

@implementation AdsPopupManager

@synthesize viewController = _viewController, delegate, adView, interstitialController, rectADView;
@synthesize bannerAdPosition = _bannerAdPosition;

+ (AdsPopupManager *)sharedManager
{
    static AdsPopupManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!instance) {
            instance = [[AdsPopupManager alloc] init];
        }
    });
    return instance;
}

- (id)init
{
    if (self = [super init]) {
        _newsBlastIsShowing = _InterstitialIsShowing = _bannerIsShowing = _bannerHasLoaded = NO;
        _canShowInterstitial = YES;
        _bannerAdPosition = BannerAdPositionBottom;
        
        _canLoadingInterstitial = YES;
        
        _bannerFrame = CGRectZero;
        
//        [[NSNotificationCenter defaultCenter] addObserver:self
//                                                 selector:@selector(startChartboostSession)
//                                                     name:UIApplicationDidBecomeActiveNotification
//                                                   object:nil];
    }
    return self;
}

// 因为不是严格的单例
// 如果用init初始化，那么需要手动管理内存
- (void)dealloc
{
    self.adView = nil;
    self.rectADView = nil;
    self.interstitialController = nil;
    [_container release];
    _container = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [super dealloc];
}

///////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Private methods
///////////////////////////////////////////////////////////////////////////////////////////////
- (void)loadInterstitialForID:(NSString *)interstitialId
{
    _shouldShowInterstitial = NO;
    if (!self.interstitialController) {
        self.interstitialController =
        [MPInterstitialAdController interstitialAdControllerForAdUnitId:interstitialId];
        self.interstitialController.delegate = self;
    }
    
    [self.interstitialController loadAd];
}

- (void)loadBannerForID:(NSString *)bannerId
{
    if (!self.adView) {
        self.adView = [[[MPAdView alloc] initWithAdUnitId:bannerId
                                                     size:[self bannerSize]] autorelease];
        self.adView.delegate = self;
    }
    
    [self.adView loadAd];
}

- (CGSize)bannerSize
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        return MOPUB_BANNER_SIZE;
    }
    return MOPUB_LEADERBOARD_SIZE;
}

- (CGRect)adViewFrame
{
    CGRect frame = self.adView.frame;
    CGSize size = [self bannerSize];//[self.adView adContentViewSize];
    frame.origin.x += (CGRectGetWidth([self getMainscreenBounds]) - size.width) / 2;
//    frame.origin.y = _bannerAdPosition == BannerAdPositionTop ? 0.0 :
//    CGRectGetHeight([self getMainscreenBounds]) - size.height;
    // iOS7 状态条有问题
    if ([[[UIDevice currentDevice] systemVersion] compare:@"7.0" options:NSNumericSearch] == NSOrderedAscending) {
        frame.origin.y = _bannerAdPosition == BannerAdPositionTop ? 0.0 :
        CGRectGetHeight([self getMainscreenBounds]) - size.height;
    } else {
        frame.origin.y = _bannerAdPosition == BannerAdPositionTop ? 0.0 :
        CGRectGetHeight([self getMainscreenBounds]) - size.height + [self getStatusBarHeight];
    }
    
    frame.size = size;
    
    return frame;
}

- (CGFloat)getStatusBarHeight
{
    if (UIInterfaceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation])) {
        return [[UIApplication sharedApplication] statusBarFrame].size.width;
    }
    
    return [[UIApplication sharedApplication] statusBarFrame].size.height;
}

- (CGRect)getMainscreenBounds
{
    CGRect frame = [[UIScreen mainScreen] applicationFrame];
    if (UIInterfaceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation])) {
        frame = CGRectMake(0, 0, frame.size.height, frame.size.width);
    }
    return frame;
}

- (UIWindow *)getWindow
{
    return [[[UIApplication sharedApplication] windows] objectAtIndex:0];
}

- (void)addBannerIfNeeded
{
    if (!self.adView.superview) {
        if (!_container) {
            _container = [[BannerContainer alloc] init];
            _container.userInteractionEnabled = NO;
        }
        
        
        _container.hidden = YES;
        
        if (!_container.superview) {
            [self.viewController.view addSubview:_container];
        }
        
//        _container.frame = [self adViewFrame];
//        self.adView.frame = _container.bounds;
        
        [_container addSubview:self.adView];
        
        _bannerIsShowing = YES;
    } else {
        if (_bannerHasLoaded)
            _container.userInteractionEnabled = YES;
    }
}

//- (void)startChartboostSession
//{
//    // NSAssert((CHARTBOOST_APP_ID.length > 0 && CHARTBOOST_APP_SIGNATURE.length > 0),@"你还没设置appId和appSignature,请到AppConfigs.h这个文件里面进行设置");
//    if (CHARTBOOST_APP_ID.length > 0 && CHARTBOOST_APP_SIGNATURE.length > 0) {
//        Chartboost *chartboost = [Chartboost sharedChartboost];
//        chartboost.appId = CHARTBOOST_APP_ID;
//        chartboost.appSignature = CHARTBOOST_APP_SIGNATURE;
//        [chartboost startSession];
//    }
//}

///////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Getter methods
///////////////////////////////////////////////////////////////////////////////////////////////
- (UIViewController *)viewController
{
    if (!_viewController) {
        _viewController = [[self getWindow] rootViewController];
    }
    NSAssert(!!_viewController, @"没有设置viewController,请先设置");
    return _viewController;
}

- (void)setViewController:(UIViewController *)viewController
{
    if (_viewController != viewController) {
        _viewController = viewController;
        
        // 移除重新添加
        [self.adView removeFromSuperview];
        [_container removeFromSuperview];
        
//        [self showBannerAd];
    }
}

- (BOOL)isIphone
{
    return UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone;
}

///////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Public methods
- (void)preloadAllAds
{
    // 加载全屏
    NSString *interstitialId = [self isIphone] ? IPHONE_FULLSCREEN_ID : IPAD_FULLSCREEN_ID;
//    NSAssert(interstitialId.length > 0, @"还没设置interstitial id，请到AppConfigs.h文件里面进行设置");
    
    if ( interstitialId.length > 0 ) {
        [self loadInterstitialForID:interstitialId];
    }
    
    // 加载横幅
    NSString *bannerId = [self isIphone] ? IPHONE_BANNER_ID : IPAD_BANNER_ID;
    // NSAssert(bannerId.length > 0, @"还没设置banner id，请到AppConfigs.h文件里面进行设置");
    if (bannerId.length > 0) {
      [self loadBannerForID:bannerId];
    }
    
    // 加载方块广告
    NSString *rectId = [self isIphone] ? IPHONE_MEDIUM_RECT_ID : IPAD_MEDIUM_RECT_ID;
    if (rectId.length > 0) {
        [self preloadMediumRectAdForId:rectId];
    }
}

- (void)preloadMediumRectAdForId:(NSString *)adsID
{
    if (!self.rectADView) {
        self.rectADView = [[[MPAdView alloc] initWithAdUnitId:adsID
                                                     size:MOPUB_MEDIUM_RECT_SIZE] autorelease];
        self.rectADView.delegate = self;
    }
    
    [self.rectADView loadAd];
}

- (void)showMediumRectAd
{
    CGPoint point = CGPointMake(CGRectGetWidth([self getMainscreenBounds]) * 0.5,
                                CGRectGetHeight([self getMainscreenBounds]) * 0.5);
    [self showMediumRectAdAtPoint:point];
}

- (void)showMediumRectAdAtPoint:(CGPoint)center
{
    if (!self.rectADView.superview) {
        [self.viewController.view addSubview:self.rectADView];
        self.rectADView.bounds = CGRectMake(0, 0, MOPUB_MEDIUM_RECT_SIZE.width, MOPUB_MEDIUM_RECT_SIZE.height);
    }
    
    self.rectADView.hidden = NO;
    self.rectADView.center = center;
    [self.viewController.view bringSubviewToFront:self.rectADView];
    
    [self.rectADView startAutomaticallyRefreshingContents];
}

// 设置广告的frame
- (void)showMediumRectAdAtFrame:(CGRect)frame
{
    if (!self.rectADView.superview) {
        [self.viewController.view addSubview:self.rectADView];
        self.rectADView.bounds = CGRectMake(0, 0, MOPUB_MEDIUM_RECT_SIZE.width, MOPUB_MEDIUM_RECT_SIZE.height);
    }
    
    self.rectADView.hidden = NO;
    self.rectADView.frame = frame;
    [self.viewController.view bringSubviewToFront:self.rectADView];
    
    [self.rectADView startAutomaticallyRefreshingContents];
}

- (void)hideMediumRectAd
{
    [self.rectADView stopAutomaticallyRefreshingContents];
    self.rectADView.hidden = YES;
}

- (void)removeMediumRectAd
{
    self.rectADView.delegate = nil;
    [self.rectADView removeFromSuperview];
    self.rectADView = nil;
}

- (void)showBannerAd
{
    
    [self addBannerIfNeeded];
		
    if (_bannerHasLoaded) {
        _container.userInteractionEnabled = YES;
    }
    
    _container.hidden = NO;
    
    [_container.superview bringSubviewToFront:_container];
    [self.adView startAutomaticallyRefreshingContents];
    
    //_bannerHeight = [self.adView adContentViewSize].height;
    _bannerIsShowing = YES;
}

- (void)showBannerAdAt:(CGPoint)position
{
    [self showBannerAd];
    
    CGRect frame = CGRectMake(0, 0, [self bannerSize].width, [self bannerSize].height);
    position.x = CGRectGetWidth([[UIScreen mainScreen] bounds]) / 2 - [self bannerSize].width/2;
    frame.origin = position;
    _container.frame = frame;
    
    self.adView.frame = _container.bounds;
    
    _container.hidden = !_bannerHasLoaded;
}

- (void)hideBannerAd
{
    _container.hidden = YES;
    _container.userInteractionEnabled = NO;
    
    [self.adView stopAutomaticallyRefreshingContents];
    
//    _bannerHeight = 0.0;
    _bannerIsShowing = NO;
}

- (void)removeBannerAd
{
    [self.adView removeFromSuperview];
    [_container removeFromSuperview];
    self.adView.delegate = nil;
    self.adView = nil;
    
    [_container release];
    _container = nil;
    
    _bannerHeight = 0.0;
    _bannerIsShowing = NO;
    
    // 暂时对于全屏也这样处理
    // 不想增加更多接口
    self.interstitialController = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (CGFloat)bannerHeight { return _bannerHeight; }
- (BOOL)bannerIsShowing { return _bannerIsShowing; }

- (void)showInterstitial
{
    if (_InterstitialIsShowing || _newsBlastIsShowing) {
        return;
    }
    
    NSLog(@"Showing ads");
    
    _shouldShowInterstitial = YES;
    _canShowInterstitial = YES;
    
    [[NewsBlast shareNews] cancelShowNewsBlast];
    
    if (self.interstitialController.ready) {
        [self.interstitialController showFromViewController:self.viewController];
    }else{
        if (_canLoadingInterstitial) {
            // 正在加载所以下次不加载
            _canLoadingInterstitial = NO;
            NSLog(@"没准备好重新加载全屏");
            [self.interstitialController loadAd];
        }
    }
}

- (void)dismissInterstitial
{
    if (!_InterstitialIsShowing) {
        return;
    }
    UIWindow *window = [[[UIApplication sharedApplication] windows] objectAtIndex:0];
    for (UIView *view in [window subviews]) {
        if ([view isKindOfClass:NSClassFromString(@"CBNativeInterstitialView")]) {
            [view performSelector:@selector(close:) withObject:nil];
        }
    }
}

- (BOOL)interstitialIsShowing { return _InterstitialIsShowing; }

- (void)showNewsBlast
{
    [self showNewsBlast:InvokeModeLaunch];
}

- (void)showNewsBlastOnResume
{
    [self showNewsBlast:InvokeModeResume];
}

- (void)showNewsBlast:(InvokeMode)mode
{
    [self dismissInterstitial];
    
    if (_newsBlastIsShowing || _InterstitialIsShowing) {
        return;
    }
    
    _canShowInterstitial = NO;
    NSLog(@"Loading news blast");
    
    [[NewsBlast shareNews] setInvokeMode:mode];
    [[NewsBlast shareNews] setDelegate:self];
    [[NewsBlast shareNews] sendNews];
}

///////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - newsblast delegate
///////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL)shouldDisplayNewsBlast
{
    return !_InterstitialIsShowing;
}

- (void)viewDidShow:(NewsBlast *)newsBlast
{
    _newsBlastIsShowing = YES;
    if ([self.delegate respondsToSelector:@selector(newsblastDidShow)]) {
        [self.delegate newsblastDidShow];
    }
}

- (void)viewDidNotShow:(NewsBlast *)newsBlast
{
    _newsBlastIsShowing = NO;
    if ([self.delegate respondsToSelector:@selector(newsblastDidNotShow)]) {
        [self.delegate newsblastDidNotShow];
    }
}

- (void)viewDidClickCancel:(NewsBlast *)newsBlast
{
    _newsBlastIsShowing = NO;
    if ([self.delegate respondsToSelector:@selector(newsblastDidClickCancel)]) {
        [self.delegate newsblastDidClickCancel];
    }
}

- (void)viewDidClickOK:(NewsBlast *)newsBlast
{
    _newsBlastIsShowing = NO;
    if ([self.delegate respondsToSelector:@selector(newsblastDidClickOK)]) {
        [self.delegate newsblastDidClickOK];
    }
}
///////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Banner delegate
///////////////////////////////////////////////////////////////////////////////////////////////
- (UIViewController *)viewControllerForPresentingModalView
{
    return self.viewController;
}

- (void)adViewDidLoadAd:(MPAdView *)view
{
    NSLog(@"%s",__func__);
    _container.userInteractionEnabled = YES;
    _bannerHasLoaded = YES;
    
    if ( _bannerIsShowing ) {
        _container.hidden = NO;
    } else {
        _container.hidden = YES;
    }
    
    _bannerHeight = [self bannerSize].height;
    
    if (view == self.adView) {
        if ([self.delegate respondsToSelector:@selector(bannerAdDidLoad)]) {
            [self.delegate bannerAdDidLoad];
        }
    } else if (view == self.rectADView) {
        if ([self.delegate respondsToSelector:@selector(mediumRectAdDidLoad)]) {
            [self.delegate mediumRectAdDidLoad];
        }
    }
    
}

- (void)adViewDidFailToLoadAd:(MPAdView *)view
{
    NSLog(@"%s",__func__);

    if (view == self.adView) {
        if ([self.delegate respondsToSelector:@selector(bannerAdDidFailToLoad)]) {
            [self.delegate bannerAdDidFailToLoad];
        }
    } else if (view == self.rectADView) {
        if ([self.delegate respondsToSelector:@selector(mediumRectAdDidFailToLoad)]) {
            [self.delegate mediumRectAdDidFailToLoad];
        }
    }
    
    _bannerIsShowing = NO;
}

- (void)willPresentModalViewForAd:(MPAdView *)view
{
    //    _bannerIsShowing = YES;
    
    if (view == self.adView) {
        if ([self.delegate respondsToSelector:@selector(willPresentModalViewForBanner)]) {
            [self.delegate willPresentModalViewForBanner];
        }
    } else if (view == self.rectADView) {
        if ([self.delegate respondsToSelector:@selector(willPresentModalViewForMediumRectAd)]) {
            [self.delegate willPresentModalViewForMediumRectAd];
        }
    }
}

- (void)didDismissModalViewForAd:(MPAdView *)view
{
    //    _bannerIsShowing = NO;
    
    if (view == self.adView) {
        if ([self.delegate respondsToSelector:@selector(didDismissModalViewForBanner)]) {
            [self.delegate didDismissModalViewForBanner];
        }
    } else if (view == self.rectADView) {
        if ([self.delegate respondsToSelector:@selector(didDismissModalViewForMediumRectAd)]) {
            [self.delegate didDismissModalViewForMediumRectAd];
        }
    }
}

- (void)willLeaveApplicationFromAd:(MPAdView *)view
{
    
    if (view == self.adView) {
        if ([self.delegate respondsToSelector:@selector(willLeaveApplicationFromBanner)]) {
            [self.delegate willLeaveApplicationFromBanner];
        }
    } else if (view == self.rectADView) {
        if ([self.delegate respondsToSelector:@selector(willLeaveApplicationFromMediumRectAd)]) {
            [self.delegate willLeaveApplicationFromMediumRectAd];
        }
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - interstitial delegate
///////////////////////////////////////////////////////////////////////////////////////////////
- (void)interstitialDidLoadAd:(MPInterstitialAdController *)interstitial
{
    NSLog(@"%s",__func__);
    _canLoadingInterstitial = YES;
    if (_shouldShowInterstitial && (_canShowInterstitial && !_newsBlastIsShowing )) {
        if (self.interstitialController.ready) {
            [self.interstitialController showFromViewController:self.viewController];
        }
    }
}

- (void)interstitialDidFailToLoadAd:(MPInterstitialAdController *)interstitial
{
    
    NSLog(@"%s",__func__);
    _canLoadingInterstitial = YES;
    _InterstitialIsShowing = NO;
    if ([self.delegate respondsToSelector:@selector(interstitialDidFailToLoad)]) {
        [self.delegate interstitialDidFailToLoad];
    }
}

- (void)interstitialDidExpire:(MPInterstitialAdController *)interstitial
{
    
    NSLog(@"%s",__func__);
    _InterstitialIsShowing = NO;
}

- (void)interstitialWillAppear:(MPInterstitialAdController *)interstitial
{
    
}

- (void)interstitialDidAppear:(MPInterstitialAdController *)interstitial
{
    _InterstitialIsShowing = YES;
    if ([self.delegate respondsToSelector:@selector(interstitialDidShow)]) {
        [self.delegate interstitialDidShow];
    }
}

- (void)interstitialWillDisappear:(MPInterstitialAdController *)interstitial
{
    
}

- (void)interstitialDidDisappear:(MPInterstitialAdController *)interstitial
{
    _InterstitialIsShowing = NO;
    _shouldShowInterstitial = NO;
    if ([self.delegate respondsToSelector:@selector(interstitialDidDismiss)]) {
        [self.delegate interstitialDidDismiss];
    }
    if (!self.interstitialController.ready) {
        [self.interstitialController loadAd];
    }
}

@end
