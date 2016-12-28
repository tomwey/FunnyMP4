//
//  ThumbCollectionViewCell.h
//  Cute&Funny
//
//  Created by tangwei1 on 15-4-27.
//  Copyright (c) 2015年 tangwei1. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Media;

@interface ThumbCollectionViewCell : UICollectionViewCell

@property (nonatomic, retain) Media* media;
@property (nonatomic, copy) NSString* type;

@property (nonatomic, assign) BOOL editting;

@end
