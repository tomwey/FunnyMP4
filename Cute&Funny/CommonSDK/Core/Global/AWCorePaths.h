//
//  CorePaths.h
//  Cute&Funny
//
//  Created by tangwei1 on 15-4-16.
//  Copyright (c) 2015年 tangwei1. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * 判断url是否以 "bundle://" 开始
 */
BOOL AWIsBundleURL(NSString* url);

/**
 * 判断url是否以 "documents://" 开始
 */
BOOL AWIsDocumentsURL(NSString* url);

/**
 * main bundle path 拼接一个相对的路径
 */
NSString* AWPathForBundleResource(NSString* relativePath);

/**
 * documents path 拼接一个相对的路径
 */
NSString* AWPathForDocumentsResource(NSString* relativePath);

/**
 * caches path 拼接一个相对路径
 */
NSString* AWPathForCachesResource(NSString* relativePath);