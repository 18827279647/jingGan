 //
//  commodityListView.m
//  jingGang
//
//  Created by thinker on 15/8/3.
//  Copyright (c) 2015年 yi jiehuang. All rights reserved.
//

#import "commodityListView.h"
#import "commodityListTableViewCell.h"
#import "VApiManager.h"
#import "MJRefresh.h"
#import "PublicInfo.h"
#import "GlobeObject.h"
#import "WSJSiftListModel.h"
#import "NodataShowView.h"

@interface commodityListView ()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>
{
    BOOL          _isHeader;
    VApiManager * _vapManager;
    NSInteger     _page;

}
@property (weak, nonatomic  ) IBOutlet UIButton    *synthesizeBtn;
@property (weak, nonatomic  ) IBOutlet UIButton    *salesBtn;
@property (weak, nonatomic  ) IBOutlet UIButton    *priceBtn;
@property (nonatomic, assign) BOOL        priceSortBool;
@property (weak, nonatomic  ) IBOutlet UIButton    *siftBtn;
@property (strong, nonatomic  ) UIView      *lowView;
@property (weak, nonatomic  ) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *selectBgView;





@end

@implementation commodityListView

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self initUI];
}
- (void)reloadData
{
    [self.tableView.mj_header beginRefreshing];
}
- (void)clearData
{
    self.ID = nil;
    self.keyword = nil;
    self.properties = nil;
    _page = 1;
    self.transfee = nil;
    self.inventory = @(-1);
}
#pragma mark - 店铺列表数据（店铺商品）
- (void) requestStoreListData:(BOOL)b
{
    MerchStoreListRequest *storeRequest = [[MerchStoreListRequest alloc] init:GetToken];
    storeRequest.api_pageNum = @(_page);
    storeRequest.api_pageSize = @(10);
    storeRequest.api_orderBy =  self.orderType ?: kEmptyString;
    storeRequest.api_orderType = self.orderType ?: kEmptyString;
    storeRequest.api_ugcId = self.categoryID;
    storeRequest.api_id = self.ID;
//    storeRequest.api_isPinDan = self.isPinDan;
//    storeRequest.api_isJiFenGou = self.isJiFenGou;
    [_vapManager merchStoreList:storeRequest success:^(AFHTTPRequestOperation *operation, MerchStoreListResponse *response) {
        if ([self.tableView.mj_header isRefreshing])
        {
            [self.dataSource removeAllObjects];
        }
        for (NSDictionary *dict  in response.goodsList)
        {
            [self.dataSource addObject:dict];
        }
        if (b)
        {
            [self.tableView.mj_header endRefreshing];
        }
        [self.tableView.mj_footer endRefreshing];
        [MBProgressHUD hideHUDForView:self animated:YES];
        [self.tableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideHUDForView:self animated:YES];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
}
#pragma mark - 搜索结果数据请求(关键字搜索)
- (void) requestSearchResultData:(BOOL)b
{
    
      NSLog(@"%@",@"进这里222");
    SearchGoodsKeywordRequest *keywordRequest = [[SearchGoodsKeywordRequest alloc] init:GetToken];
    keywordRequest.api_pageNum = @(_page);
    keywordRequest.api_pageSize = @(10);
    keywordRequest.api_keyword = self.keyword;
    keywordRequest.api_orderBy = _orderBy;
    keywordRequest.api_goodsInventory = @(-1);
    keywordRequest.api_orderType = _orderType;
    
    keywordRequest.api_isPinDan = self.isPinDan;
    keywordRequest.api_isJiFenGou = self.isJiFenGou;
    //1卖家包邮goodsTransfee   (默认)nil
    if (self.transfee.integerValue == 0) {
        keywordRequest.api_goodsTransfee = nil;
    }else{
        keywordRequest.api_goodsTransfee = @"1";
    }
    
    //-1(默认)全部0仅显示有货goodsInventory
    if (self.inventory.integerValue == -1) {
        keywordRequest.api_goodsInventory = @-1;
    }else{
        keywordRequest.api_goodsInventory = @0;
    }
    //是否团购
    keywordRequest.api_isTuangou = self.isUniteGoods;
    keywordRequest.api_properties = self.properties;
    [NodataShowView hideInContentView:self];
    [_vapManager searchGoodsKeyword:keywordRequest success:^(AFHTTPRequestOperation *operation, SearchGoodsKeywordResponse *response) {
        [MBProgressHUD hideHUDForView:self animated:YES];
        if ([self.tableView.mj_header isRefreshing])
        {
            [self.dataSource removeAllObjects];
        }
        for (NSDictionary *d in response.keywordGoodsList)
        {
            [self.dataSource addObject:d];
        }
        if (b)
        {
            [self.tableView.mj_header endRefreshing];
        }
        [self.tableView.mj_footer endRefreshing];
        if (self.dataSource.count > 0) {
            [self.tableView reloadData];
        }else{
            [NodataShowView showInContentView:self withReloadBlock:nil alertTitle:@"暂无此类商品，请看看别的吧"];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideHUDForView:self animated:YES];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
}
#pragma mark - 商品列表结果请求数据（商品分类）
- (void) requestShopCategoryData:(BOOL)b
{
    NSLog(@"%@",@"进这里");
    SearchGoodsKeywordRequest *searchRequest = [[SearchGoodsKeywordRequest alloc] init:GetToken];
    searchRequest.api_pageNum = @(_page);
    searchRequest.api_pageSize = @(10);
//    searchRequest.api_keyword = self.keyword;
    searchRequest.api_gcId = self.ID;
    searchRequest.api_orderBy = _orderBy;
    searchRequest.api_queryGc = self.queryGc;
    searchRequest.api_orderType = _orderType;
    
    searchRequest.api_isPinDan = self.isPinDan;
    searchRequest.api_isJiFenGou = self.isJiFenGou;
    //1卖家包邮goodsTransfee   (默认)nil
    if (self.transfee.integerValue == 0) {
        searchRequest.api_goodsTransfee = nil;
    }else{
        searchRequest.api_goodsTransfee = @"1";
    }
    //-1(默认)全部0仅显示有货goodsInventory
    if (self.inventory.integerValue == -1) {
        searchRequest.api_goodsInventory = @-1;
    }else{
        searchRequest.api_goodsInventory = @0;
    }
    
    searchRequest.api_properties = self.properties;
    //是否团购
    searchRequest.api_isTuangou = self.isUniteGoods;
    
     @weakify(self);
     [_vapManager searchGoodsKeyword:searchRequest success:^(AFHTTPRequestOperation *operation, SearchGoodsKeywordResponse *response) {
         @strongify(self);
         
         [MBProgressHUD hideHUDForView:self animated:YES];
         if ([self.tableView.mj_header isRefreshing])
         {
             [self.dataSource removeAllObjects];
         }
         for (NSDictionary *d in response.keywordGoodsList)
         {
             NSLog(@"d+++++%@",d);
             [self.dataSource addObject:d];
         }
         if (b)
         {
             [self.tableView.mj_header endRefreshing];
         }
         [self.tableView.mj_footer endRefreshing];
         if (self.dataSource.count > 0) {
             [self.tableView reloadData];
             [NodataShowView hideInContentView:self];
         }else{
             [NodataShowView showInContentView:self withReloadBlock:nil alertTitle:@"暂无此类商品，请看看别的吧"];
         }
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         [MBProgressHUD hideHUDForView:self animated:YES];
         [self.tableView.mj_header endRefreshing];
         [self.tableView.mj_footer endRefreshing];
     }];

}
#pragma mark - 请求网络数据
- (void) requestData:(BOOL)b
{
    [MBProgressHUD showHUDAddedTo:self animated:YES];
    switch (self.type)
    {
        case classSearch:
            [self requestShopCategoryData:b];
            break;
        case keywordSearch:
            [self requestSearchResultData:b];
            break;
        case storeList:
            [self requestStoreListData:b];
            break;
        default:
            break;
    }
}
- (void) initUI
{
    CGFloat scaleLowViewX = 375.0/27.0;
    self.lowView = [[UIView alloc]initWithFrame:CGRectMake(kScreenWidth/scaleLowViewX, self.selectBgView.height - 2, 40, 2)];
    [self.selectBgView addSubview:self.lowView];
    
    self.lowView.backgroundColor = [YSThemeManager buttonBgColor];
    [self.synthesizeBtn setTitleColor:UIColorFromRGB(0x4a4a4a) forState:UIControlStateSelected];
    [self.salesBtn setTitleColor:UIColorFromRGB(0x4a4a4a) forState:UIControlStateSelected];
    [self.priceBtn setTitleColor:UIColorFromRGB(0x4a4a4a) forState:UIControlStateSelected];
    [self.siftBtn setTitleColor:UIColorFromRGB(0x4a4a4a) forState:UIControlStateSelected];
    
    //调整顶部四个BUtton的select状态颜色
    _isHeader = YES;
    _vapManager = [[VApiManager alloc] init];
    _type = classSearch;//设置默认类型
    _page = 1;
    //是否拼团。默认0
    self.isUniteGoods = @0;
    _orderBy = @"add_time";
    self.transfee = nil;
    self.inventory = @(-1);
    self.dataSource = [NSMutableArray array];
    self.backgroundColor = UIColorFromRGB(0xf7f7f7);
    self.synthesizeBtn.selected = YES;
    self.isJiFenGou=0;
    self.isPinDan=0;
    self.isUniteGoods=0;
    
    //查询页数
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _page = 1;
        [self requestData:YES];
    }];
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        _page += 1;
        [self requestData:YES];
    }];
    [self.tableView registerNib:[UINib nibWithNibName:@"commodityListTableViewCell" bundle:nil] forCellReuseIdentifier:@"ListCell"];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.rowHeight = 126;
    self.tableView.separatorColor = [YSThemeManager getTableViewLineColor];
    self.tableView.tableFooterView = [[UIView alloc]init];
}

#pragma mark - 菜单按钮事件
- (IBAction)menuButton:(UIButton *)sender
{
    if (sender.selected == NO || sender == self.priceBtn || sender == self.siftBtn)
    {
        self.synthesizeBtn.selected = NO;
        self.salesBtn.selected = NO;
        self.priceBtn.selected = NO;
        self.siftBtn.selected = NO;
        sender.selected = YES;
        CGRect frame = CGRectMake(sender.centerX - 20, self.lowView.frame.origin.y, 40, 3);
        [UIView animateWithDuration:0.3 animations:^{
            self.lowView.frame = frame;
            
        }];
        
        //点击筛选以外的其他按钮回调
        if (sender.tag != 1003) {
            if (self.siftOtherButtonAction) {
                self.siftOtherButtonAction();
            }
        }
        
        switch (sender.tag) {
            case 1002: //点击价格
            {
                _orderBy = @"goods_current_price";
                if (self.priceSortBool)
                {
                    [sender setTitle:@"价格↓" forState:UIControlStateSelected];
                    _orderType = @"desc";
                }
                else
                {
                    [sender setTitle:@"价格↑" forState:UIControlStateSelected];
                    _orderType = @"asc";
                }
                self.priceSortBool = ! self.priceSortBool;
            }
                break;
            case 1003: //点击筛选
            {
                if (self.siftAction)
                {
                    self.siftAction(self.shopgoodsProperty);
                }
                self.priceSortBool = NO;
                return;
            }
                break;
            case 1000://点击综合
            {
                self.priceSortBool = NO;
                _orderBy = @"add_time";
            }
                break;
            case 1001://点击销量
            {
                _orderBy = @"goods_salenum";
                self.priceSortBool = NO;
            }
                break;
            default:
                break;
        }
        if ([self.tableView.mj_header isRefreshing])
        {
            _isHeader = NO;
            _page = 1;
            [self.dataSource removeAllObjects];
            [self requestData:NO];
        }
        else
        {
            _isHeader = YES;
            [self.tableView.mj_header beginRefreshing];
        }
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    commodityListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ListCell"];
    NSDictionary *dict = self.dataSource[indexPath.row];
    switch (self.type) {
        case classSearch:
        {
            [cell willSearchCellWithModel:dict];
        }
            break;
        case  keywordSearch:
        {
             [cell willSearchCellWithModel:dict];
        }
            break;
        case  storeList:
        {
            [cell willCellWithModel:dict withType:self.type];
        }
            break;
        default:
            break;
    }
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.selectRowBlock(self.dataSource[indexPath.row]);
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"WHiddenKey" object:nil];
//    CRMainWindow()
}

@end
