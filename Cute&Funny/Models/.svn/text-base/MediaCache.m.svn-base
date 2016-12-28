//
//  MediaCache.m
//  Cute&Funny
//
//  Created by tangwei1 on 15-4-22.
//  Copyright (c) 2015年 tangwei1. All rights reserved.
//

#import "MediaCache.h"
#import "Defines.h"
#import <objc/runtime.h>

static inline NSString* MediaCacheDataDirectory()
{
    static NSString* cachesDir = nil;
    if ( !cachesDir ) {
        cachesDir = [[NSHomeDirectory() stringByAppendingPathComponent:@"Library/Caches"] retain];
    }
    
    NSString* mediaDataDir = [cachesDir stringByAppendingPathComponent:@"MediaData"];
    if ( ![[NSFileManager defaultManager] fileExistsAtPath:mediaDataDir] ) {
        [[NSFileManager defaultManager] createDirectoryAtPath:mediaDataDir
                                  withIntermediateDirectories:YES
                                                   attributes:nil
                                                        error:nil];
    }
    
    return mediaDataDir;
}

static inline NSString* MediaCacheFilePathFromURLRequest(NSURLRequest *request)
{
    NSString* fileName = [[[[request URL] absoluteString] componentsSeparatedByString:@"/"] lastObject];
    return [MediaCacheDataDirectory() stringByAppendingPathComponent:fileName];
}

@implementation MediaCache

+ (MediaCache *)sharedCache
{
    static MediaCache* instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if ( !instance ) {
            instance = [[MediaCache alloc] init];
        }
    });
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wgnu"
    return objc_getAssociatedObject(self, @selector(sharedImageCache)) ?: instance;
#pragma clang diagnostic pop
}

- (NSURL *)cachedFileURLForRequest:(NSURLRequest *)request
{
    return [NSURL fileURLWithPath:MediaCacheFilePathFromURLRequest(request)];
}

- (NSURL *)cachedFileURLForMediaURLString:(NSString *)urlString
{
    NSString* fileName = [[urlString componentsSeparatedByString:@"/"] lastObject];
    return [NSURL fileURLWithPath:[MediaCacheDataDirectory() stringByAppendingPathComponent:fileName]];
}

- (unsigned long long)fileSizeForCachedData
{
    NSFileManager* fgr = [NSFileManager defaultManager];
    
    NSArray* files = [fgr contentsOfDirectoryAtPath:MediaCacheDataDirectory() error:nil];
    
    unsigned long long sum = 0;
    
    for ( NSString* file in files ) {
        NSString* filePath = [MediaCacheDataDirectory() stringByAppendingPathComponent:file];
        NSDictionary* attributes = [[NSFileManager defaultManager] attributesOfItemAtPath:filePath
                                                                                    error:nil];
        sum += [attributes fileSize];
    }
    
    return sum;
}

- (NSData *)cachedDataForRequest:(NSURLRequest *)request
{
    switch ([request cachePolicy]) {
        case NSURLRequestReloadIgnoringCacheData:
        case NSURLRequestReloadIgnoringLocalAndRemoteCacheData:
        {
            return nil;
        }
            
        default:
            break;
    }
    
    NSString* cachedFilePath = MediaCacheFilePathFromURLRequest(request);
    
    return [NSData dataWithContentsOfFile:cachedFilePath];
}

- (void)cacheData:(NSData *)data forRequest:(NSURLRequest *)request
{
    if ( data && request ) {
        [data writeToFile:MediaCacheFilePathFromURLRequest(request) atomically:YES];
    }
}

- (void)removeAllCaches
{
    
    [[NSFileManager defaultManager] removeItemAtPath:MediaCacheDataDirectory() error:nil];
}

@end
