//
//  CoreLocale.m
//  Cute&Funny
//
//  Created by tangwei1 on 15-4-16.
//  Copyright (c) 2015年 tangwei1. All rights reserved.
//

#import "AWCoreLocale.h"

/**
 * @获取当前用户选择的地区
 */
NSLocale* AWCurrentLocale()
{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    NSArray* languages = [defaults objectForKey:@"AppleLanguages"];
    if ( languages.count > 0 ) {
        NSString* currentLanguage = [languages objectAtIndex:0];
        return [[[NSLocale alloc] initWithLocaleIdentifier:currentLanguage] autorelease];
    }
    
    return [NSLocale currentLocale];
}

/**
 * @从Common bundle下返回一个本地化字符串
 */
NSString* AWLocalizedString(NSString* key, NSString* comment)
{
    static NSBundle* bundle  = nil;
    if ( !bundle ) {
        NSString* path = [[[NSBundle mainBundle] resourcePath]
                          stringByAppendingPathComponent:@"AWSDK.bundle"];
        bundle = [[NSBundle bundleWithPath:path] retain];
    }
    
    return [bundle localizedStringForKey:key value:key table:nil];
}

/**
 * @针对网络操作错误，返回一个本地化的描述
 */
NSString* AWDescriptionForError(NSError* error)
{
    if ( [error.domain isEqualToString:NSURLErrorDomain] ) {
        switch ( error.code ) {
            case NSURLErrorTimedOut:
            {
                return AWLocalizedString(@"Connection Timed Out", @"");
            }
                
            case NSURLErrorNotConnectedToInternet:
            {
                return AWLocalizedString(@"No Internet Connection", @"");
            }

            default:
                return AWLocalizedString(@"Connection Error", @"");
        }
    }
    
    return AWLocalizedString(@"Error", @"");
}

/**
 * @本地格式化一个数字，例如：XX,XXX,XXX.XX
 */
NSString* AWFormatInteger(NSInteger num)
{
    NSNumber* number = [NSNumber numberWithInteger:num];
    NSNumberFormatter* formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    NSString* formatted = [formatter stringFromNumber:number];
    [formatter release];
    return formatted;
}
