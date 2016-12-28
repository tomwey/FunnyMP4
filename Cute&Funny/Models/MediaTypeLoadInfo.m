//
//  MediaTypeLoadInfo.m
//  Cute&Funny
//
//  Created by tangwei1 on 15/6/4.
//  Copyright (c) 2015年 tangwei1. All rights reserved.
//

#import "MediaTypeLoadInfo.h"
#import "Defines.h"

@implementation MediaTypeLoadInfo

- (void)dealloc
{
    [_dataSource release];
    
    [super dealloc];
}

- (id)init
{
    if ( self = [super init] ) {
        _dataSource = [[NSMutableArray alloc] init];
        self.totalRecords = 0;
    }
    
    return self;
}

+ (MediaTypeLoadInfo *)buildLoadInfoForIndex:(int)mediaIndex mediaType:(int)type page:(int)page
{
    MediaTypeLoadInfo* li = [[[MediaTypeLoadInfo alloc] init] autorelease];
    li.currentMediaIndex = mediaIndex;
    li.mediaType = type;
    li.currentPage = page;
    
    return li;
}

- (NSString *)uri
{
    switch (self.mediaType) {
        case MediaInfoTypeRecent:
            return [NSString stringWithFormat:@"%@/all/res/gif/recent/%d?user=%@", kDomainURL, self.currentPage, [OpenUDID value]];
        case MediaInfoTypePopular:
            return [NSString stringWithFormat:@"%@/all/res/gif/popular/%d?user=%@", kDomainURL, self.currentPage, [OpenUDID value]];
            
        default:
            break;
    }
    
    return nil;
}

@end

@implementation MediaTypeLoadInfoManager
{
    NSMutableDictionary* _loadInfos;
    BOOL                 _loading;
}

AW_SINGLETON_IMPL(MediaTypeLoadInfoManager)

- (id)init
{
    if ( self = [super init] ) {
        _loadInfos = [[NSMutableDictionary alloc] init];
        
        MediaTypeLoadInfo* recentInfo = [MediaTypeLoadInfo buildLoadInfoForIndex:0 mediaType:MediaInfoTypeRecent page:1];
        MediaTypeLoadInfo* popularInfo = [MediaTypeLoadInfo buildLoadInfoForIndex:0 mediaType:MediaInfoTypePopular page:1];
        
        [_loadInfos setObject:recentInfo forKey:[self keyForMediaType:MediaInfoTypeRecent]];
        [_loadInfos setObject:popularInfo forKey:[self keyForMediaType:MediaInfoTypePopular]];
        
//        [[NSNotificationCenter defaultCenter] addObserver:self
//                                                 selector:@selector(didResignActive)
//                                                     name:UIApplicationDidEnterBackgroundNotification
//                                                   object:nil];
    }
    
    return self;
}

- (void)didResignActive
{
    for (id key in _loadInfos) {
        MediaTypeLoadInfo* info = [_loadInfos objectForKey:key];
        [info.dataSource removeAllObjects];
        info.currentPage = 1;
        info.currentMediaIndex = 0;
    }
}

- (NSString *)keyForMediaType:(MediaInfoType)infoType
{
    return [NSString stringWithFormat:@"%ld", infoType];
}

- (void)startLoadingMediaInfos:(LoadingResultBlock)resultBlock forType:(MediaInfoType)infoType
{
    MediaTypeLoadInfo* info = [_loadInfos objectForKey:[self keyForMediaType:infoType]];
    
    if ( [info.dataSource count] != 0 ) {
        resultBlock(info, YES);
        return;
    }
    
    if ( info.currentPage == 1 ) {
        [info.dataSource removeAllObjects];
        
        [MBProgressHUD showHUDAddedTo:AWAppWindow().rootViewController.view animated:YES];
    }
    
    [[AFHTTPRequestOperationManager manager] GET:[info uri]
                                      parameters:nil
                                         success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                             [MBProgressHUD hideHUDForView:AWAppWindow().rootViewController.view animated:YES];
                                             
                                             NSInteger total = [[responseObject objectForKey:@"total"] integerValue];
                                             if ( info.totalRecords != 0 ) {
                                                 // 已经加载过
                                                 if ( total > info.totalRecords ) {
                                                     // 有新的数据需要更新
                                                     // 重新刷新数据
                                                     
                                                     // 重置当前Load info状态
                                                     [info.dataSource removeAllObjects];
                                                     info.currentPage = 1;
                                                     info.currentMediaIndex = 0;
                                                     
                                                     [self startLoadingMediaInfos:resultBlock forType:infoType];
                                                 }
                                             } else {
                                                 // 第一次加载
                                                 info.totalRecords = total;
                                                 
                                                 [info.dataSource addObjectsFromArray:[responseObject objectForKey:@"data"]];
                                                 
                                                 dispatch_async(dispatch_get_main_queue(), ^{
                                                     if ( resultBlock ) {
                                                         resultBlock(info, YES);
                                                     }
                                                 });
                                             }

                                         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                             [MBProgressHUD hideHUDForView:AWAppWindow().rootViewController.view animated:YES];
                                             
                                             dispatch_async(dispatch_get_main_queue(), ^{
                                                 if ( resultBlock ) {
                                                     resultBlock(info, NO);
                                                 }
                                             });
                                             
                                         }];
}

- (void)loadNextPageMediaInfosIfNeededForType:(LoadingResultBlock)resultBlock forType:(MediaInfoType)infoType
{
    if ( ![self canLoadNextPageForType:infoType] ) {
        return;
    }
    
    if ( _loading ) {
        return;
    }
    
    _loading = YES;
    
    MediaTypeLoadInfo* info = [_loadInfos objectForKey:[self keyForMediaType:infoType]];
    
    info.currentPage ++;
    
    [[AFHTTPRequestOperationManager manager] GET:[info uri]
                                      parameters:nil
                                         success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                             [MBProgressHUD hideHUDForView:AWAppWindow() animated:YES];
                                             
                                             _loading = NO;
                                             
                                             [info.dataSource addObjectsFromArray:[responseObject objectForKey:@"data"]];
                                             
                                             dispatch_async(dispatch_get_main_queue(), ^{
                                                 if ( resultBlock ) {
                                                     resultBlock(info, YES);
                                                 }
                                             });
                                             
                                         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                             [MBProgressHUD hideHUDForView:AWAppWindow() animated:YES];
                                             
                                             _loading = NO;
                                             
                                             dispatch_async(dispatch_get_main_queue(), ^{
                                                 if ( resultBlock ) {
                                                     resultBlock(info, NO);
                                                 }
                                             });
                                             
                                         }];
}

- (BOOL)canLoadNextPageForType:(MediaInfoType)infoType
{
    MediaTypeLoadInfo* info = [_loadInfos objectForKey:[self keyForMediaType:infoType]];
    
    return ( info.currentMediaIndex == 72 * info.currentPage - 5 );
}

- (MediaTypeLoadInfo *)currentMediaInfoForType:(MediaInfoType)infoType
{
    return [_loadInfos objectForKey:[self keyForMediaType:infoType]];
}

@end
