//
//  FacebookEditor.h
//
//  Created by yanglei on 12-8-27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FacebookUIConfig.h"
#import "TableTextView.h"
#import "Facebook.h"

typedef enum{
    /*发送信息到涂鸦墙*/
    FBEditorFeed = 0,
    
    /*上传图片*/
    FBEditorUpload
    
} FBEditorType;

@protocol FacebookEditorDeleagte<NSObject>
@optional
/*提交成功回调方法*/
- (void)fbEditorSendSuccessed:(NSData *)data;

/*提交失败回调方法*/
- (void)fbEditorSendFailed:(NSError *)error;

@end

@interface FacebookEditor : UIView<TableTextViewDeleagte,FacebookDeleagte>{
    UIImageView *pannelView;
    UIButton *cancelBt;
    UIButton *sendBt;
    TableTextView *tbTextView;
    UIImageView *attachView;
    UILabel *counterLb;
    UIActivityIndicatorView *indicator;
    
    FBEditorType editorType;
    BOOL rotating;
    CGFloat keyboardHeight;
    
    CGRect pannelViewFrame;
    UIImage *pannelViewImg;
    CGRect cancelBtFrame;
    UIImage *cancelBtImg;
    CGRect sendBtFrame;
    UIImage *sendBtImg;
    CGRect tbTextViewFrame;
    CGFloat innerTextWidth;
    CGRect attachViewFrame;
    CGRect counterLbFrame;
    CGFloat counterPointSize;
    NSTextAlignment counterAlignment;
    CGRect indicatorFrame;
}

@property(nonatomic,assign) id<FacebookEditorDeleagte> delegate;

/*设置文本框中的文字*/
@property(nonatomic,retain) NSString *shareText;

/*设置分享的图片*/
@property(nonatomic,retain) UIImage *shareImage;

@property (nonatomic,retain) NSData* videoData;

/*Facebook FeedWall的特有参数*/
@property(nonatomic,retain) NSMutableDictionary *shareParameters;

/*文字限制*/
@property(nonatomic,assign) NSInteger wordsLimit;

/*Editor界面*/
+ (FacebookEditor *)showInView:(UIView *)view type:(FBEditorType)type delegate:(id)_delegate;

/*判断屏幕的类型*/
+ (FBDisplayType)checkDisplayTye;

/*判断是否是Iphone5*/
+ (BOOL)isIphone5;


@end
