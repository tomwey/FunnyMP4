//
//  EditOperView.h
//  Cute&Funny
//
//  Created by tangwei1 on 15/6/9.
//  Copyright (c) 2015年 tangwei1. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef NS_ENUM(NSInteger, EditOperType) {
    EditOperTypeSelectAll,
    EditOperTypeDelete,
};

@interface EditOperView : UIView

@property (nonatomic, assign, readonly) EditOperType operType;

- (void)showInView:(UIView *)superView;
- (void)dismiss;

- (void)addTarget:(id)target action:(SEL)action;

@end
