//
//  UserProfileViewController.m
//  Cute&Funny
//
//  Created by tangwei1 on 15-4-20.
//  Copyright (c) 2015年 tangwei1. All rights reserved.
//

#import "UserProfileViewController.h"
#import "Defines.h"
#import "AboutUsPage.h"

@interface UserProfileViewController () <UITableViewDataSource, UITableViewDelegate>

@end

#define CELL_TITLES @[@[@"Notifications", @"Clear Cache"], @[@"Rate Us", @"Contact Us", @"More Apps"]]

@implementation UserProfileViewController
{
    UISwitch* _toggleButton;
    SendMailCommand* _sendMailCommand;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    ProfileTopbar* topbar = [[[ProfileTopbar alloc] init] autorelease];
    topbar.delegate = self;
    [self.view addSubview:topbar];
    
    UITableView* tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 30, CGRectGetWidth(self.view.frame),
                                                                           CGRectGetHeight(self.view.frame) - CGRectGetHeight(topbar.frame) + 30)
                                                          style:UITableViewStyleGrouped];
    [self.view addSubview:tableView];
    [tableView release];
    
    tableView.delegate = self;
    tableView.dataSource = self;
    
    [self.view bringSubviewToFront:topbar];
    
    // table header
    UIView* headerView = [[[UIView alloc] init] autorelease];
    
    CGFloat height = 0;
    for (int i=0; i<2; i++) {
        UIButton* cuteBtn = createImageButton(nil, self, @selector(btnClicked:));
        [headerView addSubview:cuteBtn];
        
        UILabel* nameLabel = createLabel(CGRectZero, NSTextAlignmentCenter,
                                         [UIFont fontWithName:@"DIN Condsensed" size:24],
                                         [UIColor whiteColor]);
        [cuteBtn addSubview:nameLabel];
        
        UILabel* numLabel = createLabel(CGRectZero, NSTextAlignmentCenter,
                                        [UIFont fontWithName:@"DIN Condsensed" size:18],
                                        [UIColor whiteColor]);
        [cuteBtn addSubview:numLabel];
        
        cuteBtn.tag = 100 + i;
        
        numLabel.text = @"120";
        nameLabel.text = @"CUTE";
        cuteBtn.backgroundColor = RGB(252, 156, 24);
        if ( i == 1 ) {
            nameLabel.text = @"FUNNY";
            cuteBtn.backgroundColor = RGB(225, 15, 52);
        }
        CGFloat width = ( CGRectGetWidth(self.view.frame) - 3 * 10 ) / 2;
        height = width * 0.618;
        cuteBtn.frame = CGRectMake(10 + ( width + 10 ) * i, 0, width, height);
        cuteBtn.layer.cornerRadius = 10;
        cuteBtn.clipsToBounds = YES;
        
        nameLabel.frame = CGRectMake(0, CGRectGetHeight(cuteBtn.frame) / 2 - 30, width, 40);
        numLabel.frame = CGRectMake(0, CGRectGetHeight(cuteBtn.frame) / 2 , width, 30);
    }
    
    headerView.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), height + 5);
    
    tableView.tableHeaderView = headerView;

    [[AdsPopupManager sharedManager] setViewController:self];
    [[AdsPopupManager sharedManager] showBannerAd];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(registerNotiFailure)
                                                 name:@"kHasRegisteredFailureNotification"
                                               object:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [UIApplication sharedApplication].statusBarHidden = YES;
    self.navigationController.navigationBarHidden = YES;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [_sendMailCommand release];
    
    [super dealloc];
}

- (void)registerNotiFailure
{
    [Toast showText:@"Register Remote Notification Error."];
    _toggleButton.on = NO;
}

//http://localhost:8000/pocket/funny1/user/behavior/18365/funny?version=1.0&user=%27robot%27
// host:port/pocket/(<bundle_id>)/user/res/gif/(<usergif_type>cute|funny)/<page>?user=MMM

static NSString* uriNames[] = { @"cute", @"funny" };
- (void)btnClicked:(UIButton *)sender
{
    ThumbViewController* tvc = [[[ThumbViewController alloc] init] autorelease];
//    tvc.resourceType = uriNames[sender.tag - 100];
    [self.navigationController pushViewController:tvc animated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

static int rows[] = { 2, 3 };
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return rows[section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* cellId = @"CellId";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if ( !cell ) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId] autorelease];
        
        if ( indexPath.section == 0 ) {
            if ( indexPath.row == 0 ) {
                UISwitch* onOff = [[[UISwitch alloc] init] autorelease];
                onOff.on = [[NSUserDefaults standardUserDefaults] boolForKey:@"hasRegistered"];
                [onOff addTarget:self action:@selector(toggle:) forControlEvents:UIControlEventValueChanged];
                cell.accessoryView = onOff;
                _toggleButton = onOff;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            } else if ( indexPath.row == 1 ) {
                UILabel* mbLabel = createLabel(CGRectMake(0, 0, 150, 44),
                                               NSTextAlignmentRight,
                                               [UIFont systemFontOfSize:16],
                                               [UIColor blackColor]);
                cell.accessoryView = mbLabel;
                mbLabel.text = [NSString stringWithFormat:@"%.2fMB", (float)[[MediaCache sharedCache] fileSizeForCachedData] / ( 1024 * 1024 )];
            }
            
        } else {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
    }
    
    cell.textLabel.text = CELL_TITLES[indexPath.section][indexPath.row];
    
    return cell;
}

- (void)toggle:(UISwitch *)onOff
{
    if ( onOff ) {
        if ( [[UIApplication sharedApplication] respondsToSelector:@selector(registerForRemoteNotifications)] ) {
            [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
            [[UIApplication sharedApplication] registerForRemoteNotifications];
        } else {
            [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
             (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
        }
    } else {
        [[UIApplication sharedApplication] unregisterForRemoteNotifications];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if ( indexPath.section == 0 ) {
        if ( indexPath.row == 1 ) {
            // Clear Cache
            [[MediaCache sharedCache] removeAllCaches];
            UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
            [(UILabel *)cell.accessoryView setText:@"0.00MB"];
            [Toast showText:@"Cleared All Caches."];
        }
    } else if ( indexPath.section == 1 ) {
        if ( indexPath.row == 0 ) {
            // Rate Us
            NSString *url=nil;
            if ([[UIDevice currentDevice].systemVersion floatValue] < 7.0) {
                url=[NSString stringWithFormat:@"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%@",@"509160525"];
            }else{
                url=[NSString stringWithFormat:@"itms-apps://itunes.apple.com/app/id%@",@"509160525"];
            }
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
        } else if ( indexPath.row == 1 ) {
            // Contact Us
            // contact us
            if ( !_sendMailCommand ) {
                _sendMailCommand = [[SendMailCommand alloc] init];
            }
            
            UserProfileViewController* svc = self;
            _sendMailCommand.userData = @{
                                          kToRecipientsKey: @[@"contact@sniperstudio.com"],
                                          kSubjectKey: @"Feedback",
                                          kMailBodyIsHTMLKey: @(NO),
                                          kUserDataParentViewControllerKey: svc,
                                          };
            [_sendMailCommand execute];
        } else if ( indexPath.row == 2 ) {
            // More Apps
            AboutUsPage* page = [AboutUsPage aboutUsPage];
            [page showInView:[[[UIApplication sharedApplication] windows] objectAtIndex:0]];
        }
    }
}

- (void)back:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//- (UIStatusBarStyle)preferredStatusBarStyle
//{
//    return UIStatusBarStyleDefault;
//}

@end
