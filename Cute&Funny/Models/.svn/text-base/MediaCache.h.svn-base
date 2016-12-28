//
//  MediaCache.h
//  Cute&Funny
//
//  Created by tangwei1 on 15-4-22.
//  Copyright (c) 2015年 tangwei1. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MediaCache : NSObject

+ (MediaCache *)sharedCache;

- (NSData *)cachedDataForRequest:(NSURLRequest *)request;
- (void)cacheData:(NSData *)data forRequest:(NSURLRequest *)request;

- (void)removeAllCaches;

- (NSURL *)cachedFileURLForRequest:(NSURLRequest *)request;

- (NSURL *)cachedFileURLForMediaURLString:(NSString *)urlString;

- (unsigned long long)fileSizeForCachedData;

@end
