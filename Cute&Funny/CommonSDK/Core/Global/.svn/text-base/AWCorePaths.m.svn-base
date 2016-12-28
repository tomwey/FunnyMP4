//
//  CorePaths.m
//  Cute&Funny
//
//  Created by tangwei1 on 15-4-16.
//  Copyright (c) 2015年 tangwei1. All rights reserved.
//

#import "AWCorePaths.h"

// 判断url是否以 "bundle://" 开始
BOOL AWIsBundleURL(NSString* url)
{
    return [url hasPrefix:@"bundle://"];
}

// 判断url是否以 "documents://" 开始
BOOL AWIsDocumentsURL(NSString* url)
{
    return [url hasPrefix:@"documents://"];
}

// main bundle path 拼接一个相对的路径
NSString* AWPathForBundleResource(NSString* relativePath)
{
    NSString* resourcePath = [[NSBundle mainBundle] resourcePath];
    return [resourcePath stringByAppendingPathComponent:relativePath];
}

// documents path 拼接一个相对的路径
NSString* AWPathForDocumentsResource(NSString* relativePath)
{
    static NSString* documentsPath = nil;
    if ( !documentsPath ) {
        NSArray* dirs = NSSearchPathForDirectoriesInDomains(
          NSDocumentDirectory, NSUserDomainMask, YES);
        documentsPath = [[dirs objectAtIndex:0] copy];
    }
    
    return [documentsPath stringByAppendingPathComponent:relativePath];
}

NSString* AWPathForCachesResource(NSString* relativePath)
{
    static NSString* cachesPath = nil;
    if ( !cachesPath ) {
        NSArray* dirs = NSSearchPathForDirectoriesInDomains(
                                                            NSCachesDirectory, NSUserDomainMask, YES);
        cachesPath = [[dirs objectAtIndex:0] copy];
    }
    
    return [cachesPath stringByAppendingPathComponent:relativePath];
}
