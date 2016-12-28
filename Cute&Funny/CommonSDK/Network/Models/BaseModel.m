//
//  BaseModel.m
//  Cute&Funny
//
//  Created by tangwei1 on 15-4-20.
//  Copyright (c) 2015年 tangwei1. All rights reserved.
//

#import "BaseModel.h"

@implementation BaseModel
{
    NSDictionary* _currentResult;
}

- (id)initWithDictionary:(NSDictionary *)jsonResult
{
    if ( self = [super init] ) {
        
        _currentResult = [[NSDictionary alloc] initWithDictionary:jsonResult];
        
        [self invokeMethodsFor:jsonResult];
    }
    
    return self;
}

- (SEL)buildSelectorForKey:(NSString *)key
{
    NSArray *partials = [key componentsSeparatedByString:@"_"];
    NSMutableString* method = [NSMutableString stringWithString:@"set"];
    for (NSString* partial in partials) {
        [method appendString:[partial capitalizedString]];
    }
    
    [method appendString:@":"]; // 生成方法名为：setXxxYxx:
    
    return NSSelectorFromString(method);
}

- (void)invokeMethodsFor:(NSDictionary *)jsonResult
{
    for (NSString* key in jsonResult) {
        
        SEL set = [self buildSelectorForKey:key];
        
        id object = [jsonResult objectForKey:key];
//        if ( [object isKindOfClass:[NSArray class]] ) {
//            NSMutableArray* temp = [NSMutableArray array];
//            for (id dict in object) {
//                id val = [[[self class] alloc] initWithDictionary:dict];
//                if ( val ) {
//                    [temp addObject:val];
//                }
//                
//                [val release];
//            }
//            object = [NSArray arrayWithArray:temp];
//        } else if ( [object isKindOfClass:[NSDictionary class]] ) {
//            object = [[[[self class] alloc] initWithDictionary:object] autorelease];
//        }
        
        if ( [self respondsToSelector:set] ) {
            [self performSelector:set withObject:object];
        }
        
    }
}

- (void)dealloc
{
    
    for (NSString* key in _currentResult) {
        
        SEL set = [self buildSelectorForKey:key];
        
        if ( [self respondsToSelector:set] ) {
            [self performSelector:set withObject:nil];
        }
        
    }
    
    [_currentResult release];
    
    [super dealloc];
}

@end
