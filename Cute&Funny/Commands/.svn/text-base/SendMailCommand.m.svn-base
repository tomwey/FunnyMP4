//
//  SendMailCommand.m
//  CountDown
//
//  Created by tangwei1 on 14-6-9.
//  Copyright (c) 2014年 tangwei1. All rights reserved.
//

#import "SendMailCommand.h"
//#import "Headers.h"
#import <sys/utsname.h>
#import <MessageUI/MessageUI.h>
#import "ModalAlert.h"

@interface SendMailCommand () <MFMailComposeViewControllerDelegate>

@end
@implementation SendMailCommand

NSString * const kToRecipientsKey = @"kToRecipientsKey";
NSString * const kSubjectKey = @"kSubjectKey";
NSString * const kAttachmentDataKey = @"kAttachmentDataKey";
NSString * const kMailBodyKey = @"kMailBodyKey";
NSString * const kMailBodyIsHTMLKey = @"kMailBodyIsHTMLKey";

- (void)execute
{
    Class mailClass = (NSClassFromString(@"MFMailComposeViewController"));
	if (nil != mailClass) {
        if ( ![MFMailComposeViewController canSendMail] ) {
            [ModalAlert say:@"Not yet configure email" message:@""];
        } else {
            MFMailComposeViewController* emailDialog = [[[MFMailComposeViewController alloc] init] autorelease];
            emailDialog.mailComposeDelegate = self;
            // Set the subject of email
            
            // 设置附件
            NSData *imageData = [NSData dataWithData:UIImagePNGRepresentation([self.userData objectForKey:kAttachmentDataKey])];
            if ( [self.userData objectForKey:kAttachmentDataKey] ) {
//                NSLog(@"app name: %@", [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"]);
                [emailDialog addAttachmentData:imageData mimeType:@"image/png"
                                      fileName:@"logo"];
            }
            
            // 设置主题
            NSString* subject = [self.userData objectForKey:kSubjectKey];
            if ( subject ) {
                [emailDialog setSubject:subject];
            }
            
            // 设置收件人
            NSArray* recipients = [self.userData objectForKey:kToRecipientsKey];
            if ( [recipients count] > 0 ) {
                [emailDialog setToRecipients:recipients];
            }
            
            // 设置邮件内容
            NSString *emailBody = [self.userData objectForKey:kMailBodyKey];
            if ( emailBody.length == 0 ) {
                // 加入设备相关信息
                NSString *sku=[[NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Info" ofType:@"plist"]] objectForKey:@"sku"];
                NSString *appID = [[NSUserDefaults standardUserDefaults] objectForKey:@"appID"];
                NSString *version = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"];
                
                struct utsname  u;
                uname(&u);
                NSString *device=[NSString stringWithFormat:@"%s",u.machine];
                
                NSString *systemVersion=[UIDevice currentDevice].systemVersion;
                NSString *mailContent ;
                
                NSString* content = @"";
//                NSString* newSku = nil;
                if(!appID|| [appID isEqualToString:@""])
                    mailContent= [content stringByAppendingFormat:@"\n\n\n\n\n\n//Application Info\nApp Version: %@\nDevice: %@\niOS Version: %@",version,device,systemVersion];
                else
                    mailContent= [content stringByAppendingFormat:@"\n\n\n\n\n\n//Application Info\nApp ID: %@\nApp Version: %@\nDevice: %@\niOS Version: %@",appID,version,device,systemVersion];
                
                emailBody = [NSString stringWithString:mailContent];
            }
            
            BOOL isHTML = [[self.userData objectForKey:kMailBodyIsHTMLKey] boolValue];
            [emailDialog setMessageBody:emailBody isHTML:isHTML];
            
            UIViewController* controller = [self.userData objectForKey:kUserDataParentViewControllerKey];
            if ( !controller ) {
                controller = [[[UIApplication sharedApplication] delegate].window rootViewController];
            }
            [controller presentViewController:emailDialog animated:YES completion:nil];
//            [self retain];
        }
    } else {
        [ModalAlert say:@"Not Supported!"];
    }
}

- (void)mailComposeController:(MFMailComposeViewController *)controller
          didFinishWithResult:(MFMailComposeResult)result
                        error:(NSError *)error {
	NSLog(@"mail completed! good %i",result);
	NSString* msg= nil;
    
    [controller dismissViewControllerAnimated:YES completion:nil];
    
	if (result == MFMailComposeResultSaved) {
		msg = @"Email saved!";
        //        [ModalAlert say:nil message:msg];
	}else if (result == MFMailComposeResultSent) {
		msg = @"Send Successfully";
        //        [ModalAlert say:nil message:msg];
	}else if (result == MFMailComposeResultFailed) {
		msg = @"Send Email Failed,Please Check Your Network Connection!";
        //        [ModalAlert say:nil message:msg];
	}
    
    if (msg) {
        [self showAlert:msg];
    }
    
//    [self release];
}

- (void)showAlert:(NSString *)message
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                    message:message
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
    [alert release];
}

@end
