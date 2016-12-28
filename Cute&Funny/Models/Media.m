//
//  Media.m
//  Cute&Funny
//
//  Created by tangwei1 on 15-4-20.
//  Copyright (c) 2015年 tangwei1. All rights reserved.
//

#import "Media.h"

@implementation Media

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@, %@, %@", self.title, self.mp4Url, self.gifUrl];
}

@end
