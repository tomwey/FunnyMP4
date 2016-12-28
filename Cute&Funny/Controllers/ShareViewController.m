//
//  ShareViewController.m
//  Cute&Funny
//
//  Created by tangwei1 on 15/6/5.
//  Copyright (c) 2015年 tangwei1. All rights reserved.
//

#import "ShareViewController.h"
#import "Defines.h"

@interface ShareViewController ()

@property (nonatomic, retain) Command* command;

@end

@implementation ShareViewController

static NSString* buttons[] = {
    @"copylink",@"facebook",@"email",
    @"tumblr",@"instagram",@"twitter",
    @"save"
};

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    for (int i=0; i<7; i++) {
        NSString* btnName = [NSString stringWithFormat:@"share_%@.png", buttons[i]];
        UIButton* btn = createImageButton(btnName, self, @selector(btnClicked:));
        [self.view addSubview:btn];
        
        btn.tag = 1000 + i;
        
        int m = i % 3;
        int n = i / 3;
        
        CGFloat top = CGRectGetHeight(self.view.frame) * 0.2;
        CGFloat padding = ( CGRectGetWidth(self.view.frame) - 3 * CGRectGetWidth(btn.bounds) ) / 4;
        CGFloat topPadding = padding + 20;
        btn.center = CGPointMake(padding + CGRectGetWidth(btn.bounds) / 2 + ( CGRectGetWidth(btn.bounds) + padding ) * m,
                                 top + CGRectGetHeight(btn.bounds) / 2 + ( CGRectGetHeight(btn.bounds) + topPadding ) * n );
        
        if ( i == 6 ) {
            btn.center = CGPointMake(CGRectGetMidX(self.view.frame),
                                     top + CGRectGetHeight(btn.bounds) / 2 + ( CGRectGetHeight(btn.bounds) + topPadding ) * n );
        }
        
        CGRect frame = CGRectMake(0, 0, 100, 20);
        UILabel* label = createLabel(frame,
                                     NSTextAlignmentCenter,
                                     [UIFont boldSystemFontOfSize:16],
                                     [UIColor whiteColor]);
        [self.view addSubview:label];
        label.text = [buttons[i] uppercaseString];
        
        label.center = CGPointMake(btn.center.x, CGRectGetMaxY(btn.frame) + 20);
    }
    
    UIButton* closeBtn = createImageButton(@"btn_close.png", self, @selector(close));
    [self.view addSubview:closeBtn];
    
    closeBtn.frame = CGRectMake(0, 0, 40, 40);
    closeBtn.center = CGPointMake(CGRectGetMidX(self.view.frame),
                                  CGRectGetHeight(self.view.bounds)* 0.95);
}

static NSString* commandNames[] = {
    @"", @"SendFacebookCommand", @"SendMailCommand",
    @"SendTumblrCommand", @"SendInstagramCommand", @"SendTwitterCommand",
    @"SaveCommand"
};

- (void)btnClicked:(UIButton *)sender
{
    NSInteger index = sender.tag - 1000;
    
    if ( index == 0 ) {
        
        [[ShortenLinkManager sharedInstance] shorten:self.media.gifUrl completion:^(NSString *shortenUrl) {
            [UIPasteboard generalPasteboard].string = shortenUrl;
            [Toast showText:@"Link copied"];
        }];
        
    } else {
        self.command = [Command commandWithClass:NSClassFromString(commandNames[index])];
        
        id data = nil;
        if ( [commandNames[index] isEqualToString:@"SendInstagramCommand"] ||
            [commandNames[index] isEqualToString:@"SaveCommand"]) {
            data = self.media;
        } else {
            if ( [self.media.mp4Url rangeOfString:@"http://"].location != NSNotFound ) {
                NSURL* fileURL = [[MediaCache sharedCache] cachedFileURLForMediaURLString:self.media.mp4Url];
                data = [NSData dataWithContentsOfURL:fileURL];
            } else {
                NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.media.gifUrl]];
                data = UIImagePNGRepresentation([[UIImageView sharedImageCache] cachedImageForRequest:request]);
            }
        }

        NSString* message = @"";
        if ( [commandNames[index] isEqualToString:@"SendTwitterCommand"] ) {
            message = [NSString stringWithFormat:@"Check the most hilarious gifs via Funny :) \n%@",self.media.gifUrl];
            data = [UIImage imageNamed:@"logo.png"];
        }
        
        if ( [commandNames[index] isEqualToString:@"SendFacebookCommand"] ||
            [commandNames[index] isEqualToString:@"SendTumblrCommand"] ) {
            message = [NSString stringWithFormat:@"Check the most hilarious gifs via Funny :) \n%@",kAppStoreUrl];
        }
        
        self.command.userData = @{ kUserDataEntityKey: data, kUserDataMessageKey: message, kUserDataParentViewControllerKey: self };
        
        
        if ( [commandNames[index] isEqualToString:@"SendMailCommand"] ) {
            
            [[ShortenLinkManager sharedInstance] shorten:self.media.gifUrl completion:^(NSString *shortenUrl) {
                self.command.userData = @{
                                          kSubjectKey: @"The best from Cute&Funny",
                                          //                                      kAttachmentDataKey: [UIImage imageNamed:@"logo.png"],
                                          kMailBodyKey: [NSString stringWithFormat:@"<p>Hey buddy, check this out from Cute&Funny! </p><a href=\"%@\">%@</a>", shortenUrl, shortenUrl],
                                          kMailBodyIsHTMLKey: @(YES),
                                          kUserDataParentViewControllerKey: self,
                                          };
                
                [self.command execute];
            }];
        } else if ( [commandNames[index] isEqualToString:@"SendTwitterCommand"] ) {
            
            [[ShortenLinkManager sharedInstance] shorten:self.media.gifUrl completion:^(NSString *shortenUrl) {
                NSString* msg = [NSString stringWithFormat:@"Check the most hilarious gifs via Funny :) \n%@", shortenUrl];
                self.command.userData = @{ kUserDataEntityKey: data, kUserDataMessageKey: msg, kUserDataParentViewControllerKey: self };
                [self.command execute];
            }];
            
        } else {
            [self.command execute];
        }
        
//        [self.command execute];
    }
    
}

- (void)close
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
}

- (void)dealloc
{
    self.media = nil;
    [super dealloc];
}

@end
