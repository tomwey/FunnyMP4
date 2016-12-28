//
//  LikeDetailViewController.m
//  Cute&Funny
//
//  Created by tangwei1 on 15/6/9.
//  Copyright (c) 2015年 tangwei1. All rights reserved.
//

#import "LikeDetailViewController.h"
#import "Media.h"

@interface LikeDetailViewController ()

@end

@implementation LikeDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton* closeBtn = createImageButton(@"btn_close.png", self, @selector(close));
    closeBtn.frame = CGRectMake(0, 0, 40, 40);
    [self.view addSubview:closeBtn];
    closeBtn.center = CGPointMake(AWFullScreenWidth() - CGRectGetWidth(closeBtn.bounds) / 2 - 10, 42);
    
    CGFloat width = AWFullScreenWidth() - 17 * 2;
    CGFloat height = width * 0.976;
    CGRect frame = CGRectMake(0, 0, width, height);
    
    ThumbMediaView* mediaView = [[[ThumbMediaView alloc] initWithFrame:frame] autorelease];
    [self.view addSubview:mediaView];
    
    mediaView.layer.cornerRadius = 6;
    mediaView.clipsToBounds = YES;
    mediaView.isThumb = NO;
    mediaView.media = self.media;
    
    mediaView.center = CGPointMake(CGRectGetMidX(self.view.bounds),
                                   CGRectGetMidY(self.view.bounds));
    
    UIButton* createBtn = createImageButton(@"btn_trash.png", self, @selector(delete));
    [self.view addSubview:createBtn];
    createBtn.center = CGPointMake(mediaView.center.x, CGRectGetHeight(self.view.bounds) - 20 - CGRectGetHeight(createBtn.bounds) / 2);
}

- (void)delete
{
    [ModalAlert ask:@"Are you sure?" message:@"" result:^(BOOL yesOrNo) {
        if ( yesOrNo ) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"kMediaDidRemoveNotification" object:self.media];
            [self close];
        }
    }];
}

- (void)close
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [UIApplication sharedApplication].statusBarHidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [UIApplication sharedApplication].statusBarHidden = NO;
}

- (void)dealloc
{
    self.media = nil;
    [super dealloc];
}

@end
