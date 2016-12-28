//
//  SettingsViewController.m
//  Cute&Funny
//
//  Created by tangwei1 on 15/6/5.
//  Copyright (c) 2015年 tangwei1. All rights reserved.
//

#import "SettingsViewController.h"
#import "Defines.h"
#import "AboutUsPage.h"

@interface SettingsViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, retain) Command* command;

@end

@implementation SettingsViewController
{
    UISwitch* _toggleButton;
    SendMailCommand* _sendMailCommand;
    
    UIDocumentInteractionController* _docInteractionController;
}

- (void)dealloc
{
    self.command = nil;
    
    [_sendMailCommand release];
    
    [_docInteractionController release];
    
    _toggleButton = nil;
    
    [super dealloc];
}

#define CELL_TITLES @[@[@"Notifications", @"Clear Cache"], @[@"Rate Us", @"Contact Us", @"More Apps", @"Legal"], @[@"Tell friends",@""]]

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UILabel* headerLabel = createLabel(CGRectMake(AWFullScreenWidth() / 2 - 100, 20, 200, 44),
                                       NSTextAlignmentCenter,
                                       TITLE_FONT,
                                       [UIColor whiteColor]);
    [self.view addSubview:headerLabel];
    headerLabel.text = @"SETTING";
    
    UIButton* closeBtn = createImageButton(@"btn_close.png", self, @selector(close));
    closeBtn.frame = CGRectMake(0, 0, 40, 40);
    [self.view addSubview:closeBtn];
    closeBtn.center = CGPointMake(AWFullScreenWidth() - CGRectGetWidth(closeBtn.bounds) / 2, CGRectGetMidY(headerLabel.frame));
    
    UITableView* tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(headerLabel.frame),
                                                                           CGRectGetWidth(self.view.bounds),
                                                                           CGRectGetHeight(self.view.bounds) - 64)
                                                          style:UITableViewStyleGrouped];
    [self.view addSubview:tableView];
    [tableView release];
    
    tableView.delegate = self;
    tableView.dataSource = self;
    
    tableView.backgroundColor = [UIColor clearColor];
    tableView.rowHeight = 61;
    
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(registerNotiFailure)
                                                 name:@"kHasRegisteredFailureNotification"
                                               object:nil];
}


- (void)registerNotiFailure
{
    [Toast showText:@"Register Remote Notification Error."];
    _toggleButton.on = NO;
}

static NSInteger rows[] = { 2, 4, 2 };
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return rows[section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* cellIdentifier = [NSString stringWithFormat:@"s-%d, r-%d", indexPath.section, indexPath.row];
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if ( !cell ) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
        cell.backgroundColor = [UIColor clearColor];
        
        cell.selectedBackgroundView = [[[UIView alloc] init] autorelease];
        
        cell.selectedBackgroundView.backgroundColor = RGB(56, 61, 78);
        
        if ( indexPath.section == 2 ) {
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        if ( indexPath.row != rows[indexPath.section] - 1 ) {
            UIView* lineView = [[UIView alloc] initWithFrame:CGRectMake(15, tableView.rowHeight - 1,
                                                                        CGRectGetWidth(self.view.frame) - 15, 1)];
            [cell.contentView addSubview:lineView];
            [lineView release];
            
            lineView.backgroundColor = RGB(56, 61, 78);
        }
        
        if ( indexPath.section == 0 ) {
            if ( indexPath.row == 0 ) {
                UISwitch* onOff = [[[UISwitch alloc] init] autorelease];
                onOff.on = [[NSUserDefaults standardUserDefaults] boolForKey:@"hasRegistered"];
                [onOff addTarget:self action:@selector(toggle:) forControlEvents:UIControlEventValueChanged];
                cell.accessoryView = onOff;
                onOff.onTintColor = RGB(250, 155, 24);
                _toggleButton = onOff;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            } else if ( indexPath.row == 1 ) {
                UILabel* mbLabel = createLabel(CGRectMake(0, 0, 150, 44),
                                               NSTextAlignmentRight,
                                               [UIFont systemFontOfSize:16],
                                               [UIColor whiteColor]);
                cell.accessoryView = mbLabel;
                mbLabel.text = [NSString stringWithFormat:@"%.2fMB", (float)[[MediaCache sharedCache] fileSizeForCachedData] / ( 1024 * 1024 )];
            }
            
        } else if ( indexPath.section == 1 ) {
            if ( indexPath.row == 0 ) {
                UIImageView* starView = createImageView(@"icon_star.png");
                cell.accessoryView = starView;
            }
        } else if ( indexPath.section == 2 ) {
            NSArray* btns = @[@"setting_email.png",
                              //@"setting_instagram.png",
                              @"setting_facebook.png",
                              @"setting_twitter.png",
                              @"setting_tumblr.png"];
            if ( indexPath.row == 1 ) {
                for (int i=0; i<4; i++) {
                    UIButton* btn = createImageButton(btns[i], self, @selector(share:));
                    btn.tag = 1000 + i;
                    [cell.contentView addSubview:btn];
                    btn.frame = CGRectMake(0, 0, 40, 40);
                    btn.center = CGPointMake(15 + CGRectGetWidth(btn.bounds) / 2 + ( CGRectGetWidth(btn.bounds) + 20 ) * i,
                                             tableView.rowHeight / 2);
                }
            }
        }
    }
    
    cell.textLabel.text = CELL_TITLES[indexPath.section][indexPath.row];
    cell.textLabel.font = [UIFont boldSystemFontOfSize:18];
    
    cell.textLabel.textColor = [UIColor whiteColor];
    
    return cell;
}

static NSString* commandNames[] = {
    @"SendMailCommand",@"SendFacebookCommand",
    @"SendTwitterCommand",@"SendTumblrCommand",
};

- (void)share:(UIButton *)sender
{
    NSString* commandName = commandNames[sender.tag - 1000];
    if ( [commandName isEqualToString:@"SendInstagramCommand"] ) {
        
        NSURL *instagramURL = [NSURL URLWithString:@"instagram://media?id=315"];
        if ([[UIApplication sharedApplication] canOpenURL:instagramURL]) {
            NSString *savedImagePath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Image.igo"];
            [UIImagePNGRepresentation([UIImage imageNamed:@"logo.png"]) writeToFile:savedImagePath atomically:YES];
            NSURL *imageUrl = [NSURL fileURLWithPath:savedImagePath];
            
            if ( !_docInteractionController ) {
                _docInteractionController = [[UIDocumentInteractionController interactionControllerWithURL:imageUrl] retain];
            }
            
            _docInteractionController.annotation = [NSDictionary dictionaryWithObject:
                                                    [NSString stringWithFormat:@"Check the most hilarious gifs via Funny :) \n%@",kAppStoreUrl]
                                                                    forKey:@"InstagramCaption"];
            [_docInteractionController presentOpenInMenuFromRect:CGRectZero inView:[[[[UIApplication sharedApplication] delegate].window rootViewController] view] animated:YES];
        }
        else {
            [ModalAlert say:@"No Instagram Found" message:@""];
        }
        
    } else {
        
        self.command = [Command commandWithClass:NSClassFromString(commandNames[sender.tag - 1000])];
        
        if ( [commandName isEqualToString:@"SendMailCommand"] ) {
            self.command.userData = @{
                         kSubjectKey: @"Check out this hilarious gif app! ",
                         kAttachmentDataKey: [UIImage imageNamed:@"logo.png"],
                         kMailBodyKey: [NSString stringWithFormat:@"<p>I`m browsing gifs with this cool app! Download this app and start voting! </p><a href=\"%@\">Cute & Funny</a>", kAppStoreUrl],
                         kMailBodyIsHTMLKey: @(YES),
                         kUserDataParentViewControllerKey: self,
                         };
        } else {
           self.command.userData = @{ kUserDataMessageKey: [NSString stringWithFormat:@"Check the most hilarious gifs via Funny :) \n%@",kAppStoreUrl], kUserDataParentViewControllerKey: self };
        }
        
        [self.command execute];
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
            
            _sendMailCommand.userData = @{
                                          kToRecipientsKey: @[@"contact@sniperstudio.com"],
                                          kSubjectKey: @"Feedback",
                                          kMailBodyIsHTMLKey: @(NO),
                                          kUserDataParentViewControllerKey: self,
                                          };
            [_sendMailCommand execute];
        } else if ( indexPath.row == 2 ) {
            // More Apps
            AboutUsPage* page = [AboutUsPage aboutUsPage];
            [page showInView:[[[UIApplication sharedApplication] windows] objectAtIndex:0]];
        } else if ( indexPath.row == 3 ) {
            // legal
            LegalViewController* lvc = [[[LegalViewController alloc] init] autorelease];
            [self presentViewController:lvc animated:YES completion:nil];
        }
    }
}

- (void)toggle:(UISwitch *)sender
{
    if ( sender ) {
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (void)close
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
