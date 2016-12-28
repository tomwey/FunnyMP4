//
//  Command.h
//  CountDown
//
//  Created by tangwei1 on 14-4-30.
//  Copyright (c) 2014年 tangwei1. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const kUserDataEntityKey;
extern NSString * const kUserDataMessageKey;
extern NSString * const kUserDataParentViewControllerKey;

@interface Command : NSObject

- (id)initWithUserData:(id)userData;
+ (id)commandWithUserData:(id)userData;

+ (id)commandWithClass:(Class)clz;

- (void)execute;

@property (nonatomic, retain) id userData;

@end
