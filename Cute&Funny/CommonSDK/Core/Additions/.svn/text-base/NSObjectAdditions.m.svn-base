//
//  NSObjectAdditions.m
//  Cute&Funny
//
//  Created by tangwei1 on 15-4-17.
//  Copyright (c) 2015年 tangwei1. All rights reserved.
//

#import "NSObjectAdditions.h"

@implementation NSObject (AWCategory)

- (id)performSelector:(SEL)aSelector withArguments:(NSArray *)arguments
{
    NSMethodSignature* sig = [NSMethodSignature methodSignatureForSelector:aSelector];
    
    if ( !sig ) {
        return nil;
    }
    
    NSInvocation* invoc = [NSInvocation invocationWithMethodSignature:sig];
    [invoc setTarget:self];
    [invoc setSelector:aSelector];
    
    int i = 0;
    for (id arg in arguments) {
        [invoc setArgument:&arg atIndex: i + 2];
        i ++;
    }
    
    [invoc invoke];
    
    if ( sig.methodReturnLength ) {
        id anObject;
        [invoc getReturnValue:&anObject];
        return anObject;
    }
    
    return nil;
}


@end
