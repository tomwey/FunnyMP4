//
//  FacebookAPI.m
//
//  Created by yanglei on 12-8-23.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "FacebookAPI.h"
#import "FacebookConfig.h"
#import "NSString+Encode.h"

@implementation FacebookAPI

#pragma mark - Inner Methods

/*Dialog URL参数解析*/
+ (void)parseURLParametersWithInfo:(NSMutableDictionary *)info currentURLString:(NSMutableString **)currentURLString{
    for(NSString* key in info) {
        [*currentURLString appendFormat:[*currentURLString rangeOfString:@"?"].length>0?@"&%@=%@":@"?%@=%@",key,[[info objectForKey:key] URLEncode]];
    }
}

#pragma mark - Outer Methods

/*涂鸦墙Dialog*/
+ (NSMutableURLRequest *)createFeedWallDialogRequest:(NSMutableDictionary *)parameters{
    NSMutableString *urlString = [NSMutableString stringWithCapacity:0];
    [parameters setObject:@"touch" forKey:@"display"];
    [parameters setObject:FB_CallBackHook forKey:@"redirect_uri"];
    [urlString appendFormat:@"%@/dialog/feed?app_id=%@",FB_DialogDomain,FB_APPID];
    [FacebookAPI parseURLParametersWithInfo:parameters 
                                   currentURLString:&urlString];
    return [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
}

/*私信Dialog*/
+ (NSMutableURLRequest *)createPrivateMsgDialogRequest:(NSMutableDictionary *)parameters{
    NSMutableString *urlString = [NSMutableString stringWithCapacity:0];
    [parameters setObject:@"touch" forKey:@"display"];
    [parameters setObject:FB_CallBackHook forKey:@"redirect_uri"];
    [urlString appendFormat:@"%@/dialog/feed?app_id=%@",FB_DialogDomain,FB_APPID];
    [FacebookAPI parseURLParametersWithInfo:parameters 
                           currentURLString:&urlString];
    NSLog(@"urlString:%@",urlString);
    return [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
}


/*获取AccessToken*/
+ (NSMutableURLRequest *)createAccessTokenRequest{
    NSString *urlString = [NSString stringWithFormat:@"http://www.facebook.com/dialog/oauth/?client_id=%@&redirect_uri=%@&scope=%@&display=touch&response_type=token",FB_APPID,FB_CallBackHook,FB_Permissions];
    return  [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString] 
                                    cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData 
                                timeoutInterval:20];
}

/*获取用户允许的权限*/
+ (NSMutableURLRequest *)createPermissionsRequest{
    NSString *accessToken = [[NSUserDefaults standardUserDefaults] objectForKey:FB_AccessToken];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:FB_Gragh_Permissions,accessToken]];
    return  [NSMutableURLRequest requestWithURL:url
                                    cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData 
                                timeoutInterval:20];
}

/*获取用户基础信息*/
+ (NSMutableURLRequest *)createProfileRequest{
    NSString *accessToken = [[NSUserDefaults standardUserDefaults] objectForKey:FB_AccessToken];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:FB_Gragh_Profile,accessToken]];
    return  [NSMutableURLRequest requestWithURL:url
                                    cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData 
                                timeoutInterval:20];
}

/*获取用户相册信息*/
+ (NSMutableURLRequest *)createAlbumsRequest{
    NSString *accessToken = [[NSUserDefaults standardUserDefaults] objectForKey:FB_AccessToken];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:FB_Gragh_Albums,accessToken]];
    return  [NSMutableURLRequest requestWithURL:url
                                    cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData 
                                timeoutInterval:20];
}

/*创建相册*/
+ (NSMutableURLRequest *)createCreateAlbumWithName:(NSString*)name message:(NSString *)message{
    NSString *accessToken = [[NSUserDefaults standardUserDefaults] objectForKey:FB_AccessToken];
    NSDictionary *accountProfile = [[NSUserDefaults standardUserDefaults] objectForKey:FB_AccountProfile];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:FB_Gragh_CreateAlbum,[accountProfile objectForKey:@"id"]]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData 
                                                       timeoutInterval:20];
    [request setHTTPMethod:@"POST"];
    NSString *postString = [NSString stringWithFormat:@"access_token=%@&name=%@&message=%@",accessToken,name,message];
    [request setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
    return  request;
}

/*创建获取用户好友列表的请求*/
+ (NSMutableURLRequest *)createFriendsListRequest{
    NSString *accessToken = [[NSUserDefaults standardUserDefaults] objectForKey:FB_AccessToken];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:FB_Gragh_FriendsList,accessToken]];
    return  [NSMutableURLRequest requestWithURL:url
                                    cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData 
                                timeoutInterval:20];
    
}

+ (NSMutableURLRequest *)createEventsListRequestForStart:(NSDate *)start end:(NSDate *)end
{
    // 第二种取事件的方式
    NSString *accessToken = [[NSUserDefaults standardUserDefaults] objectForKey:FB_AccessToken];
    NSDateFormatter* df = [[[NSDateFormatter alloc] init] autorelease];
    df.dateFormat = @"yyyy-MM-dd";
    NSString* queryString = @"https://graph.facebook.com/me/events?access_token=%@&since=%@&until=%@";
    queryString = [NSString stringWithFormat:queryString, accessToken, [df stringFromDate:start], [df stringFromDate:end]];
    return [NSMutableURLRequest requestWithURL:[NSURL URLWithString:queryString]
                                   cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                               timeoutInterval:20];

    // 第一种取Facebook事件的方式，不能取过去的事件
//    NSString *accessToken = [[NSUserDefaults standardUserDefaults] objectForKey:FB_AccessToken];
//    NSString* queryString = @"{'facebookEventsLastUpdate':'SELECT eid, name, start_time, end_time, location, pic_big FROM event WHERE eid IN (SELECT eid FROM event_member WHERE uid=me()) and start_time >= \"%@\" and start_time <= \"%@\"'}";
//    queryString = [NSString stringWithFormat:queryString, start, end];
//    queryString = (NSString *)CFURLCreateStringByAddingPercentEscapes(NULL,
//                                                                      (CFStringRef)queryString,
//                                                                      NULL,
//                                                                      (CFStringRef)@"!*'\"();:@&=+$,/?%#[]% ",
//                                                                      CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding));
//    NSString* urlString = [NSString stringWithFormat:FB_Graph_EventsList,accessToken,queryString];
//    return [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]
//                                   cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
//                               timeoutInterval:20];
}

/*发送消息到涂鸦墙*/
+ (NSMutableURLRequest *)createShareMsgRequestWithMessage:(NSString *)message parameters:(NSMutableDictionary *)parameters{
    NSString *accessToken = [[NSUserDefaults standardUserDefaults] objectForKey:FB_AccessToken];
    NSDictionary *accountProfile = [[NSUserDefaults standardUserDefaults] objectForKey:FB_AccountProfile];
     NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:FB_Gragh_feedWall,[accountProfile objectForKey:@"id"]]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData 
                                                       timeoutInterval:20];
    [request setHTTPMethod:@"POST"];
    NSString *postString = message?[NSString stringWithFormat:@"access_token=%@&message=%@",accessToken,message]:[NSString stringWithFormat:@"access_token=%@",accessToken];
    for (NSString *key in parameters) {
        postString = [NSString stringWithFormat:@"%@&%@=%@",postString,key,[parameters objectForKey:key]];
    }
    [request setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
    return  request;
}

/*上传图片和消息*/
+ (NSMutableURLRequest *)createUploadImgRequestWithAlbumID:(NSString *)albumID 
                                                 image:(UIImage *)image
                                               message:(NSString *)message{
    NSString *accessToken = [[NSUserDefaults standardUserDefaults] objectForKey:FB_AccessToken];
    NSString *urlString = [NSString stringWithFormat:FB_Gragh_UploadPicture,albumID,accessToken];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    
    [request setHTTPMethod:@"POST"];
    [request setValue:@"FacebookConnect" forHTTPHeaderField:@"User-Agent"];
    NSString *boundary = [[NSProcessInfo processInfo] globallyUniqueString];
    NSString *contentType = [NSString stringWithFormat: @"multipart/form-data; boundary=%@",boundary];
    [request addValue: contentType forHTTPHeaderField: @"Content-Type"];
    
    NSMutableData *body = [NSMutableData dataWithLength:0];
    [body appendData:[[NSString stringWithFormat: @"--%@\r\n",boundary] dataUsingEncoding: NSUTF8StringEncoding]];
    
    [body appendData:[@"Content-Disposition: form-data; name=\"sdk\"\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"ios" dataUsingEncoding: NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat: @"\r\n--%@\r\n",boundary] dataUsingEncoding: NSUTF8StringEncoding]];
    
    [body appendData:[@"Content-Disposition: form-data; name=\"sdk_version\"\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"2" dataUsingEncoding: NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat: @"\r\n--%@\r\n",boundary] dataUsingEncoding: NSUTF8StringEncoding]];
    
    
    [body appendData:[@"Content-Disposition: form-data; name=\"access_token\"\r\n\r\n"dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithString:accessToken] dataUsingEncoding: NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat: @"\r\n--%@\r\n",boundary] dataUsingEncoding: NSUTF8StringEncoding]];
    
    [body appendData:[@"Content-Disposition: form-data; name=\"format\"\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"json"dataUsingEncoding: NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat: @"\r\n--%@\r\n",boundary] dataUsingEncoding: NSUTF8StringEncoding]];
    
    [body appendData:[@"Content-Disposition: form-data; name=\"message\"\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithString:message] dataUsingEncoding: NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat: @"\r\n--%@\r\n",boundary] dataUsingEncoding: NSUTF8StringEncoding]];
    
    
    [body appendData:[@"Content-Disposition: form-data; filename=\"picture\"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"Content-Type: image/png\r\n\r\n" dataUsingEncoding: NSUTF8StringEncoding]];
    NSData *imageData = UIImagePNGRepresentation(image);
    [body appendData: imageData];
    [body appendData:[[NSString stringWithFormat: @"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [request setHTTPBody:body];
    
    return request;
}

- (void)dealloc{
    [super dealloc];
}
@end
