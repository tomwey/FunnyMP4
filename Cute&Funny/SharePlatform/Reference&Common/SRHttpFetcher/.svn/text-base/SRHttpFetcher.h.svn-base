//
//  SRHttpFetcher.h
//
//  Created by yanglei on 12-2-16.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SRHttpFetcherDelegate <NSObject,NSURLConnectionDelegate>

@optional

/*请求成功的回调方法*/
- (void)requestSuccessWithData:(NSData *)data object:(NSObject *)object;

/*请求失败的回调方法*/
- (void)requestFaildWithError:(NSError *)error object:(NSObject *)object;

/*请求完成的回调方法(无论请求成败都会触发)*/
- (void)requestDidFinishedWithObject:(NSObject *)object;

/*请求过程中的进度回调方法*/
- (void)receivingProgressWithPercent:(float)percent object:(NSObject *)object;

/*请求过程中每获取一个数据块时的回调方法*/
- (void)receivingPieceDataWithData:(NSData *)data object:(NSObject *)object;

@end

@interface SRHttpFetcher : NSObject{
    NSUInteger bgTask; 
    NSInteger statusCode;
    float totalLength;
}
@property(nonatomic,retain) id<SRHttpFetcherDelegate> srDelegate;
@property(nonatomic,retain) NSURLConnection *connect;
@property(nonatomic,retain) NSMutableData *receivedData;
@property(nonatomic,retain) NSMutableURLRequest *srRequest;
@property(nonatomic,retain) NSObject *parObject;

/*发起请求，类方法*/
+ (SRHttpFetcher *)beginFetchWithRequest:(NSMutableURLRequest *)request 
                                  object:(NSObject *)object 
                                delegate:(id)delegate;

/*初始化对象*/
- (id)initWithRequest:(NSMutableURLRequest *)request
               object:(NSObject *)object
             delegate:(id)delegate;

/*发起请求，对象方法*/
- (void)beginFetch;

/*判断是否正在请求*/
- (BOOL)isFetching;

/*停止正在请求的链接*/
- (void)stopFetching;
@end
