//
//  TwitterAPI.m
//
//  Created by yanglei on 12-8-22.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "TwitterAPI.h"
#import "TwitterConfig.h"
#import "NSString+Encode.h"

#define TW_VERSION @"1.0"
#define TW_SIGNATURE_METHOD @"HMAC-SHA1"

static NSString *oauth_nonce = nil;
static NSString *oauth_timestamp = nil;

@implementation TwitterAPI

#pragma mark - Inner Methods
/*默认Basestring*/
+ (NSMutableString *)defaultBaseStringWithMethod:(NSString *)httpMethod 
                                             url:(NSString *)url 
                                           token:(NSString *)token{
    
    if(token != nil && token != NULL)
        return [NSMutableString stringWithFormat:@"%@&%@&oauth_consumer_key%%3D%@%%26oauth_nonce%%3D%@%%26oauth_signature_method%%3D%@%%26oauth_timestamp%%3D%@%%26oauth_token%%3D%@%%26oauth_version%%3D%@",httpMethod,[url URLEncode],TW_Consumerkey,oauth_nonce,TW_SIGNATURE_METHOD,oauth_timestamp,token,TW_VERSION];
    else
        return [NSMutableString stringWithFormat:@"%@&%@&oauth_consumer_key%%3D%@%%26oauth_nonce%%3D%@%%26oauth_signature_method%%3D%@%%26oauth_timestamp%%3D%@%%26oauth_version%%3D%@",httpMethod,[url URLEncode],TW_Consumerkey,oauth_nonce,TW_SIGNATURE_METHOD,oauth_timestamp,TW_VERSION];
}

/*生成带参的Basestring*/
+ (NSString *)baseStringWithParameters:(NSMutableArray *)parameters 
                                method:(NSString *)httpMethod 
                                   url:(NSString *)url 
                                 token:(NSString *)token{
    
    NSMutableString *baseString = [TwitterAPI defaultBaseStringWithMethod:httpMethod 
                                                                      url:url 
                                                                    token:token];
    
    if(parameters != nil && parameters != NULL){
        if([parameters count] > 0){
            for(NSDictionary *child in parameters){
                for(NSString *key in child){
                    [baseString appendString:@"%26"];
                    [baseString appendFormat:@"%@%%3D%@",key,[[child objectForKey:key] URLEncode]];
                }
            }
        }
    }
    
    return baseString;
}

/*默认URLstring*/
+ (NSMutableString *)defaultURLStringWithSignatrue:(NSString *)signature
                                               url:(NSString *)url 
                                             token:(NSString *)token{
    
    if(token != nil && token != NULL)
        return [NSMutableString stringWithFormat:@"%@?oauth_consumer_key=%@&oauth_nonce=%@&oauth_signature_method=%@&oauth_timestamp=%@&oauth_token=%@&oauth_version=%@&oauth_signature=%@",url,TW_Consumerkey,oauth_nonce,TW_SIGNATURE_METHOD,oauth_timestamp,token,TW_VERSION,[signature URLEncode]];
    else
        return [NSMutableString stringWithFormat:@"%@?oauth_consumer_key=%@&oauth_nonce=%@&oauth_signature_method=%@&oauth_timestamp=%@&oauth_version=%@&oauth_signature=%@",url,TW_Consumerkey,oauth_nonce,TW_SIGNATURE_METHOD,oauth_timestamp,TW_VERSION,[signature URLEncode]];
}

/* 生成带参的URLstring*/
+ (NSString *)urlStringWithParameters:(NSMutableArray *)parameters 
                            signatrue:(NSString *)signature 
                                  url:(NSString *)url 
                                token:(NSString *)token{
    
    NSMutableString *urlString = [TwitterAPI defaultURLStringWithSignatrue:signature 
                                                                       url:url 
                                                                     token:token];
    
    if(parameters != nil && parameters != NULL){
        if([parameters count] > 0){
            for(NSDictionary *child in parameters){
                for(NSString *key in child){
                    [urlString appendString:@"&"];
                    [urlString appendFormat:@"%@=%@",key,[[child objectForKey:key] URLEncode]];
                }
            }
        }
    }
    
    return urlString;
}

/*默认Authorization*/
+ (NSMutableString *)defaultAuthorizationWithSignatrue:(NSString *)signature 
                                                 token:(NSString *)token {
    
    return [NSMutableString stringWithFormat:@"OAuth oauth_consumer_key=\"%@\", oauth_nonce=\"%@\", oauth_signature_method=\"%@\", oauth_timestamp=\"%@\", oauth_token=\"%@\", oauth_version=\"%@\", oauth_signature=\"%@\"",
            TW_Consumerkey,oauth_nonce,TW_SIGNATURE_METHOD,oauth_timestamp,token,TW_VERSION,[signature URLEncode]];
}

/*生成带参的Authorization*/
+ (NSString *)authorizationWithParameters:(NSMutableArray *)parameters 
                                signatrue:(NSString *)signature 
                                    Token:(NSString *)token{
    
    NSMutableString *authorization = [TwitterAPI defaultAuthorizationWithSignatrue:signature token:token];
    
    if(parameters != nil && parameters != NULL){
        if([parameters count] > 0){
            for(NSDictionary *child in parameters){
                for(NSString *key in child){
                    [authorization appendString:@", "];
                    [authorization appendFormat:@"%@=\"%@\"",key,[[child objectForKey:key] URLEncode]];
                }
            }
        }
    }
    return authorization;
}

#pragma mark - Outer Methods
/*验证第一步：获取RequestToken*/
+ (NSMutableURLRequest *)createRequestTokenRequest{
    oauth_nonce = [NSString createOauthNonce];
    oauth_timestamp = [NSString createOauthTimestamp];
    
    NSString *baseString = [TwitterAPI baseStringWithParameters:nil 
                                                         method:@"GET" 
                                                            url:TW_RequestTokenURL 
                                                          token:nil];;
    NSString *secret = [NSString stringWithFormat:@"%@&",TW_Consumersecret];
    NSString *oauth_signature = [baseString HMACSHA1EncodeWithSecret:secret];
    
    
    NSString *urlString = [TwitterAPI urlStringWithParameters:nil 
                                                    signatrue:oauth_signature 
                                                          url:TW_RequestTokenURL 
                                                        token:nil];
    return [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString] 
                                   cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                               timeoutInterval:20];
}

/*验证第二步：官网用户验证，获取oauth_verifier*/
+ (NSMutableURLRequest *)createAuthorizeRequest:(NSString *)requestToken{
    NSString *urlString = [NSString stringWithFormat:@"%@?oauth_token=%@",TW_AuthorizeURL,requestToken];
    return [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    
}

/*验证第三步：RequestToken RequestSecret 交换 AccessToken AccessSecret*/
+ (NSMutableURLRequest *)createAccessTokenRequestWithToken:(NSString *)token 
                                                   secrect:(NSString *)secrect 
                                                  verifier:(NSString *)verifier{
    oauth_nonce = [NSString createOauthNonce];
    oauth_timestamp = [NSString createOauthTimestamp];
    
    NSMutableArray *parameters = [NSMutableArray arrayWithCapacity:0];
    [parameters addObject:[NSDictionary dictionaryWithObject:verifier forKey:@"oauth_verifier"]];
    
    
    
    NSString *baseString = [TwitterAPI baseStringWithParameters:parameters
                                                         method:@"POST" 
                                                            url:TW_AccesstokenURL 
                                                          token:token];
    NSString *secret = [NSString stringWithFormat:@"%@&%@",TW_Consumersecret,secrect];
    NSString *oauth_signature = [baseString HMACSHA1EncodeWithSecret:secret];
    NSString *postString = [TwitterAPI authorizationWithParameters:parameters 
                                                         signatrue:oauth_signature 
                                                             Token:token];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:TW_AccesstokenURL] 
                                                           cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                                                       timeoutInterval:20];
    [request setHTTPMethod:@"POST"];
	[request addValue:postString forHTTPHeaderField: @"Authorization"];
    
    return request;
}

/*在AccessToken存在的情况下判断是否合法（过期，无效，撤销）*/
+ (NSMutableURLRequest *)createVerifyCredentialsRequest{
    oauth_nonce = [NSString createOauthNonce];
    oauth_timestamp = [NSString createOauthTimestamp];
    
    NSString *accessToken = [[NSUserDefaults standardUserDefaults] objectForKey:TW_AccessToken];
    NSString *accessSecret = [[NSUserDefaults standardUserDefaults] objectForKey:TW_AccessSecret];
    
    NSString *baseString = [TwitterAPI baseStringWithParameters:nil 
                                                         method:@"GET" 
                                                            url:TW_VerifyCredentials 
                                                          token:accessToken];
    
    NSString *secret = [NSString stringWithFormat:@"%@&%@",TW_Consumersecret,accessSecret];
    NSString *oauth_signature = [baseString HMACSHA1EncodeWithSecret:secret];
    
    NSString *postString = [TwitterAPI authorizationWithParameters:nil 
                                                         signatrue:oauth_signature 
                                                             Token:accessToken];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:TW_VerifyCredentials] 
                                                           cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                                                       timeoutInterval:20];
    [request addValue:postString forHTTPHeaderField: @"Authorization"];
    
    return request;
}

/*分享文字*/
+ (NSMutableURLRequest *)createShareMsgRequestWithMessage:(NSString *)message{
    oauth_nonce = [NSString createOauthNonce];
    oauth_timestamp = [NSString createOauthTimestamp];
    
    NSString *accessToken = [[NSUserDefaults standardUserDefaults] objectForKey:TW_AccessToken];
    NSString *accessSecret = [[NSUserDefaults standardUserDefaults] objectForKey:TW_AccessSecret];
    NSMutableArray *parameters = [NSMutableArray arrayWithCapacity:0];
    [parameters addObject:[NSDictionary dictionaryWithObject:[message URLEncode] forKey:@"status"]];
    
    NSString *baseString = [TwitterAPI baseStringWithParameters:parameters 
                                                         method:@"POST" 
                                                            url:TW_UpdateStatus 
                                                          token:accessToken];
    NSString *secret = [NSString stringWithFormat:@"%@&%@",TW_Consumersecret,accessSecret];
    NSString *oauth_signature = [baseString HMACSHA1EncodeWithSecret:secret];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:TW_UpdateStatus] 
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:20];
    NSString *postHeader = [TwitterAPI authorizationWithParameters:nil
                                                         signatrue:oauth_signature 
                                                             Token:accessToken];
    [request setHTTPMethod:@"POST"];
    [request addValue:postHeader forHTTPHeaderField: @"Authorization"];
    
    NSString *postBody = [NSString stringWithFormat:@"status=%@",[message URLEncode]];
    [request setHTTPBody:[postBody dataUsingEncoding:NSUTF8StringEncoding]];
    
    return request;
}

/*分享文字和图片*/
+ (NSMutableURLRequest *)createShareMsgAndImgRequestWithMessage:(NSString *)message image:(UIImage *)image{
    oauth_nonce = [NSString createOauthNonce];
    oauth_timestamp = [NSString createOauthTimestamp];
    
    NSString *accessToken = [[NSUserDefaults standardUserDefaults] objectForKey:TW_AccessToken];
    NSString *accessSecret = [[NSUserDefaults standardUserDefaults] objectForKey:TW_AccessSecret];
    
    NSString *baseString = [TwitterAPI baseStringWithParameters:nil 
                                                         method:@"POST" 
                                                            url:TW_UpdateStauesAndMedia 
                                                          token:accessToken];
    NSString *secret = [NSString stringWithFormat:@"%@&%@",TW_Consumersecret,accessSecret];
    NSString *oauth_signature = [baseString HMACSHA1EncodeWithSecret:secret];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:TW_UpdateStauesAndMedia] 
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:20];
    NSString *boundary = [[NSProcessInfo processInfo] globallyUniqueString];
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
	[request addValue:contentType forHTTPHeaderField: @"Content-Type"];
    [request setHTTPMethod:@"POST"];
    
    NSString *postHeader = [TwitterAPI authorizationWithParameters:nil
                                                         signatrue:oauth_signature 
                                                             Token:accessToken];
    [request addValue:postHeader forHTTPHeaderField: @"Authorization"];
    
    NSMutableData *postBody = [NSMutableData dataWithLength:0];
    NSDateFormatter *formater = [[NSDateFormatter alloc] init];
	[formater setDateFormat: @"yyyyMMddHHmmSS"];
	NSString* fileName = [formater stringFromDate: [NSDate date]];
	[formater release];
    
    [postBody appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	[postBody appendData:[@"Content-Disposition: form-data; name=\"status\";\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithFormat:@"%@", message] dataUsingEncoding:NSUTF8StringEncoding]];
	[postBody appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    [postBody appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	[postBody appendData:[[NSString stringWithFormat: @"Content-Disposition: form-data; name=\"media[]\"; filename=\"%@\"\r\n",fileName] dataUsingEncoding:NSUTF8StringEncoding]];
	[postBody appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding: NSUTF8StringEncoding]];
	[postBody appendData: UIImagePNGRepresentation(image)];
	[postBody appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    [postBody appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [request setHTTPBody:postBody];
    return request;
}

+ (NSMutableURLRequest *)createShareMsgAndVideoRequestWithMessage:(NSString *)message video:(NSData *)data
{
    oauth_nonce = [NSString createOauthNonce];
    oauth_timestamp = [NSString createOauthTimestamp];
    
    NSString *accessToken = [[NSUserDefaults standardUserDefaults] objectForKey:TW_AccessToken];
    NSString *accessSecret = [[NSUserDefaults standardUserDefaults] objectForKey:TW_AccessSecret];
    
    NSString *baseString = [TwitterAPI baseStringWithParameters:nil
                                                         method:@"POST"
                                                            url:TW_UpdateStauesAndMedia
                                                          token:accessToken];
    NSString *secret = [NSString stringWithFormat:@"%@&%@",TW_Consumersecret,accessSecret];
    NSString *oauth_signature = [baseString HMACSHA1EncodeWithSecret:secret];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:TW_UpdateStauesAndMedia]
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:20];
    NSString *boundary = [[NSProcessInfo processInfo] globallyUniqueString];
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
	[request addValue:contentType forHTTPHeaderField: @"Content-Type"];
    [request setHTTPMethod:@"POST"];
    
    NSString *postHeader = [TwitterAPI authorizationWithParameters:nil
                                                         signatrue:oauth_signature
                                                             Token:accessToken];
    [request addValue:postHeader forHTTPHeaderField: @"Authorization"];
    
    NSMutableData *postBody = [NSMutableData dataWithLength:0];
    NSDateFormatter *formater = [[NSDateFormatter alloc] init];
	[formater setDateFormat: @"yyyyMMddHHmmSS"];
	NSString* fileName = [formater stringFromDate: [NSDate date]];
	[formater release];
    
    fileName = [fileName stringByAppendingString:@".mov"];
    
    [postBody appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	[postBody appendData:[@"Content-Disposition: form-data; name=\"status\";\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithFormat:@"%@", message] dataUsingEncoding:NSUTF8StringEncoding]];
	[postBody appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    [postBody appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	[postBody appendData:[[NSString stringWithFormat: @"Content-Disposition: form-data; name=\"media[]\"; filename=\"%@\"\r\n",fileName] dataUsingEncoding:NSUTF8StringEncoding]];
	[postBody appendData:[@"Content-Type: video/quicktime\r\n\r\n" dataUsingEncoding: NSUTF8StringEncoding]];
	[postBody appendData: data];
	[postBody appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    [postBody appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [request setHTTPBody:postBody];
    return request;
}

-(void)dealloc{
    [super dealloc];
}

@end
