//
//  SendFacebookCommand.m
//  CountDown
//
//  Created by tangwei1 on 14-6-9.
//  Copyright (c) 2014年 tangwei1. All rights reserved.
//

#import "SendFacebookCommand.h"
#import "Facebook.h"
#import "FacebookEditor.h"
#import "FacebookOauthView.h"
#import "ModalAlert.h"
#import "Toast.h"

@implementation SendFacebookCommand

- (void)execute
{
//    [self retain];
    
    if ( [Facebook checkAuthorizedCacheInfo] ) {
        // 已经登录
        [self sendFacebook];
    } else {
        [FacebookOauthView showInView:[[UIApplication sharedApplication] delegate].window delegate:self animation:FBAnimationAlert];
    }
}

- (void)fbOauthSuccessed
{
    NSLog(@"oauth success");
    // 已经登录
    [self sendFacebook];
//    [[Facebook sharedFacebook] uploadVideo:[self.userData objectForKey:kShareImageKey] message:[self.userData objectForKey:kShareMessageKey]];
}

- (void)sendFacebook
{
//    [MBProgressHUD showHUDAddedTo:APP_DELEGATE.window animated:YES];
//    
//    [[Facebook sharedFacebook] beginUploadImgWithImage:self.userData message:@"Countdown"];
    FacebookEditor* editor = [FacebookEditor showInView:[[UIApplication sharedApplication] delegate].window type:FBEditorFeed delegate:self];
//    editor.shareImage = [self.userData objectForKey:kShareImageKey];
    editor.shareText = [self.userData objectForKey:kUserDataMessageKey];
    editor.videoData = [self.userData objectForKey:kUserDataEntityKey];
}

/*提交成功回调方法*/
- (void)fbEditorSendSuccessed:(NSData *)data
{
//    [self release];
//    NSLog(@"%@", [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease]);
//    [ModalAlert say:@"Share Successfully"];
    [Toast showText:@"Shared to Facebook!"];
}

/*提交失败回调方法*/
- (void)fbEditorSendFailed:(NSError *)error
{
//    [self release];
    NSLog(@"%@", error);
}

@end
