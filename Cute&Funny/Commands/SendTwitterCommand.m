//
//  SendTwitterCommand.m
//  CountDown
//
//  Created by tangwei1 on 14-6-9.
//  Copyright (c) 2014年 tangwei1. All rights reserved.
//

#import "SendTwitterCommand.h"
#import "Twitter.h"
#import "TwitterOauthView.h"
#import "TwitterEditor.h"
#import "Toast.h"

@implementation SendTwitterCommand

- (void)execute
{
//    [self retain];
    
    if ( [Twitter checkAuthorizedCacheInfo] ) {
        // 登录成功
        [self sendTwitter];
    } else {
        [TwitterOauthView showInView:[[UIApplication sharedApplication] delegate].window delegate:self animation:TWAnimationTopBottom];
    }
}

- (void)twOauthSuccessed
{
    NSLog(@"twitter oauth successed");
    [self sendTwitter];
}

- (void)sendTwitter
{
    TWEditorType type = TWEditorMessageAndImage;
    
    if ( ![self.userData objectForKey:kUserDataEntityKey] ) {
        type = TWEditorMessage;
    }
    
    TwitterEditor* tw = [TwitterEditor showInView:[[UIApplication sharedApplication] delegate].window type:type delegate:self];
    tw.shareText = [self.userData objectForKey:kUserDataMessageKey];
    tw.shareImage = [self.userData objectForKey:kUserDataEntityKey];
//    tw.videoData = [self.userData objectForKey:kShareImageKey];
}

/*提交成功回调方法*/
- (void)twEditorSendSuccessed:(NSData *)data
{
//    NSLog(@"twitter send success");
    [Toast showText:@"Shared to Twitter!"];
//    [self release];
}

/*提交失败回调方法*/
- (void)twEditorSendFailed:(NSError *)error
{
    NSLog(@"error:%@", error);
//    [self release];
}

@end
