//
//  UnderLineOrderManagerViewController.m
//  jingGang
//
//  Created by thinker on 15/9/9.
//  Copyright (c) 2015年 yi jiehuang. All rights reserved.
//

#import "UnderLineOrderManagerViewController.h"
#import "TLTitleSelectorView.h"
#import "PublicInfo.h"
#import "Masonry.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "APIManager.h"
#import "MJRefresh.h"
#import "UnderLineOrderManagerTableViewCell.h"
#import "NodataShowView.h"
#import "MJExtension.h"
#import "ShoppingOrderDetailController.h"
#import "PayOrderViewController.h"
#import "ServiceCommentController.h"
#import "AppDelegate.h"
//#import "YSSelectOnlieOrderTypeBgView.h"
#import "YSOnlineOrderListDataModel.h"
#import "YSScanOrderDetailController.h"
#import "YSScanPayViewController.h"
#import "YSHotelOrderListCell.h"
#import "YSHotelOrderDetailController.h"
#import "YSHotelOrderListRequstManager.h"
#import "YSHotelOrderListModel.h"
#import "YSLocationManager.h"
#import "CLLocation+YSLocationTransform.h"
#import "YSLinkElongHotelWebController.h"
#import "YSHotelOrderDeleteRequstManager.h"
#import "YSHotelOrderCancelRequstManager.h"
@interface UnderLineOrderManagerViewController () <UITableViewDelegate,UITableViewDataSource,APIManagerDelegate,YSAPICallbackProtocol,YSAPIManagerParamSource>

@property (nonatomic,strong) TLTitleSelectorView *titleView;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataSource;
@property (nonatomic,assign) NSInteger pageNumber;
@property (nonatomic,assign) BOOL hiddenSubviews;

@property (nonatomic,strong) APIManager *orderLineListManager;
@property (nonatomic,strong) APIManager *orderCancelManage;
@property (nonatomic,strong) APIManager *orderPayViewManager;
//状态|0已取消,10未付款20未使用,30已使用100退款|全部传nil，选择优惠买单与扫码支付传nil  传1000，requst的时候会判断
@property (nonatomic,assign) NSInteger orderStatus;
@property (nonatomic,strong) UIImageView *imageViewSelectOrderType;
//@property (nonatomic,strong) YSSelectOnlieOrderTypeBgView *selectOnlieOrderTypeBgView;

//酒店订单列表请求
@property (nonatomic,strong) YSHotelOrderListRequstManager *hotelOrderListRequstManager;
@property (nonatomic,strong) YSHotelOrderDeleteRequstManager *hotelOrderDeleteRequstManager;
@property (nonatomic,strong) YSHotelOrderCancelRequstManager *hotelOrderCancelManager;

/**
 *  酒店订单专用订单状态用，点击删除/取消订单按钮后记录所选的那一条记录的订单的状态，然后针对这个model的数据处理请求/返回的数据
 */
@property (nonatomic,strong) YSHotelOrderListModel *tempHotelListModel;
@end

static NSString *cellIdentifier = @"UnderLineOrderManagerTableViewCell";
static NSString *hotelOrderListCellID = @"YSHotelOrderListCell";
@implementation UnderLineOrderManagerViewController
@synthesize orderStatus = _orderStatus;

#pragma mark - life cycle
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.titleView];
    [self.view addSubview:self.tableView];
    [self setUIContent];
    

}

- (void)viewWillAppear:(BOOL)animated {
    [self.tableView.mj_header beginRefreshing];
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [YSUMMobClickManager beginLogPageWithKey:[NSString stringWithFormat:@"%@%@",@"um_",NSStringFromClass([self class])]];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [YSUMMobClickManager endLogPageWithKey:[NSString stringWithFormat:@"%@%@",@"um_",NSStringFromClass([self class])]];
}

- (void)setOrderType:(NSInteger)orderType{
    _orderType = orderType;
    //订单类型1、线上订单2、扫码支付3、优惠买单4、套餐券5、代金券  6酒店订单
    //        选择优惠买单与扫码支付传nil，orderStatus传1000，requst的时候会判断
    self.orderStatus = 1000;
    if (orderType == 6) {
        //酒店订单
        self.pageNumber = 1;
    }else{
        //非酒店订单
        self.orderLineListManager = [[APIManager alloc] initWithDelegate:self];
        self.orderCancelManage = [[APIManager alloc] initWithDelegate:self];
    }
    [self setTitleViewAndTableViewFramWithOrderOrder];
}
- (void)setStrTitle:(NSString *)strTitle{
    _strTitle = strTitle;
    strTitle = [strTitle stringByAppendingString:@"订单"];
    [YSThemeManager setNavigationTitle:strTitle andViewController:self];
}
#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.orderType == 6) {
        YSHotelOrderListModel *model = [self.dataSource xf_safeObjectAtIndex:indexPath.row];
        return [model getHotelOrderListCellRowHeight];
    }
    return 200.0;
}




- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.orderType == 6) {
        //酒店订单
        YSHotelOrderListModel *model = [self.dataSource xf_safeObjectAtIndex:indexPath.row];
        if(model.showStatus == 2048 || model.showStatus == 4096 || model.showStatus == 16){
            //以上两种状态点击cell无任何效果
            return;
        }
        YSHotelOrderDetailController *hotelOrderDetailVC = [[YSHotelOrderDetailController alloc]init];
        hotelOrderDetailVC.orderID = model.orderId;
        [self.navigationController pushViewController:hotelOrderDetailVC animated:YES];
    }else{
        YSOnlineOrderListDataModel *model = self.dataSource[indexPath.row];
        if (model.orderType.integerValue == 2 || model.orderType.integerValue == 3) {
            //是优惠买单或者扫码买单的订单
            YSScanOrderDetailController *scanPayOrderDetailVC = [[YSScanOrderDetailController alloc]init];
            scanPayOrderDetailVC.api_ID = model.id;
            scanPayOrderDetailVC.comeFromeType = comeFromOrderListType;
            [self.navigationController pushViewController:scanPayOrderDetailVC animated:YES];
        }else{
            ShoppingOrderDetailController *VC = [[ShoppingOrderDetailController alloc] initWithStatus:model.orderStatus.integerValue];
            VC.orderId = model.id.integerValue;
            VC.comeFromePushType = comeFromOrderListType;
            [self.navigationController pushViewController:VC animated:YES];
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
    UITableViewCell *cell;
    if (self.orderType == 6) {
        cell = [tableView dequeueReusableCellWithIdentifier:hotelOrderListCellID];
        [self setDataForHotelListCellContent:cell indexPath:indexPath];
    }else{
        cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        [self loadCellContent:cell indexPath:indexPath];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)setDataForHotelListCellContent:(UITableViewCell *)cell indexPath:(NSIndexPath*)indexPath{
    @weakify(self);
    //这里把数据设置给Cell
    YSHotelOrderListCell *hotelOrderCell = (YSHotelOrderListCell *)cell;
    YSHotelOrderListModel *model = [self.dataSource xf_safeObjectAtIndex:indexPath.row];
    hotelOrderCell.model = model;
    hotelOrderCell.indexPath = indexPath;
    
    hotelOrderCell.goUpToPayHotelOrderBlcok = ^(NSIndexPath *selectIndexPath) {
        @strongify(self);
        [self goUpToPayHotelOrderWithIndexPath:selectIndexPath];
    };
    
    hotelOrderCell.deleteHotelOrderBlcok = ^(NSIndexPath *selectIndexPath) {
        @strongify(self);
        [self deleteHotelOrderWithIndexPath:selectIndexPath];
    };
    
    hotelOrderCell.navigationToHotelBlcok = ^(NSIndexPath *selectIndexPath) {
        @strongify(self);
        [self navigationToHotelWithIndexPath:selectIndexPath];
    };

    hotelOrderCell.liaisonHotelBlcok = ^(NSIndexPath *selectIndexPath) {
        @strongify(self);
        [self liaisonHotelWithIndexPath:selectIndexPath];
    };
    
    hotelOrderCell.againAdvanceHotelBlcok = ^(NSIndexPath *selectIndexPath) {
        @strongify(self);
        [self againAdvanceHotelWithIndexPath:selectIndexPath];
    };
    hotelOrderCell.cancelHotelOrderBlcok = ^(NSIndexPath *selectIndexPath) {
        @strongify(self);
        [self canelHotelOrderWithIndexPath:selectIndexPath];
    };
    hotelOrderCell.goGuaranteeHotelOrderBlock = ^(NSIndexPath *selectIndexPath) {
        @strongify(self);
        [self goGuaranteeHotelOrderWithIndexPath:selectIndexPath];
    };
}

//去支付酒店订单
- (void)goUpToPayHotelOrderWithIndexPath:(NSIndexPath *)indexPath{
    YSHotelOrderListModel *model = [self.dataSource xf_safeObjectAtIndex:indexPath.row];
    NSString *webUrl = [NSString stringWithFormat:@"%@/v1/elong/order/toPay.htm?id=%ld",MobileWeb_Url,model.id.integerValue];
    YSLinkElongHotelWebController *elongHotelWebController = [[YSLinkElongHotelWebController alloc] initWithWebUrl:webUrl];
    elongHotelWebController.navTitle = @"支付订单";
    [self.navigationController pushViewController:elongHotelWebController animated:YES];
}
//取消订单
- (void)canelHotelOrderWithIndexPath:(NSIndexPath *)indexPath{
    YSHotelOrderListModel *model = [self.dataSource xf_safeObjectAtIndex:indexPath.row];
    [self cancelOrderWithHotelListModel:model];
}
//酒店去支付担保金
-(void)goGuaranteeHotelOrderWithIndexPath:(NSIndexPath *)indexPath{
    YSHotelOrderListModel *model = [self.dataSource xf_safeObjectAtIndex:indexPath.row];
    NSString *webUrl = [NSString stringWithFormat:@"%@/v1/elong/order/toPay.htm?id=%ld",MobileWeb_Url,model.id.integerValue];
    YSLinkElongHotelWebController *elongHotelWebController = [[YSLinkElongHotelWebController alloc] initWithWebUrl:webUrl];
    elongHotelWebController.navTitle = @"支付订单";
    [self.navigationController pushViewController:elongHotelWebController animated:YES];
}

//删除酒店订单
- (void)deleteHotelOrderWithIndexPath:(NSIndexPath *)indexPath{
    @weakify(self);
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"删除订单" message:@"订单删除后将无法恢复，确定删除？" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        @strongify(self);
        YSHotelOrderListModel *model = [self.dataSource xf_safeObjectAtIndex:indexPath.row];
        self.tempHotelListModel = model;
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [self.hotelOrderDeleteRequstManager requestData];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:cancelAction];
    [alert addAction:okAction];
    [self presentViewController:alert animated:YES completion:nil];
}
//导航去酒店
- (void)navigationToHotelWithIndexPath:(NSIndexPath *)indexPath{
    @weakify(self);
    YSHotelOrderListModel *model = [self.dataSource xf_safeObjectAtIndex:indexPath.row];
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:nil
                                                                              message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    //自带地图
        [alertController addAction:[UIAlertAction actionWithTitle:@"用iPhone自带地图导航" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //使用自带地图导航
        @strongify(self);
        [self navForIOSMapWithHoteLatitude:model.latitude HotelLongitude:model.longitude HotelAddress:model.address];
    }]];
    //判断是否安装了高德地图，如果安装了高德地图，则显示高德地图导航
    if ( [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"iosamap://"]]) {
        [alertController addAction:[UIAlertAction actionWithTitle:@"用高德地图导航" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            @strongify(self);
            [self navForGDMapWithHoteLatitude:model.latitude HotelLongitude:model.longitude HotelAddress:model.address];
        }]];
    }
    //判断是否安装了百度地图，如果安装了百度地图，则显示百度地图导航
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"baidumap://"]]) {
        [alertController addAction:[UIAlertAction actionWithTitle:@"用百度地图导航" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            @strongify(self);
            [self navForBDMapWithHoteLatitude:model.latitude HotelLongitude:model.longitude HotelAddress:model.address];
        }]];
    }
    //添加取消选项
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [alertController dismissViewControllerAnimated:YES completion:nil];
        
    }]];
    //显示alertController
    [self presentViewController:alertController animated:YES completion:nil];
}
//联系酒店
- (void)liaisonHotelWithIndexPath:(NSIndexPath *)indexPath{
    YSHotelOrderListModel *model = [self.dataSource xf_safeObjectAtIndex:indexPath.row];
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"酒店电话"
                                                                              message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [alertController addAction:[UIAlertAction actionWithTitle:model.phone style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
         [YSThemeManager callPhone:model.phone];
    }]];
    //添加取消选项
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alertController animated:YES completion:nil];
}
//再次预订酒店
- (void)againAdvanceHotelWithIndexPath:(NSIndexPath *)indexPath{
    YSHotelOrderListModel *model = [self.dataSource xf_safeObjectAtIndex:indexPath.row];
    NSString *webUrl = [NSString stringWithFormat:@"%@/v1/elong_hotel_detail.htm?hotelId=%ld",MobileWeb_Url,[model.hotelId integerValue]];
    YSLinkElongHotelWebController *elongHotelWebController = [[YSLinkElongHotelWebController alloc] initWithWebUrl:webUrl];
    elongHotelWebController.navTitle = @"酒店住宿";
    [self.navigationController pushViewController:elongHotelWebController animated:YES];
}

/**
 *  系统自带地图导航 */
- (void)navForIOSMapWithHoteLatitude:(CGFloat)toLatitude HotelLongitude:(CGFloat)toLongitude HotelAddress:(NSString *)toAddress{
    //起点
    MKMapItem *currentLocation = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc]  initWithCoordinate:[self transformGDMapFromBDMapWithLatitute:[YSLocationManager sharedInstance].coordinate.latitude longitude:[YSLocationManager sharedInstance].coordinate.longitude]  addressDictionary:nil]];
    currentLocation.name = @"我的位置";
    
    //目的地的位置
    MKMapItem *toLocation = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:[self transformGDMapFromBDMapWithLatitute:toLatitude longitude:toLongitude] addressDictionary:nil]];
    toLocation.name = toAddress;
    NSArray *items = [NSArray arrayWithObjects:currentLocation, toLocation, nil];
    NSString * mode = MKLaunchOptionsDirectionsModeDriving;
    NSDictionary *options = @{ MKLaunchOptionsDirectionsModeKey:mode, MKLaunchOptionsMapTypeKey: [NSNumber                                 numberWithInteger:MKMapTypeStandard], MKLaunchOptionsShowsTrafficKey:@YES };
    //打开苹果自身地图应用，并呈现特定的item
    [MKMapItem openMapsWithItems:items launchOptions:options];
}

/**
 *   高德地图导航*/
- (void)navForGDMapWithHoteLatitude:(CGFloat)toLatitude HotelLongitude:(CGFloat)toLongitude HotelAddress:(NSString *)toAddress {
    NSString * t = @"0";
    CLLocationCoordinate2D originCoor = [self transformGDMapFromBDMapWithLatitute:[YSLocationManager sharedInstance].coordinate.latitude longitude:[YSLocationManager sharedInstance].coordinate.longitude];
    CLLocationCoordinate2D toCoor = [self transformGDMapFromBDMapWithLatitute:toLatitude longitude:toLongitude];
    NSString *url = [[NSString stringWithFormat:@"iosamap://path?sourceApplication=applicationName&sid=BGVIS1&slat=%lf&slon=%lf&sname=我的位置&did=BGVIS2&dlat=%lf&dlon=%lf&dname=%@&dev=0&m=0&t=%@",originCoor.latitude,originCoor.longitude, toCoor.latitude,toCoor.longitude,toAddress,t] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [[UIApplication  sharedApplication]openURL:[NSURL URLWithString:url]];
}
- (void)navForBDMapWithHoteLatitude:(CGFloat)toLatitude HotelLongitude:(CGFloat)toLongitude HotelAddress:(NSString *)toAddress {
    CLLocationCoordinate2D toCoordinate = {toLatitude,toLongitude};
    NSString * modeBaiDu = @"driving";
    NSString *url = [[NSString stringWithFormat:@"baidumap://map/direction?origin=%lf,%lf&destination=%f,%f&mode=%@&src=%@",[YSLocationManager sharedInstance].coordinate.latitude,[YSLocationManager sharedInstance].coordinate.longitude,toCoordinate.latitude,toCoordinate.longitude,modeBaiDu,@"e生康缘"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] ;
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
}
// 百度地图坐标系转高德地图坐标系
- (CLLocationCoordinate2D)transformGDMapFromBDMapWithLatitute:(CGFloat)latitude longitude:(CGFloat)longitude
{
    CLLocation *location = [[CLLocation alloc] initWithLatitude:latitude longitude:longitude];
    return [location locationMarsFromBaidu].coordinate;
}

//tableview的线补齐
- (void)tableViewLineRepair:(UITableView *)tableView{
    if ([tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [tableView setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}
- (void)loadCellContent:(UITableViewCell *)cell indexPath:(NSIndexPath*)indexPath
{
     @weakify(self);
    //这里把数据设置给Cell
    UnderLineOrderManagerTableViewCell *underOrderCell = (UnderLineOrderManagerTableViewCell *)cell;
    underOrderCell.indexPath = indexPath;
    [underOrderCell configWithObject:self.dataSource[indexPath.row]];
    underOrderCell.payBlock = ^(NSIndexPath *selectIndexPath) {
        @strongify(self);
        [self payOrder:selectIndexPath];
    };
    underOrderCell.commentBlock = ^(NSIndexPath *selectIndexPath) {
        @strongify(self);
        [self commnent:selectIndexPath];
    };
    underOrderCell.goUseBlock = ^(NSIndexPath *selectIndexPath) {
        @strongify(self);
        [self goUseOrder:selectIndexPath];
    };
}

#pragma mark - 处理网络返回
- (void)apiManagerDidSuccess:(APIManager *)manager {
    [NodataShowView hideInContentView:self.tableView];
    if (manager == self.orderLineListManager) {
        if ([self.tableView.mj_header isRefreshing]) {
            [self.tableView.mj_header endRefreshing];
        }
        if ([self.tableView.mj_footer isRefreshing]) {
            [self.tableView.mj_footer endRefreshing];
        }
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        if (manager.successResponse != nil) {
            PersonalGroupOrderAllResponse *response = (PersonalGroupOrderAllResponse *)manager.successResponse;
            NSMutableArray *dicArray = [NSMutableArray array];
            for (NSInteger i = 0; i < response.myselfOrderList.count; i++) {
                NSDictionary *dict = [NSDictionary dictionaryWithDictionary:response.myselfOrderList[i]];
                YSOnlineOrderListDataModel *model = [YSOnlineOrderListDataModel objectWithKeyValues:dict];
                if (self.orderStatus == 100) {
                    //退款临时写死
                    model.orderStatus = @100;
                }
                [dicArray addObject:model];
            }
            
            NSArray *orderArray = [dicArray copy];
            if ([manager.name isEqualToString:@"lowerFresh"]) {
                self.dataSource = [NSMutableArray array];
                
            }
            [self.dataSource addObjectsFromArray:orderArray];
            
            if (orderArray.count > 0) {
                self.pageNumber++;
            }else{
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }
            [self.tableView reloadData];
            if (self.dataSource.count == 0) {
                NodataShowView *showView = [NodataShowView showInContentView:self.tableView withReloadBlock:^{
                    AppDelegate *appDelegate = kAppDelegate;
                    [appDelegate gogogoWithTag:2];
                } requestResultType:NoDataType];
                [showView.alertButton setTitle:@"您还没有相关订单，可以去看看有哪些想买的，随便逛逛" forState:UIControlStateNormal];
            }
        }
    } else if (manager == self.orderCancelManage) {
        [self reloadOrderData];
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    } else if (manager == self.orderPayViewManager) {
        PersonalPayViewResponse *response = (PersonalPayViewResponse *)manager.successResponse;
        GroupOrder *orderView = [GroupOrder objectWithKeyValues:response.order];
        PayOrderViewController *VC = [[PayOrderViewController alloc] initWithNibName:@"PayOrderViewController" bundle:nil];
        VC.orderNumber = orderView.orderId;
        VC.totalPrice = orderView.totalPrice.doubleValue;
        VC.orderID = ((NSDictionary *)response.order)[@"id"];
        VC.jingGangPay = O2OPay;
        [self.navigationController pushViewController:VC animated:YES];
    }
}

- (void)apiManagerDidFail:(APIManager *)manager {
    if ([self.tableView.mj_header isRefreshing]) {
        [self.tableView.mj_header endRefreshing];
    }
    if ([self.tableView.mj_footer isRefreshing]) {
        [self.tableView.mj_footer endRefreshing];
    }
    [NodataShowView showInContentView:self.tableView withReloadBlock:nil requestResultType:NetworkRequestFaildType];
}

//酒店订单列表请求成功
- (void)managerCallBackDidSuccess:(YSAPIBaseManager *)manager {
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    NSDictionary *dictResponseObject = [NSDictionary dictionaryWithDictionary:manager.response.responseObject];
    NSNumber *requstStatus = (NSNumber *)dictResponseObject[@"m_status"];
    if (requstStatus.integerValue > 0) {
        //异常
        [UIAlertView xf_showWithTitle:dictResponseObject[@"m_errorMsg"] message:nil delay:1.2 onDismiss:NULL];
        return;
    }
    
    if (manager == self.hotelOrderListRequstManager) {//酒店订单列表
        if ([self.tableView.mj_header isRefreshing]) {
            [self.tableView.mj_header endRefreshing];
            [self.dataSource removeAllObjects];
        }
        if ([self.tableView.mj_footer isRefreshing]) {
            [self.tableView.mj_footer endRefreshing];
        }
        if (self.pageNumber == 1) {
            [self.tableView.mj_footer resetNoMoreData];
        }
        NSArray *arrayHotelListData = [NSArray arrayWithArray:manager.response.responseObject[@"elongOrderList"]];

        for (NSInteger i = 0; i < arrayHotelListData.count; i++) {
            NSDictionary *dictListData = [NSDictionary dictionaryWithDictionary:[arrayHotelListData xf_safeObjectAtIndex:i]];
            YSHotelOrderListModel *model = [YSHotelOrderListModel objectWithKeyValues:dictListData];
            [self.dataSource xf_safeAddObject:model];
        }
        if (arrayHotelListData.count == 0) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
        [self.tableView reloadData];
        if (self.dataSource.count == 0) {
            NodataShowView *showView = [NodataShowView showInContentView:self.tableView withReloadBlock:^{
                //点击效果在此
            } requestResultType:NoDataType];
            [showView.alertButton setTitle:@"您还没有相关订单，可以去看看有哪些想买的，随便逛逛" forState:UIControlStateNormal];
        }else{
            [NodataShowView hideInContentView:self.tableView];
        }
    }else if (self.hotelOrderDeleteRequstManager == manager){
        //删除成功
        [self.tableView.mj_header beginRefreshing];
    }else if (self.hotelOrderCancelManager == manager){
        //取消成功
        [self.tableView.mj_header beginRefreshing];
    }
}

//酒店订单列表请求失败
- (void)managerCallBackDidFailed:(YSAPIBaseManager *)manager {
    
    //请求报错的时候要把之前的type赋值给tempType值，这样才能再次请求原来的数据
    if ([self.tableView.mj_header isRefreshing]) {
        [self.tableView.mj_header endRefreshing];
    }
    if ([self.tableView.mj_footer isRefreshing]) {
        [self.tableView.mj_footer endRefreshing];
    }
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    [UIAlertView xf_showWithTitle:@"网络错误，请检查网络" message:nil delay:1.2 onDismiss:NULL];
}


- (NSDictionary *)paramsForApi:(YSAPIBaseManager *)manager {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    if (manager == self.hotelOrderListRequstManager) {
        return @{@"pageSize":@10,
                 @"pageNum":@(self.pageNumber)};
    }else if (manager == self.hotelOrderDeleteRequstManager || manager == self.hotelOrderCancelManager){
        return @{@"orderId":self.self.tempHotelListModel.orderId};
    }
    return nil;
}


#pragma mark - event response
- (void)goUseOrder:(NSIndexPath *)indexPath{
    YSOnlineOrderListDataModel *groupOrder = self.dataSource[indexPath.row];
    ShoppingOrderDetailController *VC = [[ShoppingOrderDetailController alloc] initWithStatus:groupOrder.orderStatus.integerValue];
    VC.orderId = groupOrder.id.integerValue;
    VC.comeFromePushType = comeFromOrderListType;
    [self.navigationController pushViewController:VC animated:YES];
}

- (void)payOrder:(NSIndexPath *)indexPath {
    [NodataShowView showLoadingInView:self.tableView];
    YSOnlineOrderListDataModel *model = self.dataSource[indexPath.row];
    self.orderPayViewManager = [[APIManager alloc] initWithDelegate:self];
    [self.orderPayViewManager personalPayView:model.id];
}

- (void)commnent:(NSIndexPath *)indexPath {
    ServiceCommentController *VC = [[ServiceCommentController alloc] initWithNibName:@"ServiceCommentController" bundle:nil];
    YSOnlineOrderListDataModel *model = self.dataSource[indexPath.row];
    VC.api_Id = model.id;
    VC.ggName = model.ggName;
    [self.navigationController pushViewController:VC animated:YES];
}


- (void)showCancelHotelAlert{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"订单已取消" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alert addAction:okAction];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)changeSelectedTtile:(NSInteger)index {
    //状态|10未付款20未使用,30已使用100退款|全部传nil，选择优惠买单与扫码支付传nil，传1000，requst的时候会判断
    if (index == 0) {
        self.orderStatus = 1000;
    } else if (index == 1) {
        self.orderStatus = 10;
    } else if (index == 2) {
        self.orderStatus = 20;
    } else if (index == 3) {
        self.orderStatus = 30;
    } else if (index == 4) {
        self.orderStatus = 100;
    }
    [self reloadOrderData];
}

#pragma mark - private methods
- (void)reloadOrderData {
    self.pageNumber = 1;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.orderLineListManager = [[APIManager alloc] initWithDelegate:self];
    self.orderLineListManager.name = @"lowerFresh";
    [self.tableView.mj_footer resetNoMoreData];
    [self.orderLineListManager getPersonalGroupOrderStatus:self.orderStatus pageSize:10 pageNum:self.pageNumber ordertype:self.orderType];
}

- (void)addOrderData {
    self.orderLineListManager = [[APIManager alloc] initWithDelegate:self];
    self.orderLineListManager.name = @"upperFresh";
    [self.orderLineListManager getPersonalGroupOrderStatus:self.orderStatus pageSize:10 pageNum:self.pageNumber ordertype:self.orderType];
}

#pragma mark - 设置更新订单的操作
- (void)setRefresh {
     @weakify(self);
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        @strongify(self);
        if (self.orderType == 6) {
            //酒店订单列表
            JGLog(@"酒店订单列表下拉刷新");
            
            self.pageNumber = 1;
            [self.hotelOrderListRequstManager requestData];
        }else{
            //非酒店订单列表
            [self reloadOrderData];
        }
    }];
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        @strongify(self);
        if (self.orderType == 6) {
            //酒店订单列表
            JGLog(@"酒店订单列表上拉加载");
            
            self.pageNumber++;
            [self.hotelOrderListRequstManager requestData];
        }else{
            //非酒店订单列表
            [self addOrderData];
        }
    }];
}
- (void)cancelOrderWithHotelListModel:(YSHotelOrderListModel *)hotelListModel{
    
    self.tempHotelListModel = hotelListModel;
    if (self.tempHotelListModel.showStatus == 512) {
        
        if (hotelListModel.isCancelable.boolValue) {
            //已确认等待入住，不扣钱的订单取消
            [self orderMayCancel];
        }else{
            //已确认等待入住，需要扣一定手续费的订单取消
            [self orderNoMayCancel];
        }
    }else if (self.tempHotelListModel.showStatus == 32){
        //酒店拒绝订单的取消订单
        [self hotelRejectOrderCancel];
    }else{//未付款、未入住的取消订单
        @weakify(self);
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"确定要取消订单吗？" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            @strongify(self);
            
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            [self.hotelOrderCancelManager requestData];
        }];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"返回" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:cancelAction];
        [alert addAction:okAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

//酒店拒绝订单的取消订单
- (void)hotelRejectOrderCancel{
    @weakify(self);
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"点击确定后会免费为您取消订单，所支付的金额将会原路退还到您原支付账户中！" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        @strongify(self);
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [self.hotelOrderCancelManager requestData];
    }];
    [alert addAction:okAction];
    [self presentViewController:alert animated:YES completion:nil];
}

//不扣款订单取消(可取消)
- (void)orderMayCancel{
    @weakify(self);
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"亲, 您确定要取消吗？订单取消后，金额会原路退还到您支付账户！" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确认取消" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        @strongify(self);
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [self.hotelOrderCancelManager requestData];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"点错了" style:UIAlertActionStyleCancel handler:nil];
    //修改按钮的颜色   此方法需要只有8.3包括之后的系统才有，所以要加个判断，不然会crash
    NSString *version = [UIDevice currentDevice].systemVersion;
    if (version.floatValue >= 8.3) {
        [okAction setValue:UIColorFromRGB(0x9b9b9b) forKey:@"titleTextColor"];
    }
    [alert addAction:cancelAction];
    [alert addAction:okAction];
    [self presentViewController:alert animated:YES completion:nil];
}

//需要扣一定手续费的订单取消(不可取消)
- (void)orderNoMayCancel{
    @weakify(self);
    NSString *strTotalPrice = [NSString stringWithFormat:@"%.2f元",self.tempHotelListModel.totalPrice];
    NSString *strMessage = [NSString stringWithFormat:@"此订单不可取消, 未如约入住将扣您全额房费%@支付酒店。",strTotalPrice];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:strMessage preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确认取消" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        @strongify(self);
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [self.hotelOrderCancelManager requestData];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"点错了" style:UIAlertActionStyleCancel handler:nil];
    NSString *version = [UIDevice currentDevice].systemVersion;
    if (version.floatValue >= 8.3) {
        //修改message   此方法需要只有8.3包括之后的系统才有，所以要加个判断，不然会crash
        NSMutableAttributedString *alertControllerMessageStr = [[NSMutableAttributedString alloc] initWithString:strMessage];
        [alertControllerMessageStr addAttribute:NSForegroundColorAttributeName value:[YSThemeManager priceColor] range:NSMakeRange(21, strTotalPrice.length)];
        [alert setValue:alertControllerMessageStr forKey:@"attributedMessage"];
        [okAction setValue:UIColorFromRGB(0x9b9b9b) forKey:@"titleTextColor"];
    }
    [alert addAction:cancelAction];
    [alert addAction:okAction];
    [self presentViewController:alert animated:YES completion:nil];
}


- (void)setTitleViewAndTableViewFramWithOrderOrder{
    if (self.orderType == 3 || self.orderType == 2 || self.orderType == 6) {//如果是扫码支付订单、优惠买单订单，，酒店订单不显示顶部选项栏
        self.titleView.height = 0.0;
        self.tableView.frame = CGRectMake(0, 10, kScreenWidth, kScreenHeight - 64 - 10);
        if (self.orderType == 6) {
            self.tableView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64);
        }
    }else{
        [self setViewsMASConstraint];
    }

}

- (void)tableViewInit {
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorColor = [YSThemeManager getTableViewLineColor];
    self.tableView.backgroundColor = self.view.backgroundColor;
    
    UINib *nibCell = [UINib nibWithNibName:cellIdentifier bundle:nil];
    [self.tableView registerNib:nibCell forCellReuseIdentifier:cellIdentifier.copy];
    
    UINib *nibHotelOrderListCell = [UINib nibWithNibName:hotelOrderListCellID bundle:nil];
    [self.tableView registerNib:nibHotelOrderListCell forCellReuseIdentifier:hotelOrderListCellID.copy];
    
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [self.tableView setTableFooterView:view];
}

- (void)setBarButtonItem {
    [self setLeftBarAndBackgroundColor];
}
- (void)setUIContent {
    [self setBarButtonItem];
    [self tableViewInit];
    [self setRefresh];
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
}

- (void)setViewsMASConstraint {
    
    self.titleView.frame = CGRectMake(0, 0, kScreenWidth, 42);
    
    self.tableView.frame = CGRectMake(0, 52, kScreenWidth, kScreenHeight - 64 - 52);
}




#pragma mark - getters and settters

- (void)setOrderStatus:(NSInteger)orderStatus {
    if (orderStatus != _orderStatus) {
        _orderStatus = orderStatus;
    }
}

- (NSMutableArray *)dataSource {
    if (_dataSource == nil) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero];
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.estimatedRowHeight = 450.0f;
    }
    return _tableView;
}

- (TLTitleSelectorView *)titleView {
    if (_titleView == nil) {
        _titleView = [[TLTitleSelectorView alloc] initWithTitles:@"全部",@"待付款",@"待使用",@"待评价",@"退款", nil];
        _titleView.backgroundColor = [UIColor whiteColor];
        _titleView.selectedColor = [YSThemeManager buttonBgColor];
        WEAK_SELF;
        _titleView.buttonPressBlock = ^(NSInteger index) {
            [weak_self changeSelectedTtile:index];
        };
    }
    return _titleView;
}

- (YSHotelOrderListRequstManager *)hotelOrderListRequstManager{
    if (!_hotelOrderListRequstManager) {
        _hotelOrderListRequstManager = [[YSHotelOrderListRequstManager alloc]init];
        _hotelOrderListRequstManager.delegate = self;
        _hotelOrderListRequstManager.paramSource = self;
    }
    return _hotelOrderListRequstManager;
}
- (YSHotelOrderDeleteRequstManager *)hotelOrderDeleteRequstManager{
    if (!_hotelOrderDeleteRequstManager) {
        _hotelOrderDeleteRequstManager = [[YSHotelOrderDeleteRequstManager alloc]init];
        _hotelOrderDeleteRequstManager.delegate = self;
        _hotelOrderDeleteRequstManager.paramSource = self;
    }
    return _hotelOrderDeleteRequstManager;
}
- (YSHotelOrderCancelRequstManager *)hotelOrderCancelManager{
    if (!_hotelOrderCancelManager) {
        _hotelOrderCancelManager = [[YSHotelOrderCancelRequstManager alloc]init];
        _hotelOrderCancelManager.delegate = self;
        _hotelOrderCancelManager.paramSource = self;
    }
    return _hotelOrderCancelManager;
}

- (void)dealloc{

}

@end
