//
//  TwitterEditor.h
//
//  Created by yanglei on 12-8-29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "TwitterUIConfig.h"
#import "TableTextView.h"
#import "Twitter.h"

typedef enum{
    /*发送文字信息*/
    TWEditorMessage= 0,
    
    /*发送图片和文字信息*/
    TWEditorMessageAndImage
    
} TWEditorType;

@protocol TwitterEditorDeleagte<NSObject>
@optional
/*提交成功回调方法*/
- (void)twEditorSendSuccessed:(NSData *)data;

/*提交失败回调方法*/
- (void)twEditorSendFailed:(NSError *)error;

@end

@interface TwitterEditor : UIView<TableTextViewDeleagte,TwitterDeleagte>{
    UIImageView *pannelView;
    UIButton *cancelBt;
    UIButton *sendBt;
    TableTextView *tbTextView;
    UIImageView *attachView;
    UILabel *counterLb;
    UIActivityIndicatorView *indicator;
    
    TWEditorType editorType;
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

@property(nonatomic,assign) id<TwitterEditorDeleagte> delegate;

/*设置文本框中的文字*/
@property(nonatomic,retain) NSString *shareText;

/*设置分享的图片*/
@property(nonatomic,retain) UIImage *shareImage;

@property (nonatomic, retain) NSData* videoData;

/*文字限制*/
@property(nonatomic,assign) NSInteger wordsLimit;

/*Editor界面*/
+ (TwitterEditor *)showInView:(UIView *)view type:(TWEditorType)type delegate:(id)_delegate;

/*判断屏幕的类型*/
+ (TWDisplayType)checkDisplayTye;

/*判断是否是Iphone5*/
+ (BOOL)isIphone5;

@end
