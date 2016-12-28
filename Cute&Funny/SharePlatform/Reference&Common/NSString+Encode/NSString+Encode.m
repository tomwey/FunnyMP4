//
//  NSString+Encode.m
//
//  Created by yanglei on 12-5-31.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <CommonCrypto/CommonHMAC.h>
#import "NSString+Encode.h"
#import "GTMBase64.h"

@implementation NSString(Encode)

/*URL特殊字符转义*/
- (NSString *)URLEncode{
    
    NSString * encodedString = (NSString *)CFURLCreateStringByAddingPercentEscapes(NULL,(CFStringRef)self,NULL,(CFStringRef)@"!*'();:@&=+$,/?%#[]",kCFStringEncodingUTF8 );
	[encodedString autorelease];
	return encodedString;
    
}

/*进行HMAC-SHA1加密*/
- (NSString *)HMACSHA1EncodeWithSecret:(NSString *)secret{
    const char *cSecret  = [secret cStringUsingEncoding:NSUTF8StringEncoding];
    const char *cString = [self cStringUsingEncoding:NSUTF8StringEncoding];
	
    char cHMAC[CC_SHA1_DIGEST_LENGTH];
	
    CCHmac(kCCHmacAlgSHA1, cSecret, strlen(cSecret), cString, strlen(cString), cHMAC);
	
    NSData *HMAC = [[NSData alloc] initWithBytes:cHMAC length:CC_SHA1_DIGEST_LENGTH]; 
    
    NSString *oauthSignature = [[[NSString alloc] initWithData:[GTMBase64 encodeData:HMAC] encoding:NSUTF8StringEncoding] autorelease];
	[HMAC release];
		
	return oauthSignature;
}

/*创建oauth_nonce*/
+ (NSString *)createOauthNonce{
    CFUUIDRef uuidObj = CFUUIDCreate(kCFAllocatorDefault);
    CFStringRef strRef = CFUUIDCreateString(kCFAllocatorDefault, uuidObj);
    NSString* uuidString = [[NSString stringWithString:(NSString*)strRef] stringByReplacingOccurrencesOfString:@"-" withString:@""];
    CFRelease(strRef);
    CFRelease(uuidObj);
    return uuidString;
    
}

/*创建oauth_timestamp*/
+(NSString *)createOauthTimestamp{
    NSDate *datenow = [NSDate date];
	NSString *identifyCode = [NSString stringWithFormat:@"%ld", (long)[datenow  timeIntervalSince1970]];
	return identifyCode;
    
}



@end
