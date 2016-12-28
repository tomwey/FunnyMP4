//
//  FacebookOauthView.h
//
//  Created by yanglei on 12-8-23.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//
// Support Device Only Iphone
// Push NotificationCenter “UIInterfaceOrientationDidChangeNotification” to auto rotate interface orientation

/*Profile Example{
 "id": "100003781872468",
 "name": "XX",
 "first_name": "X",
 "last_name": "X",
 "link": "XXXXXXXXX",
 "username": "XXXX",
 "birthday": "8/23/2012",
 "gender": "male",
 "timezone": 8,
 "locale": "en_US",
 "verified": true,
 "updated_time": "2012-07-26T06:44:44+0000"
 }*/

#import <UIKit/UIKit.h>
#import "FacebookUIConfig.h"

@protocol FacebookOauthViewDeleagte<NSObject>
@optional
/*授权成功的回调方法*/
- (void)fbOauthSuccessed;

@end

@interface FacebookOauthView : UIView<UIWebViewDelegate,UIAlertViewDelegate>{
    UIWebView *oauthWeb;
    UIImageView *background;
    UIView *loadingView;
    UINavigationBar *navigation;
    
    FBAnimationType animationType;
    
    UIImage *bgImg;
    CGRect loadingFrame;
}
@property (nonatomic,assign) id<FacebookOauthViewDeleagte> delegate;

/*弹出授权界面*/
+ (void)showInView:(UIView *)view delegate:(id)_delegate animation:(FBAnimationType)animation;

/*判断屏幕的类型*/
+ (FBDisplayType)checkDisplayTye;

/*判断是否是Iphone5*/
+ (BOOL)isIphone5;

@end
