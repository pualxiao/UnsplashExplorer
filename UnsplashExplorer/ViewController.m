//
//  ViewController.m
//  UnsplashExplorer
//
//  Created by 习波 肖 on 2020/1/18.
//  Copyright © 2020 习波 肖. All rights reserved.
//

#import "ViewController.h"
#import "UENetworking.h"
#import "UEGetPhotosParam.h"
#import "UENetworkConfig.h"
#import "UEPhotoCollectionViewCell.h"
#import "UEPhotosModel.h"
#import "UEFullPhtotoViewController.h"

@interface ViewController () <UICollectionViewDelegate, UICollectionViewDataSource, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@property (nonatomic ,weak) IBOutlet UICollectionView *collectionView;

@property (nonatomic, strong) UEGetPhotosParam *getPhotosParam;
@property (nonatomic, strong) NSMutableArray *photoDatas;
@property (nonatomic, assign) Boolean showNetworkError;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initData];
    [self initView];
}

- (void)initView {
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout*) self.collectionView.collectionViewLayout;
    CGFloat itemW = (SCREEN_WIDTH - 20) / 2;
    CGFloat itemH = itemW * 256 / 180;
    layout.itemSize = CGSizeMake(itemW, itemH);
    layout.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5);
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.minimumLineSpacing = 20;
    layout.minimumInteritemSpacing = 10;
    
    _collectionView.emptyDataSetSource = self;
    _collectionView.emptyDataSetDelegate = self;
    
    __weak ViewController *ws = self;
    MJRefreshNormalHeader *refreshheader = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        ws.getPhotosParam.page = @(1);
        ws.showNetworkError = NO;
        [ws loadData];
    }];
    _collectionView.mj_header = refreshheader;

    refreshheader.stateLabel.text = @"松开立即刷新";
    refreshheader.lastUpdatedTimeLabel.hidden = YES;
    [refreshheader setTitle:@"松开立即刷新" forState:MJRefreshStateIdle];
    [refreshheader setTitle:@"松开立即刷新" forState:MJRefreshStatePulling];
    [refreshheader setTitle:@"刷新中..." forState:MJRefreshStateRefreshing];
    refreshheader.lastUpdatedTimeText = ^NSString *(NSDate *lastUpdatedTime) {
        NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
        fmt.dateFormat = @"yyyy-MM-dd HH:mm:ss";
        NSString *timeStr = [fmt stringFromDate:lastUpdatedTime];;
        return timeStr;
    };
    
    MJRefreshBackNormalFooter *footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
//        [target getNextData];
        ws.getPhotosParam.page = @(ws.getPhotosParam.page.intValue + 1);
        [ws loadData];
    }];
    
    [footer setTitle:@"松开加载更多" forState:MJRefreshStateIdle];
    [footer setTitle:@"正在加载..." forState:MJRefreshStateRefreshing];
    [footer setTitle:@"没有更多数据" forState:MJRefreshStateNoMoreData];
    _collectionView.mj_footer = footer;

    [_collectionView registerClass:[UEPhotoCollectionViewCell class] forCellWithReuseIdentifier:UEUEPhotoCollectionViewCellIdentifier];
}

- (void)initData {
    _photoDatas = @[].mutableCopy;
    _getPhotosParam = [[UEGetPhotosParam alloc] init];
    _getPhotosParam.client_id = CLIENT_ID;
    _getPhotosParam.page = @(1);
    _getPhotosParam.per_page = @(20);
    
    [self loadData];
}

- (void)loadData {
    __weak ViewController *ws = self;
    [UENetworking getPhotosWithParam:_getPhotosParam callback:^(NSError * _Nullable error, UENetworkResultBase * _Nonnull data) {
        [ws.collectionView.mj_header endRefreshing];
        [ws.collectionView.mj_footer endRefreshing];
        if (data.isSuccess) {
            [ws.photoDatas addObjectsFromArray:((UEPhotosModel*)data).data.data];
        }
        else {
            [UIView showToast:data.message];
            ws.showNetworkError = YES;
        }
        [ws.collectionView reloadData];
    }];
}

#pragma mark - datasource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.photoDatas.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UEPhotoData *photoData = self.photoDatas[indexPath.item];
    UEPhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:UEUEPhotoCollectionViewCellIdentifier forIndexPath:indexPath];
    [cell.photo sd_setImageWithURL:[NSURL URLWithString:photoData.urls.small] usingProgressView:nil];
    return cell;
}


#pragma mark - delegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    UEPhotoData *photoData = self.photoDatas[indexPath.item];
    
    UEFullPhtotoViewController *controller = [[UEFullPhtotoViewController alloc] initWithPhotoData:photoData];
    [self presentViewController:controller animated:YES completion:nil];
}

#pragma mark  DZNEmptyDataSetSource & DZNEmptyDataSetDelegate
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
 
    if (_showNetworkError) {
        NSString *title = @"网络出错了";
        NSDictionary *attributes = @{NSForegroundColorAttributeName:[UIColor grayColor]};
        return [[NSAttributedString alloc] initWithString:title attributes:attributes];
    }
    else {
        NSString *title = @"加载中...";
        NSDictionary *attributes = @{NSForegroundColorAttributeName:[UIColor grayColor]};
        return [[NSAttributedString alloc] initWithString:title attributes:attributes];
    }
}

- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView
{
    return YES;
}

@end
