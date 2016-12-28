//
//  NSObjectAdditions.h
//  Cute&Funny
//
//  Created by tangwei1 on 15-4-17.
//  Copyright (c) 2015年 tangwei1. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (AWCategory)

/**
 * 动态调用一个对象的某个方法
 */
- (id)performSelector:(SEL)aSelector withArguments:(NSArray *)arguments;

@end
