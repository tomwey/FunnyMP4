//
//  BaseViewController.m
//  Cute&Funny
//
//  Created by tangwei1 on 15-4-20.
//  Copyright (c) 2015年 tangwei1. All rights reserved.
//

#import "BaseViewController.h"

#import "Defines.h"

@interface BaseViewController ()

@end

@implementation BaseViewController
{
    CustomNavigationBar* _navBar;
}

@synthesize contentSubview = _contentSubview;
@synthesize navBar = _navBar;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = kMainBackgroundColor;
    
    _contentSubview = [[[UIView alloc] init] autorelease];
    [self.view addSubview:_contentSubview];
    
    [self.view sendSubviewToBack:_contentSubview];
    
    if ( [self shouldShowingNavigationBar] ) {
        CustomNavigationBar* navBar = [[[CustomNavigationBar alloc] init] autorelease];
        [self.view addSubview:navBar];
        
        _navBar = navBar;
    }
    
    _contentSubview.frame = CGRectMake( 0, CGRectGetMaxY(_navBar.frame), AWFullScreenWidth(),
                                       CGRectGetHeight(self.view.frame) - CGRectGetHeight(_navBar.frame) );
//    _contentSubview.backgroundColor = [UIColor greenColor];
}

- (UIView *)contentSubview
{
    return _contentSubview;
}

- (BOOL)shouldShowingNavigationBar
{
    return NO;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return toInterfaceOrientation == UIInterfaceOrientationPortrait;
}


#ifdef __IPHONE_6_0

- (BOOL)shouldAutorotate
{
    return NO;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

#endif

//- (UIStatusBarStyle)preferredStatusBarStyle
//{
//    return UIStatusBarStyleLightContent;
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
