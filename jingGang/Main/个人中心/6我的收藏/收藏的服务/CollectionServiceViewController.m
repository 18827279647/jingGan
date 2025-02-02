//
//  CollectionServiceViewController.m
//  jingGang
//
//  Created by thinker on 15/9/9.
//  Copyright (c) 2015年 yi jiehuang. All rights reserved.
//

#import "CollectionServiceViewController.h"
#import "CollectionShopsViewController.h"
#import "GlobeObject.h"
#import "PublicInfo.h"
#import "CollectionServerTableViewCell.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "CollectionGoodsViewController.h"
#import "Masonry.h"
#import "APIManager.h"
#import "MJRefresh.h"
#import "WSJShopHomeViewController.h"
#import "OptionViewController.h"
#import "MerchantListViewController.h"
#import "NodataShowView.h"
#import "MJExtension.h"
#import "SubmitOrderController.h"
#import "ServiceDetailController.h"
#import "YSImageConfig.h"
//
@interface CollectionServiceViewController ()<UITableViewDelegate,UITableViewDataSource,APIManagerDelegate>
{
    NSInteger _page;
}


@property (nonatomic) UITableView *tableView;
@property (nonatomic) NSMutableArray *dataSource;
@property (nonatomic) VApiManager *vapiManager;
@property (nonatomic) OptionViewController *optionVC;
@property (nonatomic) NSIndexPath *selectedIndexPath;
@property (nonatomic) APIManager *serverListManager;
@property (nonatomic) APIManager *cancelServiceManager;

@property NSInteger pageNum;

@end

@implementation CollectionServiceViewController

static NSString *cellIdentifier = @"CollectionServerTableViewCell";

#pragma mark - life cycle
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLoad{
    
    [self.view addSubview:self.tableView];
    
    [self setUIContent];
    [self setViewsMASConstraint];
    self.serverListManager = [[APIManager alloc] initWithDelegate:self];
    self.cancelServiceManager = [[APIManager alloc] initWithDelegate:self];
    [self.tableView.mj_header endRefreshing];
}

- (void)viewWillAppear:(BOOL)animated{
}

- (void)viewDidAppear:(BOOL)animated {
    
}

- (void)viewWillDisappear:(BOOL)animated{
    
    
}

- (void)viewDidLayoutSubviews {
}

#pragma mark - UITableViewDelegate


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [tableView fd_heightForCellWithIdentifier:cellIdentifier cacheByIndexPath:indexPath configuration:^(id cell) {
        [self loadCellContent:cell indexPath:indexPath];
        
    }];
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [tableView fd_heightForCellWithIdentifier:cellIdentifier cacheByIndexPath:indexPath configuration:^(id cell) {
        [self loadCellContent:cell indexPath:indexPath];
        
    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *favaService = self.dataSource[indexPath.row];
    ServiceDetailController *VC = [[ServiceDetailController alloc] initWithNibName:@"ServiceDetailController" bundle:nil];
    VC.serviceID = favaService[@"id"];
    [self.navigationController pushViewController:VC animated:YES];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
                             cellIdentifier];
    
    [self loadCellContent:cell indexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (void)loadCellContent:(UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath
{
    //这里把数据设置给Cell
    CollectionServerTableViewCell *serverCell = (CollectionServerTableViewCell *)cell;
    FavaGroupGoods *favaService = [FavaGroupGoods objectWithKeyValues:self.dataSource[indexPath.row]];
    [YSImageConfig yy_view:serverCell.serverImage setImageWithURL:[NSURL URLWithString:favaService.groupAccPath] placeholderImage:DEFAULTIMG];
    serverCell.shopName.text = favaService.storeName;
    serverCell.serverName.text = favaService.ggName;
    serverCell.serverPrice.text = [@"￥" stringByAppendingString:favaService.groupPrice.stringValue];
    serverCell.indexPath = indexPath;
    if (!serverCell.isAssociatedAction) {
        serverCell.associatedAction = YES;
        serverCell.optionBlock = ^(NSIndexPath *cellIndexPath) {
            self.selectedIndexPath = cellIndexPath;
            [self optionAction];
        };
    }
    
}


#pragma mark - 处理网路请求
- (void)apiManagerDidSuccess:(APIManager *)manager {
    [self hiddenHud];
    [NodataShowView hideInContentView:self.view];
    if (manager == self.serverListManager) {
        if ([self.tableView.mj_header isRefreshing]) {
            [self.tableView.mj_header endRefreshing];
        }
        if ([self.tableView.mj_footer isRefreshing ]) {
            [self.tableView.mj_footer endRefreshing ];
        }
        PersonalFavaGoodsListResponse *response = (PersonalFavaGoodsListResponse *)manager.successResponse;
        NSArray *favaArray = response.favaList;
        //        if (favaArray.count == 0) { return;}
        if ([manager.name isEqualToString:@"lowerRefresh"]) {
            self.dataSource = [NSMutableArray array];
            [self.tableView setScrollsToTop:YES];
        }
        [self.dataSource addObjectsFromArray:favaArray];
        if (self.dataSource.count > 0) {
            [self.tableView reloadData];
        }else {
            [NodataShowView showInContentView:self.view withReloadBlock:nil alertTitle:@"暂无收藏"];
        }
    } else if (manager == self.cancelServiceManager) {
        
    }
}

- (void)apiManagerDidFail:(APIManager *)manager {
    [self hiddenHud];
    WEAK_SELF;
    [NodataShowView showInContentView:self.view withReloadBlock:^{
        [weak_self reloadOrderData];
    } requestResultType:NetworkRequestFaildType];
}


#pragma mark - event response

- (void)buyAction:(NSIndexPath *)index
{
    SubmitOrderController *VC = [[SubmitOrderController alloc] init];
    NSDictionary *fava = self.dataSource[index.row];
    FavaGroupGoods *favaService = [FavaGroupGoods objectWithKeyValues:self.dataSource[index.row]];
    VC.serviceId = ((NSNumber *)fava[@"id"]).longValue;
    VC.serviceName = favaService.ggName;
    VC.price = favaService.groupPrice.stringValue;
    [self.navigationController pushViewController:VC animated:YES];
}

- (void)cancelWatch:(NSIndexPath *)index
{
    NSDictionary *fava = self.dataSource[index.row];
    [self.cancelServiceManager cancelPersonalCollection:fava[@"id"] type:5];
    [self.dataSource removeObjectAtIndex:index.row];
    [self.tableView deleteRowsAtIndexPaths:@[index]
                          withRowAnimation:UITableViewRowAnimationLeft];
}

- (void)optionAction
{
    CGRect frame = self.view.frame;
    UIView *optionView = self.optionVC.view;
    optionView.frame = CGRectMake(frame.origin.x, 0, frame.size.width, frame.size.height);
    [self.view addSubview:optionView];
    [self.view bringSubviewToFront:optionView];
}

#pragma mark - 设置更新订单的操作
- (void)setRefresh {
    [self reloadOrderData];
    WEAK_SELF
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weak_self reloadOrderData];
    }];
    //    [self.tableView addHeaderWithCallback:^{
    //        [weak_self reloadOrderData];
    //    }];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [weak_self addOrderData];
    }];
    
    //    [self.tableView addFooterWithCallback:^{
    //        if ([weak_self.tableView isFooterRefreshing]) {
    //            return;
    //        }
    //        [weak_self addOrderData];
    //    }];
}

#pragma mark - private methods
- (void)reloadOrderData {
    [self showHud];
    self.pageNum = 1;
    //    self.serverListManager = [[APIManager alloc] initWithDelegate:self];
    //    self.serverListManager.name = @"lowerRefresh";
    //    [self.serverListManager favServiceList:10 pageNum:self.pageNum];
    
    PersonalFavaGoodsListRequest *request = [[PersonalFavaGoodsListRequest alloc] init:GetToken];
    request.api_pageNum = @(self.pageNum);
    request.api_pageSize = @(10);
    @weakify(self);
    [self showHud];
    VApiManager *manager = [[VApiManager alloc] init];
    [manager personalFavaGoodsList:request success:^(AFHTTPRequestOperation *operation, PersonalFavaGoodsListResponse *response) {
        @strongify(self);
        [self hiddenHud];
        [NodataShowView hideInContentView:self.view];
        if ([self.tableView.mj_header isRefreshing]) {
            [self.tableView.mj_header endRefreshing];
        }
        NSArray *favaArray = response.favaList;
        [self.dataSource removeAllObjects];
        [self.dataSource xf_safeAddObjectsFromArray:favaArray];
        if (self.dataSource.count > 0) {
            [self.tableView reloadData];
        }else {
            [NodataShowView showInContentView:self.view withReloadBlock:nil alertTitle:@"暂无收藏"];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self hiddenHud];
        [UIAlertView xf_showWithTitle:@"网络错误" message:error.domain delay:2.0 onDismiss:NULL];
    }];
}

- (void)addOrderData {
    self.serverListManager.name = @"upperRefresh";
    [self.serverListManager favServiceList:10 pageNum:self.pageNum];
}


- (void)setUIContent
{
    
    UINavigationBar *navBar = self.navigationController.navigationBar;
    navBar.barTintColor = COMMONTOPICCOLOR;
    navBar.tintColor = [UIColor whiteColor];
    navBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
    
    if (self.navigationController.viewControllers.count == 1) {
        
        self.navigationItem.leftBarButtonItem = [UIBarButtonItem initJingGangBackItemWihtAction:@selector(btnClick) target:self];
    }
    
    [YSThemeManager setNavigationTitle:@"我收藏的服务" andViewController:self];
    [self setLeftBarAndBackgroundColor];
    self.view.backgroundColor = background_Color;
    [self setRefresh];
}

- (void)setViewsMASConstraint
{
    UIEdgeInsets padding = UIEdgeInsetsMake(0, 0, 0, 0);
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).with.insets(padding);
        
    }];
}

#pragma mark - getters and settters

- (OptionViewController *)optionVC {
    if (_optionVC == nil) {
        _optionVC = [[OptionViewController alloc] initWithNibName:@"OptionViewController" bundle:nil];
        [self addChildViewController:_optionVC];
        _optionVC.isServerView = YES;
        WEAK_SELF;
        _optionVC.cancelBlock = ^() {
            [weak_self cancelWatch:weak_self.selectedIndexPath];
        };
        _optionVC.addShoppingBlock = ^(){
            //            [weak_self addShoppingCart];
        };
        _optionVC.buyCurrentBlock = ^(){
            [weak_self buyAction:weak_self.selectedIndexPath];
        };
    }
    
    return _optionVC;
}

- (NSMutableArray *)dataSource {
    if (_dataSource == nil) {
        _dataSource = [NSMutableArray array];
    }
    
    return _dataSource;
}

- (UITableView *)tableView {
    if (_tableView == nil) {
        _page = 1;
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, __MainScreen_Width, __MainScreen_Height)];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.estimatedRowHeight = 95.5;
        _tableView.rowHeight = 95.5;
        _tableView.backgroundColor = [UIColor clearColor];
        
        UINib *nibCell = [UINib nibWithNibName:cellIdentifier bundle:nil];
        [_tableView registerNib:nibCell forCellReuseIdentifier:cellIdentifier];
        
        UIView *view = [UIView new];
        view.backgroundColor = [UIColor clearColor];
        [_tableView setTableFooterView:view];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    
    return _tableView;
}
@end
