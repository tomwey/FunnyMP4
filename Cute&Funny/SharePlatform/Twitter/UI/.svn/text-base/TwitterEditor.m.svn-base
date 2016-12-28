//
//  TwitterEditor.m
//
//  Created by yanglei on 12-8-29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "TwitterEditor.h"
#import "sys/utsname.h"

#define SAFE_Release(p)	if(p) { [p release]; p = nil; }
#define deviceIsIpad ([[[UIDevice currentDevice] model] hasPrefix:@"iPad"] && [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
#define IOS_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]

#define TW_GrayColor [UIColor colorWithRed:85.0/255.0 green:85.0/255.0 blue:85.0/255.0 alpha:1.0]
#define TW_RedColor [UIColor colorWithRed:128.0/255.0 green:0.0 blue:0.0 alpha:1.0]

#define TW_WordsLimit_Message @"Sorry! You're only allowed to type a maximum of %i letters. Please try again later."

static float screenWidth = 0.0f;
static float screenHeight = 0.0f;

@interface TwitterEditor(PrivateMethods)

/*对象初始化*/
- (id)initWithFrame:(CGRect)frame type:(TWEditorType)type delegate:(id)_delegate;

/*判断屏幕的类型*/
- (TWDisplayType)checkDisplayTye;

/*同步Counter字数显示*/
- (void)syncCounterDisplay;

/*初始化View上的元素*/
- (void)initElementsForView;

/*根据设备和方向设置元素坐标*/
- (void)initCoordinates;

/*显示View*/
- (void)startDisplayAnimation;

/*隐藏View*/
- (void)startDismissAnimation;

/*弹出错误的提示*/
- (void)alertFailTipView;

/*键盘高度改变对于布局的影响*/
- (void)moveInputBarWithKeyboardHeight:(CGFloat)height withDuration:(NSTimeInterval)duration;

/*开始send的动画*/
- (void)beginSendAnimation;

/*结束send的动画*/
- (void)endSendAnimation;

@end

@implementation TwitterEditor
@synthesize delegate,shareText,shareImage,wordsLimit;

#pragma mark - View LifeCycle
/*Editor界面*/
+ (TwitterEditor *)showInView:(UIView *)view type:(TWEditorType)type delegate:(id)_delegate{
    [TwitterEditor checkDisplayTye];
    
    TwitterEditor *editorView = [[[TwitterEditor alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight) 
                                                                   type:type 
                                                               delegate:_delegate] autorelease];
    [view addSubview:editorView];
    return editorView;
}

- (id)initWithFrame:(CGRect)frame type:(TWEditorType)type delegate:(id)_delegate{
    self = [super initWithFrame:frame];
    if (self) {
        wordsLimit = -1;
        rotating = NO;
        self.delegate = _delegate;
        editorType = type;
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
        [[NSNotificationCenter defaultCenter] addObserver:self 
                                                 selector:@selector(deviceOrientationDidChange:) 
                                                     name:@"UIInterfaceOrientationDidChangeNotification"
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
        
        // 键盘高度变化通知，ios5.0新增的  
        if (IOS_VERSION >= 5.0)
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillChangeFrameNotification object:nil];
        
       [self initElementsForView];
       [self startDisplayAnimation];
    }
    return self;
}

- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"UIInterfaceOrientationDidChangeNotification" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    if (IOS_VERSION >= 5.0)
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
    
    SAFE_Release(pannelView);
    SAFE_Release(cancelBt);
    SAFE_Release(sendBt);
    SAFE_Release(tbTextView);
    SAFE_Release(attachView);
    SAFE_Release(counterLb);
    SAFE_Release(indicator);
    
    SAFE_Release(shareText);
    SAFE_Release(shareImage);
    
    self.videoData = nil;
    
    [super dealloc];
}

#pragma mark - KVC Methods
- (void)keyboardWillShow:(id)notification{
    NSDictionary *userInfo = [notification userInfo];
    
    CGFloat keybordHeight;
    TWDisplayType displayType = [TwitterEditor checkDisplayTye];
    switch (displayType) {
        case TWDisplayIphoneLandscape:
            keybordHeight = 162.0;
            break;
        case TWDisplayIphoneportrait:
            keybordHeight = 216.0;
            break;
        case TWDisplayIphone5Landscape:
            keybordHeight = 162.0;
            break;
        case TWDisplayIphone5portrait:
            keybordHeight = 216.0;
            break;
        case TWDisplayIpadLandscape:
            keybordHeight = 352.0;
            break;
        case TWDisplayIpadportrait:
            keybordHeight = 264.0;
            break;
            
    }
    
    if(IOS_VERSION >= 3.2){
        UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
        
        NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
        CGRect keyboardRect = [aValue CGRectValue];
        keybordHeight = UIInterfaceOrientationIsLandscape(orientation)?keyboardRect.size.width:keyboardRect.size.height;
    }
    
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    [self moveInputBarWithKeyboardHeight:keybordHeight withDuration:animationDuration];
}

- (void)keyboardWillHide:(id)notification{
    NSDictionary* userInfo = [notification userInfo];
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    [self moveInputBarWithKeyboardHeight:0 withDuration:animationDuration];
}

- (void)moveInputBarWithKeyboardHeight:(CGFloat)height withDuration:(NSTimeInterval)duration{
    keyboardHeight = height;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:duration];
    if(height == 0 && !rotating){
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDidStopSelector:@selector(removeMe)];
        pannelView.center = CGPointMake(CGRectGetWidth(self.frame)/2.0, -CGRectGetHeight(self.frame)/2.0);
    }
    else 
        pannelView.center = CGPointMake(CGRectGetWidth(self.frame)/2.0,(CGRectGetHeight(self.frame)-height)/2.0);
    [UIView commitAnimations];
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
        if([TwitterEditor isIphone5]){
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
                screenWidth = [UIApplication sharedApplication].statusBarHidden?CGRectGetWidth([UIScreen mainScreen].bounds):(CGRectGetWidth([UIScreen mainScreen].bounds)-20.0);
                screenHeight = [UIApplication sharedApplication].statusBarHidden?CGRectGetHeight([UIScreen mainScreen].bounds):(CGRectGetHeight([UIScreen mainScreen].bounds)-20.0);
            }
            else{
                displayType = TWDisplayIphoneportrait;
//                screenWidth = [UIApplication sharedApplication].statusBarHidden?320.0:(320.0-20.0);
                screenHeight = [UIApplication sharedApplication].statusBarHidden?CGRectGetHeight([UIScreen mainScreen].bounds):(CGRectGetHeight([UIScreen mainScreen].bounds)-20.0);
                screenWidth = CGRectGetWidth([UIScreen mainScreen].bounds);
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
    if([UIScreen mainScreen].bounds.size.height == 568)
        return YES;
    
    return NO;
}


#pragma mark - Rewrite Set Methods 
- (void)setShareText:(NSString *)newShareText{
    if(shareText != newShareText){
        [shareText release];
        shareText = [newShareText retain];
        if(self.shareText){
            [tbTextView setTextViewString:self.shareText];
            [self syncCounterDisplay];
        }
    }
}

- (void)setShareImage:(UIImage *)newShareImage{
    if(shareImage != newShareImage){
        [shareImage release];
        shareImage = [newShareImage retain];
        if(shareImage){
            attachView.image = self.shareImage;
        }
    }
}

- (void)setWordsLimit:(NSInteger)newWordsLimit{
    wordsLimit = newWordsLimit;
    [self syncCounterDisplay];
}

#pragma mark - Private Methods
/*同步Counter字数显示*/
- (void)syncCounterDisplay{
    NSInteger textLength = [[tbTextView getTextViewString] length];
    counterLb.text = [NSString stringWithFormat:@"%i",wordsLimit == -1?textLength:wordsLimit-textLength];
    if(wordsLimit != -1 && (wordsLimit-textLength)<0)
        counterLb.textColor = TW_RedColor;
    else
        counterLb.textColor = TW_GrayColor;
    sendBt.enabled = (textLength != 0);
}


/*根据设备和方向设置元素坐标*/
- (void)initCoordinates{
    TWDisplayType displayType = [TwitterEditor checkDisplayTye];
    
    switch (displayType) {
        case TWDisplayIphoneLandscape:
            pannelViewFrame = CGRectMake(0, 0, 480, 123);
            pannelViewImg = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"tw_box_h.png" ofType:nil]];
            cancelBtFrame = CGRectMake(5, 4, 67, 33);
            cancelBtImg = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"tw_cancel_h.png" ofType:nil]];
            sendBtFrame = CGRectMake(408, 4, 67, 33);
            sendBtImg = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"tw_share_h.png" ofType:nil]];
            tbTextViewFrame = CGRectMake(5, 50, 470, 62);
            innerTextWidth = (editorType == TWEditorMessage)?470:392;
            attachViewFrame = CGRectMake(406, 45, 62, 62);
            counterLbFrame = CGRectMake(406, 104, 62, 21);
            counterPointSize = 15.0f;
            indicatorFrame = CGRectMake(292, 11, 20, 20);
            break;
            
        case TWDisplayIphoneportrait:
            pannelViewFrame = CGRectMake(0, 0, 311, 203);
            pannelViewImg = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"tw_box_v.png" ofType:nil]];
            cancelBtFrame = CGRectMake(5, 4, 67, 33);
            cancelBtImg = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"tw_cancel_v.png" ofType:nil]];
            sendBtFrame = CGRectMake(239, 4, 67, 33);
            sendBtImg = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"tw_share_v.png" ofType:nil]];
            tbTextViewFrame = CGRectMake(5, 50, 301, 132);
            innerTextWidth = (editorType == TWEditorMessage)?301:223;
            attachViewFrame = CGRectMake(236, 45, 70, 70);
            counterLbFrame = CGRectMake(236, 178, 70, 21);
            counterPointSize = 15.0f;
            indicatorFrame = CGRectMake(206, 11, 20, 20);
            break;
            
        case TWDisplayIphone5Landscape:
            pannelViewFrame = CGRectMake(0, 0, 568, 123);
            pannelViewImg = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"tw_box_h-i5.png" ofType:nil]];
            cancelBtFrame = CGRectMake(5, 4, 67, 33);
            cancelBtImg = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"tw_cancel_h.png" ofType:nil]];
            sendBtFrame = CGRectMake(496, 4, 67, 33);
            sendBtImg = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"tw_share_h.png" ofType:nil]];
            tbTextViewFrame = CGRectMake(5, 50, 558, 62);
            innerTextWidth = (editorType == TWEditorMessage)?558:480;
            attachViewFrame = CGRectMake(494, 45, 62, 62);
            counterLbFrame = CGRectMake(494, 104, 62, 21);
            counterPointSize = 15.0f;
            indicatorFrame = CGRectMake(380, 11, 20, 20);
            break;
            
        case TWDisplayIphone5portrait:
            pannelViewFrame = CGRectMake(0, 0, 311, 203);
            pannelViewImg = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"tw_box_v.png" ofType:nil]];
            cancelBtFrame = CGRectMake(5, 4, 67, 33);
            cancelBtImg = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"tw_cancel_v.png" ofType:nil]];
            sendBtFrame = CGRectMake(239, 4, 67, 33);
            sendBtImg = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"tw_share_v.png" ofType:nil]];
            tbTextViewFrame = CGRectMake(5, 50, 301, 132);
            innerTextWidth = (editorType == TWEditorMessage)?301:223;
            attachViewFrame = CGRectMake(236, 45, 70, 70);
            counterLbFrame = CGRectMake(236, 178, 70, 21);
            counterPointSize = 15.0f;
            indicatorFrame = CGRectMake(206, 11, 20, 20);
            break;
            
        case TWDisplayIpadLandscape:
            pannelViewFrame = CGRectMake(0, 0, 541, 191);
            pannelViewImg = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"tw_ipad_box_h.png" ofType:nil]];
            cancelBtFrame = CGRectMake(5, 4, 68, 34);
            cancelBtImg = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"tw_ipad_cancel_h.png" ofType:nil]];
            sendBtFrame = CGRectMake(468, 4, 68, 34);
            sendBtImg = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"tw_ipad_share_h.png" ofType:nil]];
            tbTextViewFrame = CGRectMake(5, 43, 531, 125);
            innerTextWidth = (editorType == TWEditorMessage)?531:426;
            attachViewFrame = CGRectMake(444, 51, 80, 80);
            counterLbFrame = CGRectMake(444, 160, 80, 21);
            counterPointSize = 17.0f;
            indicatorFrame = CGRectMake(328, 12, 20, 20);
            break;
            
        case TWDisplayIpadportrait:
            pannelViewFrame = CGRectMake(0, 0, 636, 224);
            pannelViewImg = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"tw_ipad_box_v.png" ofType:nil]];
            cancelBtFrame = CGRectMake(5, 7, 68, 34);
            cancelBtImg = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"tw_ipad_cancel_v.png" ofType:nil]];
            sendBtFrame = CGRectMake(563, 7, 68, 34);
            sendBtImg = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"tw_ipad_share_v.png" ofType:nil]];
            tbTextViewFrame = CGRectMake(5, 50, 626, 145);
            innerTextWidth = (editorType == TWEditorMessage)?626:521;
            attachViewFrame = CGRectMake(539, 58, 80, 80);
            counterLbFrame = CGRectMake(539, 190, 80, 21);
            counterPointSize = 17.0f;
            indicatorFrame = CGRectMake(384, 16, 20, 20);
            break;
    }
    
    switch (editorType) {
        case TWEditorMessage:{
            counterAlignment = NSTextAlignmentRight;
            attachViewFrame = CGRectZero;
            break;
        }
            
        case TWEditorMessageAndImage:{
            counterAlignment = NSTextAlignmentCenter;
            break;
        }
    }
    
}

/*初始化View上的元素*/
- (void)initElementsForView{
    [self initCoordinates];
    
    pannelView = [[UIImageView alloc] initWithFrame:pannelViewFrame];
    pannelView.center = CGPointMake(CGRectGetWidth(self.frame)/2.0, -CGRectGetHeight(self.frame)/2.0);
    pannelView.image = pannelViewImg;
    pannelView.userInteractionEnabled = YES;
    [self addSubview:pannelView];
    
    cancelBt = [[UIButton alloc] initWithFrame:cancelBtFrame];
    [cancelBt setImage:cancelBtImg forState:UIControlStateNormal];
    [cancelBt addTarget:self action:@selector(cancelPressed:) forControlEvents:UIControlEventTouchUpInside];
    [pannelView addSubview:cancelBt];
    
    sendBt = [[UIButton alloc] initWithFrame:sendBtFrame];
    sendBt.enabled = NO;
    [sendBt setImage:sendBtImg forState:UIControlStateNormal];
    [sendBt addTarget:self action:@selector(sendPressed:) forControlEvents:UIControlEventTouchUpInside];
    [pannelView addSubview:sendBt];
    
    tbTextView = [[TableTextView alloc] initWithFrame:tbTextViewFrame];
    tbTextView.delegate = self;
    [tbTextView setTextViewWidth:innerTextWidth];
    [pannelView addSubview:tbTextView];
    
    attachView = [[UIImageView alloc] initWithFrame:attachViewFrame];
    attachView.contentMode = UIViewContentModeScaleAspectFit;
    attachView.backgroundColor = [UIColor colorWithRed:225.0/255.0 green:225.0/255.0 blue:225.0/255.0 alpha:1.0];
    attachView.layer.borderWidth = 2.0f;
    attachView.layer.masksToBounds = YES;
    attachView.layer.borderColor = [UIColor grayColor].CGColor;
    attachView.layer.cornerRadius = 3.0f;
    attachView.layer.masksToBounds = YES;
    [pannelView addSubview:attachView];
    
    counterLb = [[UILabel alloc] initWithFrame:counterLbFrame];
    counterLb.textAlignment = counterAlignment;
    counterLb.backgroundColor = [UIColor clearColor];
    counterLb.textColor = TW_GrayColor;
    counterLb.shadowColor = [UIColor whiteColor];
    counterLb.shadowOffset = CGSizeMake(0, 1.0f);
    counterLb.font = [UIFont systemFontOfSize:counterPointSize];
    counterLb.text = @"0";
    [pannelView addSubview:counterLb];
    
    indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    indicator.frame = indicatorFrame;
    [indicator stopAnimating];
    [pannelView addSubview:indicator];
}

/*显示View*/
- (void)startDisplayAnimation{
    [tbTextView innerBecomeFirstResponder];
}

/*隐藏View*/
- (void)startDismissAnimation{
    [tbTextView innerResignFirstResponder];
    self.delegate = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"UIInterfaceOrientationDidChangeNotification" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    if (IOS_VERSION >= 5.0)
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
}

/*从父对象中删除自身*/
- (void)removeMe{;
    [self removeFromSuperview];
}

/*开始send的动画*/
- (void)beginSendAnimation{
    [indicator startAnimating];
    cancelBt.enabled = NO;
    sendBt.enabled = NO;
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
}

/*结束send的动画*/
- (void)endSendAnimation{
    [indicator stopAnimating];
    cancelBt.enabled = YES;
    sendBt.enabled = YES;
    [[UIApplication sharedApplication] endIgnoringInteractionEvents];
}

#pragma mark - KVC Methods
- (void)deviceOrientationDidChange:(id)notification{
    rotating = YES;
    CGFloat duration = [UIApplication sharedApplication].statusBarOrientationAnimationDuration;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:duration];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(resetRorateFlag)];
    [self initCoordinates];
    
    self.frame = CGRectMake(0, 0, screenWidth, screenHeight);
    pannelView.frame = pannelViewFrame;
    pannelView.center = CGPointMake(CGRectGetWidth(self.frame)/2.0, -CGRectGetHeight(self.frame)/2.0);
    pannelView.image = pannelViewImg;
    
    cancelBt.frame = cancelBtFrame;
    [cancelBt setImage:cancelBtImg forState:UIControlStateNormal];
    
    sendBt.frame = sendBtFrame;
    [sendBt setImage:sendBtImg forState:UIControlStateNormal];
    
    tbTextView.frame = tbTextViewFrame;
    tbTextView.delegate = self;
    [tbTextView setTextViewWidth:innerTextWidth];
    
    attachView.frame = attachViewFrame;
    
    counterLb.frame = counterLbFrame;
    counterLb.textAlignment = counterAlignment;
    counterLb.font = [UIFont systemFontOfSize:counterPointSize];
    
    indicator.frame = indicatorFrame;
    
    [UIView commitAnimations];
}


- (void)resetRorateFlag{
    rotating = NO;
    pannelView.center = CGPointMake(CGRectGetWidth(self.frame)/2.0,(CGRectGetHeight(self.frame)-keyboardHeight)/2.0);
    
}

#pragma mark - Button Functions
- (void)cancelPressed:(id)sender{
    [self startDismissAnimation];
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
        [self moveInputBarWithKeyboardHeight:0 withDuration:0.25];
    
    /////蛋疼bug
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"NoAD"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    /////
}

- (void)sendPressed:(id)sender{
    if(wordsLimit != -1 && [counterLb.text intValue] < 0){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                        message:[NSString stringWithFormat:TW_WordsLimit_Message,wordsLimit]
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        [alert release];
        return;
    }
    
    
    [self beginSendAnimation];
    switch (editorType) {
        case TWEditorMessage:
            [[Twitter sharedTwitter] beginShareMessage:self.shareText];
            break;
            
        case TWEditorMessageAndImage:
            [[Twitter sharedTwitter] beginShareMessage:self.shareText image:self.shareImage];
            break;
    }
//    [[Twitter sharedTwitter] uploadVideo:self.videoData message:self.shareText];
    [Twitter sharedTwitter].delegate = self;
    
}

#pragma mark - TableTextViewDeleagte Methods
- (void)textViewDidChange:(UITextView *)textView{
    [shareText release];
    shareText = [[tbTextView getTextViewString] retain];
    [self syncCounterDisplay];
}

#pragma mark - FacebookDeleagte Methods
/*事务请求成功*/
- (void)twTransactionSuccessWithKey:(NSString *)key data:(NSData *)data{
    if([key isEqualToString:TW_CallBack_ShareMessage] || [key isEqualToString:TW_CallBack_ShareMessageAndImage]){
        if(self.delegate && [self.delegate  respondsToSelector:@selector(twEditorSendSuccessed:)])
            [self.delegate twEditorSendSuccessed:data];
        [self endSendAnimation];
//        [self startDismissAnimation];
//        [self moveInputBarWithKeyboardHeight:0 withDuration:0.25];
        [self cancelPressed:nil];
    }
    
}

/*事务请求失败*/
- (void)twTransactionFailedWithKey:(NSString *)key error:(NSError *)error{
    [self endSendAnimation];
    if(self.delegate && [self.delegate  respondsToSelector:@selector(twEditorSendFailed:)])
        [self.delegate twEditorSendFailed:error];
    if(error.code == TW_ErrorCode_OAuth){
        [self startDismissAnimation];
        [self moveInputBarWithKeyboardHeight:0 withDuration:0.25];
    }
}

@end
