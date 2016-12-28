//
//  TableTextView.m
//  ShareDemo
//
//  Created by yanglei on 12-8-27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "TableTextView.h"

@implementation TableTextView
@synthesize delegate;

static CGFloat insetSize = 10.0;

#pragma mark - View LifeCycle
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        lineTable = [[UITableView alloc] initWithFrame:self.bounds];
        lineTable.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        lineTable.separatorColor = [UIColor lightGrayColor];
        lineTable.backgroundColor = [UIColor clearColor];
        lineTable.delegate = self;
        lineTable.dataSource = self;
        [self addSubview:lineTable];
       
        
        innerTextView = [[UITextView alloc] initWithFrame:CGRectMake(-insetSize, -insetSize, CGRectGetWidth(self.frame)+insetSize*3-10, CGRectGetHeight(self.frame)+insetSize)];
        innerTextView.bounces = YES;
        innerTextView.alwaysBounceVertical = YES;
        innerTextView.backgroundColor = [UIColor clearColor];
        innerTextView.autocorrectionType = UITextAutocorrectionTypeNo;
        innerTextView.showsHorizontalScrollIndicator = NO;
        innerTextView.showsVerticalScrollIndicator = NO;
        innerTextView.font = [UIFont fontWithName:@"Helvetica" size:15.0f];
        innerTextView.delegate = self;
        [self addSubview:innerTextView];
        
        lineHeight = [@" " sizeWithFont:innerTextView.font constrainedToSize:CGSizeMake(CGRectGetWidth(self.frame), MAXFLOAT)].height;
        numberOfLines = 1;
        
        [lineTable reloadData];
    }
    return self;
}

- (void)dealloc{
    self.delegate = nil;
    [lineTable release]; lineTable = nil;
    [innerTextView release]; innerTextView = nil;
    [super dealloc];
}

#pragma mark - Pubic Methods
/*设置文本框中的文字*/
- (void)setTextViewString:(NSString *)string{
    innerTextView.text = string;
    numberOfLines = (int)ceilf([innerTextView.text sizeWithFont:innerTextView.font constrainedToSize:CGSizeMake(CGRectGetWidth(innerTextView.frame), MAXFLOAT)].height/lineHeight)+5;
    [lineTable reloadData];
}

/*修改文本框的字体*/
- (void)setTextViewFont:(UIFont *)font{
    innerTextView.font = font;
    lineHeight = [@" " sizeWithFont:innerTextView.font constrainedToSize:CGSizeMake(CGRectGetWidth(self.frame), MAXFLOAT)].height;
    [lineTable reloadData];
}
/*修改分割线的颜色*/
- (void)setSeperateLineColor:(UIColor *)color{
    lineTable.separatorColor = color;
}

/*修改文本框的偏移*/
- (void)setTextViewOffset:(CGPoint)offset{
    innerTextView.frame = CGRectMake(offset.x-insetSize, offset.y-insetSize, CGRectGetWidth(innerTextView.frame), CGRectGetHeight(innerTextView.frame));
}

/*修改文本框的宽度*/
- (void)setTextViewWidth:(CGFloat)width{
    innerTextView.frame = CGRectMake(innerTextView.frame.origin.x, innerTextView.frame.origin.y,width+insetSize*3-10, CGRectGetHeight(innerTextView.frame));
    numberOfLines = (int)ceilf([innerTextView.text sizeWithFont:innerTextView.font constrainedToSize:CGSizeMake(CGRectGetWidth(innerTextView.frame), MAXFLOAT)].height/lineHeight)+5;
    [lineTable reloadData];
}

/*获取TextView的文本*/
- (NSString *)getTextViewString{
    return innerTextView.text;
}

/*文本框获取焦点*/
- (void)innerBecomeFirstResponder{
    [innerTextView becomeFirstResponder];
}

/*文本框失去焦点*/
- (void)innerResignFirstResponder{
    [innerTextView resignFirstResponder];
}

- (void)setFrame:(CGRect)newFrame{
    [super setFrame:newFrame];
    lineTable.frame = self.bounds;
}

#pragma mark - UITableViewDelegate&UITableViewDataSource Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return numberOfLines==0?1:numberOfLines;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if(cell == nil){
        cell =  [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        UIView *backGroundView = [[UIView alloc] initWithFrame:cell.bounds];
//        backGroundView.backgroundColor = CellSelectColor;
//        cell.selectedBackgroundView = backGroundView;
//        [backGroundView release];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return lineHeight;
}

#pragma mark - UITextViewDelegate Methods
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    lineTable.contentOffset = innerTextView.contentOffset;
    lineTable.contentSize = CGSizeMake(CGRectGetWidth(self.frame), innerTextView.contentSize.height);
}

/*完全传递TextView的Delegate方法*/
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    if(self.delegate && [self.delegate respondsToSelector:@selector(textViewShouldBeginEditing:)])
        return [self.delegate textViewShouldBeginEditing:textView];
    return YES;
}
- (BOOL)textViewShouldEndEditing:(UITextView *)textView{
    if(self.delegate && [self.delegate respondsToSelector:@selector(textViewShouldEndEditing:)])
        return [self.delegate textViewShouldEndEditing:textView];
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView{
    if(self.delegate && [self.delegate respondsToSelector:@selector(textViewDidBeginEditing:)])
        [self.delegate textViewDidBeginEditing:textView];
}
- (void)textViewDidEndEditing:(UITextView *)textView{
    if(self.delegate && [self.delegate respondsToSelector:@selector(textViewDidEndEditing:)])
        [self.delegate textViewDidEndEditing:textView];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if(self.delegate && [self.delegate respondsToSelector:@selector(textView:shouldChangeTextInRange:replacementText:)])
        return [self.delegate textView:textView shouldChangeTextInRange:range replacementText:text];
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView{
    numberOfLines = (int)ceilf([innerTextView.text sizeWithFont:innerTextView.font constrainedToSize:CGSizeMake(CGRectGetWidth(innerTextView.frame), MAXFLOAT)].height/lineHeight)+5;
    [lineTable reloadData];
    if(self.delegate && [self.delegate respondsToSelector:@selector(textViewDidChange:)])
        [self.delegate textViewDidChange:textView];
}

- (void)textViewDidChangeSelection:(UITextView *)textView{
    if(self.delegate && [self.delegate respondsToSelector:@selector(textViewDidChangeSelection:)])
        [self.delegate textViewDidChangeSelection:textView];
}

@end
