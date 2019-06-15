//
//  NoticeController.m
//  Operator_JingGang
//
//  Created by dengxf on 15/10/27.
//  Copyright © 2015年 XKJH. All rights reserved.
//

#import "NoticeController.h"
#import "NoticeCell.h"
#import "MerchantPosterDetailVC.h"
#import "GlobeObject.h"
#import "PublicInfo.h"
#import "MJRefresh.h"
#import "NSObject+MJExtension.h"
#import "Util.h"
#import "YSLinkCYDoctorWebController.h"
#import "ShoppingOrderDetailController.h"
#import "YSCloudMoneyDetailController.h"
#import "YSJPushHelper.h"
#import "YSUserMessageReadAllRequstManager.h"
#import "YSNoticeCenterNoDataView.h"
#import "YSLocationManager.h"
#import "KJGoodsDetailViewController.h"
#import "YSLinkElongHotelWebController.h"
#import "WSJMerchantDetailViewController.h"
#import "ServiceDetailController.h"
#import "YSHealthAIOController.h"
#import "YSSurroundAreaCityInfo.h"
#import "YSNearAdContentModel.h"
#import "WSJManagerAddressViewController.h"
@interface NoticeController ()<UITableViewDelegate,UITableViewDataSource,YSAPICallbackProtocol,YSAPIManagerParamSource>

@property (strong,nonatomic) UITableView *tableView;

@property (assign, nonatomic) NSInteger requestPageNumber;
/**
 *   数据源 -- */
@property (strong,nonatomic) NSMutableArray *dataArray;
@property (nonatomic,strong) YSUserMessageReadAllRequstManager *userMessageReadAllRequstManger;
@property (nonatomic,strong) YSNoticeCenterNoDataView *noDataView;
@property (nonatomic,strong) UIButton *buttonRightNav;
@end

@implementation NoticeController
#pragma mark --- 懒加载
//公告页面
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.separatorStyle = UITableViewCellSelectionStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [[UIView alloc] init];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.estimatedRowHeight = 450.0f;
        @weakify(self);
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            @strongify(self);
            //下拉刷新
            self.requestPageNumber = 1;
            [self _requestPostData];
        }];
        
        _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            @strongify(self);
            self.requestPageNumber++;
            JGLog(@"%ld",self.requestPageNumber);
            [self _requestPostData];
        }];
        [self.view addSubview:_tableView];
    }
    return _tableView;
}
- (YSUserMessageReadAllRequstManager *)userMessageReadAllRequstManger{
    if (!_userMessageReadAllRequstManger) {
        _userMessageReadAllRequstManger = [[YSUserMessageReadAllRequstManager alloc]init];
        _userMessageReadAllRequstManger.delegate = self;
        _userMessageReadAllRequstManger.paramSource = self;
    }
    return _userMessageReadAllRequstManger;
}
- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
- (YSNoticeCenterNoDataView *)noDataView{
    if (!_noDataView) {
        _noDataView = [[YSNoticeCenterNoDataView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - NavBarHeight)];
        _noDataView.hidden = YES;
        [self.view addSubview:_noDataView];
    }
    return _noDataView;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // 初始化页面
    [self setupContent];
}

/**
 *  初始化页面、数据--
 */
- (void)setupContent {
    self.view.backgroundColor = UIColorFromRGB(0xf7f7f7);
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem initJingGangBackItemWihtAction:@selector(btnClick) target:self];
    if ([self respondsToSelector:@selector(automaticallyAdjustsScrollViewInsets)]) {
        self.automaticallyAdjustsScrollViewInsets = YES;
    }
    [YSThemeManager setNavigationTitle:@"消息" andViewController:self];
    self.navigationController.navigationBar.translucent = NO;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.tableView.x = 0;
    self.tableView.y = 0;
    self.tableView.width = ScreenWidth;
    self.tableView.height = ScreenHeight - NavBarHeight;
    self.requestPageNumber = 1;
    [self _requestPostData];
    self.navigationItem.rightBarButtonItem = [self rightButtonCustomView];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [YSUMMobClickManager beginLogPageWithKey:[NSString stringWithFormat:@"%@%@",@"um_",NSStringFromClass([self class])]];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [YSUMMobClickManager endLogPageWithKey:[NSString stringWithFormat:@"%@%@",@"um_",NSStringFromClass([self class])]];
}

#pragma mark - 请求数据
-(void)_requestPostData {
    VApiManager *manager = [[VApiManager alloc] init];
    UserMessageListRequest *request = [[UserMessageListRequest alloc]init:GetToken];
    request.api_type = @"1";
    request.api_pageNum = [NSNumber numberWithInteger:self.requestPageNumber];
    request.api_pageSize = @10;
     @weakify(self);
    [manager userMessageList:request success:^(AFHTTPRequestOperation *operation, UserMessageListResponse *response) {
         @strongify(self);
        [self _dealTableFreshUI];
        NSArray *arrayData = [APIMessageBO JGObjectArrWihtKeyValuesArr:response.messages];
        for (NSInteger i = 0; i < arrayData.count; i++) {
            APIMessageBO *model = [arrayData xf_safeObjectAtIndex:i];
            NSString *strContent = [model.digest filterHTML:model.digest];
            [model setValue:strContent forKey:@"digest"];
        }
        [self _dealWithTableFreshData:arrayData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [UIAlertView xf_showWithTitle:@"提示" message:error.domain onDismiss:NULL];
    }];
}


#pragma mark - 处理表刷新UI
-(void)_dealTableFreshUI{
    if (_requestPageNumber == 1) {//下拉或自动刷新
        [_tableView.mj_header endRefreshing];
        [self.tableView.mj_footer resetNoMoreData];
    }else{
        [_tableView.mj_footer endRefreshing];
    }
}

#pragma mark - 处理表刷新数据
-(void)_dealWithTableFreshData:(NSArray *)array {
    if (array.count > 0) {
        if (_requestPageNumber == 1) {//下拉或自动刷新
            [self.dataArray removeAllObjects];
            [self.dataArray xf_safeAddObjectsFromArray:array];
        }else{//上拉刷新
            [self.dataArray xf_safeAddObjectsFromArray:array];
        }
        [self.tableView reloadData];
    }else {
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
    }
    if (self.dataArray.count == 0) {
        //没数据
        self.tableView.hidden = YES;
        self.noDataView.hidden = NO;
        self.buttonRightNav.hidden = YES;
    }else{
        //有数据
        self.tableView.hidden = NO;
        self.buttonRightNav.hidden = NO;
        self.noDataView.hidden = YES;
    }
}

#pragma mark  --- TableViewDelegate --
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellId = @"NoticeCell";
    NoticeCell *cell   = [tableView dequeueReusableCellWithIdentifier:CellId];
    if (!cell) {
        cell = [[NoticeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellId];
    }
    cell.apiMessageBO = [self.dataArray xf_safeObjectAtIndex:indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [self getTableViewHeightWithIndexPath:indexPath];
}

- (CGFloat)getTableViewHeightWithIndexPath:(NSIndexPath *)indexPath{
    APIMessageBO *apiMessageBO = [self.dataArray xf_safeObjectAtIndex:indexPath.row];
    CGFloat rowHeight = 167.0;
    if (!IsEmpty(apiMessageBO.thumbnail)) {
        rowHeight = rowHeight + [YSAdaptiveFrameConfig width:130];
        
    }
    if (![self checkNoticeContentIsNeedLineFeelWithString:apiMessageBO.content]) {
        rowHeight = rowHeight - 14;
    }
    return rowHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    APIMessageBO *model = [self.dataArray xf_safeObjectAtIndex:indexPath.row];
    
    if (model.pageType.integerValue == 7 && [[model.linkUrl substringToIndex:3] isEqualToString:@"zbs"] && model.receiveType.integerValue == 4) {
        //如果是争霸赛活动点击列表，暂时先不设置已读状态，设置地址成功后再设置已读状态
    }else{
         [self setNoticeReadDoneStatusWith:model indexPath:indexPath];
    }
    
    if (model.receiveType.integerValue == 4) {//广告位使用pageType字段判断跳转
        [self didSelectTableViewCellAdvertTypeWithModel:model indexPath:indexPath];
    }else{//原先消息列表type字段判断跳转
        [self didSelectTableViewCelNoticeAgoWithModel:model];
    }
}
//原先的消息列表点击区分type
- (void)didSelectTableViewCelNoticeAgoWithModel:(APIMessageBO *)model{
    NSInteger noticeState = [model.status integerValue];
    switch ([model.type integerValue]) {
        case 3:
        {
            // 春雨医生 title是春雨医生链接
            YSLinkCYDoctorWebController *chunYuDoctorController = [[YSLinkCYDoctorWebController alloc] initWithWebUrl:model.title];
            chunYuDoctorController.controllerPushType = YSControllerPushFromNoticeListType;
            chunYuDoctorController.postId = model.apiId;
            [self.navigationController pushViewController:chunYuDoctorController animated:YES];
        }
            break;
        case 10:
        {
            // 健康豆明细
            YSCloudMoneyDetailController *cloudMoneyDetailController = [[YSCloudMoneyDetailController alloc] init];
            if (!noticeState) {
                [self clearNoticeWithPostId:model.apiId];
            }
            [self.navigationController pushViewController:cloudMoneyDetailController animated:YES];
        }
            break;
        case 20:
        {
            // 服务订单详情 title是服务订单id
            ShoppingOrderDetailController *serviceOrderVC = [[ShoppingOrderDetailController alloc] init];
            serviceOrderVC.orderId = [model.title longLongValue];
            serviceOrderVC.comeFromePushType = comeFromOrderListType;
            if (noticeState) {
                // 已读状态不做处理
            }else {
                serviceOrderVC.showRefundRefuseAlert = YES;
                serviceOrderVC.refuseReasonString = [NSString stringWithFormat:@"%@",model.content];
            }
            [self.navigationController pushViewController:serviceOrderVC animated:YES];
        }
            break;
        default:
        {
            // 站内消息。文本、富文本
            MerchantPosterDetailVC *noticeDetailController = [[MerchantPosterDetailVC alloc] init];
            noticeDetailController.posterID = model.apiId;
            [self.navigationController pushViewController:noticeDetailController animated:YES];
        }
            break;
    }
}

//广告位的type跳转
- (void)didSelectTableViewCellAdvertTypeWithModel:(APIMessageBO *)model indexPath:(NSIndexPath * )indexPath{

    switch ([model.pageType integerValue]) {
        case 1:
        {
            // 链接
            NSString *appendUrlString;
            if([model.linkUrl rangeOfString:@"?"].location !=NSNotFound)//_roaldSearchText
            {
                appendUrlString = [NSString stringWithFormat:@"%@&cityName=%@",model.linkUrl,[YSLocationManager currentCityName]];
            }else{
                appendUrlString = [NSString stringWithFormat:@"%@?cityName=%@",model.linkUrl,[YSLocationManager currentCityName]];
            }
            appendUrlString = [appendUrlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            YSLinkElongHotelWebController *elongHotelWebController = [[YSLinkElongHotelWebController alloc] initWithWebUrl:appendUrlString];
            elongHotelWebController.hidesBottomBarWhenPushed = YES;
            elongHotelWebController.navTitle = model.title;
            [self.navigationController pushViewController:elongHotelWebController animated:YES];
            
        }
            break;
        case 2:
        {
            // 商品详情
            KJGoodsDetailViewController *goodsDetailVC = [[KJGoodsDetailViewController alloc] init];
            goodsDetailVC.goodsID = [NSNumber numberWithInteger:[model.linkUrl integerValue]];
            goodsDetailVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:goodsDetailVC animated:YES];
        }
            break;
        case 5:
        {
            // 商户详情
            WSJMerchantDetailViewController *goodStoreVC = [[WSJMerchantDetailViewController alloc] init];
            goodStoreVC.api_classId = [NSNumber numberWithInteger:[model.linkUrl integerValue]];
            goodStoreVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:goodStoreVC animated:YES];
        }
            break;
        case 6:
        {
            //服务详情
            ServiceDetailController *serviceDetailVC = [[ServiceDetailController alloc] init];
            serviceDetailVC.serviceID = [NSNumber numberWithInteger:[model.linkUrl integerValue]];
            serviceDetailVC.hidesBottomBarWhenPushed = YES;
            if ([YSSurroundAreaCityInfo isElseCity]) {
                serviceDetailVC.api_areaId = [YSSurroundAreaCityInfo achieveElseSelectedAreaInfo].areaId;
            }else {
                YSLocationManager *locationManager = [YSLocationManager sharedInstance];
                serviceDetailVC.api_areaId = locationManager.cityID;
            }
            [self.navigationController pushViewController:serviceDetailVC animated:YES];
        }
            break;
        case 7:
        {
            // 原生类别区分 link
            if ([model.linkUrl isEqualToString:YSAdvertOriginalTypeAIO]) {
                YSHealthAIOController *healthAIOController = [[YSHealthAIOController alloc] init];
                healthAIOController.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:healthAIOController animated:YES];
            }else if ([[model.linkUrl substringToIndex:3] isEqualToString:@"zbs"]){
                if (model.status.integerValue == 1) {//已读就要提示已经设置过地址
                    [UIAlertView xf_showWithTitle:@"您已经提交过地址信息，我们将尽快发货！" message:nil delay:2.0 onDismiss:NULL];
                }else{//未读才能点击去设置地址
                    WSJManagerAddressViewController *managerAddressVC = [[WSJManagerAddressViewController alloc]init];
                    managerAddressVC.type = noticeCenter;
                    managerAddressVC.linkUrl = model.linkUrl;
                    @weakify(self);
                    managerAddressVC.setZbsAddressSucceed = ^(NSIndexPath *setZbsAddressIndexPath) {
                        @strongify(self);
                        [self setNoticeReadDoneStatusWith:model indexPath:indexPath];
                    };
                    [self.navigationController pushViewController:managerAddressVC animated:YES];
                }
                
            }
        }
            break;
        default:
            break;
    }
}
- (void)setNoticeReadDoneStatusWith:(APIMessageBO *)model indexPath:(NSIndexPath *)indexPath{
    NSInteger noticeState = [model.status integerValue];
    if (!noticeState) {
        // 如果是未读消息，将状态设置为已读，不用重新请求 刷新列表 影响体验
        [model setValue:@1 forKey:@"status"];
        [self.dataArray xf_safeReplaceObjectAtIndex:indexPath.row withObject:model];
        NSIndexPath *reloadIndexPath = [NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section];
        NSArray *reloadIndexPaths = @[reloadIndexPath];
        [self.tableView reloadRowsAtIndexPaths:reloadIndexPaths withRowAnimation:UITableViewRowAnimationFade];
    }
    [self clearNoticeWithPostId:model.apiId];
}

#pragma mark --- 消除点击的相应站内消息
- (void)clearNoticeWithPostId:(NSNumber *)postId {
    [YSJPushHelper dealClickJPushWithQuestionId:postId];
}
- (void)cleanNoticeButtonClick{
    NSString *strNoticeMsg = @"标记所有消息为已读?";
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:strNoticeMsg preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.userMessageReadAllRequstManger requestData];
    }];
    [alert addAction:cancelAction];
    [alert addAction:okAction];
    
    NSString *version = [UIDevice currentDevice].systemVersion;
    if (version.floatValue >= 8.3){
        //修改message
        NSMutableAttributedString *alertControllerMessageStr = [[NSMutableAttributedString alloc] initWithString:strNoticeMsg];
        [alertControllerMessageStr addAttribute:NSForegroundColorAttributeName value
                                               :UIColorFromRGB(0x4a4a4a) range:NSMakeRange(0, strNoticeMsg.length)];
        [alertControllerMessageStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16] range:NSMakeRange(0, strNoticeMsg.length)];
        [alert setValue:alertControllerMessageStr forKey:@"attributedMessage"];
    }
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark --- 请求返回
- (void)managerCallBackDidSuccess:(YSAPIBaseManager *)manager{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    NSDictionary *dictResponseObject = [NSDictionary dictionaryWithDictionary:manager.response.responseObject];
    NSNumber *requstStatus = (NSNumber *)dictResponseObject[@"m_status"];
    if (requstStatus.integerValue > 0) {
        //异常
        [UIAlertView xf_showWithTitle:dictResponseObject[@"m_errorMsg"] message:nil delay:1.2 onDismiss:NULL];
        return;
    }
    [self setAllDataReadStatus];
    
}
#pragma mark --- 请求报错返回
- (void)managerCallBackDidFailed:(YSAPIBaseManager *)manager{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    [UIAlertView xf_showWithTitle:@"网络错误，请检查网络" message:nil delay:1.2 onDismiss:NULL];
}
#pragma mark --- 请求参数
- (NSDictionary *)paramsForApi:(YSAPIBaseManager *)manager{
    return @{};
}
//设置本地数组所有消息数据为已读
- (void)setAllDataReadStatus{
    for (NSInteger i = 0; i < self.dataArray.count; i++) {
        APIMessageBO *model = [self.dataArray xf_safeObjectAtIndex:i];
        [model setValue:@1 forKey:@"status"];
    }
    [self.tableView reloadData];
}

- (BOOL)checkNoticeContentIsNeedLineFeelWithString:(NSString *)strContent{
//    kScreenWidth - 12 -12 - 10 -10
    CGSize sizeStr = [strContent sizeWithFont:[UIFont systemFontOfSize:12] maxW:(kScreenWidth - 44)];
    if (sizeStr.height > 15) {
        //需要换行
        return YES;
    }else{
        //不需要换行
        return NO;
    }
    return YES;
}

//右上角按钮
- (UIBarButtonItem *)rightButtonCustomView
{
    UIView *rightBarView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 86, 31)];
    UIButton *buttonCleanNotice = [UIButton buttonWithType:UIButtonTypeCustom];
    [buttonCleanNotice setFrame: CGRectMake(0, 0, 86, 31)];
    [buttonCleanNotice setTitle:@"标记已读" forState:UIControlStateNormal];
    buttonCleanNotice.titleLabel.font = [UIFont systemFontOfSize:14.0];
    [buttonCleanNotice addTarget:self action:@selector(cleanNoticeButtonClick)forControlEvents:UIControlEventTouchDown];
    [rightBarView addSubview:buttonCleanNotice];
    rightBarView.backgroundColor=[UIColor clearColor];
    self.buttonRightNav = buttonCleanNotice;
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc]initWithCustomView:rightBarView];
    return rightBtn;
}

@end
