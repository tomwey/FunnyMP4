//
//  SRHttpFetcher.m
//
//  Created by yanglei on 12-2-16.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "SRHttpFetcher.h"

#define SR_IOS_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]
#define SAFE_Release(p)	if(p) { [p release]; p = nil; }

@implementation SRHttpFetcher
@synthesize srDelegate;
@synthesize connect,receivedData,srRequest,parObject;

#pragma mark - Object LifeCycle 

+ (SRHttpFetcher *)beginFetchWithRequest:(NSMutableURLRequest *)request 
                                  object:(NSObject *)object 
                                delegate:(id)delegate{
    SRHttpFetcher *httpFetcher = [[[[self class] alloc] initWithRequest:request 
                                                                 object:object
                                                               delegate:delegate] autorelease];
    [httpFetcher beginFetch];
    return httpFetcher;
}

- (id)initWithRequest:(NSMutableURLRequest *)request
             object:(NSObject *)object
             delegate:(id)delegate{
    self = [super init];
    if (self) {
        self.parObject = object;
        self.srDelegate = delegate;
        self.srRequest = request;
    }
    return self;
}

- (void)dealloc{
    if([self isFetching]){
        [self stopFetching];
    }
    
    if(SR_IOS_VERSION >= 4.0)
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidEnterBackgroundNotification object:nil];
    
    SAFE_Release(receivedData);
    SAFE_Release(connect);
    SAFE_Release(srRequest);
    SAFE_Release(parObject);
    SAFE_Release(srDelegate);
    [super dealloc];
}

#pragma mark - Public Methods
- (void)beginFetch{
    //退入后台维持请求
    if(SR_IOS_VERSION >= 4.0)
        [[NSNotificationCenter defaultCenter] addObserver:self 
												 selector:@selector(appDidEnterBackground:)
													 name:UIApplicationDidEnterBackgroundNotification 
												   object:nil];
    
    self.connect = [NSURLConnection connectionWithRequest:self.srRequest delegate:self];
    if (self.connect) 
        self.receivedData = [NSMutableData dataWithLength:0];  
}

- (void)appDidEnterBackground:(id)sender{
    UIApplication *app = [UIApplication sharedApplication];
    bgTask = [app beginBackgroundTaskWithExpirationHandler:^{ 
        [app endBackgroundTask:bgTask];
        bgTask = UIBackgroundTaskInvalid;
    }];
}

/*判断是否正在请求*/
- (BOOL)isFetching{
    return self.connect != nil;
}

/*停止正在请求的链接*/
- (void)stopFetching{
    [self.connect cancel];
    self.connect = nil;
}

#pragma mark - NSURLConnection Delegate Method
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    statusCode = ((NSHTTPURLResponse *)response).statusCode;
    totalLength = [[NSNumber numberWithLongLong:[response expectedContentLength]] floatValue];
    self.receivedData = [NSMutableData dataWithLength:0];  
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    [receivedData appendData:data];
    
    if(self.srDelegate){
        if([self.srDelegate respondsToSelector:@selector(receiveProgressWithPercent:object:)])
            [self.srDelegate receivingProgressWithPercent:receivedData.length/totalLength object:self.parObject];
        if([self.srDelegate respondsToSelector:@selector(receiveMiddleDataWithData:object:)])
            [self.srDelegate receivingPieceDataWithData:receivedData object:self.parObject];
    }
    
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    NSLog(@"error: %@",error);
    [self stopFetching];
    if(self.srDelegate){
        if([self.srDelegate respondsToSelector:@selector(requestFaildWithError:object:)])
            [self.srDelegate requestFaildWithError:error object:self.parObject];
        if([self.srDelegate respondsToSelector:@selector(requestDidFinishedWithObject:)])
            [self.srDelegate requestDidFinishedWithObject:self.parObject];
    }
    self.receivedData = [NSMutableData dataWithLength:0];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
    if(statusCode >= 300){
        NSString *response = [[NSString alloc] initWithData:self.receivedData encoding:NSUTF8StringEncoding];
        NSError *error = [NSError errorWithDomain:@"SRHttpFetcher.HTTPStatus" code:statusCode userInfo:[NSDictionary dictionaryWithObject:response forKey:@"SRHttpFetcher.ErrorInfo" ]];
        [self connection:connection didFailWithError:error];
        [response release];
        return;
    }
    
    [self stopFetching];
    if(self.srDelegate){
        if([self.srDelegate respondsToSelector:@selector(requestSuccessWithData:object:)])
            [self.srDelegate requestSuccessWithData:self.receivedData object:self.parObject];
        if([self.srDelegate respondsToSelector:@selector(requestDidFinishedWithObject:)])
            [self.srDelegate requestDidFinishedWithObject:self.parObject];
    }
    self.receivedData = [NSMutableData dataWithLength:0];
}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection willCacheResponse:(NSCachedURLResponse *)cachedResponse{
    return nil;
}

@end
