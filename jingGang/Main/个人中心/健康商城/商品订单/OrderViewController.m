//
//  OrderViewController.m
//  jingGang
//
//  Created by thinker on 15/8/5.
//  Copyright (c) 2015年 yi jiehuang. All rights reserved.
//

#import "OrderViewController.h"
#import "TLTitleSelectorView.h"
#import "OrderCell.h"
#import "ApplySalesReturnVC.h"
#import "APIManager.h"
#import "OrderConfirmViewController.h"
#import "QueryLogisticsViewController.h"
#import "PayOrderViewController.h"
#import "ShopCenterListReformer.h"
#import "MJRefresh.h"
#import "ActionSheetStringPicker.h"
#import "OrderDetailController.h"
#import "KJDarlingCommentVC.h"
#import "MJExtension.h"
#import "NodataShowView.h"
#import "AppDelegate.h"
#import "YSYunGouBiPayController.h"
#import "YSYgbPayModel.h"
#import "YSCommonAccountEliteZonePayController.h"
#import "YSJuanPiWebViewController.h"
#import "YSLiquorDomainWebController.h"
#import "YSOrderCell.h"
#import "YSOrderListHeaderView.h"
#import "YSOrderListFooterView.h"
#import "PTViewController.h"
@interface OrderViewController () <UITableViewDataSource,UITableViewDelegate,APIManagerDelegate>

@property (weak, nonatomic) IBOutlet TLTitleSelectorView *titleSelector;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) ActionSheetStringPicker *actionPicker;
@property (nonatomic,strong) NSMutableArray *dataSource;
@property (nonatomic,strong) NSMutableArray *orderListArray;
@property (nonatomic,assign) NSInteger pageNumber;
@property (nonatomic,assign) BOOL hiddenSubviews;

@property (nonatomic,strong) NSMutableArray<__kindof SelfOrder *> *selfOrderList;
@property (nonatomic,strong) APIManager *selfOrderListManager;
@property (nonatomic,strong) APIManager *orderCancelManage;
@property (nonatomic,strong) APIManager *orderDeleteManage;
@property (nonatomic,strong) APIManager *confirmRecieveManage;
@property (nonatomic,strong) ShopCenterListReformer <AddressReformerProtocol> *shopCenterReformer;
@property (nonatomic,copy) NSString *orderStatus;

@end

@implementation OrderViewController




#pragma mark - life cycle
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLoad{
    
    [self setUIContent];
    [self initResueqs];
    [self.tableView.mj_header beginRefreshing];
}

- (void)viewWillAppear:(BOOL)animated{
    
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [YSUMMobClickManager beginLogPageWithKey:[NSString stringWithFormat:@"%@%@",@"um_",NSStringFromClass([self class])]];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [YSUMMobClickManager endLogPageWithKey:[NSString stringWithFormat:@"%@%@",@"um_",NSStringFromClass([self class])]];
}
#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat rowHeight = 113.0;
    SelfOrder *selfOrder = [self.selfOrderList xf_safeObjectAtIndex:indexPath.section];
//    NSLog(@"222222222%@",selfOrder);
    if ((selfOrder.goodsInfos.count -1) == indexPath.row) {
        rowHeight = rowHeight - 5;
    }else if(selfOrder == NULL){
        rowHeight = 0;
    }
    return rowHeight;
}
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat rowHeight = 113.0;
    SelfOrder *selfOrder = [self.selfOrderList xf_safeObjectAtIndex:indexPath.section];
    if ((selfOrder.goodsInfos.count -1) == indexPath.row) {
        rowHeight = rowHeight - 5;
    }
    return rowHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SelfOrder *selfOrder = [self.selfOrderList xf_safeObjectAtIndex:indexPath.section];
    if (selfOrder.juanpiOrder.boolValue) {
        //是卷皮订单
        YSJuanPiWebViewController *juanPiWebVC = [[YSJuanPiWebViewController alloc]initWithUrlType:YSOrderListType];
        juanPiWebVC.strWebUrl = selfOrder.targetUrlM;
        [self.navigationController pushViewController:juanPiWebVC animated:YES];
    }else if (selfOrder.orderTypeFlag.integerValue == 4){//酒业订单
        //酒业商品跳转
        [self liquorDomainPushWithUrl:selfOrder.targetUrlM];
    }else{
        [self showOrderDetailVC:[self getOrderID:indexPath.section] goodsInfo:[self getGoodsInfo:indexPath.section]];
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.selfOrderList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    SelfOrder *selfOrder = self.selfOrderList[section];
    return selfOrder.goodsInfos.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString const *cellIdentifier = @"OrderCell";
    YSOrderCell *cell = (YSOrderCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier.copy];
    if (!cell) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"YSOrderCell" owner:self options:nil];
        cell = [nib lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    SelfOrder *selfOrder = [self.selfOrderList xf_safeObjectAtIndex:indexPath.section];
    [cell setDataModelWithSelfOrderModel:selfOrder indexPath:indexPath];
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    NSDictionary *orderData = [self.dataSource xf_safeObjectAtIndex:section];
    if (orderData.allKeys.count >0)
    {
        static NSString *viewIdentfier = @"headView";
        YSOrderListHeaderView *sectionHeadView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:viewIdentfier];
        if(!sectionHeadView){
            sectionHeadView = [[YSOrderListHeaderView alloc] initWithReuseIdentifier:viewIdentfier];
        }
        [sectionHeadView configWithReformedOrder:orderData];
        
        return sectionHeadView;
    }
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    static NSString *viewIdentfier = @"footView";
    YSOrderListFooterView *sectionFootView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:viewIdentfier];
    if(!sectionFootView){
        sectionFootView = [[YSOrderListFooterView alloc] initWithReuseIdentifier:viewIdentfier];
    }
  
    
    NSDictionary *orderData = [self.dataSource xf_safeObjectAtIndex:section];
      NSLog(@"self.dataSourceself.dataSourceself.dataSource%@",orderData);
    if (orderData) {
        [sectionFootView configWithReformedOrder:orderData];
        sectionFootView.indexPathSection = section;
        @weakify(self);
        sectionFootView.buttonPressBlock = ^(NSInteger operationType, NSInteger indexPathSection) {
            @strongify(self);
            [self pressCellButton:operationType atIndexPath:indexPathSection];
        };
    }
    
    return sectionFootView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 49;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    SelfOrder *selfOrder = [self.selfOrderList xf_safeObjectAtIndex:section];
    CGFloat rowHeight = 84;
    if (selfOrder.juanpiOrder.boolValue && !selfOrder.isDelete.boolValue) {
        //是卷皮商品的同时还要是不能删除的订单状态,需要缩短cell的高度，隐藏底部按钮
        rowHeight = rowHeight - 42;
    }
    return rowHeight;
}

#pragma mark - APIManagerDelegate 网络回调
- (void)apiManagerDidSuccess:(APIManager *)manager {
    if (manager == self.selfOrderListManager) {
        
        if ([self.tableView.mj_header isRefreshing]) {
            [self.tableView.mj_header endRefreshing];
        }
        if ([self.tableView.mj_footer isRefreshing]) {
            [self.tableView.mj_footer endRefreshing];
        }
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        if (manager.successResponse != nil) {
            SelfOrderListResponse *response = (SelfOrderListResponse *)manager.successResponse;
            NSArray *orderList = response.orderList;
            if (orderList.count > 0) {
                NSLog(@"====%zd\n",orderList.count);
                [NodataShowView hideInContentView:self.tableView];
                for (NSDictionary *selfOrder in orderList) {
                    [self.dataSource addObject:[self.shopCenterReformer getOrderDatafromData:selfOrder fromManager:manager]];
                    [self.orderListArray addObject:selfOrder];
                }

                [SelfOrder setupObjectClassInArray:^NSDictionary *{
                    return @{
                             @"goodsInfos" : [GoodsInfo class]
                             };
                }];
                [SelfOrder setupReplacedKeyFromPropertyName:^NSDictionary *{
                    return @{@"apiId":@"id"};
                }];
                [self.selfOrderList addObjectsFromArray:[SelfOrder objectArrayWithKeyValuesArray:orderList]];
                self.pageNumber++;
                [self.tableView reloadData];
                [self setHiddenSubviews:NO];
            }  else if (orderList.count == 0){
                if (self.selfOrderList.count == 0) {
                    [self showNoDataView];
                    self.tableView.mj_footer.hidden = YES;
                }else {
                    [self.tableView.mj_footer endRefreshingWithNoMoreData];
                    self.tableView.mj_footer.hidden = NO;
                    [self.tableView.mj_footer endRefreshingWithNoMoreData];
                }
        
                [self.tableView reloadData];
                
                
                
            }
        }
    } else if (manager == self.orderCancelManage) {
        [self reloadOrderData];
    } else if (manager == self.confirmRecieveManage) {
        [self reloadOrderData];
    }
}

- (void)apiManagerDidFail:(APIManager *)manager {
    [self.dataSource removeAllObjects];
    [self.orderListArray removeAllObjects];
    [self.selfOrderList removeAllObjects];
    [self.tableView reloadData];
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    [self showNoDataView];
     @weakify(self);
    if ([self.tableView.mj_header isRefreshing]) {
        @strongify(self);
        [self.tableView.mj_header endRefreshing];
    }
    
    if ([self.tableView.mj_footer isRefreshing]) {
        @strongify(self);
        [self.tableView.mj_footer endRefreshing];
    }
    
}

#pragma mark - event response
- (void)showNoDataView {
    [NodataShowView showInContentView:self.tableView withReloadBlock:^{
        AppDelegate *appDelegate = kAppDelegate;
        [appDelegate gogogoWithTag:3];
    } alertTitle:@"你还没有相关订单，可以看看有哪些想买的，随便去逛逛"];
}

#pragma mark - 跳转至订单详情
- (void)showOrderDetailVC:(NSNumber *)ID goodsInfo:(NSArray *)goodsInfo{
    
    OrderDetailController *VC = [[OrderDetailController alloc] initWithNibName:@"OrderDetailController" bundle:nil];
    VC.orderID = ID;
    VC.goodsInfo = goodsInfo;
    VC.comeFromPushType = comeFromOrderListType;
     @weakify(self);
    VC.refreshOrderListNotice = ^{
        @strongify(self);
        [self reloadOrderData];
    };
    [self.navigationController pushViewController:VC animated:YES];
}

#pragma mark - 取消订单
- (void)cancelOrderAction:(NSInteger)indexPathSection
{
    __block NSString *cancelReason = @"不想要了";
    long orderID = [self getOrderID:indexPathSection].longValue;
    
    NSArray *numberData = @[
                            @"我不想要了",
                            @"信息错误,重新拍",
                            @"卖家缺货",
                            @"其他原因",
                            ];
     @weakify(self);
    ActionStringDoneBlock done = ^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
        @strongify(self);
        cancelReason = selectedValue;
        [self.orderCancelManage cancelOrder:orderID stateInfo:cancelReason];
    };
    ActionStringCancelBlock cancel = ^(ActionSheetStringPicker *picker) {
    };
    self.actionPicker = [[ActionSheetStringPicker alloc] initWithTitle:@"退货原因" rows:numberData.copy initialSelection:0 doneBlock:done cancelBlock:cancel origin:self.view];
    [self.actionPicker showActionSheetPicker];
}

#pragma mark - 删除订单
- (void)deleteOrder:(NSInteger)indexPathSection
{
    JGLog(@"%ld",indexPathSection);
    SelfOrder *selfOrder = [self.selfOrderList xf_safeObjectAtIndex:indexPathSection];

    [self.orderDeleteManage deleteOrder:[self getOrderID:indexPathSection].longValue isJuanPiOrder:selfOrder.isDelete];
    [self.dataSource removeObjectAtIndex:indexPathSection];
    [self.orderListArray removeObjectAtIndex:indexPathSection];
    [self.selfOrderList removeObjectAtIndex:indexPathSection];
    [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:indexPathSection] withRowAnimation:UITableViewRowAnimationLeft];
}

#pragma mark - 改变所选状态
- (void)changeSelectedTtile:(NSInteger)selectedNumber
{
    NSString *orderStatus = nil;
    if (1 == selectedNumber) {
        orderStatus = @"order_submit";
    } else if (2 == selectedNumber) {
        orderStatus = @"order_pay";
    } else if (3 == selectedNumber) {
        orderStatus = @"order_shipping";
    } else if (4 == selectedNumber) {
        orderStatus = @"order_receive";
    }
    self.orderStatus = orderStatus;
    self.selfOrderListManager = [[APIManager alloc] initWithDelegate:self];
    [self.tableView.mj_header beginRefreshing];
}
- (void)liquorDomainPushWithUrl:(NSString *)url{
    //酒业商品跳转
    YSLiquorDomainWebController *liquorDomainWebVC = [[YSLiquorDomainWebController alloc]initWithUrlType:YSLiquorDomainOrderListType];
    liquorDomainWebVC.strUrl = url;
    [self.navigationController pushViewController:liquorDomainWebVC animated:YES];
    
}
#pragma mark - 响应订单的各种取消、查看物流、评价...等等事件
- (void)pressCellButton:(TLOperationType)operationType atIndexPath:(NSInteger )indexPathSection 
{
    
    NSDictionary *orderData = [self.dataSource xf_safeObjectAtIndex:indexPathSection];
    
    NSLog(@"----%@\n",orderData);
    
    UIViewController *VC = nil;
    SelfOrder *selfOrder = [self.selfOrderList xf_safeObjectAtIndex:indexPathSection];
    NSInteger orderTypeFlag = selfOrder.orderTypeFlag.integerValue;
    switch (operationType) {
        case TLOperationTypeCancel:
        {
//            NSLog(@"[%lu - %lu] 取消订单",indexPath.section,indexPath.row);
            [self cancelOrderAction:indexPathSection];
            break;
        }
        case TLOperationTypeDelete:
//            NSLog(@"[%lu - %lu] 删除订单",indexPath.section,indexPath.row);
            
            if ([orderData[@"isPindan"] integerValue] == 1) {
                
                PTViewController * view  = [[PTViewController alloc] init];
                view.orderID = orderData[@"orderKeyID"];
                view.pdorderID = orderData[@"orderKeyOrderID"];
                [self.navigationController pushViewController:view animated:YES];
            }else {
               [self deleteOrder:indexPathSection];
            }
            

            break;
            case TLOperationTypePay:
        {

            if (orderTypeFlag == 4) {
                //酒业商品跳转
                [self liquorDomainPushWithUrl:selfOrder.targetUrlM];
                break;
            }

            NSDictionary *orderData = self.dataSource[indexPathSection];
             @weakify(self);
            VApiManager *vapiManager = [[VApiManager alloc]init];
            ShopTradePaymetViewRequest *request = [[ShopTradePaymetViewRequest alloc] init:GetToken];
            request.api_id = ((NSNumber *)orderData[orderKeyID]);
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            [vapiManager shopTradePaymetView:request success:^(AFHTTPRequestOperation *operation, ShopTradePaymetViewResponse *response) {
                @strongify(self);
                
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                
                if (response.errorCode.integerValue > 0) {
                    [UIAlertView xf_showWithTitle:response.subMsg message:nil delay:1.2 onDismiss:NULL];
                    return ;
                }
                NSNumber *payTypeFlag = ((NSDictionary *)response.order)[@"payTypeFlag"];
                if ([payTypeFlag integerValue] == 1 || [payTypeFlag integerValue] == 2) {
//                    是云购币专区订单
                    YSYunGouBiPayController *yunGouBiPayVC = [[YSYunGouBiPayController alloc]init];
                    NSDictionary *dictYgbPay = [NSDictionary dictionaryWithDictionary:(NSDictionary *)response.ygPayMode];
                    yunGouBiPayVC.ygbPayModel = [YSYgbPayModel objectWithKeyValues:dictYgbPay];
                    yunGouBiPayVC.ygbPayModel.orderID = ((NSDictionary *)response.order)[@"id"];
                    yunGouBiPayVC.ygbPayModel.orderNumber = ((NSDictionary *)response.order)[@"orderId"];
                    yunGouBiPayVC.ygbPayModel.totalPrice = [response.totalPrice floatValue];
                    yunGouBiPayVC.ygbPayModel.orderStatus = ((NSDictionary *)response.order)[@"orderStatus"];
                    if ([payTypeFlag integerValue] == 1) {
                        //重消订单
                        yunGouBiPayVC.ygbPayModel.res = @40;
                    }
                    [self.navigationController pushViewController:yunGouBiPayVC animated:YES];
                }else if ([payTypeFlag integerValue] == 3){
                    //精品专区普通账号支付页面
                    YSCommonAccountEliteZonePayController *eliteZonePayVC = [[YSCommonAccountEliteZonePayController alloc]init];
                    NSDictionary *dictYgbPay = [NSDictionary dictionaryWithDictionary:(NSDictionary *)response.ygPayMode];
                    eliteZonePayVC.ygbPayModel = [YSYgbPayModel objectWithKeyValues:dictYgbPay];
                    eliteZonePayVC.ygbPayModel.orderID = ((NSDictionary *)response.order)[@"id"];
                    eliteZonePayVC.ygbPayModel.orderNumber = ((NSDictionary *)response.order)[@"orderId"];
                    eliteZonePayVC.ygbPayModel.totalPrice = [response.totalPrice floatValue];
                    eliteZonePayVC.ygbPayModel.orderStatus = ((NSDictionary *)response.order)[@"orderStatus"];
                    [self.navigationController pushViewController:eliteZonePayVC animated:YES];
                }else{
                    PayOrderViewController *payOrderVC = [[PayOrderViewController alloc] init];
                    payOrderVC.orderID = ((NSNumber *)orderData[orderKeyID]);
                    payOrderVC.orderNumber = (NSString *)orderData[orderKeyOrderID];
                    payOrderVC.jingGangPay = ShoppingPay;
                    payOrderVC.totalPrice = ((NSNumber *)orderData[orderKeyTotalPrice]).floatValue;
                    [self.navigationController pushViewController:payOrderVC animated:YES];
                }
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                [UIAlertView xf_showWithTitle:@"网络错误，请稍后再试 " message:nil delay:1.2 onDismiss:NULL];
                [MBProgressHUD hideHUDForView:self.view animated:YES];
            }];
            
        }

            break;
            case TLOperationTypeRecieve:
//            NSLog(@"[%lu - %lu] 签收商品",indexPath.section,indexPath.row);
            if (orderTypeFlag == 4) {
                //酒业签收商品跳转
                YSLiquorDomainWebController *liquorDomainWebVC = [[YSLiquorDomainWebController alloc]initWithUrlType:YSLiquorDomainOrderListType];
                liquorDomainWebVC.strUrl = selfOrder.targetUrlM;
                VC = liquorDomainWebVC;
            }else{
                [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                [self.confirmRecieveManage confirmRecieve:[self getOrderID:indexPathSection].longValue];
            }
           
            
            break;
            case TLOperationTypeCheckLogistics:
        {
//            NSLog(@"[%lu - %lu] 查看物流",indexPath.section,indexPath.row);
            QueryLogisticsViewController *quertVC = [[QueryLogisticsViewController alloc] initWithNibName:@"QueryLogisticsViewController" bundle:nil];
            NSDictionary *orderData = self.dataSource[indexPathSection];
            quertVC.expressCompanyId = (NSNumber *)orderData[transKeyCompanyID];
            quertVC.expressCode = orderData[transKeyShipCodeID];
            VC = quertVC;
        }
  
            break;
        case TLOperationTypeWriteComment:
        {
//            NSLog(@"[%lu - %lu] 写评价",indexPath.section,indexPath.row);
            KJDarlingCommentVC *commentVC = [[KJDarlingCommentVC alloc] initWithNibName:@"KJDarlingCommentVC" bundle:nil];
            commentVC.goodsInfos = [self getGoodsInfo:indexPathSection];
            commentVC.orderID = [self getOrderID:indexPathSection];
            @weakify(self);
            commentVC.refreshOrderListNotice = ^{
                @strongify(self);
                [self reloadOrderData];
            };
            VC = commentVC;
        }
            
            break;
        case TLOperationTypeReturn:
        {
//            NSLog(@"[%lu - %lu] 退货",indexPath.section,indexPath.row);
            ApplySalesReturnVC *returnVC = [[ApplySalesReturnVC alloc] initWithNibName:@"ApplySalesReturnVC" bundle:nil];
            VC = returnVC;
        }
            
            break;
        default:
            break;
    }

    if (VC) {
        [self.navigationController pushViewController:VC animated:YES];
    }
    
}

#pragma mark - private methods
- (void)initResueqs
{
    self.selfOrderListManager = [[APIManager alloc] initWithDelegate:self];
    self.orderCancelManage = [[APIManager alloc] initWithDelegate:self];
    self.orderDeleteManage = [[APIManager alloc] initWithDelegate:self];
    self.confirmRecieveManage = [[APIManager alloc] initWithDelegate:self];
}

- (void)reloadOrderData {
    self.pageNumber = 1;
    self.dataSource = [[NSMutableArray alloc] init];
    self.orderListArray = [[NSMutableArray alloc] init];
    self.selfOrderList = [[NSMutableArray alloc] init];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self.tableView.mj_footer resetNoMoreData];
    [self.selfOrderListManager getOrderList:self.orderStatus pageNum:@(self.pageNumber)];
}

- (void)addOrderData {
    
    [self.selfOrderListManager getOrderList:self.orderStatus pageNum:@(self.pageNumber)];
}

#pragma mark - 设置更新订单的操作
- (void)setRefresh {
     @weakify(self);
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        @strongify(self);

        [self reloadOrderData];
    }];
    
    
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        @strongify(self);

        [self addOrderData];
    }];

}

- (void)tableViewInit {
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.backgroundColor = UIColorFromRGB(0xf7f7f7);
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [self.tableView setTableFooterView:view];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.selfOrderList removeAllObjects];
    
}

- (void)setBarButtonItem {
    [self setLeftBarAndBackgroundColor];
}

- (void)setUIContent
{
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }

    UINavigationBar *navBar = self.navigationController.navigationBar;
    navBar.tintColor = [UIColor whiteColor];
    navBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
    [self setBarButtonItem];
    [YSThemeManager setNavigationTitle:@"商品订单" andViewController:self];
    [self.titleSelector setSelectorTitles:@"全部",@"待付款",@"待发货",@"待收货",@"待评价",nil];
    self.titleSelector.backgroundColor = [UIColor whiteColor];
    self.titleSelector.selectedColor = UIColorFromRGB(0x4a4a4a);
    self.titleSelector.titleColor = UIColorFromRGB(0x9b9b9b);
    self.titleSelector.buttonPressBlock = ^(NSInteger index) {

        [self changeSelectedTtile:index];
    };
    [self tableViewInit];
    [self setRefresh];
    self.tableView.fd_debugLogEnabled = YES;
}

#pragma mark - getters and settters

- (NSArray *)getGoodsInfo:(NSInteger )indexPathSection
{
    NSDictionary *selfOrder = self.orderListArray[indexPathSection];
    NSArray *goodsInfo = selfOrder[@"goodsInfos"];

    return goodsInfo;
}

- (NSNumber *)getOrderID:(NSInteger )indexPathSection
{
    NSDictionary *orderData = self.dataSource[indexPathSection];
    NSNumber *orderID = ((NSNumber *)orderData[orderKeyID]);
    return orderID;
}

- (void)setOrderStatus:(NSString *)orderStatus {
    if (![_orderCancelManage isEqual:orderStatus]) {
        self.pageNumber = 1;
        self.dataSource = [[NSMutableArray alloc] init];
        self.orderListArray = [[NSMutableArray alloc] init];
        self.selfOrderList = [[NSMutableArray alloc] init];
        _orderStatus = orderStatus;
    }
}

- (void)setHiddenSubviews:(BOOL)hiddenSubviews {
    if (hiddenSubviews != _hiddenSubviews) {
        _hiddenSubviews = hiddenSubviews;
        self.tableView.hidden = hiddenSubviews;
    }
}


- (NSMutableArray *)dataSource {
    if (_dataSource == nil) {
        _dataSource = [[NSMutableArray alloc] init];
    }
    
    return _dataSource;
}

- (ShopCenterListReformer *)shopCenterReformer {
    if (_shopCenterReformer == nil) {
        _shopCenterReformer = [[ShopCenterListReformer alloc] init];
    }
    return _shopCenterReformer;
}

#pragma mark - dyci debug operation
- (void)updateOnClassInjection {
//    [self showNoDataView];
    UIViewController *VC = [[NSClassFromString(@"ApplySalesReturnVC") alloc] init];
    [self.navigationController pushViewController:VC animated:YES];
}


@end
