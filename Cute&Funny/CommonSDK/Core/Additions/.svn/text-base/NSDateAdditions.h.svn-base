//
//  NSDateAdditions.h
//  Cute&Funny
//
//  Created by tangwei1 on 15-4-16.
//  Copyright (c) 2015年 tangwei1. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (AWCategory)

/**
 * 获取今天的日期，例如："2015-04-16"
 */
+ (NSDate *)dateWithToday;

/**
 * 格式化一个时间, 例如："12:00:00"
 */
- (NSString *)formatTime;

/**
 * 格式化一个日期，例如："2015-04-16"
 */
- (NSString *)formatDate;

/**
 * 根据时间格式化为一个短时间
 * 
 * 时间小于一天，格式化为："HH:mm:ss a"
 * 时间小于一周，格式化为："EEEE"
 * 除此之外，格式为："yyyy/MM/dd"
 */
- (NSString *)formatShortTime;

/**
 * 根据当前日期时间进行格式化
 *
 * 时间小于一天，格式化为："h:mm a"
 * 时间小于一周，格式化为："EEE h:mm a"
 * 时间小于一年，格式化为："MMM d h:mm a"
 */
- (NSString *)formatDateTime;

/**
 * 格式化时间差，例如24小时以内为："5 分钟前"，超过24小时，访问formatDateTime
 */

- (NSString *)formatRelativeTime;

@end
