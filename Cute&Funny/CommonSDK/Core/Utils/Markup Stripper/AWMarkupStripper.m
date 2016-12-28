//
//  AWMarkupStripper.m
//  Cute&Funny
//
//  Created by tangwei1 on 15-4-17.
//  Copyright (c) 2015年 tangwei1. All rights reserved.
//

#import "AWMarkupStripper.h"

#import "AWCoreMacros.h"
#import "AWEntityTables.h"

@implementation AWMarkupStripper
{
    NSMutableArray* _strings;
}

- (void)dealloc
{
    AW_RELEASE_SAFELY(_strings);
    
    [super dealloc];
}

#pragma mark -
#pragma mark NSXMLParserDelegate

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    [_strings addObject:string];
}

- (NSData *)       parser:(NSXMLParser *)parser
resolveExternalEntityName:(NSString *)name
                 systemID:(NSString *)systemID
{
    return [[[AWEntityTables sharedInstance] iso88591] objectForKey:name];
}

- (NSString *)parse:(NSString *)htmlString
{
    _strings = [[NSMutableArray alloc] init];
    
    NSString* document = [NSString stringWithFormat:@"<x>%@</x>", htmlString];
    NSData* data = [document dataUsingEncoding:htmlString.fastestEncoding];
    NSXMLParser* parser = [[NSXMLParser alloc] initWithData:data];
    parser.delegate = self;
    [parser parse];
    
    AW_RELEASE_SAFELY(parser);
    
    NSString* result = [_strings componentsJoinedByString:@""];
    
    AW_RELEASE_SAFELY(_strings);
    
    return result;
}

@end
