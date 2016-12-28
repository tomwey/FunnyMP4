//
//  TwitterAPI.h
//
//  Created by yanglei on 12-8-22.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>

@interface TwitterAPI : NSObject

/*验证第一步：获取RequestToken*/
+ (NSMutableURLRequest *)createRequestTokenRequest;

/*验证第二步：官网用户验证，获取oauth_verifier*/
+ (NSMutableURLRequest *)createAuthorizeRequest:(NSString *)requestToken;

/*验证第三步：RequestToken RequestSecret 交换 AccessToken AccessSecret*/
+ (NSMutableURLRequest *)createAccessTokenRequestWithToken:(NSString *)token 
                                                   secrect:(NSString *)secrect 
                                                  verifier:(NSString *)verifier;

/*在AccessToken存在的情况下判断是否合法（过期，无效，撤销）*/
+ (NSMutableURLRequest *)createVerifyCredentialsRequest;

/*分享文字*/
+ (NSMutableURLRequest *)createShareMsgRequestWithMessage:(NSString *)message;

/*分享文字和图片*/
+ (NSMutableURLRequest *)createShareMsgAndImgRequestWithMessage:(NSString *)message image:(UIImage *)image;

+ (NSMutableURLRequest *)createShareMsgAndVideoRequestWithMessage:(NSString *)message video:(NSData *)data;

@end
