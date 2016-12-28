//
//  ThumbViewController.m
//  Cute&Funny
//
//  Created by tangwei1 on 15-4-24.
//  Copyright (c) 2015年 tangwei1. All rights reserved.
//

#import "ThumbViewController.h"
#import "Defines.h"

@interface ThumbViewController () <UICollectionViewDataSource, CHTCollectionViewDelegateWaterfallLayout>
{
    NSInteger _page;
    NSInteger _totalPage;
    
    UITableView* _tableView;
    
    NSMutableArray* _neededRemoveMedias;
}

@property (nonatomic, assign) int totalPages;
@property (nonatomic, assign) BOOL editting;

@end

#define CELL_IDENTIFIER @"waterfall"

@implementation ThumbViewController
{
    UICollectionView* _collectionView;
    NSMutableArray*   _dataSource;
    CHTCollectionViewWaterfallLayout* _waterfallLayout;
}

- (void)initNavBar
{
    UILabel* headerLabel = createLabel(CGRectMake(AWFullScreenWidth() / 2 - 100, 20, 200, 44),
                                       NSTextAlignmentCenter,
                                       [UIFont boldSystemFontOfSize:20],
                                       [UIColor whiteColor]);
    [self.view addSubview:headerLabel];
    headerLabel.text = @"LIKED";
    
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

- (void)close
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)edit:(UIButton *)sender
{
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initNavBar];
    
    _dataSource = [[NSMutableArray alloc] init];

    CHTCollectionViewWaterfallLayout* waterfallLayout = [[[CHTCollectionViewWaterfallLayout alloc] init] autorelease];
//    waterfallLayout.sectionInset = UIEdgeInsetsMake(0, 22, 0, 0);
    waterfallLayout.minimumColumnSpacing = 0;
    waterfallLayout.minimumInteritemSpacing = 0;
    waterfallLayout.columnCount = 2;
    
    _waterfallLayout = waterfallLayout;
    
    UICollectionView* collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds
                                                          collectionViewLayout:waterfallLayout];
    collectionView.delegate = self;
    
    [self.view addSubview:collectionView];
    [collectionView release];
    
    collectionView.backgroundColor = self.view.backgroundColor;
    
    collectionView.contentInset = UIEdgeInsetsMake(0, 0, 15, 0);
    
    [collectionView registerClass:[ThumbCollectionViewCell class] forCellWithReuseIdentifier:CELL_IDENTIFIER];
    
    _collectionView = collectionView;
    
    [self loadData];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didRemoveItem:) name:@"kItemDidRemoveNotification" object:nil];
}

- (void)didRemoveItem:(NSNotification *)sender
{
    [_dataSource removeObject:sender.object];
    
    [_collectionView.collectionViewLayout invalidateLayout];
    
    [_collectionView reloadData];
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [_dataSource count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ThumbCollectionViewCell* cell = (ThumbCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:CELL_IDENTIFIER forIndexPath:indexPath];
    
    cell.media = [_dataSource objectAtIndex:indexPath.item];
    cell.editting = self.editting;
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat width = ( AWFullScreenWidth() - 3 * 5 ) / 2;
    CGFloat height = width * 0.764;
    return CGSizeMake(width, height);
}

- (void)doEdit:(UIButton *)sender
{
    self.editting = !self.editting;
    
    if ( self.editting ) {
        [sender setTitle:@"Done" forState:UIControlStateNormal];
    } else {
        [sender setTitle:@"Edit" forState:UIControlStateNormal];
    }
    
    for (ThumbCollectionViewCell* cell in [_collectionView visibleCells]) {
        cell.editting = self.editting;
    }
}

- (void)loadData
{
    
    if ( [_dataSource count] == 0 ) {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    }
    
    [[AFHTTPRequestOperationManager manager] GET:[NSString stringWithFormat:@"%@/likes/res/gif/%ld?version=1.0&user=%@",
                                                  kDomainURL, (long)_page, [OpenUDID value]]
                                      parameters:nil
                                         success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                             
                                             [MBProgressHUD hideHUDForView:self.view animated:YES];
                                             
                                             _totalPage = ( [[responseObject objectForKey:@"total"] integerValue] + 72 - 1 ) / 72;
                                             
                                             NSArray* temp = [responseObject objectForKey:@"data"];
                                             for (id val in temp) {
                                                 Media* aMedia = [[Media alloc] initWithDictionary:val];
                                                 [_dataSource addObject:aMedia];
                                                 [aMedia release];
                                             }
                                             
                                             _collectionView.dataSource = self;
                                             [_collectionView reloadData];
                                             
                                         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                             //
                                             [MBProgressHUD hideHUDForView:self.view animated:YES];
                                             
                                             AW_LOG(@"Load Error: %@", error);
                                         }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [_dataSource release];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [super dealloc];
}

@end
