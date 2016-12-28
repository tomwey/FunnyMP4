//
//  Facebook.h
//
//  Created by yanglei on 12-8-23.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FacebookConfig.h"
#import "FacebookAPI.h"

@protocol FacebookDeleagte<NSObject>
@optional
/*事务请求成功*/
- (void)fbTransactionSuccessWithKey:(NSString *)key data:(NSData *)data;

/*事务请求失败*/
- (void)fbTransactionFailedWithKey:(NSString *)key error:(NSError *)error;

@end

@interface Facebook : NSObject{
    NSString *albumID;
    UIImage *uploadImg;
    NSString *uploadMsg;
}

@property(nonatomic,assign) id<FacebookDeleagte> delegate;

@property(nonatomic,retain) NSMutableArray *apiTransactions;

/*单例对象初始化*/
+ (Facebook *)sharedFacebook;

/*单例对象释放*/
+  (void)releaseFacebook;

/*删除过时授权数据*/
+ (void)removeAuthorizedCacheInfo;

/*检查是否存在授权数据*/
+ (BOOL)checkAuthorizedCacheInfo;

/*获取朋友列表*/
- (void)beginFetchFriendsList;

/* 获取事件列表 */
- (void)beginFetchEventsListForStartDate:(NSDate *)startDate endDate:(NSDate *)endDate forKey:(NSString *)key;

/*发送信息到涂鸦墙*/
- (void)beginPostToFeedWallWithMessage:(NSString *)message parameters:(NSMutableDictionary *)parameters;

/*上传图片到相册*/
- (void)beginUploadImgWithImage:(UIImage *)image
                        message:(NSString *)messag;

- (void)uploadVideo:(NSData *)videoData message:(NSString *)message;

@end



