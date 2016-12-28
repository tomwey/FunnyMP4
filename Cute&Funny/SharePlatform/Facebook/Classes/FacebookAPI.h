//
//  FacebookAPI.h
//
//  Created by yanglei on 12-8-23.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface FacebookAPI : NSObject

/*涂鸦墙Dialog*/
/*
 Dialog parameters Key:"name","link","picture","caption","description","properties"({"XXXXXX":{"text":"XXXXXX","href":"XXXXXX"}})
 */
+ (NSMutableURLRequest *)createFeedWallDialogRequest:(NSMutableDictionary *)parameters;

/*私信Dialog*/
/*
 Dialog parameters Key:"to"{ProfileID},"name","link","picture","caption","description","properties"({"XXXXXX":{"text":"XXXXXX","href":"XXXXXX"}})
 */
+ (NSMutableURLRequest *)createPrivateMsgDialogRequest:(NSMutableDictionary *)parameters;

/*创建获取AccessToken的请求*/
+ (NSMutableURLRequest *)createAccessTokenRequest;

/*创建获取用户开放权限的请求*/
+ (NSMutableURLRequest *)createPermissionsRequest;

/*创建获取用户基础信息的请求*/
+ (NSMutableURLRequest *)createProfileRequest;

/*创建获取用户相册信息的请求*/
+ (NSMutableURLRequest *)createAlbumsRequest;

/*创建创建相册的请求*/
+ (NSMutableURLRequest *)createCreateAlbumWithName:(NSString*)name message:(NSString *)message;

/*创建获取用户好友列表的请求*/
+ (NSMutableURLRequest *)createFriendsListRequest;

/*创建获取用户事件的请求*/
+ (NSMutableURLRequest *)createEventsListRequestForStart:(NSDate *)start end:(NSDate *)end;

/*发送消息到涂鸦墙*/
+ (NSMutableURLRequest *)createShareMsgRequestWithMessage:(NSString *)message parameters:(NSMutableDictionary *)parameters;

/*创建上传图片和信息的请求*/
+ (NSMutableURLRequest *)createUploadImgRequestWithAlbumID:(NSString *)albumID 
                                                     image:(UIImage *)image
                                                   message:(NSString *)message;
@end
