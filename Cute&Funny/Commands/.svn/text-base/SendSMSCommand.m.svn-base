//
//  SendSMSCommand.m
//  CountDown
//
//  Created by tangwei1 on 14-6-9.
//  Copyright (c) 2014年 tangwei1. All rights reserved.
//

#import "SendSMSCommand.h"
#import "ModalAlert.h"
#import <MessageUI/MessageUI.h>
#import "Toast.h"
#import <MobileCoreServices/MobileCoreServices.h>
#include <sys/socket.h> // Per msqr
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>

@interface SendSMSCommand () <MFMessageComposeViewControllerDelegate>

@end

@implementation SendSMSCommand

- (void)execute
{
    Class messageClz = NSClassFromString(@"MFMessageComposeViewController");
    if ( !messageClz ) {
        [ModalAlert say:@"iOS version lower iOS4.0"];
//        [Toast showText:@"iOS version lower iOS4.0"];
    } else {
        if ( ![messageClz canSendText] ) {
            [ModalAlert say:@"Device not configured to send SMS."];
//            [Toast showText:@"Device not configured to send SMS."];
        } else {
            [self displaySMSComposerSheet];
        }
    }
}

- (void)displaySMSComposerSheet
{
//    [self retain];
    
    MFMessageComposeViewController* picker = [[MFMessageComposeViewController alloc] init];
    
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    
    char *answer = malloc(size);
    sysctlbyname("hw.machine", answer, &size, NULL, 0);
    
    NSString *results = [NSString stringWithCString:answer encoding: NSUTF8StringEncoding];
    
    free(answer);
    
    if ( [results isEqualToString:@"iPad2,5"] ) { // ipad mini不能发附件
        picker.body = [self.userData objectForKey:kUserDataEntityKey];
    } else {
        picker.body = @"";//[self.userData objectForKey:kShareMessageKey];
        if ( [picker respondsToSelector:@selector(addAttachmentData:typeIdentifier:filename:)] ) {
            NSData* data = [self.userData objectForKey:kUserDataEntityKey];
            if ( data ) {
                BOOL flag = [picker addAttachmentData:data
                           typeIdentifier:@"public.movie"
                                 filename:@"video.mp4"];
                if ( !flag ) {
                    NSLog(@"error attach");
                }
            }
            
        }
    }
    
    picker.messageComposeDelegate = self;
    
    UIViewController* vc = [self.userData objectForKey:kUserDataParentViewControllerKey];
    if ( !vc ) {
        vc = [[[[UIApplication sharedApplication] windows] objectAtIndex:0] rootViewController];
    }
    
    [vc presentViewController:picker animated:YES completion:nil];
    [picker release];
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
//    [self release];
    [controller dismissViewControllerAnimated:YES completion:nil];
    
    NSString* message = nil;
    switch (result) {
        case MessageComposeResultCancelled:
            message = @"Send Cancelled";
            break;
        case MessageComposeResultSent:
            message = @"Send Successfully";
            break;
        case MessageComposeResultFailed:
            message = @"Send Failed";
            break;
            
        default:
            break;
    }
    
    if ( message ) {
//        [ModalAlert say:message];
        [Toast showText:message];
    }
}

@end
