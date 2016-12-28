//
//  TableTextView.h
//  ShareDemo
//
//  Created by yanglei on 12-8-27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TableTextViewDeleagte<NSObject>

@optional
/*完全传递TextView的Delegate方法*/
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView;
- (BOOL)textViewShouldEndEditing:(UITextView *)textView;

- (void)textViewDidBeginEditing:(UITextView *)textView;
- (void)textViewDidEndEditing:(UITextView *)textView;

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text;
- (void)textViewDidChange:(UITextView *)textView;

- (void)textViewDidChangeSelection:(UITextView *)textView;

@end
@interface TableTextView : UIView<UITableViewDelegate,UITextViewDelegate,UITableViewDataSource>{
    UITableView *lineTable;
    UITextView *innerTextView;
    
    CGFloat lineHeight;
    NSInteger numberOfLines;
}

@property(nonatomic,assign) id<TableTextViewDeleagte> delegate;

/*设置文本框中的文字*/
- (void)setTextViewString:(NSString *)string;

/*修改文本框的字体*/
- (void)setTextViewFont:(UIFont *)font;

/*修改分割线的颜色*/
- (void)setSeperateLineColor:(UIColor *)color;

/*修改文本框的偏移*/
- (void)setTextViewOffset:(CGPoint)offset;

/*修改文本框的宽度*/
- (void)setTextViewWidth:(CGFloat)width;

/*获取TextView的文本*/
- (NSString *)getTextViewString;

/*文本框获取焦点*/
- (void)innerBecomeFirstResponder;

/*文本框失去焦点*/
- (void)innerResignFirstResponder;

@end
