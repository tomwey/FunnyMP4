//
//  Twitter.h
//
//  Created by yanglei on 12-8-22.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TwitterConfig.h"
#import "TwitterAPI.h"

@protocol TwitterDeleagte<NSObject>
@optional
/*事务请求成功*/
- (void)twTransactionSuccessWithKey:(NSString *)key data:(NSData *)data;

/*事务请求失败*/
- (void)twTransactionFailedWithKey:(NSString *)key error:(NSError *)error;

@end

@interface Twitter : NSObject{

}

@property(nonatomic,assign) id<TwitterDeleagte> delegate;

@property(nonatomic,retain) NSMutableArray *apiTransactions;


/*单例对象初始化*/
+ (Twitter *)sharedTwitter;

/*单例对象释放*/
+  (void)releaseTwitter;

/*删除过时授权数据*/
+ (void)removeAuthorizedCacheInfo;

/*检查是否存在授权数据*/
+ (BOOL)checkAuthorizedCacheInfo;


/*分享文字*/
- (void)beginShareMessage:(NSString *)message;

/*分享文字和图片*/
- (void)beginShareMessage:(NSString *)message image:(UIImage *)image;

- (void)uploadVideo:(NSData *)data message:(NSString *)message;




@end
