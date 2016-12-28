//
//  ShortenLinkManager.h
//  Cute&Funny
//
//  Created by tangwei1 on 15/6/23.
//  Copyright (c) 2015年 tangwei1. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShortenLinkManager : NSObject

+ (id)sharedInstance;

- (void)shorten:(NSString *)longUrl completion:( void (^)(NSString *shortenUrl) )completion;

@end
