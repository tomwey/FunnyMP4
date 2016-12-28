//
//  CustomToolbar.m
//  Cute&Funny
//
//  Created by tangwei1 on 15-4-22.
//  Copyright (c) 2015年 tangwei1. All rights reserved.
//

#import "CustomToolbar.h"
#import "Defines.h"

@implementation CustomToolbar
{
    UIScrollView* _scrollView;
    SendInstagramCommand* _sendInstagramCommand;
    SaveCommand* _saveCommand;
    Command* _command;
}

- (id)initWithItems:(NSArray *)items
{
    if ( self = [super init] ) {
        self.frame = CGRectMake(0, 0, AWFullScreenWidth(), 49);
        
        self.alpha = .8;
        
        _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        _scrollView.backgroundColor = RGB(224, 230, 231);
        [self addSubview:_scrollView];
        [_scrollView release];
        
        self.enabled = YES;
        self.canShare = YES;
        
        int i = 0;
        CGFloat width = 0;
        CGFloat padding = 16;
        for (NSString* imageName in items) {
            UIButton* btn = createImageButton(imageName, self, @selector(btnClicked:));
            [_scrollView addSubview:btn];
            
            CGFloat x = padding + CGRectGetWidth(btn.bounds) / 2 + ( CGRectGetWidth(btn.bounds) + padding * 2 ) * i++;
            btn.center = CGPointMake(x, CGRectGetMidY(_scrollView.bounds));
            
            btn.tag = i + 1000;
            
            width = CGRectGetMaxX(btn.frame) + padding;
        }
        
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.contentSize = CGSizeMake(width, CGRectGetHeight(_scrollView.frame));
    }
    return self;
}

- (void)setEnabled:(BOOL)enabled
{
    _enabled = enabled;
    
    for (UIView* view in _scrollView.subviews) {
        if ( [view isKindOfClass:[UIButton class]] ) {
            [(UIButton*)view setEnabled:_enabled];
        }
    }
}

static NSString* commandNames[] = { @"", @"SaveCommand", @"SendSMSCommand",
    @"SendFacebookCommand", @"SendTwitterCommand", @"SendTumblrCommand", @"SendInstagramCommand" };
- (void)btnClicked:(UIButton *)sender
{
    if ( !self.canShare ) {
        [Toast showText:@"Gif is loading..."];
        return;
    }
    
    int index = sender.tag - 1000 - 1;
    if ( index == 0 ) {
        if ( [self.media.mp4Url rangeOfString:@"http://"].location != NSNotFound ) {
            [UIPasteboard generalPasteboard].string = self.media.mp4Url;
        } else {
            [UIPasteboard generalPasteboard].string = self.media.gifUrl;
        }
        [Toast showText:@"Link copied"];
    } else {
        
        NSString* cmdClass = commandNames[index];
        if ( [cmdClass isEqualToString:@"SendInstagramCommand"] ) {
            if ( !_sendInstagramCommand ) {
                _sendInstagramCommand = [[SendInstagramCommand alloc] init];
            }
            
            _sendInstagramCommand.userData = @{kUserDataEntityKey: self.media};
            [_sendInstagramCommand execute];
            
        } else if ([cmdClass isEqualToString:@"SaveCommand"]) {
            if (!_saveCommand) {
                _saveCommand = [[SaveCommand alloc] init];
            }
            
            _saveCommand.media = self.media;
            [_saveCommand execute];
            
        } else {
            [_command release];
            _command = [[Command commandWithClass:NSClassFromString(commandNames[index])] retain];
            
            id data = nil;
            
            if ( [self.media.mp4Url rangeOfString:@"http://"].location != NSNotFound ) {
                NSURL* fileURL = [[MediaCache sharedCache] cachedFileURLForMediaURLString:self.media.mp4Url];
                data = [NSData dataWithContentsOfURL:fileURL];
            } else {
                NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.media.gifUrl]];
                data = [[MediaCache sharedCache] cachedDataForRequest:request];
            }
            
            NSString* messages = @"";
            if ( [commandNames[index] isEqualToString:@"SendTwitterCommand"] ) {
                messages = [NSString stringWithFormat:@"Check the most hilarious gifs via Funny :) \n%@",self.media.gifUrl];
                data = [UIImage imageNamed:@"logo.png"];
            }
            
            if ( [commandNames[index] isEqualToString:@"SendFacebookCommand"] ||
                [commandNames[index] isEqualToString:@"SendTumblrCommand"] ) {
                messages = [NSString stringWithFormat:@"Check the most hilarious gifs via Funny :) \n%@",kAppStoreUrl];
            }
            
            _command.userData = @{
                                  kUserDataMessageKey: messages,
                                  kUserDataEntityKey: data
                                  };
            [_command execute];
        }
    }
}

- (void)dealloc
{
    self.media = nil;
    [super dealloc];
}

@end
