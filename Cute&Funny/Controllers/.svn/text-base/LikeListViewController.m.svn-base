//
//  LikeListViewController.m
//  Cute&Funny
//
//  Created by tangwei1 on 15/6/8.
//  Copyright (c) 2015年 tangwei1. All rights reserved.
//

#import "LikeListViewController.h"
#import "Defines.h"

#define kNumberOfCols 2
#define kHorizontalPadding 5

@interface LikeListViewController () <UITableViewDataSource, UITableViewDelegate>
{
    NSInteger _page;
    NSInteger _totalPage;
    
    UITableView* _tableView;
    
    NSMutableArray* _neededRemoveMedias;
    
    UILabel* _headerLabel;
}

@property (nonatomic, retain) NSMutableArray* dataSource;

@property (nonatomic, assign) BOOL editing;

@property (nonatomic, assign) BOOL selectAll;

@property (nonatomic, retain) EditOperView* editOperView;

@end

@implementation LikeListViewController

- (void)dealloc
{
    self.dataSource = nil;
    self.editOperView = nil;
    [_neededRemoveMedias release];
    
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self initNavBar];
    
    self.editing = NO;
    self.selectAll = NO;
    
    _page = 1;
    
    self.dataSource = [NSMutableArray array];
    _neededRemoveMedias = [[NSMutableArray alloc] init];
    
    CGRect frame = self.view.bounds;
    frame.origin.y = 64;
    frame.size.height -= 64;
    
    UITableView* tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, AWFullScreenWidth(),
                                                                           AWFullScreenHeight() - 64 - 50)
                                                          style:UITableViewStylePlain];
    [self.view addSubview:tableView];
    [tableView release];
    
    tableView.dataSource = self;
    tableView.delegate = self;
    
    _tableView = tableView;
    
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    _tableView.backgroundColor = [UIColor clearColor];
    
    [self loadData];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(mediaDidRemove:)
                                                 name:@"kMediaDidRemoveNotification"
                                               object:nil];
    
//    [[AdsPopupManager sharedManager] setViewController:self];
//    [[AdsPopupManager sharedManager] showInterstitial];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    CGRect bounds = [UIScreen mainScreen].bounds;
    [[AdsPopupManager sharedManager] setViewController:self];
    [[AdsPopupManager sharedManager] showBannerAdAt:CGPointMake(0, CGRectGetHeight(bounds) - 50)];
}

//- (void)viewDidAppear:(BOOL)animated
//{
//    [super viewDidAppear:animated];
//    
//    [[AdsPopupManager sharedManager] showInterstitial];
//}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    CGRect bounds = [UIScreen mainScreen].bounds;
    [[AdsPopupManager sharedManager] setViewController:AWAppWindow().rootViewController];
    [[AdsPopupManager sharedManager] showBannerAdAt:CGPointMake(0, CGRectGetHeight(bounds) - 50)];
}

- (void)mediaDidRemove:(NSNotification *)sender
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/user/cancellike?user=%@", kDomainURL, [OpenUDID value]]];
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    request.HTTPBody = [NSJSONSerialization dataWithJSONObject:@[[(Media *)sender.object id]] options:NSJSONWritingPrettyPrinted error:nil];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:
     ^(NSURLResponse *response, NSData *data, NSError *connectionError) {
         
         if ( connectionError ) {
             AW_LOG(@"Error: %@", connectionError);
         }
         
         dispatch_async(dispatch_get_main_queue(), ^{
             [MBProgressHUD hideHUDForView:self.view animated:YES];
             
             if ( connectionError ) {
                 [Toast showText:@"Delete failure."];
             } else {
                 [MBProgressHUD hideHUDForView:self.view animated:YES];
                 
                 [self.dataSource removeObject:sender.object];
                 
                 for (UITableViewCell* cell in [_tableView visibleCells]) {
                     for (UIView* view in cell.contentView.subviews) {
                         [view removeFromSuperview];
                     }
                 }
                 
                 [_tableView reloadData];
             }
         });
         
     }];
}

- (void)loadData
{
    
    if ( [self.dataSource count] == 0 ) {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    }
    
    AW_LOG(@"url: %@", [NSString stringWithFormat:@"%@/likes/res/gif/%ld?version=1.0&user=%@",
                        kDomainURL, (long)_page, [OpenUDID value]]);
    
    [[AFHTTPRequestOperationManager manager] GET:[NSString stringWithFormat:@"%@/likes/res/gif/%ld?version=1.0&user=%@",
                                                  kDomainURL, (long)_page, [OpenUDID value]]
                                      parameters:nil
                                         success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                             
                                             [MBProgressHUD hideHUDForView:self.view animated:YES];
                                             
                                             _totalPage = ( [[responseObject objectForKey:@"total"] integerValue] + 72 - 1 ) / 72;
                                             
                                             NSArray* temp = [responseObject objectForKey:@"data"];
                                             for (id val in temp) {
                                                 Media* aMedia = [[Media alloc] initWithDictionary:val];
                                                 [self.dataSource addObject:aMedia];
                                                 [aMedia release];
                                                 
//                                                 AW_LOG(@"id: %@", aMedia.id);
                                             }
                                             
                                             [_tableView reloadData];
                                             
                                         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                             //
                                             [MBProgressHUD hideHUDForView:self.view animated:YES];
                                             
                                             AW_LOG(@"Load Error: %@", error);
                                         }];
}

- (NSInteger)numberOfRows
{
    return ( self.dataSource.count + kNumberOfCols - 1 ) / 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self numberOfRows];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* IDCell = [NSString stringWithFormat:@"cell id - %ld", (long)indexPath.row];
    
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:IDCell];
    
    if ( cell == nil ) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:IDCell] autorelease];
        
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    [self addContentsAtIndex:indexPath.row forCell:cell];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat width = ( AWFullScreenWidth() - 3 * kHorizontalPadding ) / kNumberOfCols;
    CGFloat height = width * 0.764;
    
    return height + kHorizontalPadding;
}

//- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
//{
//    for (UITableViewCell* cell in [_tableView visibleCells]) {
//        for (UIView* view in cell.contentView.subviews) {
//            if ( [view isKindOfClass:[ThumbMediaView class]] ) {
//                ThumbMediaView* mediaView = (ThumbMediaView *)view;
//                [mediaView stopPlayIfNeeded];
//            }
//        }
//    }
//}
//
//- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
//{
//    if ( !decelerate ) {
//        for (UITableViewCell* cell in [_tableView visibleCells]) {
//            for (UIView* view in cell.contentView.subviews) {
//                if ( [view isKindOfClass:[ThumbMediaView class]] ) {
//                    ThumbMediaView* mediaView = (ThumbMediaView *)view;
//                    [mediaView startPlayIfNeeded];
//                }
//            }
//        }
//    }
//}
//
//- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
//{
//    if ( ![scrollView isDecelerating] && ![scrollView isDragging] ) {
//        for (UITableViewCell* cell in [_tableView visibleCells]) {
//            for (UIView* view in cell.contentView.subviews) {
//                if ( [view isKindOfClass:[ThumbMediaView class]] ) {
//                    ThumbMediaView* mediaView = (ThumbMediaView *)view;
//                    [mediaView startPlayIfNeeded];
//                }
//            }
//        }
//    }
//    
//}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ( indexPath.row == [self.dataSource count] - 1 && _page < _totalPage ) {
        _page++;
        [self loadData];
    }
    
//    for (UIView* view in cell.contentView.subviews) {
//        if ( [view isKindOfClass:[ThumbMediaView class]] ) {
//            ThumbMediaView* mediaView = (ThumbMediaView *)view;
//            [mediaView startPlayIfNeeded];
//        }
//    }
}

//- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath*)indexPath
//{
//    for (UIView* view in cell.contentView.subviews) {
//        if ( [view isKindOfClass:[ThumbMediaView class]] ) {
//            ThumbMediaView* mediaView = (ThumbMediaView *)view;
//            [mediaView stopPlayIfNeeded];
//        }
//    }
//}

- (void)addContentsAtIndex:(NSInteger)index forCell:(UITableViewCell *)cell
{
    NSInteger cols = kNumberOfCols;
    
    NSInteger rows = [self numberOfRows];
    
    if ( index == rows - 1 ) {
        // 计算最后一行的列数
        cols = [self.dataSource count] - index * kNumberOfCols;
    }
    
    CGFloat horizontalPadding = kHorizontalPadding;
    CGFloat width = ( AWFullScreenWidth() - 3 * horizontalPadding ) / kNumberOfCols;
    CGFloat height = width * 0.764;
    for (NSInteger i=0; i<cols; i++) {
        NSInteger nIndex = index * kNumberOfCols + i;
        ThumbMediaView* mView = (ThumbMediaView *)[cell.contentView viewWithTag:100 + i];
        if ( !mView ) {
            mView = [[[ThumbMediaView alloc] init] autorelease];
            [cell.contentView addSubview:mView];
            mView.tag = 100 + i;
            mView.frame = CGRectMake(0, 0, width, height);
            
            [mView addTarget:self action:@selector(mediaViewDidClick:)];
            
            mView.selected = self.selectAll;
        }
        
        mView.center = CGPointMake(horizontalPadding + width / 2 + ( width + horizontalPadding ) * i,
                                   height / 2);
        mView.isThumb = YES;
        mView.media = [self.dataSource objectAtIndex:nIndex];
        mView.editing = self.editing;
    }
}

- (void)mediaViewDidClick:(ThumbMediaView *)view
{
    if ( self.editing ) {
        view.selected = !view.selected;
        
        if ( view.selected ) {
            [_neededRemoveMedias addObject:view.media];
        } else {
            [_neededRemoveMedias removeObject:view.media];
        }
        
        _headerLabel.text = [NSString stringWithFormat:@"Selected %d", [_neededRemoveMedias count]];
        
    } else {
        // 查看大图
        LikeDetailViewController* ldvc = [[[LikeDetailViewController alloc] init] autorelease];
        ldvc.media = view.media;
        [self presentViewController:ldvc animated:YES completion:nil];
    }
}

- (void)initNavBar
{
    UILabel* headerLabel = createLabel(CGRectMake(AWFullScreenWidth() / 2 - 100, 20, 200, 44),
                                       NSTextAlignmentCenter,
                                       TITLE_FONT,
                                       [UIColor whiteColor]);
    [self.view addSubview:headerLabel];
    headerLabel.text = @"LIKED";
    
    headerLabel.adjustsFontSizeToFitWidth = YES;
    
    _headerLabel = headerLabel;
    
    UIButton* closeBtn = createImageButton(@"btn_close.png", self, @selector(close));
    closeBtn.frame = CGRectMake(0, 0, 40, 40);
    [self.view addSubview:closeBtn];
    closeBtn.center = CGPointMake(AWFullScreenWidth() - CGRectGetWidth(closeBtn.bounds) / 2, CGRectGetMidY(headerLabel.frame));
    
    UIButton* editBtn = createImageButton(nil, self, @selector(edit:));
    
    [self.view addSubview:editBtn];
    [editBtn setTitle:@"Edit" forState:UIControlStateNormal];
    
    editBtn.frame = CGRectMake(0, 0, 60, 40);
    editBtn.center = CGPointMake(CGRectGetWidth(closeBtn.bounds) / 2 + 10, CGRectGetMidY(headerLabel.frame));
}

- (void)edit:(UIButton *)sender
{
    if ( self.editing ) {
        [sender setTitle:@"Edit" forState:UIControlStateNormal];
        [[NSNotificationCenter defaultCenter] postNotificationName:kThumbMediaViewDidCancelEditingNotification object:nil];
        
        [self.editOperView dismiss];
        self.editOperView = nil;
        
        [_neededRemoveMedias removeAllObjects];
        
        _headerLabel.text = @"LIKED";
        
    } else {
        [sender setTitle:@"Cancel" forState:UIControlStateNormal];
        [[NSNotificationCenter defaultCenter] postNotificationName:kThumbMediaViewWillEditingNotification object:nil];
        
        self.editOperView = [[[EditOperView alloc] init] autorelease];
        [self.editOperView showInView:self.view];
        
        [self.editOperView addTarget:self action:@selector(editOper:)];
    }
    
    self.editing = !self.editing;
}

- (void)editOper:(EditOperView *)sender
{
    if ( self.editOperView.operType == EditOperTypeDelete ) {
        
        if ( [_neededRemoveMedias count] == 0 ) {
            return;
        }
        
        NSMutableArray* ids = [NSMutableArray array];
        for (Media* aMedia in _neededRemoveMedias) {
            [ids addObject:aMedia.id];
        }
        
        [self sendRequest:ids];
        
    } else if ( self.editOperView.operType == EditOperTypeSelectAll ) {
        self.selectAll = !self.selectAll;
        
        if ( self.selectAll ) {
            [_neededRemoveMedias removeAllObjects];
            [_neededRemoveMedias addObjectsFromArray:self.dataSource];
        } else {
            [_neededRemoveMedias removeAllObjects];
        }
        
        _headerLabel.text = [NSString stringWithFormat:@"Selected %d", [_neededRemoveMedias count]];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"kMediaDidSelectAllNotification"
                                                            object:[NSString stringWithFormat:@"%d", self.selectAll]];
    }
}

- (void)sendRequest:(NSArray *)ids
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/user/cancellike?user=%@", kDomainURL, [OpenUDID value]]];
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    request.HTTPBody = [NSJSONSerialization dataWithJSONObject:ids options:NSJSONWritingPrettyPrinted error:nil];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:
     ^(NSURLResponse *response, NSData *data, NSError *connectionError) {
         
         if ( connectionError ) {
             AW_LOG(@"Error: %@", connectionError);
         }
         
         dispatch_async(dispatch_get_main_queue(), ^{
             [MBProgressHUD hideHUDForView:self.view animated:YES];
             
             if ( connectionError ) {
                 [Toast showText:@"Delete failure."];
             } else {
                 [MBProgressHUD hideHUDForView:self.view animated:YES];
                 
                 self.selectAll = NO;
                 [[NSNotificationCenter defaultCenter] postNotificationName:@"kMediaDidSelectAllNotification"
                                                                     object:[NSString stringWithFormat:@"%d",
                                                                             self.selectAll]];
                 
                 [self.dataSource removeObjectsInArray:_neededRemoveMedias];
                 
                 for (UITableViewCell* cell in [_tableView visibleCells]) {
                     for (UIView* view in cell.contentView.subviews) {
                         [view removeFromSuperview];
                     }
                 }
                 
                 [_tableView reloadData];
                 
                 [_neededRemoveMedias removeAllObjects];
             }
         });
         
     }];
}

- (void)close
{
    if ( ![self.presentedViewController isBeingDismissed] ) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}


@end
