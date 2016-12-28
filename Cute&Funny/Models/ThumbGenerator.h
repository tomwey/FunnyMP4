//
//  ThumbGenerator.h
//  Cute&Funny
//
//  Created by tangwei1 on 15-4-27.
//  Copyright (c) 2015年 tangwei1. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Defines.h"

@class Media;
@interface ThumbGenerator : NSObject

+ (ThumbGenerator *)sharedInstance;

- (UIImage *)generateThumbnailForMedia:(Media *)aMedia forType:(NSString *)type;

- (void)removeThumbnailForMedia:(Media *)aMedia forType:(NSString *)type;

@end
