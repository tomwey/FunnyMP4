//
//  SendTumblrCommand.m
//  iFunnyGif
//
//  Created by tangwei1 on 14-8-7.
//  Copyright (c) 2014年 tangwei1. All rights reserved.
//

#import "SendTumblrCommand.h"
#import "TMAPIClient.h"
#import "TMTumblrAuthenticator.h"
#import "MBProgressHUD.h"
#import "Toast.h"

@implementation SendTumblrCommand

- (void)execute
{
    TMTumblrAuthenticator* auth = [TMTumblrAuthenticator sharedInstance];
    auth.OAuthConsumerKey = @"yWOl6JRIINcBjX6dAKDJ81qB7YI2LHgovStnjai5ZJIvLIBQAK";
    auth.OAuthConsumerSecret = @"TjuncfSJJHxVO2S8jIvMsHf0Lql8fi0JnBEg8NKZnnu2HCFo7R";
    
    NSUserDefaults* ud = [NSUserDefaults standardUserDefaults];
    NSString* oauthToken = [ud objectForKey:@"OauthToken"];
    NSString* oauthTokenSecret = [ud objectForKey:@"OAuthTokenSecret"];
    if ( !oauthToken && !oauthTokenSecret )
    {
//        UIWindow* window = [[[UIApplication sharedApplication] windows] objectAtIndex:0];
//        [MBProgressHUD showHUDAddedTo:window.rootViewController.view animated:YES];
        [auth authenticate:@"bpill-funny1" callback:^(NSString *token, NSString *tokenSecret, NSError *error) {
//            [MBProgressHUD hideHUDForView:window.rootViewController.view animated:YES];
            if ( error ) {
                NSLog(@"Oauth Error!:%@", error);
            } else {
                // 保存token
                [ud setObject:token forKey:@"OauthToken"];
                [ud setObject:tokenSecret forKey:@"OAuthTokenSecret"];
                [ud synchronize];
                
                if ( ![ud objectForKey:@"tumblr.blogName"] ) {
                    // 获取并保存用户名
                    [TMAPIClient sharedInstance].OAuthToken = token;
                    [TMAPIClient sharedInstance].OAuthTokenSecret = tokenSecret;
                    
                    [[TMAPIClient sharedInstance] userInfo:^(id info, NSError *error) {
                        if ( error ) {
                            NSLog(@"Get user info error:%@", error);
                        } else {
                            NSString* blogName = [[[[info objectForKey:@"user"] objectForKey:@"blogs"] lastObject] objectForKey:@"name"];
                            NSLog(@"blog:%@", blogName);
                            [ud setObject:blogName forKey:@"tumblr.blogName"];
                            [ud synchronize];
                            
                            [self sendVideo:blogName token:token secret:tokenSecret];
                        }
                    }];
                } else {
                    [self sendVideo:[ud objectForKey:@"tumblr.blogName"] token:token secret:tokenSecret];
                }
            }
        }];
    } else {
        [self sendVideo:[ud objectForKey:@"tumblr.blogName"] token:oauthToken secret:oauthTokenSecret];
    }

}

- (void)sendVideo:(NSString *)blogName token:(NSString *)token secret:(NSString *)secret
{
    [TMAPIClient sharedInstance].OAuthToken = token;
    [TMAPIClient sharedInstance].OAuthTokenSecret = secret;
    
//    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    UIWindow* window = [[[UIApplication sharedApplication] windows] objectAtIndex:0];
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD showHUDAddedTo:window.rootViewController.view animated:YES];
    });
    
    [[TMAPIClient sharedInstance] video:blogName
                               filePath:[self.userData objectForKey:@"videoFilePath"]
                            contentType:@"video"
                               fileName:@"video.mp4"
                             parameters:@{@"caption" : [self.userData objectForKey:kUserDataMessageKey]}
                               callback:^(id response, NSError *error) {
                                   dispatch_async(dispatch_get_main_queue(), ^{
                                       [MBProgressHUD hideHUDForView:window.rootViewController.view animated:YES];
                                   });
                                   if ( error ) {
//                                       NSLog(@"Upload Error:%@", error);
                                       [Toast showText:@"Share Error"];
                                   } else {
//                                       NSLog(@"Success");
                                       [Toast showText:@"Shared to Tumblr!"];
                                   }
                               }];
}

@end
