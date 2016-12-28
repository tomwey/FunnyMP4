//
//  Command.m
//  CountDown
//
//  Created by tangwei1 on 14-4-30.
//  Copyright (c) 2014年 tangwei1. All rights reserved.
//

#import "Command.h"

@implementation Command

NSString * const kUserDataEntityKey = @"kUserDataEntityKey";
NSString * const kUserDataMessageKey = @"kUserDataMessageKey";
NSString * const kUserDataParentViewControllerKey = @"kUserDataParentViewControllerKey";

@synthesize userData = _userData;

- (id)initWithUserData:(id)userData
{
    if ( self = [super init] ) {
        self.userData = userData;
    }
    
    return self;
}

+ (id)commandWithUserData:(id)userData
{
    return [[[[self class] alloc] initWithUserData:userData] autorelease];
}

+ (id)commandWithClass:(Class)clz
{
    return [[[clz alloc] init] autorelease];
}

- (void)dealloc
{
    [_userData release];
    
    [super dealloc];
}

- (void)execute
{
    [NSException raise:@"非法访问" format:@"请重写该方法"];
}

@end
