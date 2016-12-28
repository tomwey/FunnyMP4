//
//  MediaTypeLoadInfo.h
//  Cute&Funny
//
//  Created by tangwei1 on 15/6/4.
//  Copyright (c) 2015年 tangwei1. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, MediaInfoType) {
    MediaInfoTypeRecent = 0,
    MediaInfoTypePopular = 1,
};

@interface MediaTypeLoadInfo : NSObject

@property (nonatomic, assign) int currentMediaIndex;

@property (nonatomic, assign) int mediaType;

@property (nonatomic, assign) int currentPage;

@property (nonatomic, assign) NSInteger totalRecords;

@property (nonatomic, retain, readonly) NSMutableArray* dataSource;

+ (MediaTypeLoadInfo *)buildLoadInfoForIndex:(int)mediaIndex mediaType:(int)type page:(int)page;

@end

typedef void (^LoadingResultBlock)(MediaTypeLoadInfo* info, BOOL succeed);

@interface MediaTypeLoadInfoManager : NSObject

+ (id)sharedInstance;

- (void)startLoadingMediaInfos:(LoadingResultBlock)resultBlock forType:(MediaInfoType)infoType;

//- (BOOL)canLoadNextPageForType:(MediaInfoType)infoType;

- (void)loadNextPageMediaInfosIfNeededForType:(LoadingResultBlock)resultBlock forType:(MediaInfoType)infoType;

- (MediaTypeLoadInfo *)currentMediaInfoForType:(MediaInfoType)infoType;

@end
