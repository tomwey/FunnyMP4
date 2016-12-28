//
//  CoreMacros.h
//  Cute&Funny
//
//  Created by tangwei1 on 15-4-16.
//  Copyright (c) 2015年 tangwei1. All rights reserved.
//

#ifndef AWCoreMacros_h
#define AWCoreMacros_h

// 自定义日志输出方法
#ifdef DEBUG

#define AW_LOG(s, ...) do { \
    NSLog(@"<%@:(%d)> %@", [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__,[NSString stringWithFormat:(s), ##__VA_ARGS__]);\
} while(0)

#else

#define AW_LOG(s, ...) do {} while(0)

#endif

/////////////////////////////////////////////////////////////////////////////////////

// 单例实现
#define AW_SINGLETON_IMPL(__CLASS_NAME) \
\
static __CLASS_NAME* instance = nil;\
\
+ (__CLASS_NAME*)sharedInstance \
{ \
    @synchronized(self) { \
        if ( nil == instance ) { \
            instance = [[__CLASS_NAME alloc] init]; \
        } \
    } \
    \
    return instance; \
} \
\
- (oneway void)superRelease \
{ \
    [super release]; \
} \
\
+ (void)releaseSharedInstance \
{ \
    @synchronized(self) { \
        [instance superRelease]; \
        instance = nil; \
    } \
} \
\
+ (id)allocWithZone:(NSZone *)zone \
{ \
    @synchronized(self) { \
        if ( nil == instance ) { \
            instance = [super allocWithZone:zone]; \
        } \
    } \
    \
    return instance; \
} \
\
- (id)copyWithZone:(NSZone *)zone \
{ \
    return instance; \
} \
\
- (id)retain \
{ \
    return instance; \
} \
\
- (NSUInteger)retainCount \
{ \
    return NSUIntegerMax; \
} \
\
- (oneway void)release \
{ \
} \
\
- (id)autorelease \
{ \
    return instance; \
} 

/////////////////////////////////////////////////////////////////////////////////////

// Time
#define AW_MINUTE    60
#define AW_HOUR      ( 60 * AW_MINUTE )
#define AW_DAY       ( 24 * AW_HOUR )
#define AW_5_DAYS ( 5 * AW_DAY )
#define AW_WEEK      ( 7 * AW_DAY )
#define AW_MONTH     ( 30.5 * AW_DAY )
#define AW_YEAR      ( 365 * AW_DAY )

// Safe releases
#define AW_RELEASE_SAFELY(__POINTER) { [__POINTER release]; __POINTER = nil; }
#define AW_INVALIDATE_TIMER(__TIMER) { [__TIMER invalidate]; __TIMER = nil; }

// Release a CoreFoundation object safely
#define AW_RELEASE_CF_SAFELY(__REF)  { if ( nil != (__REF) ) { CFRelease(__REF); __REF = nil; } }

#endif
