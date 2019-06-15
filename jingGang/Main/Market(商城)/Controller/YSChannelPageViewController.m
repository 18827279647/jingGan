//
//  YSChannelPageViewController.m
//  jingGang
//
//  Created by Eric Wu on 2019/6/1.
//  Copyright © 2019 dengxf_dev. All rights reserved.
//

#import "YSChannelPageViewController.h"
#import "YSMallHeadView.h"
#import "YSAFNetworking.h"
#import "AdVertisingModel.h"
#import "GroupListModel.h"
#import "GoodListModel.h"
#import "RecommenModel.h"
#import "ChanneListModel.h"
#import "GlobeObject.h"
#import "YSCommodityViewCell.h"
#import "YSCommodityHeaderView.h"
#import "GoodsDetailsController.h"

static NSString *const kContentCellIdentifier = @"kContentCellIdentifier";
static NSString *const kHeaderIdentifier = @"kHeaderIdentifier";

@interface YSChannelPageViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, YSMallHeadViewDelegate>
@property (weak, nonatomic) UICollectionView *contentView;
@property (nonatomic, strong) YSCommodityHeaderView * HeadView;
//轮播图数据
@property (nonatomic, strong) NSMutableArray * ChannelArray;
//二级菜单数据
@property (nonatomic, strong) NSMutableArray * TwoListArray;
//倒计时时间数据
@property (nonatomic, strong) NSMutableArray * GroupListArray;

@property (nonatomic, assign) NSInteger PageInteger;
//时间段ID
@property (nonatomic, copy) NSString * TimeIDString;
//商品数据
@property (nonatomic, strong) NSMutableArray * ShopDataArray;
//广告位数据
@property (nonatomic, strong) NSMutableArray * AdContentArray;
@end

@implementation YSChannelPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColorHex(F9F9F9);
    self.ShopDataArray = [NSMutableArray array];
    [self setUpUI];
    [self loadData];
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear: animated];
    if (!self.TwoListArray.count || !self.ChannelArray.count) {//无数据才需要请求
        [self loadData];
    }
}

- (void)setUpUI
{
    self.edgesForExtendedLayout = UIRectEdgeNone;
    UICollectionView *contentView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:[self defaultLayout]];
    if (@available(iOS 11.0, *)) {
        contentView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    contentView.backgroundView = [UIView new];
    contentView.backgroundView.backgroundColor = UIColorHex(F9F9F9);
    [self.view addSubview:contentView];
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    contentView.delegate = self;
    contentView.dataSource = self;
    contentView.showsVerticalScrollIndicator = NO;
    contentView.decelerationRate = UIScrollViewDecelerationRateFast;
    [contentView registerNib:[UINib nibWithNibName:@"YSCommodityViewCell" bundle:nil] forCellWithReuseIdentifier:kContentCellIdentifier];
    [contentView registerClass:CRClass(UICollectionReusableView) forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kHeaderIdentifier];
    
    _contentView = contentView;
    
    YSCommodityHeaderView *HeadView = [[YSCommodityHeaderView alloc]initWithFrame:CGRectMake(0, 0,kScreenWidth, K_ScaleWidth(1199))];
    self.HeadView = HeadView;
    HeadView.backgroundColor = CRCOLOR_WHITE;
    
    CRWeekRef(self);
    MJRefreshNormalHeader *header =  [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        __self.PageInteger = 1;
        [__self loadData];
    }];
    header.lastUpdatedTimeLabel.hidden = YES;
    contentView.mj_header = header;
    
    MJRefreshBackNormalFooter *footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        __self.PageInteger += 1;
        [__self GETShopData];
    }];
    contentView.mj_footer = footer;
}
- (UICollectionViewFlowLayout *)defaultLayout
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumInteritemSpacing = 9;
    layout.minimumLineSpacing = 9;
    layout.sectionInset = UIEdgeInsetsMake(9, 9, 9, 9);
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    CGFloat scale = 342.0 / 518.0;
    CGFloat width = (kScreenWidth - (3 * layout.minimumInteritemSpacing)) / 2;
    layout.itemSize = CGSizeMake(width, width / scale);
    return layout;
}

#pragma mark -
#pragma mark collectionView delegate
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    YSCommodityViewCell *cell = [collectionView  dequeueReusableCellWithReuseIdentifier:kContentCellIdentifier forIndexPath:indexPath];
    GoodListModel *model = [self.ShopDataArray safeObjectAtIndex:indexPath.item];
    cell.model = model;
    return cell;
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if (kind == UICollectionElementKindSectionHeader)
    {
        UICollectionReusableView *header = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:kHeaderIdentifier forIndexPath:indexPath];
        [header.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [header addSubview:self.HeadView];
        return header;
    }
    return nil;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return self.HeadView.size;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.ShopDataArray.count;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (CRIsNullOrEmpty(GetToken)) {
        YSLoginPopManager *loginPopManager = [[YSLoginPopManager alloc] init];
        [loginPopManager showLogin:^{
            
        } cancelCallback:^{
        }];
        return;
    }
    GoodListModel *model = [self.ShopDataArray safeObjectAtIndex:indexPath.item];
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    GoodsDetailsController *controller = [[GoodsDetailsController alloc]init];
    controller.areaId = @"1";
    controller.goodsId = model.ID;
    
    [self.navigationController pushViewController:controller animated:YES];
}
#pragma mark -
#pragma mark network
- (void)loadData
{
    dispatch_group_t group = dispatch_group_create();
    //    NSMutableArray *result = [NSMutableArray array];
    //    for (NSInteger idx = 0; idx < 4; idx ++) {
    //          [result addObject:@(0)];
    //    }
    dispatch_group_enter(group);
    [self loadAdvertList:^{
        dispatch_group_leave(group);
    }];
    dispatch_group_enter(group);
    [self loadAdContent:^{
        dispatch_group_leave(group);
    }];
    dispatch_group_enter(group);
    [self loadChannelList:^{
        dispatch_group_leave(group);
    }];
    
    dispatch_group_enter(group);
    [self loadChannelGroupList:^{
        dispatch_group_leave(group);
    }];
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        
        self.HeadView.backImage = self.backImage;
        self.HeadView.backColor = self.backColor;
        self.HeadView.commenModelArray = self.ChannelArray;
        self.HeadView.ListModelArray = self.TwoListArray;
        self.HeadView.AdContentArray = self.AdContentArray;
        [self.contentView.mj_header endRefreshing];
        [self.contentView reloadData];
    });
}
- (void)loadAdvertList:(CRCompletionTask)completion
{
    //轮播图接口
    NSString *url = [ShanrdURL joinUrl:@"v1/channelTop/advertlist"];
    NSDictionary *params = @{@"channelOneId":self.channelOneId};
    [YSAFNetworking POSTUrlString:url parametersDictionary:params successBlock:^(NSURLSessionDataTask *operation, id responseObject) {
        NSDictionary *data = JSONFromObject(responseObject);
        self.ChannelArray = [RecommenModel arrayOfModelsFromDictionaries:data[@"advList"] error:nil];
        if (completion) {
            completion();
        }
    } failureBlock:^(NSURLSessionDataTask *operation, NSError *error) {
        if (completion) {
            completion();
        }
    }];
}
- (void)loadAdContent:(CRCompletionTask)completion
{
    //广告接口
    NSString *url = [ShanrdURL joinUrl:@"/v1/channelTop/adContent"];
    NSDictionary *params = @{@"channelOneId":self.channelOneId};
    [YSAFNetworking POSTUrlString:url parametersDictionary:params successBlock:^(NSURLSessionDataTask *operation, id responseObject) {
        NSDictionary *data = JSONFromObject(responseObject);
        NSMutableArray *adList = [[NSArray modelArrayWithClass:CRClass(AdVertisingModel) json:data[@"adContentBO"]] mutableCopy];
        self.AdContentArray = adList;
        if (completion) {
            completion();
        }
    } failureBlock:^(NSURLSessionDataTask *operation, NSError *error) {
        if (completion) {
            completion();
        }
    }];
}
- (void)loadChannelList:(CRCompletionTask)completion
{
    //二级频道
    NSString *url = [ShanrdURL joinUrl:@"v1/channelTop/channelTwoList"];
    NSDictionary *params = @{@"channelOneId":self.channelOneId};
    [YSAFNetworking POSTUrlString:url parametersDictionary:params successBlock:^(NSURLSessionDataTask *operation, id responseObject) {
        NSDictionary *data = JSONFromObject(responseObject);
        self.TwoListArray =  [[NSArray modelArrayWithClass:CRClass(ChanneListModel) json:data[@"channelList"]] mutableCopy];
        if (completion) {
            completion();
        }
    } failureBlock:^(NSURLSessionDataTask *operation, NSError *error) {
        if (completion) {
            completion();
        }
    }];
}

- (void)loadChannelGroupList:(CRCompletionTask)completion
{
    NSDictionary *dictGoodList = @{@"channelOneId":self.channelOneId ?: kEmptyString,@"pageSize":@"15",@"pageNum":CRStringNum(self.PageInteger)};
    DefineWeakSelf;
    NSString *url = [ShanrdURL joinUrl:@"v1/channelTop/channelGoodClassList"];
    [YSAFNetworking POSTUrlString:url parametersDictionary:dictGoodList successBlock:^(NSURLSessionDataTask *operation, id responseObject) {
        NSDictionary *data = JSONFromObject(responseObject);
        [self.contentView.mj_header endRefreshing];
        NSMutableArray *DataArray = [[NSArray modelArrayWithClass:CRClass(GoodListModel) json:data[@"list"]] mutableCopy];
        weakSelf.ShopDataArray = DataArray;
        [weakSelf.contentView reloadData];
        if (completion) {
            completion();
        }
    } failureBlock:^(NSURLSessionDataTask *operation, NSError *error) {
        if (completion) {
            completion();
        }
    }];
}

#pragma 获取商品数据
- (void)GETShopData{
    NSDictionary *dictGoodList = @{@"channelOneId":self.channelOneId ?: kEmptyString,@"pageSize":@"15",@"pageNum":CRStringNum(self.PageInteger)};
    DefineWeakSelf;
    NSString *url = [ShanrdURL joinUrl:@"v1/channelTop/channelGoodClassList"];
    [YSAFNetworking POSTUrlString:url parametersDictionary:dictGoodList successBlock:^(NSURLSessionDataTask *operation, id responseObject) {
        NSDictionary *data = JSONFromObject(responseObject);
        [self.contentView.mj_header endRefreshing];
        NSArray *DataArray = [NSArray modelArrayWithClass:CRClass(GoodListModel) json:data[@"list"]];
        [weakSelf.ShopDataArray addObjectsFromArray:DataArray];
        if (DataArray.count >= 15) {
            [weakSelf.contentView.mj_footer endRefreshing];
        }
        else
        {
            [weakSelf.contentView.mj_footer endRefreshingWithNoMoreData];
        }
        [weakSelf.contentView reloadData];
    } failureBlock:^(NSURLSessionDataTask *operation, NSError *error) {
        [weakSelf.contentView.mj_footer endRefreshing];
    }];
}

@end
