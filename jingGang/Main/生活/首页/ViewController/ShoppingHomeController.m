//
//  ShoppingHomeController.m
//  jingGang
//
//  Created by 张康健 on 15/8/13.
//  Copyright (c) 2015年 yi jiehuang. All rights reserved.
//

#import "ShoppingHomeController.h"
#import "Util.h"
#import "GlobeObject.h"
#import "AppDelegate.h"
#import "PublicInfo.h"
#import "JGNearMainTabelViewCell.h"
#import "RecommendStoreModel.h"
#import "MJRefresh.h"
#import "MJExtension.h"
#import "AdRecommendModel.h"
#import "WSJShopCategoryViewController.h"
#import "WSJKeySearchViewController.h"
#import "WSJMerchantDetailViewController.h"
#import "WSJSelectCityViewController.h"
#import "SelectCityView.h"
#import "JGSelectCityViewButoon.h"
#import "JGPersonalAwayStoreCell.h"
#import "JGPersonalAwayStoreModel.h"
#import "MJRefresh.h"
#import "JGSacnQRCodeNextController.h"
#import "ServiceDetailController.h"
#import "YSLocationManager.h"
#import "YSMyNearBestView.h"
#import "WebDayVC.h"
#import "YSSelecteCityController.h"
#import "YSLoginManager.h"
#import "QRCodeReaderViewController.h"
#import "NSString+Extension.h"
#import "YSSurroundAreaCityInfo.h"
#import "YSTargetTriggerLimitConfig.h"
#import "YSLinkElongHotelWebController.h"
#import "YSActivityController.h"
#import "YSThumbnailManager.h"
#import "YSNearHeaderView.h"
#import "YSNearAdContentDataManager.h"
#import "YSNearAdContentModel.h"
#import "YSNearClassListDataManager.h"
#import "YSNearClassListModel.h"
#import "YSNearAdvertTemplateView.h"
#import "KJGoodsDetailViewController.h"
#import "YSHealthAIOController.h"
#import "JGActivityHelper.h"
#import "AppDelegate+JGActivity.h"
#import "YSConfigAdRequestManager.h"
#import "JGNearTopButtonView.h"
#import "YSLiquorDomainWebController.h"
#import "YSJuanPiWebViewController.h"
#import "YSHealthyMessageDatas.h"
#import "YSLinkCYDoctorWebController.h"
#import "YSAdContentDataManager.h"
#import "YSBaseInfoManager.h"
#import "HongBaoTCViewController.h"

//首页推荐限时推荐
#import "RXFlashSaleView.h"

//服务首页广告推荐位
#define ServiceHomeRecommendCode     @"APP_GROUP_INDEX"
#define kUnLauchLocateServiceKey  201
#define kSwitchCityKey            202

@interface ShoppingHomeController ()<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate,YSNearHeaderViewDelegate,YSAPIManagerParamSource,YSAPICallbackProtocol>

@property (nonatomic,strong) UIScrollView *scrollView;
/**
 *  tableView
 */
@property (nonatomic,strong) UITableView *tableView;
/**
 *  底部tableView
 */
@property (nonatomic,strong) UITableView *tableViewBottom;
/**
 *  滚动图片数组
 */
@property (nonatomic,strong) NSMutableArray *arrayTopScrollImageData;

@property (nonatomic,strong) UICollectionView *collectionView;
/**
 *  纬度
 */
@property (nonatomic,strong) NSNumber *longtitude;
/**
 *  经度
 */
@property (nonatomic,strong) NSNumber *latitude;
/**
 *  城市ID
 */
@property (nonatomic,strong) NSNumber *cityID;
/**
 *  好店推荐数组
 */
@property (nonatomic,strong) NSMutableArray *arrayRecommStoreInfo;
/**
 *  离我最近数组
 */
@property (nonatomic,strong) NSMutableArray *arrayPersonalAwayStore;
/**
 *  顶部单张广告视图
 */
@property (nonatomic,strong)YSMyNearBestView *viewHeaderCommend;
/**
 *  底部单张广告视图
 */
@property (nonatomic,strong)YSMyNearBestView *viewFootCommend;
/**
 *  viewTabelFootView底部
 */
@property (nonatomic,strong) UIView *viewTabelFootView;
/**
 *  离我最近页码
 */
@property (nonatomic,assign) NSInteger personalAwayPageNum;

@property (strong,nonatomic) NSArray *hotCities;

@property (assign, nonatomic) BOOL  getCitiesDataError;

@property (strong,nonatomic) YSNearHeaderView *tableViewHeaderView;

@property (strong,nonatomic) YSNearAdContentDataManager *adContentDataManager;

@property (strong,nonatomic) YSNearClassListDataManager *classListDataManager;

@property (strong,nonatomic) UIImageView *floatImageView;

@property (strong,nonatomic) YSActivitiesInfoItem *actInfoItem;

@property (strong,nonatomic) YSAdContentItem *adContentItem;

/**
 *  是否有分类页 */
@property (assign, nonatomic) BOOL isClassifyPage;


/**
 
 限时推荐界面
 **/
@property(nonatomic,strong)RXFlashSaleView*flashSaleView;


@end


@implementation ShoppingHomeController

- (YSNearAdContentDataManager *)adContentDataManager {
    if (!_adContentDataManager) {
        _adContentDataManager = [[YSNearAdContentDataManager alloc] init];
        _adContentDataManager.delegate = self;
        _adContentDataManager.paramSource = self;
    }
    return _adContentDataManager;
}

- (YSNearClassListDataManager *)classListDataManager {
    if (!_classListDataManager) {
        _classListDataManager = [[YSNearClassListDataManager alloc] init];
        _classListDataManager.delegate = self;
        _classListDataManager.paramSource = self;
    }
    return _classListDataManager;
}

- (void)reloadTableView {
    [self.tableView reloadData];
}

- (CGFloat)near_headerViewHeight {
    CGFloat height = 0;
//    height += 45.; //  搜索高度
    CGFloat scale = 320.0 / 170.0;
    CGFloat cycleViewHeight = ScreenWidth / scale;
    height += cycleViewHeight; // 轮播图高度
    height += [JGNearTopButtonView nearCategoryButtonViewHeight];// 八大分类高度
    if (self.adContentItem.adTotleHeight > 0) {
        height += 12;
    }else {
        height += 6;
    }
    
    height += self.adContentItem.adTotleHeight;
    height += 48; // 好店推荐高度
    NSLog(@"高度为：%f,%f",self.adContentItem.adTotleHeight,height);
    return height;
}

- (YSNearHeaderView *)tableViewHeaderView {
    if (!_tableViewHeaderView) {
        _tableViewHeaderView = [[YSNearHeaderView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth,[self near_headerViewHeight])];
        _tableViewHeaderView.delegate = self;
    }
    return _tableViewHeaderView;
}

- (void)updateHeaderViewFrame {
    if (self.isClassifyPage) {
        // 有分页
        self.tableViewHeaderView.frame = CGRectMake(0, 0, ScreenWidth, [self near_headerViewHeight]);
    }else {
        // 无分页
        self.tableViewHeaderView.frame = CGRectMake(0, 0, ScreenWidth, [self near_headerViewHeight] - 20.);
    }
}

#pragma YSAPICallbackProtocol
- (void)managerCallBackDidSuccess:(YSAPIBaseManager *)manager {
    YSResponseDataReformer *reformer = [[YSResponseDataReformer alloc] init];
    if ([manager isKindOfClass:[YSNearAdContentDataManager class]]) {

    }else if ([manager isKindOfClass:[YSNearClassListDataManager class]]) {
        // 服务分类
        YSNearClassListModel *classListModel = [reformer reformDataWithAPIManager:manager];
        if (!classListModel.groupClassList.count) {
            self.isClassifyPage = NO;
            [self updateHeaderViewFrame];
            [self.tableViewHeaderView updateFrame];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView beginUpdates];
                self.tableView.tableHeaderView = self.tableViewHeaderView;
                self.tableView.tableHeaderView.height = self.tableViewHeaderView.height;
                [self.tableView endUpdates];
                [self reloadTableView];
            });
            return;
        }
        // 根据页码更新frame
        self.tableViewHeaderView.groupClassDatasources = classListModel.groupClassList;
        if ((self.tableViewHeaderView.groupClassDatasources.count - 1) / 8 == 0 ) {
            // 只有一页八个
            self.isClassifyPage = NO;
            [self updateHeaderViewFrame];
            [self.tableViewHeaderView updateFrame];
        }else {
            self.isClassifyPage = YES;
            [self updateHeaderViewFrame];
            [self.tableViewHeaderView updateFrame];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView beginUpdates];
            self.tableView.tableHeaderView = self.tableViewHeaderView;
            self.tableView.tableHeaderView.height = self.tableViewHeaderView.height;
            [self.tableView endUpdates];
            [self reloadTableView];
        });
    }
}

- (void)managerCallBackDidFailed:(YSAPIBaseManager *)manager {

}

- (NSDictionary *)paramsForApi:(YSAPIBaseManager *)manager {
    if ([manager isKindOfClass:[YSNearAdContentDataManager class]]) {
        // 广告模板
        NSNumber *cityId;
        if ([YSSurroundAreaCityInfo isElseCity]) {
            cityId = [YSSurroundAreaCityInfo achieveElseSelectedAreaInfo].areaId;
        }else {
            YSLocationManager *locationManager = [YSLocationManager sharedInstance];
            cityId = locationManager.cityID;
        }
        if (!cityId) {
            cityId = @4524157;
        }
        return @{
                 @"areaId":cityId,
                 @"code":@"APP_NEARER_AD_SF"
                 };
    }else if ([manager isKindOfClass:[YSNearClassListDataManager class]]) {
        // 服务分类
        return @{
                    @"classNum":@1,
                 };
    }
    return @{};
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
    self.view.backgroundColor = JGColor(247, 247, 247, 1);
    UIImageView *floatImageView = [UIImageView new];
    floatImageView.width = 90;
    floatImageView.height = 90;
    floatImageView.x = ScreenWidth - floatImageView.width - 12.;
    if(iPhoneX_X){
        floatImageView.y = ScreenHeight - NavBarHeight * 2 - floatImageView.height - 6-44;
    }else{
        floatImageView.y = ScreenHeight - NavBarHeight * 2 - floatImageView.height - 6;
    }
    floatImageView.userInteractionEnabled = YES;
    floatImageView.contentMode = UIViewContentModeScaleAspectFit;
    @weakify(self);
    [floatImageView addTapActionWithBlock:^(UIGestureRecognizer *gestureRecoginzer) {
        @strongify(self);
        [self enterActivityH5Controller];
    }];
    floatImageView.hidden = YES;
    self.floatImageView = floatImageView;
    [self.view addSubview:self.floatImageView];
    
    //限时推荐界面
    if (self.flashSaleView!=nil) {
        [self.flashSaleView p_dismissView];
        self.flashSaleView=nil;
    }
    self.flashSaleView=[[RXFlashSaleView alloc]init];
    [self.flashSaleView showFlashSaleView:[UIImage imageNamed:@""] with:self with:@selector(showFlashCencelButton)];
}
//限时推荐去其他界面
-(void)showFlashCencelButton;{
    if (self.flashSaleView!=nil) {
        [self.flashSaleView p_dismissView];
        self.flashSaleView=nil;
    }
}

-(void)initPos{
    if ([YSLocationManager locationAvailable]) {
        // 已开启定位功能
        JGLog(@"----%@",[YSLocationManager sharedInstance].cityName);
        
        // 定位城市跟后台开放城市不匹配
        VApiManager *manager = [[VApiManager alloc] init];
        [YSLocationManager beginLocateSuccess:^{ } fail:^{ }];
        @weakify(self);
        [self showHud];
        PersonalAllCityListRequest *listRequest = [[PersonalAllCityListRequest alloc] init:nil];
        [manager personalAllCityList:listRequest success:^(AFHTTPRequestOperation *operation, PersonalAllCityListResponse *response) {
            @strongify(self);
            [self hiddenHud];
            if ([response.errorCode integerValue]) {
                [UIAlertView xf_showWithTitle:response.subMsg message:nil delay:1.4 onDismiss:NULL];
            }else {
                __block BOOL isEqual = NO;
                // 对象类型是否正确
                __block BOOL indexType = YES;
                self.hotCities = response.areaListBos;
                dispatch_queue_t queue = dispatch_queue_create("queue", DISPATCH_QUEUE_CONCURRENT);
                dispatch_group_t group = dispatch_group_create();
                dispatch_group_async(group, queue, ^{//当前
                    [response.areaListBos enumerateObjectsUsingBlock:^(id  _Nonnull objs, NSUInteger idx, BOOL * _Nonnull stop) {
                        if ([objs isKindOfClass:[NSDictionary class]]) {
                            *stop = YES;
                            indexType = NO;
                            return ;
                        }
                        for (NSDictionary *dict in objs) {
                            NSString *city = [dict objectForKey:@"areaName"];
                            NSString *cityId = [NSString stringWithFormat:@"%@",[dict objectForKey:@"id"]];
                            NSString *localCity;
                            NSString *selectedCity = [YSLocationManager sharedInstance].selectedCity;
                            YSSurroundAreaCityInfo *elseSelectedCityInfo = [YSSurroundAreaCityInfo achieveElseSelectedAreaInfo];
                            if (elseSelectedCityInfo) {
                                if (elseSelectedCityInfo.areaId) {
                                    NSString *elseId = [NSString stringWithFormat:@"%@",elseSelectedCityInfo.areaId];
                                    if ([elseId isEqualToString:cityId]) {
                                        isEqual = YES;
                                        *stop = YES;
                                    }
                                }else {
                                    NSString *localId = [NSString stringWithFormat:@"%@",[YSLocationManager sharedInstance].cityID];
                                    if ([localId isEqualToString:cityId]) {
                                        isEqual = YES;
                                        *stop = YES;
                                    }
                                }
                            }
                            //                            JGLog(@"before-enumerateObjects--%@",dict);
                            if (selectedCity) {
                                if ([selectedCity isEmpty]) {
                                    localCity = [YSLocationManager sharedInstance].cityName;
                                }else{
                                    localCity = [YSLocationManager sharedInstance].selectedCity;
                                }
                            }else {
                                localCity = [YSLocationManager sharedInstance].cityName;
                            }
                            if ([city isEqualToString:localCity] || [city containsString:localCity] || [localCity containsString:city]) {
                                // 当前城市为热门开通城市
                                isEqual = YES;
                                *stop = YES;
                            }
                        }
                    }];
                });
                dispatch_group_notify(group, dispatch_get_main_queue(), ^{
                    JGLog(@"end-enumerateObjects--");
                    self.getCitiesDataError = NO;
                    if (!indexType) {
                        self.getCitiesDataError = YES;
                    }else {
                        self.getCitiesDataError = NO;
                    }
                    if (isEqual) {
                        [self loadNearView];
                    }else {
                        if (!indexType) {
                            [UIAlertView xf_showWithTitle:@"获取周边城市数据格式不正确" message:nil delay:1.2 onDismiss:NULL];
                            return ;
                        }else {
                            
                        }
                        
                        YSSelecteCityController *selecteCityController = [[YSSelecteCityController alloc] initWithCities:response.areaListBos selected:^(id obj) {
                            if (![obj isKindOfClass:[NSDictionary class]]) {
                                [UIAlertView xf_showWithTitle:@"数据出错!" message:nil delay:1.4 onDismiss:NULL];
                                return ;
                            }
                            NSString *city = [((NSDictionary *)obj) objectForKey:@"areaName"];
                            NSString *cityIdString = [NSString stringWithFormat:@"%@",[((NSDictionary *)obj) objectForKey:@"id"]];
                            NSNumber *cityID = [NSNumber numberWithInteger:[cityIdString integerValue]];
                            self.selectCityViewButoon.cityName = city;
                            self.selectCityViewButoon.cityID = cityID;
                            //城市变了之后记得要同时修改选择后的城市ID，YSLocationManager 里面的单例ID也要修改，因为后面也需要用到
                            //                            [YSLocationManager sharedInstance].cityID = cityID;
                            YSSurroundAreaCityInfo *elseSelectedCityInfo = [[YSSurroundAreaCityInfo alloc] init];
                            elseSelectedCityInfo.areaId = cityID;
                            elseSelectedCityInfo.areaName = city;
                            [YSSurroundAreaCityInfo saveElseSelectedAreaInfo:elseSelectedCityInfo];
                            [YSLocationManager sharedInstance].selectedCity = city;
                            [self request];
                            JGLog(@"---%@",obj);
                        } showHeaderView:YES];
                        [self.navigationController pushViewController:selecteCityController animated:YES];
                    }
                });
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            @strongify(self);
            [self hiddenHud];
            [self loadNearView];
            [UIAlertView xf_showWithTitle:@"网络错误!" message:nil delay:1.2 onDismiss:NULL];
        }];
    }
//    else {
//        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"定位失败，请重新尝试"
//                                                            message:@"为提供更优质的服务,请去\"设置-隐私\"中开启定位服务"
//                                                           delegate:self
//                                                  cancelButtonTitle:nil
//                                                  otherButtonTitles:@"好的", nil];
//        [alertView show];
//    }
    //    self.navigationController.navigationBar.barTintColor = [YSThemeManager themeColor];
}
- (void)loadNearView {
    [self request];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    [self initPos];
    /**
     *  当定位到当前经纬度时，通知控制前进行反地理编译当前城市 */
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateUserLocationCoordinate) name:kDidUpdateUserLocationKey object:nil];
    [self reqeustconfirmJiankangdouReadCount];
    [self reqeustconfirmYouhuiquanReadCount];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    [JGActivityHelper controllerDidAppear:@"nearm.com" requestStatus:^(YSActivityInfoRequestStatus status) {
        switch (status) {
            case YSActivityInfoRequestIdleStatus:
            {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [JGActivityHelper controllerDidAppear:@"nearm.com" requestStatus:NULL];
                });
            }
                break;
            default:
                break;
        }
    }];;
    @weakify(self);
    [JGActivityHelper controllerFloatImageDidAppear:@"nearm.com" result:^(BOOL ret, UIImage *floatImge, YSActivitiesInfoItem *actInfoItem,YSActivityInfoRequestStatus status) {
        @strongify(self);
        dispatch_async(dispatch_get_main_queue(), ^{
            self.floatImageView.hidden = !ret;
            if (ret) {
                self.actInfoItem = actInfoItem;
                self.floatImageView.image = floatImge;
            }else {
                switch (status) {
                    case YSActivityInfoRequestIdleStatus:
                    {
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            [JGActivityHelper controllerFloatImageDidAppear:@"nearm.com" result:^(BOOL ret, UIImage *floatImge, YSActivitiesInfoItem *actInfoItem, YSActivityInfoRequestStatus status) {
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    self.floatImageView.hidden = !ret;
                                    if (ret) {
                                        self.actInfoItem = actInfoItem;
                                        self.floatImageView.image = floatImge;
                                    }
                                });
                            }];
                        });
                    }
                        break;
                    default:
                        break;
                }
            }
        });
    }];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4. * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        AppDelegate *appDelegate = kAppDelegate;
        [appDelegate loadActivityNeedPop:NO];
    });
    self.navigationController.navigationBar.barTintColor =[UIColor whiteColor];// [YSThemeManager themeColor];
    if ([YSSurroundAreaCityInfo isElseCity]) {
        YSSurroundAreaCityInfo *elseSelectedcity = [YSSurroundAreaCityInfo achieveElseSelectedAreaInfo];
        
        if ([[YSLocationManager sharedInstance].cityID integerValue] == [elseSelectedcity.areaId integerValue]) {
            // 当定位城市与选择城市一致时不做处理
        }else {
            [YSTargetTriggerLimitConfig addTargetArrayTriggerWithIdentifier:@"com.memeber.switchIdentifier" configCount:1 delay:0.8 result:^(BOOL result) {
                if (result) {
                    NSString *noticeTitle = [NSString stringWithFormat:@"系统定位到您在%@,需要切换至%@吗?",[YSLocationManager sharedInstance].cityName,[YSLocationManager sharedInstance].cityName];
                    UIAlertView *switchCityAlertView = [[UIAlertView alloc] initWithTitle:noticeTitle message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                    switchCityAlertView.tag = kSwitchCityKey;
                    [switchCityAlertView show];
                }
            }];
        }
    }
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:YES];
    self.navigationController.navigationBar.barTintColor = [YSThemeManager themeColor];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:YES];
    self.navigationController.navigationBar.barTintColor = [YSThemeManager themeColor];
}

#pragma mark --- UITableViewDataSource
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    if (tableView == self.tableView) {
        if (self.arrayRecommStoreInfo.count < 11) {
            return self.arrayRecommStoreInfo.count;
        }else{
            return 10;
        }
    }else{
        return self.arrayPersonalAwayStore.count;
    }

}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.tableView) {
        return 280;
    }else{
        return 95;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.tableView) {
        static NSString *identifile = @"cell";
        
        JGNearMainTabelViewCell *cell = (JGNearMainTabelViewCell *) [tableView dequeueReusableCellWithIdentifier:identifile];
        
        if (!cell) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"JGNearMainTabelViewCell" owner:self options:nil];
            cell = [nib lastObject];
        }
        if (self.arrayRecommStoreInfo.count > 0) {
            RecommendStoreModel *model = self.arrayRecommStoreInfo[indexPath.row];
            cell.model = model;
        }
        cell.separatorInset = UIEdgeInsetsMake(0,kScreenWidth, 0, 0);
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else{
        static NSString *identifileAway = @"JGPersonalAwayStoreCell";
        
        JGPersonalAwayStoreCell *cellAway = (JGPersonalAwayStoreCell *) [tableView dequeueReusableCellWithIdentifier:identifileAway];
        
        if (!cellAway) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"JGPersonalAwayStoreCell" owner:self options:nil];
            cellAway = [nib lastObject];
        }
        JGPersonalAwayStoreModel *model = self.arrayPersonalAwayStore[indexPath.row];
        cellAway.model = model;
        cellAway.separatorInset = UIEdgeInsetsMake(0,kScreenWidth, 0, 0);
        cellAway.selectionStyle = UITableViewCellSelectionStyleNone;
        return cellAway;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (tableView == self.tableView) {
        //跳转商户详情
        WSJMerchantDetailViewController *goodStoreVC = [[WSJMerchantDetailViewController alloc] init];
        RecommendStoreModel *model = self.arrayRecommStoreInfo[indexPath.row];
        goodStoreVC.api_classId = model.id;
        goodStoreVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:goodStoreVC animated:YES];
    }else{
        //服务详情
        ServiceDetailController *serviceDetailVC = [[ServiceDetailController alloc] init];
        JGPersonalAwayStoreModel *model = self.arrayPersonalAwayStore[indexPath.row];
        serviceDetailVC.serviceID = model.goodsId;
        serviceDetailVC.api_areaId = self.cityID;
        serviceDetailVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:serviceDetailVC animated:YES];
    }
}

#pragma  mark -- Action
- (void)SearchButtonClick
{
    WSJKeySearchViewController *shopSearchVC = [[WSJKeySearchViewController alloc] init];
    shopSearchVC.shopType = searchO2Oype;
    shopSearchVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:shopSearchVC animated:YES];
}
///**
// *  发现更多好店
// */
//- (void)discoverMoreGoodsStore
//{
//    [self moreGoodStoreWith:1];
//}

- (void)moreGoodStoreWith:(YSGroupClassItem *)groupItem datasource:(NSArray *)datas
{
    WSJShopCategoryViewController *shopCategoryVC = [[WSJShopCategoryViewController alloc] initWithNibName:@"WSJShopCategoryViewController" bundle:nil];
    shopCategoryVC.selectedItem = groupItem;
    shopCategoryVC.shopType = O2OType;
    shopCategoryVC.o2oDatas = datas;
    shopCategoryVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:shopCategoryVC animated:YES];
}

- (void)selectCityButtoClick
{
    if (self.getCitiesDataError) {
        return;
    }
    if (self.hotCities.count) {
        @weakify(self);
        YSSelecteCityController *selecteCityController = [[YSSelecteCityController alloc] initWithCities:self.hotCities selected:^(id obj) {
            @strongify(self);
            if (![obj isKindOfClass:[NSDictionary class]]) {
                [UIAlertView xf_showWithTitle:@"数据出错!" message:nil delay:1.4 onDismiss:NULL];
                return ;
            }
            NSString *city = [((NSDictionary *)obj) objectForKey:@"areaName"];
            NSString *cityIdString = [NSString stringWithFormat:@"%@",[((NSDictionary *)obj) objectForKey:@"id"]];
            NSNumber *cityID = [NSNumber numberWithInteger:[cityIdString integerValue]];
            self.selectCityViewButoon.cityName = city;
            self.selectCityViewButoon.cityID = cityID;
            //城市变了之后记得要同时修改选择后的城市ID，YSLocationManager 里面的单例ID也要修改，因为后面也需要用到
//            [YSLocationManager sharedInstance].cityID = cityID;
            YSSurroundAreaCityInfo *elseSelectedCityInfo = [[YSSurroundAreaCityInfo alloc] init];
            elseSelectedCityInfo.areaId = cityID;
            elseSelectedCityInfo.areaName = city;
            [YSSurroundAreaCityInfo saveElseSelectedAreaInfo:elseSelectedCityInfo];
            [YSLocationManager sharedInstance].selectedCity = city;
//            [self request];
            JGLog(@"---%@",obj);
        } showHeaderView:NO];
        selecteCityController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:selecteCityController animated:YES];
    }else {
        [UIAlertView xf_showWithTitle:@"数据错误,请重新再试!" message:nil delay:1.2 onDismiss:NULL];
    }
}

/**
 *  扫描按钮
 */
- (void)scanQRcodeButtonClick {

    
    QRCodeReaderViewController *reader = [[QRCodeReaderViewController alloc]init];
    reader.modalPresentationStyle = UIModalPresentationFormSheet;
    
     @weakify(self);
    [reader setCompletionWithBlock:^(NSString *resultAsString) {
        @strongify(self);
        
        JGSacnQRCodeNextController *sacnQRCodeNextVC = [[JGSacnQRCodeNextController alloc]init];
        if ([resultAsString containsString:@"exclusive"]) {
            //包含此字符串说明是扫描商户端付款码过来的，接着就要判断用户是否登陆，登陆了才能继续下面的操作.
            UNLOGIN_HANDLE
            NSString *uid = [[YSLoginManager userCustomer] objectForKey:@"uid"];
            
            sacnQRCodeNextVC.isScanPay = YES;
            resultAsString = [resultAsString stringByAppendingString:[NSString stringWithFormat:@"&t=2&app=ysysgo&uid=%@",uid]];
    
            sacnQRCodeNextVC.strScanQRCodeUrl = resultAsString;
            
        }else{
            sacnQRCodeNextVC.isScanPay = NO;
            sacnQRCodeNextVC.strScanQRCodeUrl = resultAsString;
        }
        [self.navigationController pushViewController:sacnQRCodeNextVC animated:YES];
    }];
    [self.navigationController pushViewController:reader animated:YES];
    
    
}

#pragma mark - private
- (void)initUI
{
    [self.view addSubview:self.tableView];
    self.navigationItem.rightBarButtonItem = [self rightButton];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.selectCityViewButoon];
    UIButton *searchButton = [UIButton buttonWithType:UIButtonTypeCustom];
    searchButton.frame = CGRectMake(0, 0, kScreenSize.width-70, 35);
    [searchButton setImage:[UIImage imageNamed:@"sousuo_huise"] forState:UIControlStateNormal];
    [searchButton setTitle:@"搜索附近的服务或门店" forState:UIControlStateNormal];
    searchButton.backgroundColor = [UIColor colorWithHexString:@"F4F4F4"];
    searchButton.titleLabel.font = [UIFont systemFontOfSize:13];
    searchButton.layer.cornerRadius = searchButton.height/2;
    searchButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    searchButton.titleEdgeInsets = UIEdgeInsetsMake(0, 6, 0, 0);
    [searchButton setTitleColor:UIColorFromRGB(0x999999) forState:UIControlStateNormal];
    [searchButton addTarget:self action:@selector(SearchButtonClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.titleView = searchButton;
    
   
}

- (void)enterActivityH5Controller {
    YSActivityController *activityH5Controller = [[YSActivityController alloc] init];
    activityH5Controller.activityInfoItem = self.actInfoItem;
    [self.navigationController pushViewController:activityH5Controller animated:YES];
}

#pragma mark 接口调用
- (void)request
{
    // 114.0750533344093 22.53608667000603 4524157
    YSLocationManager *locationManager = [YSLocationManager sharedInstance];
    self.longtitude = [NSNumber numberWithDouble:locationManager.coordinate.longitude];
    self.latitude = [NSNumber numberWithDouble:locationManager.coordinate.latitude];
    //好店推荐
    [self goodStoreRecommendRequest];
    //轮播图片
    [self requestHeaderRecommendData];
    //离我最近
    self.personalAwayPageNum = 1;
    [self requestAwayNearlestMeWithPageNum:self.personalAwayPageNum isNeedRemoveObj:YES];
    @weakify(self)
    [[YSConfigAdRequestManager sharedInstance] requestAdContent:YSAdContentWithNearServiceType cacheItem:^(YSAdContentItem *cacheItem) {
        return ;
        @strongify(self);
        self.adContentItem = cacheItem;
        self.tableViewHeaderView.adContentItem = cacheItem;
        [self updateHeaderViewFrame];
        [self reloadTableView];
    } result:^(YSAdContentItem *adContentItem) {
        @strongify(self);
        if (!adContentItem) {
            self.adContentItem = adContentItem;
            self.tableViewHeaderView.adContentItem = adContentItem;
            [self updateHeaderViewFrame];
            [self reloadTableView];
        }else {
            if ([adContentItem.receiveCode isEqualToString:[[YSConfigAdRequestManager sharedInstance] requestAdContentCodeWithRequestType:YSAdContentWithNearServiceType]]) {
                self.adContentItem = adContentItem;
                self.tableViewHeaderView.adContentItem = adContentItem;
                [self updateHeaderViewFrame];
                [self reloadTableView];
            }
        }
    }];
    [self.classListDataManager requestData];
}

#pragma mark - 请求好店推荐
-(void)goodStoreRecommendRequest {
    PersonalRecommStoreListRequest *request = [[PersonalRecommStoreListRequest alloc] init:GetToken];
    if ([YSSurroundAreaCityInfo isElseCity]) {
        request.api_areaId = [YSSurroundAreaCityInfo achieveElseSelectedAreaInfo].areaId;
    }
    request.api_pageNum = @1;
    request.api_pageSize = @10;
    request.api_storeLat = self.latitude;
    request.api_storeLon = self.longtitude;
    @weakify(self);
    [self.vapiManager personalRecommStoreList:request success:^(AFHTTPRequestOperation *operation, PersonalRecommStoreListResponse *response) {
        @strongify(self);
        [self hiddenHud];
        NSArray *array = [NSArray arrayWithArray:response.recommStoreInfo];
        [self disposeRecommStoreInfoWithArray:array isNeedRemoveObj:YES];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        @strongify(self);
        [self hiddenHud];
        [self.tableView.mj_header endRefreshing];
    }];
}

/**
 *  处理网络接受到的好店推荐详情数据
 */
- (void)disposeRecommStoreInfoWithArray:(NSArray *)array isNeedRemoveObj:(BOOL)isNeedRemoveObj
{
    if (isNeedRemoveObj) {
        [self.arrayRecommStoreInfo removeAllObjects];
    }
    for (NSInteger i = 0; i < array.count; i++) {
        NSDictionary *dicDetailsList = [NSDictionary dictionaryWithDictionary:array[i]];
        
        [self.arrayRecommStoreInfo xf_safeAddObject:[RecommendStoreModel objectWithKeyValues:dicDetailsList]];
    }
    [self.tableView reloadData];
    [self.tableView.mj_header endRefreshing];
}

/**
 *  请求头部滚动轮播图Url
 */
- (void)requestHeaderRecommendData {
    SnsRecommendListRequest *request = [[SnsRecommendListRequest alloc] init:GetToken];
//    request.api_cityId = self.cityID;
    if ([YSSurroundAreaCityInfo isElseCity]) {
        request.api_cityId = [YSSurroundAreaCityInfo achieveElseSelectedAreaInfo].areaId;
    }else {
        YSLocationManager *locationManager = [YSLocationManager sharedInstance];
        request.api_cityId = locationManager.cityID;
    }
    request.api_posCode = ServiceHomeRecommendCode;
    WEAK_SELF
    [self.vapiManager snsRecommendList:request success:^(AFHTTPRequestOperation *operation, SnsRecommendListResponse *response) {
        //头部模型数组
        [weak_self hiddenHud];
        weak_self.arrayTopScrollImageData = [NSMutableArray arrayWithCapacity:response.advList.count];
        //头部图片数组
        NSMutableArray *headImgUrlArr = [NSMutableArray arrayWithCapacity:response.advList.count];
        
        for (NSDictionary *dic in response.advList) {
            //加入时间
            // 创建日期格式化对象
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            //样式
            [formatter setDateStyle:NSDateFormatterMediumStyle];
            [formatter setTimeStyle:NSDateFormatterShortStyle];
            //格式
            [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
            //时区
            NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
            [formatter setTimeZone:timeZone];
            //字符串转时间
            NSDate* begintime = [formatter dateFromString:dic[@"adBeginTime"]];
            NSDate* endtime = [formatter dateFromString:dic[@"adEndTime"]];
            //开始时间戳
            NSTimeInterval begintimes= [ begintime timeIntervalSince1970] * 1000;
            //当前时间戳
            NSTimeInterval nowtimes = [ [NSDate date ] timeIntervalSince1970] * 1000;
            //结束时间戳
            NSTimeInterval endtiiems = [ endtime timeIntervalSince1970] * 1000;
            if (begintimes< nowtimes && nowtimes< endtiiems) {
                [weak_self.arrayTopScrollImageData addObject:[PositionAdvertBO objectWithKeyValues:dic]];
                [headImgUrlArr xf_safeAddObject:[YSThumbnailManager nearbyBannerPicUrlString:dic[@"adImgPath"]]];
            }
        
//            AdRecommendModel *model = [[AdRecommendModel alloc] initWithJSONDic:dic];
            
//            [weak_self.arrayTopScrollImageData addObject:[PositionAdvertBO objectWithKeyValues:dic]];
//            [headImgUrlArr xf_safeAddObject:[YSThumbnailManager nearbyBannerPicUrlString:dic[@"adImgPath"]]];
            
//            [headImgUrlArr xf_safeAddObject:dic[@"adImgPath"]];
        }
        //更换地区要刷新，如果该地区没有推荐的话就要记得清掉
//        weak_self.cycleView.imageURLStringsGroup = (NSArray *)headImgUrlArr;
        weak_self.tableViewHeaderView.imageURLStringsGroup = (NSArray *)headImgUrlArr;
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [weak_self hiddenHud];
    }];
}

#pragma mark - 离我最近
-(void)requestAwayNearlestMeWithPageNum:(NSInteger)pageNum isNeedRemoveObj:(BOOL)isNeedRemoveObj{
    PersonalAwayStoreListRequest *request = [[PersonalAwayStoreListRequest alloc] init:GetToken];
    if ([YSSurroundAreaCityInfo isElseCity]) {
        request.api_areaId = [YSSurroundAreaCityInfo achieveElseSelectedAreaInfo].areaId;
    }
    request.api_pageNum = [NSNumber numberWithInteger:pageNum];
    request.api_pageSize = @10;
    request.api_storeLat = self.latitude;
    request.api_storeLon = self.longtitude;
    @weakify(self);
    [self.vapiManager personalAwayStoreList:request success:^(AFHTTPRequestOperation *operation, PersonalAwayStoreListResponse *response) {
        @strongify(self);
        [self hiddenHud];
        NSArray *array = [NSArray arrayWithArray:response.awayStoreList];
        [self disposeAwayNearlestMeInfoWithArray:array isNeedRemoveObj:isNeedRemoveObj];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        @strongify(self);
        [self hiddenHud];
        [self.tableView.mj_footer endRefreshing];
    }];
}

/**
 *  处理网络接受到的离我最近详情数据
 */
- (void)disposeAwayNearlestMeInfoWithArray:(NSArray *)array isNeedRemoveObj:(BOOL)isNeedRemoveObj
{
    if (isNeedRemoveObj) {
        [self.arrayPersonalAwayStore removeAllObjects];
    }
    for (NSInteger i = 0; i < array.count; i++) {
        NSDictionary *dicDetailsList = [NSDictionary dictionaryWithDictionary:array[i]];
        
        [self.arrayPersonalAwayStore addObject:[JGPersonalAwayStoreModel objectWithKeyValues:dicDetailsList]];
    }
    [self.tableViewBottom reloadData];
    
    //刷新数据后需要把footView和底部tableview高度重新设置一遍
    
    self.viewTabelFootView.height = CGRectGetMaxY(self.viewFootCommend.frame) + 5;
    
    self.tableViewBottom.height = self.tableViewBottom.rowHeight * self.arrayPersonalAwayStore.count;
    self.viewTabelFootView.height = self.viewTabelFootView.height + self.tableViewBottom.height;
    
    CGSize contentSize = self.tableView.contentSize;
    contentSize.height = contentSize.height + self.tableViewBottom.height;
    self.tableView.contentSize = contentSize;
    self.tableView.tableFooterView = self.viewTabelFootView;
    [self hiddenHud];
    [self.tableView.mj_footer endRefreshing];
}

#pragma mark ------getter

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64 - 48)];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.rowHeight = 95.0;
        _tableView.separatorColor = [YSThemeManager getTableViewLineColor];
        _tableView.tableHeaderView = self.tableViewHeaderView;
        _tableView.backgroundColor = JGColor(240, 240, 240, 1);
        //添加上拉加载下拉刷新
        WEAK_SELF
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            weak_self.personalAwayPageNum = 1;
            [weak_self request];
        }];
        _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            weak_self.personalAwayPageNum++;
            [weak_self requestAwayNearlestMeWithPageNum:weak_self.personalAwayPageNum isNeedRemoveObj:NO];
        }];
    }
    return _tableView;
}

- (UITableView *)tableViewBottom
{
    if (!_tableViewBottom) {
        _tableViewBottom = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 68)];
        _tableViewBottom.dataSource = self;
        _tableViewBottom.delegate = self;
        _tableViewBottom.separatorColor = [YSThemeManager getTableViewLineColor];
        _tableViewBottom.rowHeight = 95.0;
        _tableViewBottom.tableFooterView = [[UIView alloc]init];
        _tableViewBottom.scrollEnabled = NO;
    }
    return _tableViewBottom;
}

/**
 *  TabelHeaderView
 */
//- (UIView *)loadTabelHeaderView
//{
//    YSNearHeaderView *tableViewHeaderView = [[YSNearHeaderView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth,[YSNearAdvertTemplateView adverTemplateViewHeight])];
//    tableViewHeaderView.delegate = self;
//    self.tableViewHeaderView = tableViewHeaderView;
//    return tableViewHeaderView;
//}

/**
 *  viewTabelFootView
 */
- (UIView *)viewTabelFootView
{
    if(!_viewTabelFootView){
        UIView *viewTabelFootView = [[UIView alloc]init];
        viewTabelFootView.backgroundColor = kGetColorWithAlpha(240, 240, 240, 1);
        //好店推荐
        self.viewFootCommend = [[YSMyNearBestView alloc]initWithFrame:CGRectMake(0, 5, kScreenWidth, 48)];
        self.viewFootCommend.backgroundColor = [UIColor whiteColor];
        self.viewFootCommend.strTitle = @"离你最近";
        [viewTabelFootView addSubview:self.viewFootCommend];
        self.tableViewBottom.y = CGRectGetMaxY(self.viewFootCommend.frame);
        [viewTabelFootView addSubview:self.tableViewBottom];
        viewTabelFootView.frame = CGRectMake(0, 0, kScreenWidth, self.tableViewBottom.y);
        _viewTabelFootView = viewTabelFootView;
    }
    return _viewTabelFootView;
}

/**
 *  右上角扫码按钮
 */
- (UIBarButtonItem *)rightButton
{
    UIButton *navRightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    navRightButton.frame= CGRectMake(0, 0, 40, 40);
    [navRightButton setImage:[UIImage imageNamed:@"saoyisao_hei"] forState:UIControlStateNormal];
    [navRightButton addTarget:self action:@selector(scanQRcodeButtonClick) forControlEvents:UIControlEventTouchUpInside];
    navRightButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -20);
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:navRightButton];
    return item;
}

/**
 *  好店推荐数组
 */
- (NSMutableArray *)arrayRecommStoreInfo
{
    if (!_arrayRecommStoreInfo) {
        _arrayRecommStoreInfo = [NSMutableArray array];
    }
    return _arrayRecommStoreInfo;
}

/**
 *  离我最近数组
 */
- (NSMutableArray *)arrayPersonalAwayStore
{
    if (!_arrayPersonalAwayStore) {
        _arrayPersonalAwayStore = [NSMutableArray array];
    }
    return _arrayPersonalAwayStore;
}
/**
 *  头部轮播图数组
 */
- (NSMutableArray *)arrayTopScrollImageData
{
    if (!_arrayTopScrollImageData) {
        _arrayTopScrollImageData = [NSMutableArray array];
    }
    return _arrayTopScrollImageData;
}

-(JGSelectCityViewButoon *)selectCityViewButoon {
    if (!_selectCityViewButoon) {
        _selectCityViewButoon = [JGSelectCityViewButoon buttonWithType:UIButtonTypeSystem];
        _selectCityViewButoon.frame = CGRectMake(0, 0, 60, 30);
        NSUserDefaults *userDefauls = [NSUserDefaults standardUserDefaults];
        if (isEmpty([userDefauls objectForKey:kBaseInfoUserCityKey])) {
            _selectCityViewButoon.cityName = @"深圳市";
        }else{
            _selectCityViewButoon.cityName = [userDefauls objectForKey:kBaseInfoUserCityKey];
        }
        [_selectCityViewButoon addTarget:self action:@selector(selectCityButtoClick) forControlEvents:UIControlEventTouchUpInside];
        [_selectCityViewButoon setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    return _selectCityViewButoon;
}

- (UIScrollView *)scrollView
{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        _scrollView.backgroundColor = [UIColor lightGrayColor];
    }
    return _scrollView;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (alertView.tag) {
        case kUnLauchLocateServiceKey:
        {
            AppDelegate *appdelegate = kAppDelegate;
            [appdelegate gogogoWithTag:0];
        }
            break;
        case kSwitchCityKey:
        {
            if (buttonIndex == 1) {
                // 确定切换到定位城市
                if (![YSLocationManager sharedInstance].cityName) {
                    self.selectCityViewButoon.cityName = @"深圳市";
                }else{
                    if (isEmpty([YSLocationManager sharedInstance].cityName)) {
                        self.selectCityViewButoon.cityName = @"深圳市";
                    }else {
                        self.selectCityViewButoon.cityName = [YSLocationManager sharedInstance].cityName;
                    }
                }
                YSSurroundAreaCityInfo *elseSelectedCityInfo = [[YSSurroundAreaCityInfo alloc] init];
                elseSelectedCityInfo.areaId = [YSLocationManager sharedInstance].cityID;
                elseSelectedCityInfo.areaName = self.selectCityViewButoon.cityName;
                [YSSurroundAreaCityInfo saveElseSelectedAreaInfo:elseSelectedCityInfo];
                [YSLocationManager sharedInstance].selectedCity = self.selectCityViewButoon.cityName;
                [self request];
            }
        }
            break;
        default:
            break;
    }
}

#pragma mark -------- YSHeaderViewDelegate

- (void)headerView:(YSNearHeaderView *)nearHeaderView searchButtonClick:(UIButton *)button {
    [self SearchButtonClick];
}

- (void)headerView:(YSNearHeaderView *)nearHeaderView didSelectCycleViewItemAtIndex:(NSInteger)index {
    PositionAdvertBO *model = self.arrayTopScrollImageData[index];
    [YSUMMobClickManager beginLogPageWithKey:[NSString stringWithFormat:@"%@%@%@%@",@"um_",@"Near_",@"Banner_",model.adType]];
    if (model.itemId) {
        NSNumber *detailID = @(model.itemId.integerValue);
        if (model.adType.integerValue == 5) {
            //商户详情
            WSJMerchantDetailViewController *goodStoreVC = [[WSJMerchantDetailViewController alloc] init];
            goodStoreVC.api_classId = detailID;
            goodStoreVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:goodStoreVC animated:YES];
        }else if([model.adType integerValue] == 1){
            //帖子
            YSActivityController *activityController = [[YSActivityController alloc] init];
            activityController.hidesBottomBarWhenPushed = YES;
            activityController.activityUrl = model.itemId;
            activityController.activityTitle = model.adTitle;
            [self.navigationController pushViewController:activityController animated:YES];
        }else if ([model.adType integerValue] == 6){
            //服务详情
            ServiceDetailController *serviceDetailVC = [[ServiceDetailController alloc] init];
            serviceDetailVC.serviceID = detailID;
            serviceDetailVC.hidesBottomBarWhenPushed = YES;
            serviceDetailVC.api_areaId = self.cityID;
            [self.navigationController pushViewController:serviceDetailVC animated:YES];
        }else if ([model.adType isEqualToString:@"4"]) {
            // 资讯
            WebDayVC *weh = [[WebDayVC alloc]init];
            [[NSUserDefaults standardUserDefaults]setObject:model.adTitle  forKey:@"circleTitle"];
            NSString *url = [NSString stringWithFormat:@"%@%@",Base_URL,model.adUrl];
            weh.strUrl = url;
            weh.ind = 1;
            weh.titleStr = model.adTitle;
            weh.hiddenBottomToolView = YES;
            UINavigationController *nas = [[UINavigationController alloc]initWithRootViewController:weh];
            nas.navigationBar.barTintColor = [YSThemeManager themeColor];
            [self.navigationController presentViewController:nas animated:YES completion:nil];
        }
    }
}

- (void)headerView:(YSNearHeaderView *)nearHeaderView didSelecteClassifyItem:(YSGroupClassItem *)item {
    JGLog(@"******* group class item:%@",item);
    if (item.isLogin) {
        BOOL ret = CheckLoginState(YES);
        if (ret) {
            JGLog(@"----已登录");
        }else {
            JGLog(@"----未登录");
            return;
        }
    }
    [YSUMMobClickManager beginLogPageWithKey:[NSString stringWithFormat:@"%@%@%@%ld",@"um_",@"Near_",@"groupClass_",item.gcType]];
    
    if (item.gcType == 10) {
        // url  h5
//        YSActivityController *activityController = [[YSActivityController alloc] init];
//        activityController.hidesBottomBarWhenPushed = YES;
//        activityController.activityUrl = item.url;
//        activityController.activityTitle = item.gcName;
//        [self.navigationController pushViewController:activityController animated:YES];

        NSString *appendUrlString;
        if([item.url rangeOfString:@"?"].location !=NSNotFound)//_roaldSearchText
        {
            appendUrlString = [NSString stringWithFormat:@"%@&cityName=%@",item.url,[YSLocationManager currentCityName]];
        }
        else
        {
            appendUrlString = [NSString stringWithFormat:@"%@?cityName=%@",item.url,[YSLocationManager currentCityName]];
        }
        appendUrlString = [appendUrlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                
        YSLinkElongHotelWebController *elongHotelWebController = [[YSLinkElongHotelWebController alloc] initWithWebUrl:appendUrlString];
        
        elongHotelWebController.hidesBottomBarWhenPushed = YES;
        elongHotelWebController.navTitle = item.gcName;
        [self.navigationController pushViewController:elongHotelWebController animated:YES];
    }else if (item.gcType == 0) {
        // 原生
        [self moreGoodStoreWith:item datasource:self.tableViewHeaderView.groupClassDatasources];
    }
}

#pragma mark ----周边广告模板点击事件处理
- (void)headerView:(YSNearHeaderView *)nearHeaderView clickAdvertItem:(YSNearAdContent *)adItem itemIndex:(NSInteger)index {
    [YSUMMobClickManager beginLogPageWithKey:[NSString stringWithFormat:@"%@%@%@%ld",@"um_",@"Near_",@"adItemIndex_",adItem.type]];
    switch (adItem.type) {
        case 1:
        {
            if ([adItem.link containsString:@"ys.zjtech.cc"]) {
                //是酒业
                YSLiquorDomainWebController *liquorDomainWebVC = [[YSLiquorDomainWebController alloc]initWithUrlType:YSLiquorDomainZoneType];
                liquorDomainWebVC.strUrl = adItem.link;
                [self.navigationController pushViewController:liquorDomainWebVC animated:YES];
            }else if ([adItem.link containsString:@"union.juanpi.com"]){
                //卷皮商品
                YSJuanPiWebViewController *juanPiVC = [[YSJuanPiWebViewController alloc]initWithUrlType:YSGoodsDetileType];
                juanPiVC.goodsID  = [juanPiVC getJuanPiGoodsIdWithJuanPiGoodsUrl:adItem.link];
                juanPiVC.strWebUrl = adItem.link;
                [self.navigationController pushViewController:juanPiVC animated:YES];
            }else{
                //其他链接
                NSString *appendUrlString;
                if([adItem.link rangeOfString:@"?"].location !=NSNotFound)//_roaldSearchText
                {
                    appendUrlString = [NSString stringWithFormat:@"%@&cityName=%@",adItem.link,[YSLocationManager currentCityName]];
                }else{
                    appendUrlString = [NSString stringWithFormat:@"%@?cityName=%@",adItem.link,[YSLocationManager currentCityName]];
                }
                appendUrlString = [appendUrlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                appendUrlString=[appendUrlString stringByReplacingOccurrencesOfString:@"%23"withString:@"#"];
                // 链接
                YSLinkElongHotelWebController *elongHotelWebController = [[YSLinkElongHotelWebController alloc] initWithWebUrl:appendUrlString];
                elongHotelWebController.hidesBottomBarWhenPushed = YES;
                elongHotelWebController.navTitle = adItem.name;
                [self.navigationController pushViewController:elongHotelWebController animated:YES];
            }
        }
            break;
        case 2:
        {
            //  商品
            KJGoodsDetailViewController *goodsDetailVC = [[KJGoodsDetailViewController alloc] init];
            goodsDetailVC.goodsID = [NSNumber numberWithInteger:[adItem.link integerValue]];
            goodsDetailVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:goodsDetailVC animated:YES];
        }
            break;
        case 5:
        {
            // 商户详情
            WSJMerchantDetailViewController *goodStoreVC = [[WSJMerchantDetailViewController alloc] init];
            goodStoreVC.api_classId = [NSNumber numberWithInteger:[adItem.link integerValue]];
            goodStoreVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:goodStoreVC animated:YES];
        }
            break;
        case 6:
        {
            //服务详情
            ServiceDetailController *serviceDetailVC = [[ServiceDetailController alloc] init];
            serviceDetailVC.serviceID = [NSNumber numberWithInteger:[adItem.link integerValue]];
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
            if ([adItem.link isEqualToString:YSAdvertOriginalTypeAIO]) {
                YSHealthAIOController *healthAIOController = [[YSHealthAIOController alloc] init];
                healthAIOController.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:healthAIOController animated:YES];
            }else if ([adItem.link isEqualToString:YSAdvertOriginalTypeCYDoctor]) {
                // 春雨医生
                [self showHud];
                @weakify(self);
                @weakify(adItem);
                [YSHealthyMessageDatas  chunYuDoctorUrlRequestWithResult:^(BOOL ret, NSString *msg) {
                    @strongify(self);
                    @strongify(adItem);
                    [self hiddenHud];
                    if (ret) {
                        YSLinkCYDoctorWebController *cyDoctorController = [[YSLinkCYDoctorWebController alloc] initWithWebUrl:msg];
                        cyDoctorController.navTitle = adItem.name;
                        cyDoctorController.tag = 100;
                        cyDoctorController.controllerPushType = YSControllerPushFromHealthyManagerType;
                        [self.navigationController pushViewController:cyDoctorController animated:YES];
                    }else {
                        [UIAlertView xf_showWithTitle:msg message:nil delay:2.0 onDismiss:NULL];
                    }
                }];
            }
        }
            break;
        default:
            break;
    }
}
// 成功定位到当前城市
- (void)locateSucceedWithCity:(NSString *)city {
    [YSBaseInfoManager storageCity:city];
}

// 失败定位，默认为深圳
- (void)locateFail {
}

- (void)updateUserLocationCoordinate {
    @weakify(self);
    [YSLocationManager  reverseGeoResult:^(NSString *city) {
         @strongify(self);
         [self locateSucceedWithCity:city];
        NSLog(@"城市：",city);
     }
     fail:^{
         @strongify(self);
         [self locateFail];
     }
     addressComponentCallback:^(BMKAddressComponent *componet) {
         
     }
     callbackType:YSLocationCallbackCityType];
}

- (void)dealloc
{
    [kNotification removeObserver:self];
}

-(void)reqeustconfirmJiankangdouReadCount {
    if (GetToken) {
        VApiManager *manager = [[VApiManager alloc] init];
        ConfirmJiankangdouRequest *request = [[ConfirmJiankangdouRequest alloc]init:GetToken];
        @weakify(self);
        
        
        [manager ConfirmJiankangdou:request success:^(AFHTTPRequestOperation *operation, ConfirmJiankangdouResponse *response) {
            
            @strongify(self);
            if([response.show intValue] ==1){
                
                HongBaoTCViewController * hongbao  = [[HongBaoTCViewController alloc] init];
                hongbao.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
                hongbao.titleLabel.text = [NSString stringWithFormat:@"%@元健康豆已放至账户",response.num];
                hongbao.contentLabel.text = @"邀请用户下单奖励";
                hongbao.lable.text = @"健康豆专享";
                hongbao.isJK = YES;
                hongbao.nav = self.navigationController;
                hongbao.totalLabel.text = [NSString stringWithFormat:@"¥%@",response.money];
                hongbao.modalPresentationStyle = UIModalPresentationCustom;
                
                self.modalPresentationStyle = UIModalPresentationCustom;
                [self presentViewController:hongbao animated:YES completion:^{
                    
                    
                }];
                
            }
            
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
        }];
        
    }
}


-(void)reqeustconfirmYouhuiquanReadCount {
    if (GetToken) {
        VApiManager *manager = [[VApiManager alloc] init];
        confirmYouhuiquanRequest *request = [[confirmYouhuiquanRequest alloc]init:GetToken];
        @weakify(self);
        
        [manager confirmYouhuiquan:request success:^(AFHTTPRequestOperation *operation, ConfirmJiankangdouResponse *response) {
            
            @strongify(self);
            if([response.show intValue] ==1){
                HongBaoTCViewController * hongbao  = [[HongBaoTCViewController alloc] init];
                hongbao.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
                hongbao.titleLabel.text = [NSString stringWithFormat:@"%@张优惠券已放至账户",response.num];
                hongbao.nav = self.navigationController;
                hongbao.contentLabel.text = @"优惠券限时，快去使用吧!";
                hongbao.lable.text = @"专享优惠券";
                hongbao.totalLabel.text = [NSString stringWithFormat:@"¥%@",response.money];
                hongbao.modalPresentationStyle = UIModalPresentationCustom;
                
                self.modalPresentationStyle = UIModalPresentationCustom;
                [self presentViewController:hongbao animated:YES completion:^{
                    
                    
                }];
                
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
        }];
        
    }
}

@end
