//
//  TwitterOauthView.h
//
//  Created by yanglei on 12-8-22.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//
// Support Device Only Iphone
// Push NotificationCenter “UIInterfaceOrientationDidChangeNotification” to auto rotate interface orientation
// TW_AccountProfile contain "name","screen_name","profile_image_url"


#import <UIKit/UIKit.h>
#import "TwitterUIConfig.h"

@protocol TwitterOauthViewDeleagte<NSObject>
@optional
/*验证成功的回调方法*/
- (void)twOauthSuccessed;

@end

@interface TwitterOauthView : UIView<UIWebViewDelegate,UIAlertViewDelegate>{
    UIWebView *oauthWeb;
    UIImageView *background;
    UIView *loadingView;
    UINavigationBar *navigation;
    
    NSString *requestToken;
    NSString *requestSecret;
    
    TWAnimationType animationType;
    
    UIImage *bgImg;
    CGRect loadingFrame;
    ////
    BOOL isStartDismissAnimation;
}

@property(nonatomic,assign) id<TwitterOauthViewDeleagte> delegate;

/*弹出授权界面*/
+ (void)showInView:(UIView *)view delegate:(id)_delegate animation:(TWAnimationType)animation;

/*判断屏幕的类型*/
+ (TWDisplayType)checkDisplayTye;

/*判断是否是Iphone5*/
+ (BOOL)isIphone5;

@end
