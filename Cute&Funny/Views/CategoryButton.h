//
//  CategoryButton.h
//  Cute&Funny
//
//  Created by tangwei1 on 15/5/18.
//  Copyright (c) 2015年 tangwei1. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CategoryButton : UIView

@property (nonatomic, assign) BOOL selected;

@property (nonatomic, retain) UIImage* normalImage;
@property (nonatomic, retain) UIImage* selectedImage;

@property (nonatomic, assign) BOOL showingLeftSpliter;
@property (nonatomic, assign) BOOL showingRightSpliter;

- (void)addTarget:(id)target action:(SEL)action;

@end

@interface CategoryButtonGroup : NSObject

+ (CategoryButtonGroup *)sharedInstance;

@property (nonatomic, assign, readonly) NSArray* buttons;

- (void)addButton:(id)button;

- (void)removeAllButtons;

@end
