//
//  ShortenLinkManager.m
//  Cute&Funny
//
//  Created by tangwei1 on 15/6/23.
//  Copyright (c) 2015年 tangwei1. All rights reserved.
//

#import "ShortenLinkManager.h"
#import "Defines.h"

@implementation ShortenLinkManager
{
    NSMutableDictionary* _cacheUrls;
}

AW_SINGLETON_IMPL(ShortenLinkManager)

- (id)init
{
    if ( self = [super init] ) {
        _cacheUrls = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (void)shorten:(NSString *)longUrl completion:( void (^)(NSString *shortenUrl) )completion
{
    if ( [_cacheUrls objectForKey:longUrl] ) {
        if ( completion ) {
            completion([_cacheUrls objectForKey:longUrl]);
        }
        return;
    }
    
    // 加载
    NSString* shortenUrl = [NSString stringWithFormat:@"https://api-ssl.bitly.com/v3/shorten?access_token=%@&longUrl=%@",
                            BITLY_ACCESS_TOKEN, [longUrl URLEncode]];
    
    [MBProgressHUD showHUDAddedTo:AWAppWindow() animated:YES];
    
    [[AFHTTPRequestOperationManager manager] GET:shortenUrl
                                      parameters:nil
                                         success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                             [MBProgressHUD hideHUDForView:AWAppWindow() animated:YES];
                                             
                                             int code = [[responseObject objectForKey:@"status_code"] integerValue];
                                             if ( code == 200 ) {
                                                 NSString* shortUrl = [[responseObject objectForKey:@"data"] objectForKey:@"url"];
                                                 
                                                 [_cacheUrls setObject:shortUrl forKey:longUrl];
                                                 
                                                 if ( completion ) {
                                                     completion([_cacheUrls objectForKey:longUrl]);
                                                 }
                                                 
                                             } else {
                                                 [Toast showText:@"Shorten Link Error."];
                                             }
                                         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                             [MBProgressHUD hideHUDForView:AWAppWindow() animated:YES];
                                             
                                             [Toast showText:@"Shorten Link Error."];
                                         }];
}

@end
