//
//  FacebookOauthView.m
//
//  Created by yanglei on 12-8-23.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "FacebookOauthView.h"
#import <QuartzCore/QuartzCore.h>
#import "SRHttpFetcher.h"
#import "JSON.h"
#import "Facebook.h"
#import "sys/utsname.h"

#define SAFE_Release(p)	if(p) { [p release]; p = nil; }
#define FB_OauthAlert_Title @"Authorize Failed"
#define FB_OauthAlert_Message @"Please try again later."

#define deviceIsIpad ([[[UIDevice currentDevice] model] hasPrefix:@"iPad"] && [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)

static float screenWidth = 0.0f;
static float screenHeight = 0.0f;

@interface FacebookOauthView(PrivateMethods)

/*对象初始化*/
- (id)initWithFrame:(CGRect)frame delegate:(id)_delegate animation:(FBAnimationType)animation;

/*初始化元素*/
- (void)initElementsForView;

/*根据设备和方向设置元素坐标*/
- (void)initCoordinates;

/*显示View*/
- (void)startDisplayAnimation;

/*隐藏View*/
- (void)startDismissAnimation;

/*弹出错误的提示*/
- (void)alertFailTipView;

/*解析Json为Dictionary*/
- (NSMutableDictionary *)parseToDictionaryWithJsonData:(NSData *)jsonData;

/*移除自身*/
- (void)removeMe;

@end

@implementation FacebookOauthView
@synthesize delegate;

/*弹出授权界面*/
+ (void)showInView:(UIView *)view delegate:(id)_delegate animation:(FBAnimationType)animation{
//    [FacebookOauthView checkDisplayTye];
    screenWidth = CGRectGetWidth([[UIScreen mainScreen] bounds]);
    screenHeight = CGRectGetHeight([[UIScreen mainScreen] bounds]);
    FacebookOauthView *oauthView = [[FacebookOauthView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight) delegate:_delegate animation:animation];
    [view addSubview:oauthView];
    [oauthView release];
}


- (id)initWithFrame:(CGRect)frame delegate:(id)_delegate animation:(FBAnimationType)animation{
    if(self = [super initWithFrame:frame]){
        self.delegate = _delegate;
        self.backgroundColor = [UIColor clearColor];
        animationType = animation;
        [Facebook removeAuthorizedCacheInfo];
        [[NSNotificationCenter defaultCenter] addObserver:self 
                                                 selector:@selector(deviceOrientationDidChange:) 
                                                     name:@"UIInterfaceOrientationDidChangeNotification"
                                                   object:nil];
        [self initElementsForView];
        [self startDisplayAnimation];
        [oauthWeb loadRequest:[FacebookAPI createAccessTokenRequest]];
    }
    return self;
    
}

- (void)dealloc{
    SAFE_Release(oauthWeb);
    SAFE_Release(background);
    SAFE_Release(loadingView);
    SAFE_Release(navigation);
    [super dealloc];
}

#pragma mark - Category Methods
/*判断屏幕的类型*/
+ (FBDisplayType)checkDisplayTye{
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    FBDisplayType displayType;
    if(deviceIsIpad){
        if(UIInterfaceOrientationIsLandscape(orientation)){
            displayType = FBDisplayIpadLandscape;
            screenWidth = [UIApplication sharedApplication].statusBarHidden?1024.0:(1024.0-20.0);
            screenHeight = [UIApplication sharedApplication].statusBarHidden?768.0:(768.0-20.0);
        }
        else{
            displayType = FBDisplayIpadportrait;
            screenWidth = [UIApplication sharedApplication].statusBarHidden?768.0:(768.0-20.0);
            screenHeight = [UIApplication sharedApplication].statusBarHidden?1024.0:(1024.0-20.0);
        }
    }
    else{
        if([FacebookOauthView isIphone5]){
            if(UIInterfaceOrientationIsLandscape(orientation)){
                displayType = FBDisplayIphone5Landscape;
                screenWidth = [UIApplication sharedApplication].statusBarHidden?568.0:(568.0-20.0);
                screenHeight = [UIApplication sharedApplication].statusBarHidden?320.0:(320.0-20.0);
            }
            else{
                displayType = FBDisplayIphone5portrait;
//                screenWidth = [UIApplication sharedApplication].statusBarHidden?320.0:(320.0-20.0);
                screenHeight = [UIApplication sharedApplication].statusBarHidden?568.0:(568.0-20.0);
                screenWidth = 320;
            }
        }else{
            if(UIInterfaceOrientationIsLandscape(orientation)){
                displayType = FBDisplayIphoneLandscape;
                screenWidth = [UIApplication sharedApplication].statusBarHidden?480.0:(480.0-20.0);
                screenHeight = [UIApplication sharedApplication].statusBarHidden?320.0:(320.0-20.0);
            }
            else{
                displayType = FBDisplayIphoneportrait;
//                screenWidth = [UIApplication sharedApplication].statusBarHidden?320.0:(320.0-20.0);
                screenHeight = [UIApplication sharedApplication].statusBarHidden?480.0:(480.0-20.0);
                screenWidth = 320;
            }
        }
    }
    return displayType;
}

/*判断是否是Iphone5*/
+ (BOOL)isIphone5{
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *machine =[NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    if([machine hasPrefix:@"iPhone5"])
        return YES;
    if([UIScreen mainScreen].bounds.size.height  == 568)
        return YES;
    
    return NO;
}

#pragma mark - Private Methods

/*根据设备和方向设置元素坐标*/
- (void)initCoordinates{
    FBDisplayType displayType = FBDisplayIphoneportrait;//[FacebookOauthView checkDisplayTye];
    switch (displayType) {
        case FBDisplayIphoneLandscape:
            bgImg =  [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"fb_h.png" ofType:nil]];
            loadingFrame = CGRectMake((screenWidth-220.0)/2.0, 220.0, 220.0, 80.0);
            break;
            
        case FBDisplayIphoneportrait:
            bgImg =  [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"fb_v.png" ofType:nil]];
            loadingFrame = CGRectMake((screenWidth-220.0)/2.0, 340.0, 220.0, 80.0);
            break;
            
        case FBDisplayIphone5Landscape:
            bgImg =  [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"fb_h-i5.png" ofType:nil]];
            loadingFrame = CGRectMake((screenWidth-220.0)/2.0, 220.0, 220.0, 80.0);
            break;
            
        case FBDisplayIphone5portrait:
            bgImg =  [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"fb_v-i5.png" ofType:nil]];
            loadingFrame = CGRectMake((screenWidth-220.0)/2.0, 380.0, 220.0, 80.0);
            break;
            
        case FBDisplayIpadLandscape:
            bgImg =  [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"fb_ipad_h.png" ofType:nil]];
            loadingFrame = CGRectMake((screenWidth-410.0)/2.0, 545.0, 410.0, 150.0);
            break;
            
        case FBDisplayIpadportrait:
            bgImg =  [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"fb_ipad_h.png" ofType:nil]];
            loadingFrame = CGRectMake((screenWidth-410.0)/2.0, 760.0, 410.0, 150.0);
            break;
    }
}

- (void)initElementsForView{
    [self initCoordinates];
    
    /*添加WebView*/
    oauthWeb = [[UIWebView alloc] initWithFrame:CGRectMake(0, 44, screenWidth,screenHeight-44)];
    oauthWeb.delegate = self;
    [self addSubview:oauthWeb];
    
    /*添加背景*/
    background = [[UIImageView alloc] initWithFrame:CGRectMake(0, [UIApplication sharedApplication].statusBarHidden ? 0 : 20,screenWidth, screenHeight)];
    background.image = bgImg;
    background.alpha = 0.6f;
    background.userInteractionEnabled = YES;
    [self addSubview:background];
    
    /*添加Loading*/
    loadingView = [[UIView alloc] initWithFrame:loadingFrame];
    loadingView.userInteractionEnabled = YES;
    loadingView.backgroundColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.7f];
    loadingView.layer.borderColor = [UIColor blackColor].CGColor;
    loadingView.layer.cornerRadius = 10.0;
    loadingView.layer.masksToBounds = YES;
    [self addSubview:loadingView];
    
    UILabel *tip = [[UILabel alloc] initWithFrame:loadingView.bounds];
    tip.backgroundColor = [UIColor clearColor];
    tip.textAlignment = NSTextAlignmentCenter;
    tip.textColor = [UIColor whiteColor];
    tip.text = @"Please Wait...";
    tip.font = [UIFont fontWithName:@"Helvetica-Bold" size:deviceIsIpad?25.0f:17.0f];
    [loadingView addSubview:tip];
    [tip release];
    
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:deviceIsIpad?UIActivityIndicatorViewStyleWhiteLarge:UIActivityIndicatorViewStyleWhite];
    indicator.frame = deviceIsIpad?CGRectMake(75, 56, 37, 37):CGRectMake(28, 30, 20, 20);
    [indicator startAnimating];
    [loadingView addSubview:indicator];
    [indicator release];
    
    /*添加Navigation*/
    navigation = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, [UIApplication sharedApplication].statusBarHidden ? 0 : 20,screenWidth, 44)];
    navigation.barStyle = UIBarStyleBlack;
    [self addSubview:navigation];
    
    //////
    CGRect frame = oauthWeb.frame;
    frame.origin.y = navigation.frame.origin.y + navigation.bounds.size.height;
    oauthWeb.frame = frame;
    //////
    
    UINavigationItem *item = [[UINavigationItem alloc] initWithTitle:@"Facebook Authorize"];
    UIBarButtonItem *cancelButton =  [[UIBarButtonItem alloc]  
                                      initWithTitle:@"Cancel"
                                      style: UIBarButtonItemStylePlain  
                                      target: self  
                                      action: @selector(cancelPressed:)  
                                      ]; 
    item.rightBarButtonItem =  cancelButton;
    [cancelButton release];
    navigation.items = [NSArray arrayWithObject:item];
    [item release];
}

- (void)startDisplayAnimation{
    switch (animationType) {
        case FBAnimationNone:
            self.center = CGPointMake(CGRectGetWidth(self.frame)/2.0, CGRectGetHeight(self.frame)/2.0);
            break;
            
        case FBAnimationBottomTop:{
            self.center = CGPointMake(CGRectGetWidth(self.frame)/2.0, CGRectGetHeight(self.frame)/2.0*3.0);
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:.3];
            self.center = CGPointMake(CGRectGetWidth(self.frame)/2.0, CGRectGetHeight(self.frame)/2.0);
            [UIView commitAnimations];
            break;
        }
        case FBAnimationTopBottom:{
            self.center = CGPointMake(CGRectGetWidth(self.frame)/2.0, -CGRectGetHeight(self.frame)/2.0);
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:.3];
            self.center = CGPointMake(CGRectGetWidth(self.frame)/2.0, CGRectGetHeight(self.frame)/2.0);
            [UIView commitAnimations];
            break;
        }
        case FBAnimationLeftRight:{
            self.center = CGPointMake(-CGRectGetWidth(self.frame)/2.0, CGRectGetHeight(self.frame)/2.0);
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:.3];
            self.center = CGPointMake(CGRectGetWidth(self.frame)/2.0, CGRectGetHeight(self.frame)/2.0);
            [UIView commitAnimations];
            break;
        }
        case FBAnimationRightLeft:{
            self.center = CGPointMake(CGRectGetWidth(self.frame)/2.0*3.0, CGRectGetHeight(self.frame)/2.0);
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:.3];
            self.center = CGPointMake(CGRectGetWidth(self.frame)/2.0, CGRectGetHeight(self.frame)/2.0);
            [UIView commitAnimations];
            break;
        }
        case FBAnimationAlert:{
            self.center = CGPointMake(CGRectGetWidth(self.frame)/2.0, CGRectGetHeight(self.frame)/2.0);
            self.transform = CGAffineTransformMakeScale(0.3, 0.3);
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:.2];
            self.transform = CGAffineTransformMakeScale(1.0, 1.0);
            [UIView commitAnimations];
            break;
        }
    }
    
}

- (void)startDismissAnimation{
    self.delegate = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"UIInterfaceOrientationDidChangeNotification" object:nil];
    switch (animationType) {
        case FBAnimationNone:
            [self removeMe];
            break;
            
        case FBAnimationBottomTop:{
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:.3];
            [UIView setAnimationDelegate:self];
            [UIView setAnimationDidStopSelector:@selector(removeMe)];
            self.center = CGPointMake(CGRectGetWidth(self.frame)/2.0, CGRectGetHeight(self.frame)/2.0*3.0);
            [UIView commitAnimations];
            break;
        }
        case FBAnimationTopBottom:{
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:.3];
            [UIView setAnimationDelegate:self];
            [UIView setAnimationDidStopSelector:@selector(removeMe)];
            self.center = CGPointMake(CGRectGetWidth(self.frame)/2.0, -CGRectGetHeight(self.frame)/2.0);
            [UIView commitAnimations];
            break;
        }
        case FBAnimationLeftRight:{
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:.3];
            [UIView setAnimationDelegate:self];
            [UIView setAnimationDidStopSelector:@selector(removeMe)];
            self.center = CGPointMake(-CGRectGetWidth(self.frame)/2.0, CGRectGetHeight(self.frame)/2.0);
            [UIView commitAnimations];
            break;
        }
        case FBAnimationRightLeft:{
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:.3];
            [UIView setAnimationDelegate:self];
            [UIView setAnimationDidStopSelector:@selector(removeMe)];
            self.center = CGPointMake(CGRectGetWidth(self.frame)/2.0*3.0, CGRectGetHeight(self.frame)/2.0);
            [UIView commitAnimations];
            break;
        }
        case FBAnimationAlert:{
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:.2];
            [UIView setAnimationDelegate:self];
            [UIView setAnimationDidStopSelector:@selector(removeMe)];
            self.transform = CGAffineTransformMakeScale(0.3, 0.3);
            [UIView commitAnimations];
            break;
        }
    }
}

- (void)removeMe{
    [self removeFromSuperview];
}

/*弹出错误的提示*/
- (void)alertFailTipView{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Share Failed!"
                                                    message:nil
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
    [alert release];
}

/*解析Json为Dictionary*/
- (NSMutableDictionary *)parseToDictionaryWithJsonData:(NSData *)jsonData{
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSError *error = nil;
    SBJSON *parser = [SBJSON new];
    NSMutableDictionary *response = [NSMutableDictionary dictionaryWithDictionary:[parser objectWithString:jsonString error:&error]];
    if(error)
        response = [NSMutableDictionary dictionaryWithCapacity:0];
    [jsonString release];
    [parser release];
    
    return response;
}

#pragma mark - KVC Methods
- (void)deviceOrientationDidChange:(id)notification{
    CGFloat duration = [UIApplication sharedApplication].statusBarOrientationAnimationDuration;
    [self initCoordinates];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:duration];
    self.frame = CGRectMake(0, 0, screenWidth, screenHeight);
    oauthWeb.frame = CGRectMake(0, 44, screenWidth, screenHeight-44);
    background.image = bgImg;
    background.frame = CGRectMake(0, 0, bgImg.size.width, bgImg.size.height);
    
    loadingView.frame = loadingFrame;
    navigation.frame = CGRectMake(0, 0, screenWidth, 44);
    [UIView commitAnimations];
}

#pragma mark - Button Functions
- (void)cancelPressed:(id)sender{
    [self startDismissAnimation];
}

#pragma mark - UIWebViewDelegate Method
- (BOOL)webView:(UIWebView *)webview shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    NSString *url = [request.URL description];
    if([url hasPrefix:FB_CallBackHook]){
        NSArray *parase = [url componentsSeparatedByString:@"#"];
        if([parase count] == 2){
            if([[parase objectAtIndex:1] hasPrefix:@"access_token="]){
                NSString *accessToken =  [[[[parase objectAtIndex:1] componentsSeparatedByString:@"&"] objectAtIndex:0] stringByReplacingOccurrencesOfString:@"access_token=" withString:@""];
                [[NSUserDefaults standardUserDefaults] setObject:accessToken forKey:FB_AccessToken];
                [[NSUserDefaults standardUserDefaults] synchronize];
                [SRHttpFetcher beginFetchWithRequest:[FacebookAPI createProfileRequest]
                                              object:nil 
                                            delegate:self];
                background.hidden = NO;
                loadingView.hidden = NO;
            }
            return NO;
        }else{
            [self alertFailTipView];
            [Facebook removeAuthorizedCacheInfo];
        }
            
    }
    return YES;
}
- (void)webViewDidFinishLoad:(UIWebView *)webview{    
    background.hidden = YES;
    loadingView.hidden = YES;
}

#pragma mark - SRHttpFetcherDelegate Delegate
- (void)requestSuccessWithData:(NSData *)data object:(NSObject *)object{
    NSMutableDictionary *response = [self parseToDictionaryWithJsonData:data];
    [[NSUserDefaults standardUserDefaults] setObject:response forKey:FB_AccountProfile];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(fbOauthSuccessed)])
        [self.delegate fbOauthSuccessed];
    [self startDismissAnimation];
}
- (void)requestFaildWithError:(NSError *)error object:(NSObject *)object{
    [self alertFailTipView];
    [Facebook removeAuthorizedCacheInfo];
}


#pragma mark - UIAlertViewDelegate Methods
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    [self startDismissAnimation];
}

@end
