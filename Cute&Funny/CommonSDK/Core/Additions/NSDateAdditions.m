//
//  NSDateAdditions.m
//  Cute&Funny
//
//  Created by tangwei1 on 15-4-16.
//  Copyright (c) 2015年 tangwei1. All rights reserved.
//

#import "NSDateAdditions.h"
#import "AWCoreMacros.h"
#import "AWCoreLocale.h"

@implementation NSDate (AWCategory)

/**
 * 获取今天的日期，例如："2015-04-16"
 */
+ (NSDate *)dateWithToday
{
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd";
    
    NSString* formattedTime = [formatter stringFromDate:[NSDate date]];
    NSDate* date = [formatter dateFromString:formattedTime];
    
    AW_RELEASE_SAFELY(formatter);
    
    return date;
}

/**
 * 格式化一个时间, 例如："12:00:00"
 */
- (NSString *)formatTime
{
    static NSDateFormatter* formatter = nil;
    if ( !formatter ) {
        formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = AWLocalizedString(@"h:mm a", @"Date format: 1:05 pm");
        formatter.locale = AWCurrentLocale();
    }
    
    return [formatter stringFromDate:self];
}

/**
 * 格式化一个日期，例如："2015-04-16"
 */
- (NSString *)formatDate
{
    static NSDateFormatter* formatter = nil;
    if ( !formatter ) {
        formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = AWLocalizedString(@"EEEE, LLLL d, YYYY", @"Date format: Monday, July 27, 2009");
        formatter.locale = AWCurrentLocale();
    }
    
    return [formatter stringFromDate:self];
}

/**
 * 根据时间格式化为一个短时间
 *
 * 时间小于一天，格式化为："HH:mm:ss a"
 * 时间小于一周，格式化为："EEEE"
 * 除此之外，格式为："yyyy/MM/dd"
 */
- (NSString *)formatShortTime
{
    NSTimeInterval diff = abs([self timeIntervalSinceNow]);
    
    if ( diff < AW_DAY ) {
        return [self formatTime];
    }
    
    if ( diff < AW_5_DAYS ) {
        static NSDateFormatter* formatter = nil;
        if ( !formatter ) {
            formatter = [[NSDateFormatter alloc] init];
            formatter.dateFormat = AWLocalizedString(@"EEEE", @"Date format: Monday");
            formatter.locale = AWCurrentLocale();
        }
        
        return [formatter stringFromDate:self];
    } else {
    
        static NSDateFormatter* formatter = nil;
        if ( !formatter ) {
            formatter = [[NSDateFormatter alloc] init];
            formatter.dateFormat = AWLocalizedString(@"M/d/yy", @"Date format: 7/27/09");
            formatter.locale = AWCurrentLocale();
        }
        
        return [formatter stringFromDate:self];
    }
}

/**
 * 根据当前日期时间进行格式化
 *
 * 时间小于一天，格式化为："h:mm a"
 * 时间小于一周，格式化为："EEE h:mm a"
 * 时间小于一年，格式化为："MMM d h:mm a"
 */
- (NSString *)formatDateTime
{
    NSTimeInterval diff = abs([self timeIntervalSinceNow]);
    if ( diff < AW_DAY ) {
        return [self formatTime];
    } else if (diff < AW_5_DAYS) {
        static NSDateFormatter* formatter = nil;
        if (!formatter) {
            formatter = [[NSDateFormatter alloc] init];
            formatter.dateFormat = AWLocalizedString(@"EEE h:mm a", @"Date format: Mon 1:05 pm");
            formatter.locale = AWCurrentLocale();
        }
        return [formatter stringFromDate:self];
        
    } else {
        static NSDateFormatter* formatter = nil;
        if (!formatter) {
            formatter = [[NSDateFormatter alloc] init];
            formatter.dateFormat = AWLocalizedString(@"MMM d h:mm a", @"Date format: Jul 27 1:05 pm");
            formatter.locale = AWCurrentLocale();
        }
        return [formatter stringFromDate:self];
    }
}

/**
 * 格式化时间差，例如24小时以内为："5 分钟前"，超过24小时，访问formatDateTime
 */

- (NSString *)formatRelativeTime
{
    NSTimeInterval elapsed = abs([self timeIntervalSinceNow]);
    if ( elapsed <= 1 ) {
        return AWLocalizedString(@"just a moment ago", @"");
    } else if ( elapsed < AW_MINUTE ) {
        int seconds = (int)(elapsed);
        return [NSString stringWithFormat:AWLocalizedString(@"%d seconds ago", @""), seconds];
    } else if ( elapsed < 2 * AW_MINUTE ) {
        return AWLocalizedString(@"about a minute ago", @"");
    } else if ( elapsed < AW_HOUR ) {
        int mins = (int) ( elapsed / AW_MINUTE );
        return [NSString stringWithFormat:AWLocalizedString(@"%d minutes ago", @""), mins];
    } else if ( elapsed < AW_HOUR * 1.5 ) {
        return AWLocalizedString(@"about an hour ago", @"");
    } else if ( elapsed < AW_DAY ) {
        int hours = (int) ( ( elapsed + AW_HOUR / 2 ) / AW_HOUR );
        return [NSString stringWithFormat:AWLocalizedString(@"%d hours ago", @""), hours];
    } else {
        return [self formatDateTime];
    }
}

@end
