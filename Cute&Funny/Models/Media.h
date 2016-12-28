//
//  Media.h
//  Cute&Funny
//
//  Created by tangwei1 on 15-4-20.
//  Copyright (c) 2015年 tangwei1. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Defines.h"

@interface Media : BaseModel

@property (nonatomic, copy) NSString* id;

@property (nonatomic, copy) NSString* title;

@property (nonatomic, copy) NSString* mp4Url;

@property (nonatomic, copy) NSString* gifUrl;

@property (nonatomic, copy) NSString* dislikeCount;

@property (nonatomic, copy) NSString* likeCount;

@property (nonatomic, copy) NSString* bfunny; // 是否点过funny

@property (nonatomic, copy) NSString* bcute;  // 是否点过cute

@end
