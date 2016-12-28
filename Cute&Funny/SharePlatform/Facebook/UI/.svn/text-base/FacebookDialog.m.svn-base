//
//  FacebookDialog.m
//  ShareDemo
//
//  Created by yanglei on 12-8-24.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "FacebookDialog.h"
#import <QuartzCore/QuartzCore.h>
#import "SRHttpFetcher.h"
#import "Facebook.h"
#import "sys/utsname.h"

#define FB_DialogAlert_Title @"Request Failed"
#define FB_DialogAlert_Message @"Please try again later."

#define SAFE_Release(p)	if(p) { [p release]; p = nil; }

#define deviceIsIpad ([[[UIDevice currentDevice] model] hasPrefix:@"iPad"] && [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)

#define borderSpace 13.0f

static float screenWidth = 0.0f;
static float screenHeight = 0.0f;

@interface FacebookDialog(PrivateMethods)

/*对象初始化*/
- (id)initWithFrame:(CGRect)frame type:(FBDialogType)_type parameters:(NSMutableDictionary *)parameters  delegate:(id)_delegate animation:(FBAnimationType)animation;

/*初始化View上的元素*/
- (void)initElementsForView;

/*显示View*/
- (void)startDisplayAnimation;

/*隐藏View*/
- (void)startDismissAnimation;

/*弹出错误的提示*/
- (void)alertFailTipView;

/*移除自身*/
- (void)removeMe;

@end

@implementation FacebookDialog
@synthesize delegate;

/*Dialog界面*/
+ (void)showInView:(UIView *)view type:(FBDialogType)_type parameters:(NSMutableDictionary *)parameters  delegate:(id)_delegate animation:(FBAnimationType)animation{
    [FacebookDialog checkDisplayTye];
    
    FacebookDialog *dialogView = [[FacebookDialog alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight) 
                                                                  type:_type 
                                                            parameters:(NSMutableDictionary *)parameters  delegate:(id)_delegate 
                                                             animation:(BOOL)animation];
    [view addSubview:dialogView];
    [dialogView release];
}

/*对象初始化*/
- (id)initWithFrame:(CGRect)frame type:(FBDialogType)_type parameters:(NSMutableDictionary *)parameters  delegate:(id)_delegate animation:(FBAnimationType)animation{
    if(self = [super initWithFrame:frame]){
        self.backgroundColor = deviceIsIpad?[UIColor colorWithRed:0 green:0 blue:0 alpha:0.4]:[UIColor clearColor];
        self.delegate = _delegate;
        animationType = animation;
        dialogType = _type;
        [[NSNotificationCenter defaultCenter] addObserver:self 
                                                 selector:@selector(deviceOrientationDidChange:) 
                                                     name:@"UIInterfaceOrientationDidChangeNotification"
                                                   object:nil];
        [self initElementsForView];
        [self startDisplayAnimation];
        
        switch (dialogType) {
            case FBDialogWall:
                [dialogWeb loadRequest:[FacebookAPI createFeedWallDialogRequest:parameters]];
                break;
                
            case FBDialogPrivaeMessage:
                [dialogWeb loadRequest:[FacebookAPI createPrivateMsgDialogRequest:parameters]];
                break;
        }
       
    }
    return self;
}

- (void)dealloc{
    SAFE_Release(centerView);
    SAFE_Release(indicator);
    SAFE_Release(dialogWeb);
    SAFE_Release(closeBt);
    SAFE_Release(pannel);
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
        if([FacebookDialog isIphone5]){
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


#pragma mark - KVC Methods
- (void)deviceOrientationDidChange:(id)notification{
    CGFloat duration = [UIApplication sharedApplication].statusBarOrientationAnimationDuration;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:duration];
    self.frame = CGRectMake(0, 0, screenWidth, screenHeight);
    pannel.frame = self.bounds;
    centerView.frame = CGRectMake(0,0, deviceIsIpad?544:CGRectGetWidth(self.frame)-2*borderSpace, deviceIsIpad?622:CGRectGetHeight(self.frame)-2*borderSpace);
    centerView.center = self.center;
    CGRect outerFrame = CGRectInset(centerView.frame, -borderSpace, -borderSpace);
    closeBt.frame = CGRectMake(CGRectGetWidth(outerFrame)-(deviceIsIpad?40:30)+outerFrame.origin.x, outerFrame.origin.y, deviceIsIpad?40:30, deviceIsIpad?40:30);
    CGFloat contentMargin = centerView.layer.borderWidth;
    dialogWeb.frame = CGRectMake(contentMargin, contentMargin,CGRectGetWidth(centerView.frame)-contentMargin*2, CGRectGetHeight(centerView.frame)-contentMargin*2);
    indicator.center = CGPointMake(CGRectGetWidth(centerView.frame)/2.0, CGRectGetHeight(centerView.frame)/2.0);
    [UIView commitAnimations];
}


/*显示View*/
#pragma mark - Private Methods
- (void)initElementsForView{
    pannel = [[UIView alloc] initWithFrame:self.bounds];
    pannel.backgroundColor = [UIColor clearColor];
    [self addSubview:pannel];
    
    centerView = [[UIView alloc] initWithFrame:CGRectMake(0,0, deviceIsIpad?544:CGRectGetWidth(self.frame)-2*borderSpace, deviceIsIpad?622:CGRectGetHeight(self.frame)-2*borderSpace)];
    centerView.center = self.center;
    centerView.backgroundColor = [UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:1.0];
    centerView.layer.borderColor = [UIColor colorWithRed:155.0/255.0 green:155.0/255.0 blue:155.0/255.0 alpha:0.9].CGColor;
    centerView.layer.borderWidth = deviceIsIpad?8.0f:5.0f;
    centerView.layer.cornerRadius = deviceIsIpad?8.0f:5.0f;
    centerView.layer.masksToBounds = YES;
    [pannel addSubview:centerView];
    
    /*添加WebView*/
    CGFloat contentMargin = centerView.layer.borderWidth;
    dialogWeb = [[UIWebView alloc] initWithFrame:CGRectMake(contentMargin, contentMargin,CGRectGetWidth(centerView.frame)-contentMargin*2, CGRectGetHeight(centerView.frame)-contentMargin*2)];
    dialogWeb.opaque = NO;
    dialogWeb.backgroundColor = [UIColor clearColor];
    dialogWeb.delegate = self;
    dialogWeb.scalesPageToFit = YES;
    [centerView addSubview:dialogWeb];
    
    /*添加关闭按钮*/
    CGRect outerFrame = CGRectInset(centerView.frame, -borderSpace, -borderSpace);
    closeBt = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetWidth(outerFrame)-(deviceIsIpad?40:30)+outerFrame.origin.x, outerFrame.origin.y, deviceIsIpad?40:30, deviceIsIpad?40:30)];
    closeBt.showsTouchWhenHighlighted = YES;
    [closeBt setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"fb_close.png" ofType:nil]] forState:UIControlStateNormal];
    [closeBt setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"fb_close.png" ofType:nil]] forState:UIControlStateHighlighted];
    [closeBt addTarget:self action:@selector(closePressed:) forControlEvents:UIControlEventTouchUpInside];
    [pannel addSubview:closeBt];
    
    /*添加加载菊花*/
    indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:deviceIsIpad?UIActivityIndicatorViewStyleWhiteLarge:UIActivityIndicatorViewStyleWhite];
    indicator.center = CGPointMake(CGRectGetWidth(centerView.frame)/2.0, CGRectGetHeight(centerView.frame)/2.0);
    indicator.hidesWhenStopped = YES;
    [indicator startAnimating];
    [centerView addSubview:indicator];
}

/*隐藏View*/
- (void)startDisplayAnimation{
    switch (animationType) {
        case FBAnimationNone:
            pannel.center = CGPointMake(CGRectGetWidth(self.frame)/2.0, CGRectGetHeight(self.frame)/2.0);
            break;
            
        case FBAnimationBottomTop:{
            pannel.center = CGPointMake(CGRectGetWidth(self.frame)/2.0, CGRectGetHeight(self.frame)/2.0*3.0);
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:0.3];
            pannel.center = CGPointMake(CGRectGetWidth(self.frame)/2.0, CGRectGetHeight(self.frame)/2.0);
            [UIView commitAnimations];
            break;
        }
        case FBAnimationTopBottom:{
            pannel.center = CGPointMake(CGRectGetWidth(self.frame)/2.0, -CGRectGetHeight(self.frame)/2.0);
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:0.3];
            pannel.center = CGPointMake(CGRectGetWidth(self.frame)/2.0, CGRectGetHeight(self.frame)/2.0);
            [UIView commitAnimations];
            break;
        }
        case FBAnimationLeftRight:{
            pannel.center = CGPointMake(-CGRectGetWidth(self.frame)/2.0, CGRectGetHeight(self.frame)/2.0);
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:0.3];
            pannel.center = CGPointMake(CGRectGetWidth(self.frame)/2.0, CGRectGetHeight(self.frame)/2.0);
            [UIView commitAnimations];
            break;
        }
        case FBAnimationRightLeft:{
            pannel.center = CGPointMake(CGRectGetWidth(self.frame)/2.0*3.0, CGRectGetHeight(self.frame)/2.0);
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:0.3];
            pannel.center = CGPointMake(CGRectGetWidth(self.frame)/2.0, CGRectGetHeight(self.frame)/2.0);
            [UIView commitAnimations];
            break;
        }
        case FBAnimationAlert:{
            pannel.center = CGPointMake(CGRectGetWidth(self.frame)/2.0, CGRectGetHeight(self.frame)/2.0);
            pannel.transform = CGAffineTransformMakeScale(0.3, 0.3);
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:0.3];
            pannel.transform = CGAffineTransformMakeScale(1.0, 1.0);
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
            [UIView setAnimationDuration:0.3];
            [UIView setAnimationDelegate:self];
            [UIView setAnimationDidStopSelector:@selector(removeMe)];
            pannel.center = CGPointMake(CGRectGetWidth(self.frame)/2.0, CGRectGetHeight(self.frame)/2.0*3.0);
            [UIView commitAnimations];
            break;
        }
        case FBAnimationTopBottom:{
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:0.3];
            [UIView setAnimationDelegate:self];
            [UIView setAnimationDidStopSelector:@selector(removeMe)];
            pannel.center = CGPointMake(CGRectGetWidth(self.frame)/2.0, -CGRectGetHeight(self.frame)/2.0);
            [UIView commitAnimations];
            break;
        }
        case FBAnimationLeftRight:{
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:0.3];
            [UIView setAnimationDelegate:self];
            [UIView setAnimationDidStopSelector:@selector(removeMe)];
            pannel.center = CGPointMake(-CGRectGetWidth(self.frame)/2.0, CGRectGetHeight(self.frame)/2.0);
            [UIView commitAnimations];
            break;
        }
        case FBAnimationRightLeft:{
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:0.3];
            [UIView setAnimationDelegate:self];
            [UIView setAnimationDidStopSelector:@selector(removeMe)];
            pannel.center = CGPointMake(CGRectGetWidth(self.frame)/2.0*3.0, CGRectGetHeight(self.frame)/2.0);
            [UIView commitAnimations];
            break;
        }
        case FBAnimationAlert:{
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:0.3];
            [UIView setAnimationDelegate:self];
            [UIView setAnimationDidStopSelector:@selector(removeMe)];
            pannel.transform = CGAffineTransformMakeScale(0.3, 0.3);
            [UIView commitAnimations];
            break;
        }
    }
}

/*弹出错误的提示*/
- (void)alertFailTipView{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:FB_DialogAlert_Title
                                                    message:FB_DialogAlert_Message
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
    [alert release];
}

- (void)removeMe{
    [self removeFromSuperview];
}

#pragma mark - UIWebViewDelegate Method
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{  
    if([request.URL.scheme isEqualToString:@"fbconnect"]){
        if([request.URL.query hasPrefix:@"post_id"]){
            if(self.delegate && [self.delegate  respondsToSelector:@selector(fbDialogSubmitSuccessed)])
                [self.delegate performSelector:@selector(fbDialogSubmitSuccessed)];
        }
        
        [self startDismissAnimation];
        return NO;
    }
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView{
    [indicator startAnimating];
}

- (void)webViewDidFinishLoad:(UIWebView *)webview{    
    [indicator stopAnimating];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    if(error.code != -999){
        [self alertFailTipView];
    }
}


#pragma mark - UIAlertViewDelegate Methods
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    [self startDismissAnimation];
}

#pragma mark - Button Functions
- (void)closePressed:(id)sender{
    [self startDismissAnimation];
}


@end
