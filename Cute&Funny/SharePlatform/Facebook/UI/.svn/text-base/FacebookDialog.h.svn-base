//
//  FacebookDialog.h
//
//  Created by yanglei on 12-8-24.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FacebookUIConfig.h"

typedef enum{
    /*涂鸦墙*/
    FBDialogWall = 0,
    
    /*私信*/
    FBDialogPrivaeMessage
    
} FBDialogType;


@protocol FacebookDialogDeleagte<NSObject>
@optional
/*dialog提交成功回调方法*/
- (void)fbDialogSubmitSuccessed;

@end

@interface FacebookDialog : UIView<UIWebViewDelegate,UIAlertViewDelegate>{
    UIView *pannel;
    UIView *centerView;
    UIActivityIndicatorView *indicator;
    UIWebView *dialogWeb;
    UIButton *closeBt;
    
    FBAnimationType animationType;
    FBDialogType dialogType;
}
@property(nonatomic,assign) id<FacebookDialogDeleagte> delegate;

/*Dialog界面*/
+ (void)showInView:(UIView *)view type:(FBDialogType)_type parameters:(NSMutableDictionary *)parameters  delegate:(id)_delegate animation:(FBAnimationType)animation;

/*判断屏幕的类型*/
+ (FBDisplayType)checkDisplayTye;

/*判断是否是Iphone5*/
+ (BOOL)isIphone5;

@end
