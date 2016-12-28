//
//  CategoryView.m
//  Cute&Funny
//
//  Created by tangwei1 on 15-4-20.
//  Copyright (c) 2015年 tangwei1. All rights reserved.
//

#import "CategoryView.h"
#import "Defines.h"

@interface CategoryView () <UITableViewDataSource, UITableViewDelegate>

@end

@implementation CategoryView
{
    UITableView* _tableView;
    UIView*      _maskView;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if ( self = [super initWithFrame:frame] ) {
        
        self.frame = AWFullScreenBounds();
        
//        self.backgroundColor = [UIColor greenColor];
        
//        self.frame = CGRectMake(0, 0, 162, 130);
        
//        self.layer.cornerRadius = 5;
//        self.clipsToBounds = YES;
        
//        self.layer.borderWidth = 1;
//        
//        self.layer.shadowColor = [UIColor redColor].CGColor;
//        self.layer.shadowOffset = CGSizeMake(1,1);
//        self.layer.shadowOpacity = .8;
//        self.layer.shadowRadius = 20;
        
        _maskView = [[UIView alloc] init];
        [self addSubview:_maskView];
        [_maskView release];
        
        _maskView.backgroundColor = [UIColor whiteColor];
        _maskView.alpha = .9;
        
        _maskView.frame = CGRectMake(15, 0, 162, 130);
        
        _maskView.layer.cornerRadius = 5;
        _maskView.clipsToBounds = YES;
        
        _tableView = [[[UITableView alloc] initWithFrame:CGRectMake(15, 0, 162, 130)
                                                   style:UITableViewStylePlain] autorelease];
        _tableView.layer.cornerRadius = 5;
        _tableView.clipsToBounds = YES;
        
        [self addSubview:_tableView];
        _tableView.rowHeight = 65;
        
        _tableView.scrollEnabled = NO;
        
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        _tableView.backgroundColor = [UIColor clearColor];
        
        _tableView.delegate = self;
        
    }
    return self;
}

- (void)dealloc
{
    [_categoryItems release];
    
    [super dealloc];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self dismiss];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.categoryItems count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* cellID = @"cellID";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if ( !cell ) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID] autorelease];
        cell.backgroundColor = [UIColor clearColor];
    }
    
    UILabel* textLabel = (UILabel *)[cell.contentView viewWithTag:100];
    if ( !textLabel ) {
        textLabel = createLabel(CGRectMake(40, 0, 120, _tableView.rowHeight),
                                NSTextAlignmentLeft,
                                [UIFont fontWithName:@"DIN Condensed" size:18],
                                RGB(137, 137, 137));
        textLabel.tag = 100;
        [cell.contentView addSubview:textLabel];
    }
    
    textLabel.text = [self.categoryItems objectAtIndex:indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if ( [self.delegate respondsToSelector:@selector(didSelectCategoryItem:)] ) {
        [self.delegate didSelectCategoryItem:[self.categoryItems objectAtIndex:indexPath.row]];
    }
    
    [self dismiss];
}

- (void)showInView:(UIView *)superView
{
    if ( !self.superview ) {
        [superView addSubview:self];
    }
    
    [superView bringSubviewToFront:self];
    
    _tableView.dataSource = self;
    
    __block CGRect frame = _tableView.frame;
    frame.origin.y = - CGRectGetHeight(frame);
    
    [UIView animateWithDuration:.3
                     animations:^{
                         
                         frame.origin.y = 70;
                         
                         _tableView.frame = _maskView.frame = frame;
                         
                     } completion:^(BOOL finished) {
                         
                     }];
}

- (void)dismiss
{
    CGRect frame = _tableView.frame;
    frame.origin.y = - CGRectGetHeight(frame);
    [UIView animateWithDuration:.3
                     animations:^{
                         _tableView.frame = _maskView.frame = frame;
                         
                     } completion:^(BOOL finished) {
                         [self removeFromSuperview];
                     }];
}

@end
