//
//  CategoryView.h
//  Cute&Funny
//
//  Created by tangwei1 on 15-4-20.
//  Copyright (c) 2015年 tangwei1. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CategoryViewDelegate <NSObject>

@optional
- (void)didSelectCategoryItem:(NSString *)item;

@end

@interface CategoryView : UIView

@property (nonatomic, assign) id delegate;
@property (nonatomic, copy) NSArray* categoryItems;

- (void)showInView:(UIView *)superView;

- (void)dismiss;

@end
