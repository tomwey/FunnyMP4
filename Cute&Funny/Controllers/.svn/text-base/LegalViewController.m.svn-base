//
//  LegalViewController.m
//  iFunnyGif
//
//  Created by tangwei1 on 14-7-23.
//  Copyright (c) 2014年 tangwei1. All rights reserved.
//

#import "LegalViewController.h"
#import "Defines.h"

@interface LegalViewController () <UIWebViewDelegate>
{
    SendMailCommand* _sendMailCommand;
}

@end

@implementation LegalViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [_sendMailCommand release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UILabel* headerLabel = createLabel(CGRectMake(AWFullScreenWidth() / 2 - 100, 20, 200, 44),
                                       NSTextAlignmentCenter,
                                       [UIFont boldSystemFontOfSize:20],
                                       [UIColor whiteColor]);
    [self.view addSubview:headerLabel];
    headerLabel.text = @"Legal";
    
    UIButton* closeBtn = createImageButton(@"btn_close.png", self, @selector(close));
    closeBtn.frame = CGRectMake(0, 0, 40, 40);
    [self.view addSubview:closeBtn];
    closeBtn.center = CGPointMake(AWFullScreenWidth() - CGRectGetWidth(closeBtn.bounds) / 2, CGRectGetMidY(headerLabel.frame));
    
    UIWebView *legalWeb = [[UIWebView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(headerLabel.frame),
                                                                      AWFullScreenWidth(),
                                                                      AWFullScreenHeight() - 64)];
    legalWeb.backgroundColor = [UIColor clearColor];
    legalWeb.opaque = NO;
    legalWeb.delegate = self;
    [legalWeb loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"Legal.html" ofType:nil]]]];
    [self.view addSubview:legalWeb];
    [legalWeb release];
    
}

- (void)close
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    NSString *scheme=request.URL.scheme;
    if ([scheme isEqualToString:@"mailto"]){
        // contact us
        if ( !_sendMailCommand ) {
            _sendMailCommand = [[SendMailCommand alloc] init];
        }
        
        LegalViewController* svc = self;
        _sendMailCommand.userData = @{
                                      kToRecipientsKey: @[@"contact@sniperstudio.com"],
                                      kSubjectKey: @"Legal Report",
                                      kMailBodyIsHTMLKey: @(NO),
                                      kUserDataParentViewControllerKey: svc,
                                      };
        [_sendMailCommand execute];
        
        return NO;
    }
    return YES;
}

- (void)cancel
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
