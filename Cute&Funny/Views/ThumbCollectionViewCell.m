//
//  ThumbCollectionViewCell.m
//  Cute&Funny
//
//  Created by tangwei1 on 15-4-27.
//  Copyright (c) 2015年 tangwei1. All rights reserved.
//

#import "ThumbCollectionViewCell.h"
#import "Defines.h"

@implementation ThumbCollectionViewCell
{
    UIView*      _contentView;
    UIImageView* _thumbView;
    UILabel*     _titleLabel;
    UIButton*    _closeBtn;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if ( self = [super initWithFrame:frame] ) {
        
//        self.contentView.backgroundColor = [UIColor redColor];
        
        _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 15,
                                                                CGRectGetWidth(self.contentView.bounds) - 22,
                                                                CGRectGetHeight(self.contentView.bounds) - 22)];
        [self.contentView addSubview:_contentView];
        [_contentView release];
        _contentView.backgroundColor = [UIColor whiteColor];
        
        _contentView.layer.cornerRadius = 4;
        _contentView.clipsToBounds = YES;
        _contentView.layer.borderColor = [RGB(196, 196, 196) CGColor];
        _contentView.layer.borderWidth = .5;
        
        _closeBtn = createImageButton(@"icon_delete.png",
                                      self, @selector(delete:));
        _closeBtn.bounds = CGRectMake(0, 0, 44, 44);
        _closeBtn.center = CGPointMake(CGRectGetMaxX(_contentView.frame),
                                       CGRectGetMinY(_contentView.frame));
        [self.contentView addSubview:_closeBtn];
        
        _thumbView = createImageView(nil);
        [_contentView addSubview:_thumbView];
        
        _titleLabel = createLabel(CGRectZero, NSTextAlignmentLeft,
                                  [UIFont fontWithName:@"DIN Condensed" size:16],
                                  [UIColor blackColor]);
        _titleLabel.numberOfLines = 0;
        [_contentView addSubview:_titleLabel];
        _titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        
        self.editting = NO;
    }
    
    return self;
}

- (void)setEditting:(BOOL)editting
{
    _editting = editting;
    
    _closeBtn.hidden = !_editting;
}

- (void)delete:(id)sender
{
    [ModalAlert ask:@"Are you sure?" message:nil result:^(BOOL yesOrNo) {
        if ( yesOrNo ) {
            NSString* actionName = [NSString stringWithFormat:@"cancel%@", self.type];
            [NetworkService socialReqestForURI:[NSString stringWithFormat:@"user/behavior/%@/%@", self.media.id, actionName]
                                    completion:^(BOOL succeed, NSError *connectionError) {
                                        if ( succeed ) {
                                            [[NSNotificationCenter defaultCenter] postNotificationName:@"kItemDidRemoveNotification" object:self.media];
                                            [[ThumbGenerator sharedInstance] removeThumbnailForMedia:self.media
                                                                                             forType:self.type];
                                        } else {
                                            [Toast showText:@"Delete Error."];
                                        }
                                    }];
        }
    }];
}

- (void)setMedia:(Media *)media
{
    [_media release];
    _media = [media retain];
    
    [self updateContents];
}

- (void)updateContents
{
//    _contentView.frame = CGRectMake(0, 15, CGRectGetWidth(self.contentView.bounds) - 22, 0);
    UIImage* image = [[ThumbGenerator sharedInstance] generateThumbnailForMedia:self.media forType:self.type];
    _thumbView.image = image;
    
    CGFloat height = CGRectGetWidth(_contentView.bounds) * image.size.height / image.size.width;
    _thumbView.frame = CGRectMake(0, 0, CGRectGetWidth(_contentView.bounds), height);
    
    _titleLabel.text = [_media.title trim];

    CGSize size = [_titleLabel.text sizeWithFont:_titleLabel.font
                               constrainedToSize:CGSizeMake(CGRectGetWidth(_thumbView.frame) - 20, 500)];
    
    _titleLabel.frame = CGRectMake(10, CGRectGetMaxY(_thumbView.frame) + 10, CGRectGetWidth(_thumbView.frame) - 20, size.height);
    
    CGRect frame = _contentView.frame;
    frame.size.height = CGRectGetMaxY(_titleLabel.frame) + 10;
    _contentView.frame = frame;
    
}

- (void)dealloc
{
    [_media release];
    self.type = nil;
    
    [super dealloc];
}

@end
