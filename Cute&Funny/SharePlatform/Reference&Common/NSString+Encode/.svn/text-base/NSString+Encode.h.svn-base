//
//  NSString+Encode.h
//
//  Created by yanglei on 12-5-31.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString(Encode)

/*URL特殊字符转义*/
- (NSString *)URLEncode;

/*进行HMAC-SHA1加密*/
- (NSString *)HMACSHA1EncodeWithSecret:(NSString *)secret;

/*创建oauth_nonce*/
+ (NSString *)createOauthNonce;

/*创建oauth_timestamp*/
+(NSString *)createOauthTimestamp;


@end
