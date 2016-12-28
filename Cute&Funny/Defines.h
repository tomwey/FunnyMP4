//
//  Defines.h
//  Cute&Funny
//
//  Created by tangwei1 on 15-4-16.
//  Copyright (c) 2015年 tangwei1. All rights reserved.
//

#ifndef Cute_Funny_Defines_h
#define Cute_Funny_Defines_h

#import "AWSDK.h"

#define RGBA(__R, __G, __B, __A) [UIColor colorWithRed:(__R) / 255.0 \
                                                 green:(__G) / 255.0 \
                                                  blue:(__B) / 255.0 \
                                                 alpha:(__A)]
#define RGB(__R, __G, __B) RGBA(__R, __G, __B, 1.0)

static inline UIImageView* createImageView(NSString* imageName) {
    UIImageView* imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
    [imageView sizeToFit];
    return [imageView autorelease];
};

static inline UIImageView* createImageViewWithFrame(NSString* imageName, CGRect frame) {
    UIImageView* imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
    imageView.frame = frame;
    return [imageView autorelease];
};

static inline UILabel* createLabel(CGRect frame, NSTextAlignment alignment, UIFont* font, UIColor* textColor)
{
    UILabel* label = [[UILabel alloc] initWithFrame:frame];
    label.textAlignment = alignment;
    label.textColor = textColor;
    label.backgroundColor = [UIColor clearColor];
    label.font = font;
    
    return [label autorelease];
};

static inline UIButton* createImageButton(NSString* imageName, id target, SEL selector) {
    UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [button sizeToFit];
    [button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    button.exclusiveTouch = YES;
    
    return button;
};

#define kAPIHost @"http://10.0.18.2:8000/pocket/funny1/all/res/gif"

/*************************** MoPub账号设置 **************************/

#define IPHONE_BANNER_ID         @"52ad1f5cdcd7469f80267e562630e1e6"
#define IPHONE_FULLSCREEN_ID     @"cfa26ea7c70f4d00aa0dc1937ab23e9c"

#define IPAD_BANNER_ID           @"d09f2c8b25674d77aa502a6de1016c3d"
#define IPAD_FULLSCREEN_ID       @"4f73dc0246da45818921e17cacdae097"

// 方块广告，如果不需要支持可以留空
#define IPHONE_MEDIUM_RECT_ID    @""
#define IPAD_MEDIUM_RECT_ID      @""

// Chartboost账号，如果不需要支持开启chartboost会话，可以留空
#define CHARTBOOST_APP_ID        @""
#define CHARTBOOST_APP_SIGNATURE @""

/*************************** Flurry账号 ****************************/
// 如果留空不设置，那么表示不支持Flurry
#define FLURRY_KEY               @"6EMCBAA7SRI2HVA54MHF"
#define BITLY_ACCESS_TOKEN       @"5b46afdfe7361a5f0e79377844b81fe1f1321a5e"

#define TITLE_FONT               AWCustomFont(@"AbadiMT-CondensedExtraBold", 20)//[UIFont fontWithName:@"AbadiMT-CondensedExtraBold" size:20]

/*************************** Privacy Page设置 ****************************/
// 如果留空默认为http://www.xxx.com/privacy.html, 其中xxx为bundle id中间部分
#define PRIVACY_PAGE_URL         @""

#if DEBUG
#define kDomainURL @"http://laugh-origin.sniperstudio.com/pocket/funny1"//@"http://10.0.18.2:8000/pocket/funny1"
#else
#define kDomainURL @"http://laugh-origin.sniperstudio.com/pocket/funny1"
#endif
#define kAppStoreUrl @"http://itunes.apple.com/app/id509160525"

#define kMainBackgroundColor RGB(28,31,40)

#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>

#import "InMobi.h"
#import "Flurry.h"

#import "OpenUDID.h"

#import "AnalyticsTool.h"

#import "AdsPopupManager.h"

#import "AppDelegate.h"

// Models
#import "Media.h"
#import "MediaTypeLoadInfo.h"
#import "MediaCache.h"

#import "ShortenLinkManager.h"

#import "SendFacebookCommand.h"
#import "SendInstagramCommand.h"
#import "SendMailCommand.h"
#import "SendSMSCommand.h"
#import "SendTumblrCommand.h"
#import "SendTwitterCommand.h"
#import "SaveCommand.h"
#import "ThumbGenerator.h"

#import "NetworkService.h"

// Views
#import "CustomNavigationBar.h"
#import "AlertView.h"
#import "CategoryView.h"
#import "JTListView.h"
//#import "CustomToolbar.h"
#import "SocialButton.h"
#import "SocialButtonsContainer.h"
#import "Toast.h"
#import "ThumbCollectionViewCell.h"

#import "CategoryButton.h"
#import "ThumbMediaView.h"

#import "EditOperView.h"

//#import "MovieView.h"
#import "MediaView.h"
#import "ProfileTopbar.h"
#import "ModalAlert.h"
#import "MMMediaView.h"
#import "MMDraggableView.h"

// Controllers
#import "HomeViewController.h"
#import "UserProfileViewController.h"
#import "ThumbViewController.h"
#import "ShareViewController.h"
#import "SettingsViewController.h"
#import "LegalViewController.h"
#import "LikeListViewController.h"
#import "LikeDetailViewController.h"

#import "CHTCollectionViewWaterfallLayout.h"

#endif
