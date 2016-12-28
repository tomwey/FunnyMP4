//
//  TwitterOauthView.m
//
//  Created by yanglei on 12-8-22.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "TwitterOauthView.h"
#import <QuartzCore/QuartzCore.h>
#import "SRHttpFetcher.h"
#import "JSON.h"
#import "RegexKitLite.h"
#import "Twitter.h"
#import "sys/utsname.h"

#define SAFE_Release(p)	if(p) { [p release]; p = nil; }
#define TW_OauthRequestToken @"RequestToken"
#define TW_OauthAccessToken @"AccessToken"
#define TW_OauthVerifyProfile @"VerifyProfile"
#define TW_OauthAlert_Title @"Authorize Failed"
#define TW_OauthAlert_Message @"Please try again later."

#define deviceIsIpad ([[[UIDevice currentDevice] model] hasPrefix:@"iPad"] && [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)

static float screenWidth = 0.0f;
static float screenHeight = 0.0f;


@interface TwitterOauthView(PrivateMethods)

/*对象初始化*/
- (id)initWithFrame:(CGRect)frame delegate:(id)_delegate animation:(TWAnimationType)animation;
 
/*初始化元素*/
- (void)initElementsForView;

/*根据设备和方向设置元素坐标*/
- (void)initCoordinates;

/*显示View*/
- (void)startDisplayAnimation;

/*隐藏View*/
- (void)startDismissAnimation;

/*解析Twitter返回参数*/
- (NSString *)getValueByPrefix:(NSString *)prefix components:(NSArray *)components;

/*弹出错误的提示*/
- (void)alertFailTipView;

/*解析Json为Dictionary*/
- (NSMutableDictionary *)parseToDictionaryWithJsonData:(NSData *)jsonData;

/*移除自身*/
- (void)removeMe;

@end


@implementation TwitterOauthView
@synthesize delegate;

/*弹出授权界面*/
+ (void)showInView:(UIView *)view delegate:(id)_delegate animation:(TWAnimationType)animation{
//    [TwitterOauthView checkDisplayTye];
    
    screenWidth = CGRectGetWidth([[UIScreen mainScreen] bounds]);
    screenHeight = CGRectGetHeight([[UIScreen mainScreen] bounds]);
    
    TwitterOauthView *oauthView = [[TwitterOauthView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight) delegate:_delegate animation:animation];
    [view addSubview:oauthView];
    [oauthView release];
}

- (id)initWithFrame:(CGRect)frame delegate:(id)_delegate animation:(TWAnimationType)animation{
    if(self = [super initWithFrame:frame]){
        self.delegate = _delegate;
        self.backgroundColor = [UIColor clearColor];
        animationType = animation;
        [Twitter removeAuthorizedCacheInfo];
        [[NSNotificationCenter defaultCenter] addObserver:self 
                                                 selector:@selector(deviceOrientationDidChange:) 
                                                     name:@"UIInterfaceOrientationDidChangeNotification"
                                                   object:nil];
        [self initElementsForView];
        [self startDisplayAnimation];
        
        NSMutableURLRequest *request = [TwitterAPI createRequestTokenRequest];
        [SRHttpFetcher beginFetchWithRequest:request 
                                      object:TW_OauthRequestToken 
                                    delegate:self];
    }
    return self;
    	
}

- (void)dealloc{
    SAFE_Release(oauthWeb);
    SAFE_Release(background);
    SAFE_Release(loadingView);
    SAFE_Release(navigation);
    SAFE_Release(requestToken);
    SAFE_Release(requestSecret);
    [super dealloc];
}

#pragma mark - Category Methods
/*判断屏幕的类型*/
+ (TWDisplayType)checkDisplayTye{
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    TWDisplayType displayType;
    if(deviceIsIpad){
        if(UIInterfaceOrientationIsLandscape(orientation)){
            displayType = TWDisplayIpadLandscape;
            screenWidth = [UIApplication sharedApplication].statusBarHidden?1024.0:(1024.0-20.0);
            screenHeight = [UIApplication sharedApplication].statusBarHidden?768.0:(768.0-20.0);
        }
        else{
            displayType = TWDisplayIpadportrait;
            screenWidth = [UIApplication sharedApplication].statusBarHidden?768.0:(768.0-20.0);
            screenHeight = [UIApplication sharedApplication].statusBarHidden?1024.0:(1024.0-20.0);
        }
    }
    else{
        if([TwitterOauthView isIphone5]){
            if(UIInterfaceOrientationIsLandscape(orientation)){
                displayType = TWDisplayIphone5Landscape;
                screenWidth = [UIApplication sharedApplication].statusBarHidden?568.0:(568.0-20.0);
                screenHeight = [UIApplication sharedApplication].statusBarHidden?320.0:(320.0-20.0);
            }
            else{
                displayType = TWDisplayIphone5portrait;
//                screenWidth = [UIApplication sharedApplication].statusBarHidden?320.0:(320.0-20.0);
                screenHeight = [UIApplication sharedApplication].statusBarHidden?568.0:(568.0-20.0);
                screenWidth = 320;
            }
        }else{
            if(UIInterfaceOrientationIsLandscape(orientation)){
                displayType = TWDisplayIphoneLandscape;
                screenWidth = [UIApplication sharedApplication].statusBarHidden?480.0:(480.0-20.0);
                screenHeight = [UIApplication sharedApplication].statusBarHidden?320.0:(320.0-20.0);
            }
            else{
                displayType = TWDisplayIphoneportrait;
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
    TWDisplayType displayType = TWDisplayIphoneportrait;//[TwitterOauthView checkDisplayTye];
    switch (displayType) {
        case TWDisplayIphoneLandscape:
            bgImg =  [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"tw_h.png" ofType:nil]];
            loadingFrame = CGRectMake((screenWidth-220.0)/2.0, 220.0, 220.0, 80.0);
            break;
            
        case TWDisplayIphoneportrait:
            bgImg =  [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"tw_v.png" ofType:nil]];
            loadingFrame = CGRectMake((screenWidth-220.0)/2.0, 340.0, 230.0, 80.0);
            break;
            
        case TWDisplayIphone5Landscape:
            bgImg =  [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"tw_h-i5.png" ofType:nil]];
            loadingFrame = CGRectMake((screenWidth-220.0)/2.0, 220.0, 220.0, 80.0);
            break;
            
        case TWDisplayIphone5portrait:
            bgImg =  [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"tw_v-i5.png" ofType:nil]];
            loadingFrame = CGRectMake((screenWidth-220.0)/2.0, 380.0, 230.0, 80.0);
            break;
            
        case TWDisplayIpadLandscape:
            bgImg =  [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"tw_ipad_h.png" ofType:nil]];
            loadingFrame = CGRectMake((screenWidth-410.0)/2.0, 545.0, 410.0, 150.0);
            break;
            
        case TWDisplayIpadportrait:
            bgImg =  [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"tw_ipad_v.png" ofType:nil]];
            loadingFrame = CGRectMake((screenWidth-410.0)/2.0, 760.0, 410.0, 150.0);
            break;
    }
}

- (void)initElementsForView{
    [self initCoordinates];
    
    /*添加WebView*/
    oauthWeb = [[UIWebView alloc] initWithFrame:CGRectMake(0, 44, screenWidth, screenHeight-44)];
    oauthWeb.delegate = self;
    [self addSubview:oauthWeb];
    
    /*添加背景*/
    background = [[UIImageView alloc] initWithFrame:CGRectMake(0, [UIApplication sharedApplication].statusBarHidden ? 0 : 20, screenWidth, screenHeight)];
    background.image = bgImg;
    background.alpha = 0.8f;
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
    navigation = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, [UIApplication sharedApplication].statusBarHidden ? 0 : 20, screenWidth, 44)];
    navigation.barStyle = UIBarStyleBlack;
    [self addSubview:navigation];
    
    //////
    CGRect frame = oauthWeb.frame;
    frame.origin.y = navigation.frame.origin.y + navigation.bounds.size.height;
    oauthWeb.frame = frame;
    //////
    
    UINavigationItem *item = [[UINavigationItem alloc] initWithTitle:@"Twitter Authorize"];
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
        case TWAnimationNone:
            self.center = CGPointMake(CGRectGetWidth(self.frame)/2.0, CGRectGetHeight(self.frame)/2.0);
            break;
            
        case TWAnimationBottomTop:{
            self.center = CGPointMake(CGRectGetWidth(self.frame)/2.0, CGRectGetHeight(self.frame)/2.0*3.0);
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:.3];
            self.center = CGPointMake(CGRectGetWidth(self.frame)/2.0, CGRectGetHeight(self.frame)/2.0);
            [UIView commitAnimations];
            break;
        }
        case TWAnimationTopBottom:{
            self.center = CGPointMake(CGRectGetWidth(self.frame)/2.0, -CGRectGetHeight(self.frame)/2.0);
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:.3];
            self.center = CGPointMake(CGRectGetWidth(self.frame)/2.0, CGRectGetHeight(self.frame)/2.0);
            [UIView commitAnimations];
            break;
        }
        case TWAnimationLeftRight:{
            self.center = CGPointMake(-CGRectGetWidth(self.frame)/2.0, CGRectGetHeight(self.frame)/2.0);
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:.3];
            self.center = CGPointMake(CGRectGetWidth(self.frame)/2.0, CGRectGetHeight(self.frame)/2.0);
            [UIView commitAnimations];
            break;
        }
        case TWAnimationRightLeft:{
            self.center = CGPointMake(CGRectGetWidth(self.frame)/2.0*3.0, CGRectGetHeight(self.frame)/2.0);
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:.3];
            self.center = CGPointMake(CGRectGetWidth(self.frame)/2.0, CGRectGetHeight(self.frame)/2.0);
            [UIView commitAnimations];
            break;
        }
        case TWAnimationAlert:{
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
    isStartDismissAnimation = YES;
    
    self.delegate = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"UIInterfaceOrientationDidChangeNotification" object:nil];
    switch (animationType) {
        case TWAnimationNone:
            [self removeMe];
            break;
            
        case TWAnimationBottomTop:{
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:.3];
            [UIView setAnimationDelegate:self];
            [UIView setAnimationDidStopSelector:@selector(removeMe)];
            self.center = CGPointMake(CGRectGetWidth(self.frame)/2.0, CGRectGetHeight(self.frame)/2.0*3.0);
            [UIView commitAnimations];
            break;
        }
        case TWAnimationTopBottom:{
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:.3];
            [UIView setAnimationDelegate:self];
            [UIView setAnimationDidStopSelector:@selector(removeMe)];
            self.center = CGPointMake(CGRectGetWidth(self.frame)/2.0, -CGRectGetHeight(self.frame)/2.0);
            [UIView commitAnimations];
            break;
        }
        case TWAnimationLeftRight:{
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:.3];
            [UIView setAnimationDelegate:self];
            [UIView setAnimationDidStopSelector:@selector(removeMe)];
            self.center = CGPointMake(-CGRectGetWidth(self.frame)/2.0, CGRectGetHeight(self.frame)/2.0);
            [UIView commitAnimations];
            break;
        }
        case TWAnimationRightLeft:{
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:.3];
            [UIView setAnimationDelegate:self];
            [UIView setAnimationDidStopSelector:@selector(removeMe)];
            self.center = CGPointMake(CGRectGetWidth(self.frame)/2.0*3.0, CGRectGetHeight(self.frame)/2.0);
            [UIView commitAnimations];
            break;
        }
        case TWAnimationAlert:{
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

/*解析Twitter返回参数*/
- (NSString *)getValueByPrefix:(NSString *)prefix components:(NSArray *)components{
    for(NSString *child in components){
        if([child hasPrefix:prefix])
            return [child substringFromIndex:[prefix length]];
    }
    return nil;
}

/*解析Json为Dictionary*/
- (NSMutableDictionary *)parseToDictionaryWithJsonData:(NSData *)jsonData{
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSError *error = nil;
    SBJSON *parser = [SBJSON new];
//    NSMutableDictionary *response = [NSMutableDictionary dictionaryWithDictionary:[parser objectWithString:jsonString error:&error]];
    NSMutableDictionary *response = [NSMutableDictionary dictionaryWithDictionary:[parser objectWithString:jsonString]];
    if(error)
        response = [NSMutableDictionary dictionaryWithCapacity:0];
    [jsonString release];
    [parser release];
    
    return response;
}


#pragma mark - KVC Methods
- (void)deviceOrientationDidChange:(id)notification{
    [self initCoordinates];
    CGFloat duration = [UIApplication sharedApplication].statusBarOrientationAnimationDuration;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:duration];
    self.frame = CGRectMake(0, 0, screenWidth, screenHeight);
    oauthWeb.frame = CGRectMake(0, 44, screenWidth, screenHeight-44);;
    background.image = bgImg;
    background.frame = CGRectMake(0, 0, screenWidth, screenHeight);
    
    loadingView.frame = loadingFrame;
    navigation.frame = CGRectMake(0, 0, screenWidth, 44);
    [UIView commitAnimations];
}

#pragma mark - Button Functions
- (void)cancelPressed:(id)sender{
    [self startDismissAnimation];
}

#pragma mark - SRHttpFetcherDelegate Delegate
- (void)requestSuccessWithData:(NSData *)data object:(NSObject *)object{
    NSString *key = [NSString stringWithFormat:@"%@",object];
    NSString *response = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    if([key isEqualToString:TW_OauthRequestToken]){
        NSRange tokenRange = [response rangeOfString:@"oauth_token="];
        NSRange secretRange = [response rangeOfString:@"oauth_token_secret="];
        
        if(tokenRange.location != NSNotFound && secretRange.location != NSNotFound){
            NSArray *components = [response componentsSeparatedByString:@"&"];
            
            requestToken = [[self getValueByPrefix:@"oauth_token=" components:components] retain];
            
            requestSecret = [[self getValueByPrefix:@"oauth_token_secret=" components:components] retain];
            
            //进入官方页面授权
            NSMutableURLRequest *request = [TwitterAPI createAuthorizeRequest:requestToken];
            [oauthWeb loadRequest:request];
        }
        else
            [self alertFailTipView];
    }
    else if([key isEqualToString:TW_OauthAccessToken]){
        NSRange tokenRange = [response rangeOfString:@"oauth_token="];
        NSRange secretRange = [response rangeOfString:@"oauth_token_secret="];
        if(tokenRange.location != NSNotFound && secretRange.location != NSNotFound){
            NSArray *components = [response componentsSeparatedByString:@"&"];
            NSString *accessToken = [self getValueByPrefix:@"oauth_token=" components:components];
            
            NSString *accessSecret = [self getValueByPrefix:@"oauth_token_secret=" components:components];
            
            [[NSUserDefaults standardUserDefaults] setObject:accessToken forKey:TW_AccessToken];
            [[NSUserDefaults standardUserDefaults] setObject:accessSecret forKey:TW_AccessSecret];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [SRHttpFetcher beginFetchWithRequest:[TwitterAPI createVerifyCredentialsRequest] 
                                          object:TW_OauthVerifyProfile 
                                        delegate:self];
        }
        else
            [self alertFailTipView];
    }
    else if([key isEqualToString:TW_OauthVerifyProfile]){
        NSMutableDictionary *profileInfo = [self parseToDictionaryWithJsonData:data];
        
        NSMutableDictionary *importantInfo = [NSMutableDictionary dictionaryWithCapacity:0];
        [importantInfo setObject:[profileInfo objectForKey:@"name"] forKey:@"name"];
        [importantInfo setObject:[profileInfo objectForKey:@"screen_name"] forKey:@"screen_name"];
        [importantInfo setObject:[profileInfo objectForKey:@"profile_image_url"] forKey:@"profile_image_url"];
        
        
        [[NSUserDefaults standardUserDefaults] setObject:importantInfo forKey:TW_AccountProfile];
        [[NSUserDefaults standardUserDefaults] synchronize];
        if(self.delegate && [self.delegate respondsToSelector:@selector(twOauthSuccessed)])
            [self.delegate twOauthSuccessed];
        [self startDismissAnimation];
    }
    [response release];
}

- (void)requestFaildWithError:(NSError *)error object:(NSObject *)object{
//    [self alertFailTipView];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Share Failed!"
                                                    message:nil
                                                   delegate:(isStartDismissAnimation ? nil : self)
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
    [alert release];
    [Twitter removeAuthorizedCacheInfo];
}

- (void)alertFailTipView{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Share Failed!"
                                                    message:nil
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
    [alert release];
}

#pragma mark - UIAlertViewDelegate Methods
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    [self startDismissAnimation];
}

#pragma mark - UIWebViewDelegate Method
- (BOOL)webView:(UIWebView *)webview shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    return YES;
}
- (void)webViewDidStartLoad:(UIWebView *)webview{
}

- (void)webViewDidFinishLoad:(UIWebView *)webview{    
    background.hidden = YES;
    loadingView.hidden = YES;
    NSString *Js = @"document.documentElement.innerHTML";
	NSString *webViewContent=[webview stringByEvaluatingJavaScriptFromString:Js];
    NSString *regex1 = @"([0-9]{7})(?=(</a>))";
    NSString *regex2 = @"([0-9]{7})(?=(</code>))";
    
    NSString *oauthVerifier = nil;
    if([webViewContent stringByMatching:regex1] != nil){
        oauthVerifier = [webViewContent stringByMatching:regex1];
    }
    else if([webViewContent stringByMatching:regex2] != nil){
        oauthVerifier = [webViewContent stringByMatching:regex2]; 
    }
    if(oauthVerifier){
        background.hidden = NO;
        loadingView.hidden = NO;
        
        NSMutableURLRequest *request = [TwitterAPI createAccessTokenRequestWithToken:requestToken 
                                                                             secrect:requestSecret 
                                                                            verifier:oauthVerifier];
        [SRHttpFetcher beginFetchWithRequest:request 
                                      object:@"AccessToken" 
                                    delegate:self];
    }
    
}

@end
