//
//  RXMainViewController.m
//  jingGang
//
//  Created by 荣旭 on 2019/6/16.
//  Copyright © 2019年 dengxf_dev. All rights reserved.
//

#import "RXMainViewController.h"
#import "YSBaseInfoView.h"
//选择控件
#import "YUFoldingTableView.h"
#import "RXYuHeadView.h"
#import "RXTravelTableViewCell.h"

//今日任务
#import "YSHealthyTaskView.h"
#import "YSConfigAdRequestManager.h"
#import "DefuController.h"
#import "JGActivityDetailController.h"
#import "JGActivityCommonController.h"
#import "JGActivityWebController.h"
#import "JGActivityHelper.h"
#import "YSHealthManageHeaderView.h"
#import "HealthyManageData.h"
#import "YSConstitutionPromoteCell.h"
#import "YSHealthyTaskView.h"
#import "YSHealthyTaskCell.h"
#import "YSHealthyStepCell.h"
#import "YSFriendCircleCell.h"
#import "YSFriendCircleFrame.h"
#import "YSLocationManager.h"
#import "YSHealthyMessageController.h"
#import "YSHealthyManageFootView.h"
#import "YSHealthyHelperController.h"
#import "YSStepManager.h"
#import "YSHealthySelfTestController.h"
#import "YSWeatherManager.h"
#import "YSBaseInfoManager.h"
#import "YSHealthyManageWebController.h"
#import "YSHealthyManageAddTaskWebController.h"
#import "JGMessageCenterController.h"
#import "YSFriendCircleModel.h"
#import "YSFriendCircleRequestManager.h"
#import "YSFriendCircleController.h"
#import "YSCirclePersonalInfoView.h"
#import "NoticeController.h"
#import "YSShareManager.h"
#import "YSGoMissionController.h"
#import "YSFriendCircleDetailController.h"
#import "YSMaskGuideController.h"
#import "YSLoginManager.h"
#import "AppDelegate+JGActivity.h"
#import "YSLoginPopManager.h"
#import "YSActivityController.h"
#import "YSHealthyConsultCell.h"
#import "YSLinkCYDoctorWebController.h"
#import "AdRecommendModel.h"
#import "YSNearAdContentDataManager.h"
#import "YSNearAdContentModel.h"
#import "WSJMerchantDetailViewController.h"
#import "YSLinkElongHotelWebController.h"
#import "ServiceDetailController.h"
#import "YSSurroundAreaCityInfo.h"
#import "KJGoodsDetailViewController.h"
#import "YSHealthAIOController.h"
#import "YSConfigAdRequestManager.h"
#import "YSLiquorDomainWebController.h"
#import "YSJuanPiWebViewController.h"
#import "YSNearAdContentModel.h"
#import "YSHealthTaskTableViewCell.h"
#import "YSJijfenrenwTableVIewCell.h"
#import "YSGoMissionModel.h"
#import "YSjifenduihuanView.h"
#import "YSRiskLuckController.h"
#import "YSGestureNavigationController.h"
#import "YSMyHealthMissonController.h"
#import "MyErWeiMaController.h"
#import "TZImagePickerController.h"
#import "YSComposeStatusController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>
#import "TZVideoPlayerController.h"
#import "TZImageManager.h"
#import "IntegralNewHomeController.h"
#import "JGIntegralCommendGoodsModel.h"
#import "IntegralGoodsDetailController.h"

#import "YSLinkCYDoctorWebController.h"


//默认首页默认显示数据
#import "YSConTableViewCell.h"
//商品推荐
#import "YSGoodsTableViewCell.h"
//质询问题
#import "YSHotInfoTableViewCell.h"
//新健康咨询
#import "RXHealthyTableViewCell.h"
#import "YSHealthyInformationVIew.h"

//广告位
#import "RXAdvertisingTableViewCell.h"
#import "RXShoppingTableViewCell.h"

//个人信息
#import "RXUserInfoVIew.h"
//运动
#import "RXMotionTableViewCell.h"
//血压
#import "RXBloodPressureTableViewCell.h"

//动态改变tabviewcell
#import "RXTabViewHeightObjject.h"
#import "Unit.h"
//智能输入
#import "RXZhangKaiTableViewCell.h"

#import "UILabel+extension.h"

//显示更多
#import "RXMoreDetectionViewController.h"
//续费界面
#import "RXbutlerServiceViewController.h"

//领取会员
#import "RXFreeCollectionView.h"

#import "BloodPressureTestVC.h"

#import "YSMultipleTypesTestController.h"

static NSString *goodsCellID = @"goodsCellID";
static NSString *heathInfoCellID = @"heathInfoCellID";
//默认有12个分组，根据数据添加,
#define headIndex 8

@interface RXMainViewController ()<YSAPIManagerParamSource,YSAPICallbackProtocol,YSHealthManageHeaderViewDelegate,UICollectionViewDelegate,TZImagePickerControllerDelegate,UITableViewDelegate,UITableViewDataSource>

@property(strong,nonatomic)UITableView*mtableview;
@property (strong,nonatomic) NSMutableDictionary *stepUserInfo;

//头部
@property(nonatomic,strong)RXUserInfoVIew*rxBaseInfoView;
//领取会员
@property(nonatomic,strong)RXFreeCollectionView*freeCollectionView;
//默认测试数据
@property(nonatomic,strong)NSArray*titleArray;
@property(nonatomic,strong)NSArray*iconArray;

@property(nonatomic,strong)RXUserDetailResponse*response;

@property(nonatomic,strong)RXParamDetailResponse*paramResponse;

/***广告位数据***/
@property(nonatomic,strong)NSMutableArray*advertisingArray;

/**
 *  帖子数组 */
@property (strong,nonatomic) NSMutableArray *circles;
/**
 *  用户信息 */
@property (strong,nonatomic) YSUserCustomer *userCustome;
//用户积分信息列表
@property (nonatomic,strong) NSMutableArray *intergralListArrayData;
//用户积分数据列表
@property (nonatomic,strong) NSMutableArray *intergralProductsListArrayData;
/**
 *  问卷调查 */
@property (strong,nonatomic) YSQuestionnaire *questionnaire;
/**
 *  健康任务 */
@property (strong,nonatomic) YSTodayTaskList *taskList;
@property (strong,nonatomic) NSMutableArray *photos;
@property (strong,nonatomic) YSShareManager *shareManager;
@property (strong,nonatomic) YSHealthyManageTestLinkConfig *testLinkConfig;
@property (strong,nonatomic) UIImageView *floatImageView;
@property (assign, nonatomic) BOOL chunyuDoctorEntranceImageShow;
@property (strong,nonatomic) UIImage *chunYuEntranceImage;
@property (assign, nonatomic) CGFloat healthyConsultCellHeight;
@property (assign,nonatomic) CGFloat tableH;
/**
 *  健康管理广告模板 */
@property (strong,nonatomic) YSNearAdContentDataManager *adContentDataManager;
@property (strong,nonatomic) YSHealthManageHeaderView *headerView;
@property (strong,nonatomic) YSActivitiesInfoItem *actInfoItem;
/**
 *  广告位数据返回item */
@property (strong,nonatomic) YSAdContentItem *adContentItem;
//用户积分状况
@property (strong,nonatomic) NSDictionary *userIntegral;

@property (nonatomic, strong)VApiManager *vapiManager;
//商品推荐信息
@property (nonatomic, strong)NSArray *GoodsModels;
//热门问题
@property (nonatomic, strong)NSMutableArray *InfosModels;
//热门问题下标
@property (assign, nonatomic) NSInteger pageNum;


//    精准健康检测报告
//完美d档案
@property(nonatomic,strong)NSMutableArray*othersArray;
@property(nonatomic,strong)NSMutableArray*healthServiceRecommendBgBOArray;
@property(nonatomic,strong)NSMutableArray*healthServiceRecommendJdBOArray;
@property(nonatomic,strong)NSMutableArray*healthServiceRecommendXyBOArray;


@property(nonatomic,strong)NSMutableArray*dataArray;


@end

@implementation RXMainViewController

/**广告位数据**/
-(NSMutableArray*)advertisingArray;{
    if (!_advertisingArray) {
        _advertisingArray=[NSMutableArray array];
    }
    return _advertisingArray;
}

-(NSMutableArray*)healthServiceRecommendXyBOArray;{
    if (!_healthServiceRecommendXyBOArray) {
        _healthServiceRecommendXyBOArray=[NSMutableArray array];
    }
    return _healthServiceRecommendXyBOArray;
}
-(NSMutableArray*)healthServiceRecommendJdBOArray;{
    if (!_healthServiceRecommendJdBOArray) {
        _healthServiceRecommendJdBOArray=[NSMutableArray array];
    }
    return _healthServiceRecommendJdBOArray;
}

-(NSMutableArray*)healthServiceRecommendBgBOArray;{
    if (!_healthServiceRecommendBgBOArray) {
        _healthServiceRecommendBgBOArray=[NSMutableArray array];
    }
    return _healthServiceRecommendBgBOArray;
}


- (NSMutableArray *)circles {
    if (!_circles) {
        _circles = [NSMutableArray array];
    }
    return _circles;
}

- (NSMutableArray *)intergralListArrayData {
    if (!_intergralListArrayData) {
        _intergralListArrayData = [NSMutableArray array];
    }
    return _intergralListArrayData;
}
- (NSMutableArray *)intergralProductsListArrayData {
    if (!_intergralProductsListArrayData) {
        _intergralProductsListArrayData = [NSMutableArray array];
    }
    return _intergralProductsListArrayData;
}

- (NSMutableArray *)photos {
    if (!_photos) {
        _photos = [NSMutableArray array];
    }
    return _photos;
}

- (NSMutableDictionary *)stepUserInfo {
    if (!_stepUserInfo) {
        _stepUserInfo = [NSMutableDictionary dictionary];
    }
    return _stepUserInfo;
}

- (YSNearAdContentDataManager *)adContentDataManager {
    if (!_adContentDataManager) {
        _adContentDataManager = [[YSNearAdContentDataManager alloc] init];
        _adContentDataManager.delegate = self;
        _adContentDataManager.paramSource = self;
    }
    return _adContentDataManager;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden =YES;
    [self requestUserIntergral];
    [self requestMyIntegralExchangeList];
    [self.mtableview reloadData];
    [self requestStepData];
    [self getRequest];

}
- (void)requestMyIntegralExchangeList {
    IntegralListByCriteriaRequest *request = [[IntegralListByCriteriaRequest alloc] init:GetToken];
    request.api_mobileRecommend = @"2";
    request.api_pageSize = @4;
    request.api_pageNum = @1;
    VApiManager *manager = [[VApiManager alloc] init];
    
    [manager integralListByCriteria:request success:^(AFHTTPRequestOperation *operation, IntegralListByCriteriaResponse *response) {
        NSArray *arrayList = [response.integralList copy];
        [self.intergralProductsListArrayData removeAllObjects];
        for (NSInteger i = 0; i < arrayList.count; i++) {
            NSDictionary *dicDetailsList = [NSDictionary dictionaryWithDictionary:arrayList[i]];
            [self.intergralProductsListArrayData addObject:[JGIntegralCommendGoodsModel objectWithKeyValues:dicDetailsList]];
        }
        [self.mtableview reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //        [MBProgressHUD hideHUDForView:weak_self.view animated:YES];
        //        [weak_self.tableView.mj_header endRefreshing];
        //        [weak_self.tableView.mj_footer endRefreshing];
    }];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden=NO;
}
- (void)managerCallBackDidSuccess:(YSAPIBaseManager *)manager {
    YSResponseDataReformer *reformer = [[YSResponseDataReformer alloc] init];
    YSNearAdContentModel *adContentModel = [reformer reformDataWithAPIManager:manager];
    self.headerView.adContentModel = adContentModel;
    if (!adContentModel.style || !adContentModel.adContent.count) {
        self.headerView.adContentModel = nil;
    }
    [self tableViewReloadDate];
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
                 @"code":@"APP_HEALTH_AD_SF"
                 };
    }
    return @{};
}
- (void)userLoginSuccessToRefreshHealthyManagePageAction {
   // [self refreshPage];
}
#pragma mark - 用户积分请求
-(void)requestUserIntergral{
    
    @weakify(self);
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    VApiManager *manager = [[VApiManager alloc] init];
    UsersIntegralGetRequest *request = [[UsersIntegralGetRequest alloc] init:GetToken];
    [manager usersIntegralGet:request success:^(AFHTTPRequestOperation *operation, UsersIntegralGetResponse *response) {
        @strongify(self);
        NSMutableArray *integralTodayArray = [NSMutableArray arrayWithArray:response.integralToday];
        NSMutableArray *integralOtherArray = [NSMutableArray arrayWithArray:response.integralOther];
        self.userIntegral=response.integral;
        //两个数组拼接起来
        [integralTodayArray addObjectsFromArray:integralOtherArray];
        [self diposeGainIntergralListForModelWithArrry:[integralTodayArray copy]];
        
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    }];
}

- (void)diposeGainIntergralListForModelWithArrry:(NSArray *)dataArray
{
    [self.intergralListArrayData removeAllObjects];
    for (NSInteger i = 0; i < dataArray.count; i++) {
        NSDictionary *dicDetailsList = [NSDictionary dictionaryWithDictionary:dataArray[i]];
        [self.intergralListArrayData addObject:[YSGoMissionModel objectWithKeyValues:dicDetailsList]];
    }
    
    [self.mtableview reloadData];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

- (void)activityDidOpenHiddenOrShowFloatImage:(NSNotification *)noti {
    
    @weakify(self);
    NSNumber * object = (NSNumber *)noti.object;
    if (![object boolValue]) {
        self.floatImageView.hidden = YES;
        return;
    }
    
    [JGActivityHelper mainPageShowFloatImageResult:^(BOOL result,UIImage *floatImage) {
        @strongify(self);
        if (result) {
            self.floatImageView.image = floatImage;
            if (self.floatImageView.hidden) {
                POPSpringAnimation *animation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
                animation.fromValue  = [NSValue valueWithCGSize:CGSizeMake(0.0f, 0.0f)];
                animation.toValue  = [NSValue valueWithCGSize:CGSizeMake(1.0f, 1.0f)];
                animation.springSpeed = 20;
                animation.springBounciness = 20;
                [self.floatImageView.layer pop_addAnimation:animation forKey:@"kButtonPopAnimateKey"];
            }
            self.floatImageView.hidden = NO;
        }else {
            self.floatImageView.hidden = YES;
        }
    }];
    
}

- (void)clearActivitySetting {
    [self showSVProgress];
    [self remove:@"kLocalDatesKey"];
    [JGActivityHelper stProcessType:YSActivityProcessWithProcessingType];
    [self remove:kDropMenuViewDidShowKey];
    [JGActivityHelper sharedInstance].showed = NO;
    [JGActivityHelper sharedInstance].conditeShowed = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2. * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self dismissSVProgress];
    });
    [self remove:@"ysactloacldatas"];
}
- (void)chunYuDoctorEnterRequest {
}

- (void)tableViewReloadDate {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.mtableview reloadData];
    });
}

#pragma mark 查看弹框信息 活动弹框、用户签到
- (void)queryFlipViewInfo {
    @weakify(self);
    // 查询活动弹框信息
    [JGActivityHelper controllerDidAppear:@"jirirenwu.com" requestStatus:^(YSActivityInfoRequestStatus status) {
        switch (status) {
            case YSActivityInfoRequestIdleStatus:
            {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [JGActivityHelper controllerDidAppear:@"jirirenwu.com" requestStatus:NULL];
                });
            }
                break;
            default:
                break;
        }
    }];
    // 查询活动浮框信息
    [JGActivityHelper controllerFloatImageDidAppear:@"jirirenwu.com" result:^(BOOL ret, UIImage *floatImg,YSActivitiesInfoItem *infoItem,YSActivityInfoRequestStatus status) {
        @strongify(self);
        dispatch_async(dispatch_get_main_queue(), ^{
            self.floatImageView.hidden = !ret;
            if (ret) {
                self.actInfoItem = infoItem;
                self.floatImageView.image = floatImg;
            }else {
                switch (status) {
                    case YSActivityInfoRequestIdleStatus:
                    {
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            [JGActivityHelper controllerFloatImageDidAppear:@"jirirenwu.com" result:^(BOOL ret, UIImage *floatImge, YSActivitiesInfoItem *actInfoItem, YSActivityInfoRequestStatus status) {
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    self.floatImageView.hidden = !ret;
                                    if (ret) {
                                        self.actInfoItem = infoItem;
                                        self.floatImageView.image = floatImg;
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
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [YSUMMobClickManager beginLogPageWithKey:[NSString stringWithFormat:@"%@%@",@"um_",NSStringFromClass([self class])]];
    @weakify(self);
    if ([[YSConfigAdRequestManager sharedInstance] inLanunchScreenAdPage]) {
        // 在启动广告页
    }else {
        [self queryFlipViewInfo];
    }
    
#ifdef DEBUG
    JGLog(@"DEBUG");
    //    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"清除记录" style:UIBarButtonItemStylePlain target:self action:@selector(clearActivitySetting)];
#else
    JGLog(@"REALSE");
#endif
   // [self reqeustNoticeMessageNoReadCount];
    //请求未读消息数量
    self.navigationController.navigationBar.barTintColor = [YSThemeManager themeColor];
    
    [self hiddenHud];
    [self showHud];
    [self chunYuDoctorEnterRequest];
#pragma mark 健康管理广告位接口调用
    [[YSConfigAdRequestManager sharedInstance] requestAdContent:YSAdContentWithHealthyManagerType
                                                      cacheItem:^(YSAdContentItem *cacheItem) {
                                                          // 返回一个缓存广告位对象
                                                          return ;
                                                          @strongify(self);
                                                          self.adContentItem = cacheItem;
                                                          [self tableViewReloadDate];
                                                      }
                                                         result:^(YSAdContentItem *adContentItem) {
                                                             @strongify(self);
                                                             if (!adContentItem) {
                                                                 self.adContentItem = adContentItem;
                                                                 [self tableViewReloadDate];
                                                             }else if ([adContentItem.receiveCode isEqualToString:[[YSConfigAdRequestManager sharedInstance] requestAdContentCodeWithRequestType:YSAdContentWithHealthyManagerType]]) {
                                                                 self.adContentItem = adContentItem;
                                                                 [self tableViewReloadDate];
                                                             }
                                                         }];
    [HealthyManageData healthyManagerSuccess:^(YSUserCustomer *userCustomer, YSQuestionnaire *questionnaire, NSArray *postList,YSTodayTaskList *taskList,YSHealthyManageTestLinkConfig *testLinkConfig) {
        @strongify(self);
        [self.circles removeAllObjects];
        [self.circles xf_safeAddObjectsFromArray:postList];
        self.userCustome = userCustomer;
        self.testLinkConfig = testLinkConfig;
        self.userCustome.successCode = 1;
        self.questionnaire = questionnaire;
        self.questionnaire.successCode = 1;
        self.taskList = taskList;
        self.taskList.successCode = 1;
        [self tableViewReloadDate];
        [self hiddenHud];
    } fail:^{
        @strongify(self);
        [self hiddenHud];
        self.userCustome.successCode = 0;
        self.questionnaire.successCode = 0;
        self.taskList.successCode = 0;
        [self tableViewReloadDate];
    } error:^{
        @strongify(self);
        [self hiddenHud];
        self.userCustome.successCode = 0;
        self.questionnaire.successCode = 0;
        self.taskList.successCode = 0;
        [self tableViewReloadDate];
    } unlogined:^(NSArray *postList) {
        @strongify(self);
        [self.circles removeAllObjects];
        [self.circles xf_safeAddObjectsFromArray:postList];
        self.userCustome.successCode = 0;
        self.questionnaire.successCode = 0;
        self.taskList.successCode = 0;
        [self tableViewReloadDate];
        [self hiddenHud];
    } isCache:NO];
    [self disafterDismiss];
}

- (void)endScreenLauchAd:(NSNotification *)noti {
    switch ([[YSConfigAdRequestManager sharedInstance] endTypeWithNoti:noti.object]) {
        case YSLauchScreenEndWithOvertimeType:
        {
            // 超时结束、查询弹框信息
            [self queryFlipViewInfo];
        }
            break;
        case YSLauchScreenEneWithClickAdType:
        {
            // 进入详情
            YSSLAdItem *adItem = [[YSConfigAdRequestManager sharedInstance] clickAdItemWithNoti:noti.object];
            YSNearAdContent *adItemContent = [[YSNearAdContent alloc]init];
            //将启动页广告模型跳转需要的数据转移到通用广告模型上
            adItemContent.link = adItem.itemId;
            adItemContent.name = adItem.adTitle;
            adItemContent.type = adItem.adType;
            adItemContent.needLogin = @0;//点击启动页默认不需要登陆
            //[self clickAdvertItem:adItemContent itemIndex:0];
        }
            break;
        case YSLauchScreenEndWithSkipType:
        {
            // 点击跳过、查询弹框信息
            [self queryFlipViewInfo];
        }
            break;
        default:
            break;
    }
}

- (void)showMaskGuideCompleted:(voidCallback)completed {
}

// 请求定位城市天气情况
- (void)cityWeather:(NSString *)city {
    [YSWeatherManager city:city fail:^{
        
    } success:^(YSWeatherInfo *weatherInfo) {
        [YSBaseInfoManager storageWeatherInfo:weatherInfo];
    }];
}

// 成功定位到当前城市
- (void)locateSucceedWithCity:(NSString *)city {
    [YSBaseInfoManager storageCity:city];
    [self cityWeather:city];
}

// 失败定位，默认为深圳
- (void)locateFail {
    [YSWeatherManager city:@"武汉"
                      fail:^{
                          [YSBaseInfoManager storageCity:@"武汉"];
                      }
                   success:^(YSWeatherInfo *weatherInfo)
     {
         [YSBaseInfoManager storageWeatherInfo:weatherInfo];
     }
     ];
}

- (void)updateUserLocationCoordinate {
    @weakify(self);
    [YSLocationManager
     reverseGeoResult:^(NSString *city) {
         @strongify(self);
         [self locateSucceedWithCity:city];
     }
     fail:^{
         @strongify(self);
         [self locateFail];
     }
     addressComponentCallback:^(BMKAddressComponent *componet) {
         
     }
     callbackType:YSLocationCallbackCityType];
}

- (void)requestStepData {
    
    
}
- (void)disafterDismiss {
    @weakify(self);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        @strongify(self);
        [self hiddenHud];
    });
}
#pragma mark --- tableView headerView 点击跳转事件 ---
- (void)headerViewButtonClickWithIdex:(NSInteger)index {
    switch (index) {
        case 0:
        {
            // 需要登录
            BOOL ret = CheckLoginState(YES);
            if (!ret) {
                // 没登录 直接返回
                return;
            }
            DefuController *defuVC = [[DefuController alloc] init];
            [self.navigationController pushViewController:defuVC animated:YES];
        }
            break;
        case 1:
        {
            YSHealthyHelperController *healthyHelperController = [[YSHealthyHelperController alloc] init];
            [self.navigationController pushViewController:healthyHelperController animated:YES];
        }
            break;
        case 2:
        {
            YSHealthySelfTestController *healthySelfTestController = [[YSHealthySelfTestController alloc] init];
            [self.navigationController pushViewController:healthySelfTestController animated:YES];
        }
            break;
        case 3:
        {
            YSHealthyMessageController *healthyMessageController =[[YSHealthyMessageController alloc] init];
            [self.navigationController pushViewController:healthyMessageController animated:YES];
        }
            break;
        default:
            break;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUI];
    self.dataArray=[[NSMutableArray alloc]init];
    [self.dataArray addObject:@{@"itemName":@"运动步数",@"mySelectType":@"false",@"myZhankaiType":@"false",@"itemCode":@12}];
    [self.dataArray addObject:@{@"itemName":@"血压",@"mySelectType":@"false",@"myZhankaiType":@"false",@"itemCode":@4}];
    [self.dataArray addObject:@{@"itemName":@"血糖",@"mySelectType":@"false",@"myZhankaiType":@"false",@"itemCode":@9}];
    [self.dataArray addObject:@{@"itemName":@"体重",@"mySelectType":@"false",@"myZhankaiType":@"false",@"itemCode":@16}];
    self.view.backgroundColor = [UIColor whiteColor];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"kUserDidLoadMainController" object:nil];
    });
}
//- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
//    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
//    header.backgroundView.backgroundColor = UIColor.clearColor;
//}

-(void)setUI;{
    
    CGRect statusRect = [[UIApplication sharedApplication] statusBarFrame];
    int myhight=statusRect.size.height;
    _mtableview=[[UITableView alloc]initWithFrame:CGRectMake(0,0,kScreenWidth,kScreenHeight-kNarbarH) style:UITableViewStyleGrouped];
    _mtableview.backgroundColor =JGColor(250, 250, 250, 1);
    _mtableview.delegate = self;
    _mtableview.dataSource = self;
    _mtableview.sectionFooterHeight = 0;
    _mtableview.estimatedRowHeight = 0;
    _mtableview.estimatedSectionHeaderHeight = 0;
    _mtableview.estimatedSectionFooterHeight = 0;
    _mtableview.backgroundColor = JGColor(250, 250, 250, 1);
    _mtableview.separatorColor =JGColor(250, 250, 250, 1);
    _mtableview.delegate = self;
    _mtableview.dataSource = self;
    _mtableview.tableFooterView = [UIView new];

    if (@available(iOS 11.0, *)) {
         _mtableview.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        self.mtableview.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    [self.view addSubview:_mtableview];
}
#pragma mark HeaderViewDelegate 健康管理广告模板点击事件处理
- (void)headerView:(YSHealthManageHeaderView *)headerView clickAdItem:(YSNearAdContent *)adItem itemIndex:(NSInteger)index {
    [self clickAdvertItem:adItem itemIndex:index];
}

#pragma mark --- 健康管理首页广告模板与启动页广告模板点击事件处理
- (void)clickAdvertItem:(YSNearAdContent *)adItem itemIndex:(NSInteger)index{
    if ([adItem.needLogin integerValue]) {
        // 需要登录
        BOOL ret = CheckLoginState(YES);
        if (!ret) {
            // 没登录 直接返回
            return;
        }
    }
    [YSUMMobClickManager beginLogPageWithKey:[NSString stringWithFormat:@"%@%@%@%ld",@"um_",@"HM_",@"adItemIndex_",index]];
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
            // 商品详情
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
                // 跳转精准健康检测
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
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%ld",(long)collectionView.tag);
    switch (collectionView.tag) {
        case 0:{//健康清单
            UNLOGIN_HANDLE
            NSMutableDictionary *dic=[HealthyManageData taskDatasWithTaskList:self.taskList][indexPath.row];
            NSString *msg;
            if ([dic[@"title"] isEqualToString:@"去完成"]) {
                msg=nil;
            }else if([dic[@"title"] isEqualToString:@"已完成"]){
                NSString *url = [NSString stringWithFormat:@"%@",dic[@"finishTaskURL"]];
                if (url.length) {
                    msg=url;
                }
            }
            if (msg) {
                YSHealthyManageWebController *completedTaskWebController = [[YSHealthyManageWebController alloc] initWithWebType:YSHealthyManageCompleteTaskType uid:nil];
                completedTaskWebController.taskProcess = YSHealthyTaskCompleted;
                completedTaskWebController.completedTaskUrl = [NSString stringWithFormat:@"%@/%@",Base_URL,msg];
                [self.navigationController pushViewController:completedTaskWebController animated:YES];
            }else {
                YSHealthyManageWebController *completedTaskWebController = [[YSHealthyManageWebController alloc] initWithWebType:YSHealthyManageCompleteTaskType uid:self.userCustome.uid];
                YSHealthTaskList *task = [self.taskList.healthTaskList xf_safeObjectAtIndex:indexPath.row];
                completedTaskWebController.taskId = task.taskId;
                completedTaskWebController.yinDaoURL = task.yinDaoURL;
                completedTaskWebController.strNavYinDaoTitle = task.taskName;
                completedTaskWebController.taskProcess = YSHealthyTaskUnCompleted;
                [self.navigationController pushViewController:completedTaskWebController animated:YES];
            }
        }
            break;
        case 1:{//积分任务
            [self goMissionCellButtonClickWithindexPath:indexPath];
        }
            break;
        case 2:{//积分兑换
            JGIntegralCommendGoodsModel *model=self.intergralProductsListArrayData[indexPath.row];
            IntegralGoodsDetailController *integralGoodsDetailVC = [[IntegralGoodsDetailController alloc] init];
            NSInteger goodDetailId = [model.id integerValue];
            integralGoodsDetailVC.integralGoodsID = @(goodDetailId);
            [self.navigationController pushViewController:integralGoodsDetailVC animated:YES];
        }
            break;
        default:
            break;
    }
}
//赚积分做任务
- (void)goMissionCellButtonClickWithindexPath:(NSIndexPath *)indexPath
{
    UIViewController *VC;
    YSGoMissionModel *model = self.intergralListArrayData[indexPath.row];
    NSString *strType = model.type;
    if ([strType isEqualToString:@"integral_flip_cards"]) {
        //拼手气赚积分
        YSRiskLuckController *riskLuskVC = [[YSRiskLuckController alloc]init];
        riskLuskVC.isComeForGoMissionVC = YES;
        YSGestureNavigationController * nav = [[YSGestureNavigationController alloc]initWithRootViewController:riskLuskVC];
        [self presentViewController:nav animated:YES completion:nil];
        
    }else if([strType isEqualToString:@"integral_jianKangQuan_dianZan"] || [strType isEqualToString:@"integral_jianKangQuan_pingLun"]){
        //点赞      //评论
        switch (YSEnterEarnInteralControllerWithHealthyManagerMainPage){//self.enterControllerType) {
            case YSEnterEarnInteralControllerWithHealthyManagerMainPage:
            {
                AppDelegate * app = (AppDelegate*)[[UIApplication sharedApplication]delegate];
                [[NSUserDefaults standardUserDefaults] setObject:@"dianzanpinglun" forKey:@"dianzanpinglun"];
                [app gogogoWithTag:0];
            }
                break;
            case YSEnterEarnInteralControllerWithRiskLuck:
            {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"kSigninDismissPostKey" object:@1];
            }
                break;
            default:
                break;
        }
    }else if([strType isEqualToString:@"integral_jianKangQuan_faTie"] || [strType isEqualToString:@"integral_jianKangQuan_beiPingLun"] || [strType isEqualToString:@"integral_jianKangQuan_beiDianZan"]){
        //发帖    //帖子被点赞     //帖子被评论
        [self achievePhotos];
        
    }else if([strType isEqualToString:@"integral_health_tiJian"]){
        //健康体检
        DefuController *defuVC = [[DefuController alloc] init];
        VC = defuVC;
        
    }else if([strType isEqualToString:@"integral_health_ziCe"]){
        //健康自测
        YSHealthySelfTestController *healthySelfTestController = [[YSHealthySelfTestController alloc] init];
        VC = healthySelfTestController;
        
    }else if([strType isEqualToString:@"integral_health_ceShi"]){
        //健康测试
        NSDictionary *dict = [kUserDefaults objectForKey:kUserCustomerKey];
        YSHealthyManageWebController *testWebController = [[YSHealthyManageWebController alloc] initWithWebType:YSHealthyManageHealthyTestType uid:dict[@"uid"]];
        VC = testWebController;
        
    }else if([strType isEqualToString:@"integral_health_fengXianPingGu"]){
        //疾病风险评估
        YSHealthyManageWebController *illnessTestController = [[YSHealthyManageWebController alloc] initWithWebType:YSHealthyManageIllnessTestType uid:nil];
        VApiManager *manager = [[VApiManager alloc]init];
        HealthManageIndexRequest *request = [[HealthManageIndexRequest alloc] init:GetToken];
        request.api_pageNum = @0;
        request.api_pageSize = @10;
        request.api_postType = @0;
        @weakify(self);
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [manager healthManageIndex:request success:^(AFHTTPRequestOperation *operation, HealthManageIndexResponse *response) {
            @strongify(self);
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            if([response.errorCode integerValue] == 0){
                YSHealthyManageTestLinkConfig *config = [YSHealthyManageTestLinkConfig linkConfigWithResponse:response];
                illnessTestController.linkConfig = [NSString stringWithFormat:@"%@%@",Base_URL,config.retestURL];
                [self.navigationController pushViewController:illnessTestController animated:YES];
            }else {
                
                
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        }];
    }else if([strType isEqualToString:@"integral_health_renWu"]){
        //健康任务
        YSMyHealthMissonController *myHealthMissonController = [[YSMyHealthMissonController alloc]init];
        VC = myHealthMissonController;
        
    }else if([strType isEqualToString:@"integral_invite_friends"]){
        //邀请好友
        MyErWeiMaController *erWeiMaVC = [[MyErWeiMaController alloc]init];
        VC = erWeiMaVC;
        
    }else if([strType isEqualToString:@"integral_consumer"]){
        //商城购物
        switch (YSEnterEarnInteralControllerWithHealthyManagerMainPage){//self.enterControllerType) {
            case YSEnterEarnInteralControllerWithHealthyManagerMainPage:
            {
                AppDelegate * app = (AppDelegate*)[[UIApplication sharedApplication]delegate];
                [app gogogoWithTag:1];
            }
                break;
            case YSEnterEarnInteralControllerWithRiskLuck:
            {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"kSigninDismissPostKey" object:@3];
            }
                break;
            default:
                break;
        }
    }else if ([strType isEqualToString:@"integral_o2o_shop"]){
        AppDelegate * app = (AppDelegate*)[[UIApplication sharedApplication]delegate];
        [app gogogoWithTag:2];
    }
    if (VC) {
        [self.navigationController pushViewController:VC animated:YES];
    }
}

- (void)achievePhotos {
    JGLog(@"achievePhotos-");
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:9 delegate:self];
    imagePickerVc.allowTakePicture = NO;
    imagePickerVc.allowPickingVideo = NO;
    imagePickerVc.allowPickingImage = YES;
    imagePickerVc.allowPickingOriginalPhoto = NO;
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        
    }];
    
    [self presentViewController:imagePickerVc animated:YES completion:nil];
}


#pragma mark -- UIImagePickerControllerDelegate --
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto {
    [self dismissViewControllerAnimated:NO completion:^{
        [self presentControllerWithPhotos:photos assets:nil];
    }];
    JGLog(@"--%s",__func__);
}

- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingVideo:(UIImage *)coverImage sourceAssets:(id)asset {
    JGLog(@"--%s",__func__);
}

- (void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:nil];
    JGLog(@"--%s",__func__);
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    if ([type isEqualToString:@"public.image"]) {
        TZImagePickerController *tzImagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:9 delegate:self];
        [tzImagePickerVc showProgressHUD];
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        // save photo and get asset / 保存图片，获取到asset
        [[TZImageManager manager] savePhotoWithImage:image completion:^{
            [[TZImageManager manager] getCameraRollAlbum:NO allowPickingImage:YES completion:^(TZAlbumModel *model) {
                [[TZImageManager manager] getAssetsFromFetchResult:model.result allowPickingVideo:NO allowPickingImage:YES completion:^(NSArray<TZAssetModel *> *models) {
                    [tzImagePickerVc hideProgressHUD];
                    TZAssetModel *assetModel = [models lastObject];
                    JGLog(@"----assetModel:%@",assetModel);
                }];
            }];
        }];
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    if ([picker isKindOfClass:[UIImagePickerController class]]) {
        [picker dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)presentControllerWithPhotos:(NSArray *)photos assets:(NSArray *)assets {
    YSComposeStatusController *composeStatusController = [[YSComposeStatusController alloc] init];
    composeStatusController.selectedPhotos = [NSMutableArray arrayWithArray:photos];
    @weakify(composeStatusController);
    composeStatusController.composeCallback = ^(){
        
        JGLog(@"composed");
    };
    composeStatusController.cancelCallback = ^(){
        @strongify(composeStatusController);
        [composeStatusController.selectedAssets removeAllObjects];
        [composeStatusController.selectedPhotos removeAllObjects];
        
    };
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:composeStatusController];
    [self presentViewController:nav animated:NO completion:NULL];
}
-(void)gotojifenshangcheng{
    IntegralNewHomeController *integralShopHomeController = [[IntegralNewHomeController alloc] init];
    integralShopHomeController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:integralShopHomeController animated:YES];
}
#pragma mark ---requestData
- (void)requestData;{
    
    //商品推荐
    [self _requestGoodsShowcaseGoodsDataWithCaseID];
    @weakify(self);
    [self showHud];
    self.pageNum = 1;
    [YSHealthyMessageDatas healthyMessageMostDaysSuccess:^(NSArray *datas) {
        @strongify(self);
        [self.InfosModels removeAllObjects];
        [self.InfosModels xf_safeAddObjectsFromArray:datas];
        [self.mtableview reloadData];
        [self hiddenHud];
    } fail:^{
        @strongify(self);
        [self hiddenHud];
    } pageNumber:self.pageNum];
    
}

#pragma mark - 首页商品推荐下面的商品列表 caseid=26
-(void)_requestGoodsShowcaseGoodsDataWithCaseID{
    
    GoodsCaseListRequest *request = [[GoodsCaseListRequest alloc] init:GetToken];
    request.api_id = @26;
    
    [_vapiManager goodsCaseList:request success:^(AFHTTPRequestOperation *operation, GoodsCaseListResponse *response) {
        JGLog(@"good  list response %@",response);
        NSMutableArray *caseGoodsArr = [NSMutableArray arrayWithCapacity:response.goodsList.count];
        for (NSDictionary *dic in response.goodsList) {
            GoodsDetailModel *model = [[GoodsDetailModel alloc] initWithJSONDic:dic];
            [caseGoodsArr addObject:model];
            //            NSLog(@"imgUrl - %@",model.goodsMainPhotoPath);
        }
        self.GoodsModels = caseGoodsArr;
        [self.mtableview reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        //请求猜您喜欢数据
        //        [self _requestGuessYouLikeData];
        
    }];
}

/****tabview代理方法*****/
//多少分组
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;{
    
    //dataarray为默认显示数据，+1是给其他更多的分组
    if (self.dataArray.count>0) {
         return headIndex+self.dataArray.count+1;
    }
    //默认不显示数组
    return headIndex;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    //个人信息数据固定头部
    if (section==0) {
        CGRect statusRect = [[UIApplication sharedApplication] statusBarFrame];
        int myhight=statusRect.size.height;
        if (!self.rxBaseInfoView) {
            self.rxBaseInfoView=[[[NSBundle mainBundle]loadNibNamed:@"RXUserInfoVIew" owner:self options:nil]firstObject];
            self.rxBaseInfoView.userInfoTop.constant=myhight+30;
            self.rxBaseInfoView.frame=CGRectMake(0,0,kScreenWidth,300);
            //续费
            [self.rxBaseInfoView.vipButton setTitleColor:JGColor(254, 227, 184, 1) forState:UIControlStateNormal];
            self.rxBaseInfoView.iconImage.layer.masksToBounds=YES;
            self.rxBaseInfoView.iconImage.layer.cornerRadius=30;
            [self.rxBaseInfoView.vipButton addTarget:self action:@selector(vipButtonFounction) forControlEvents:UIControlEventTouchUpInside];
            self.rxBaseInfoView.iconImage.layer.masksToBounds=YES;
            self.rxBaseInfoView.iconImage.layer.borderWidth=2;;
            self.rxBaseInfoView.iconImage.layer.borderColor=[UIColor whiteColor].CGColor;
            self.rxBaseInfoView.shuoMingLabel.layer.masksToBounds=YES;
            self.rxBaseInfoView.shuoMingLabel.layer.cornerRadius=10;
            self.rxBaseInfoView.shuoMingLabel.backgroundColor=JGColor(73, 140, 122, 1);
        }
        if (self.response) {
            self.rxBaseInfoView.nameLabel.text=self.response.healthUserBO[@"nickName"]?self.response.healthUserBO[@"nickName"]:@"--";
            //头像
            [self.rxBaseInfoView.iconImage sd_setImageWithURL:[NSURL URLWithString:self.response.healthUserBO[@"headImage"]]];
            //年龄
            self.rxBaseInfoView.ageLabel.text=self.response.healthUserBO[@"age"]?self.response.healthUserBO[@"age"]:@"--";
            //性别
            int sexage=[self.response.healthUserBO[@"sex"] intValue];
            self.rxBaseInfoView.sexLabel.text=sexage==0?@"男":@"女";
            //身高
            self.rxBaseInfoView.heightLabel.text=self.response.healthUserBO[@"height"]?self.response.healthUserBO[@"height"]:@"--";
            //体重
            self.rxBaseInfoView.weghtlabel.text=self.response.healthUserBO[@"weight"]?self.response.healthUserBO[@"weight"]:@"--";
            //说明
            self.rxBaseInfoView.shuoMingLabel.text=[NSString stringWithFormat:@"   %@     ",self.response.healthUserBO[@"urlName"]?self.response.healthUserBO[@"urlName"]:@"--"];
            
            self.rxBaseInfoView.userInteractionEnabled=YES;
            self.rxBaseInfoView.shuoMingLabel.userInteractionEnabled=YES;
            
            UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapButtonFountion)];
            [self.rxBaseInfoView.shuoMingLabel addGestureRecognizer:tapGR];
            
        }
        return self.rxBaseInfoView;
    }
    if (self.dataArray.count>0) {
        //显示数组
        if (section-1<self.dataArray.count+1) {
            if (section-1==self.dataArray.count) {
                UIView*view=[[UIView alloc]initWithFrame:CGRectMake(10,0,ScreenWidth-20,40)];
                view.backgroundColor=JGColor(250, 250, 250, 1);
                
                UIButton*button=[UIButton buttonWithType:UIButtonTypeCustom];
                button.frame=CGRectMake(10,5,ScreenWidth-20,35);
                button.backgroundColor=[UIColor whiteColor];
                [button setTitle:@"其他更多" forState:UIControlStateNormal];
                [button setTitle:@"其他更多" forState:UIControlStateSelected];
                button.titleLabel.font=[UIFont systemFontOfSize:13];
                [button setTitleColor:JGColor(136, 136, 136, 1) forState:UIControlStateSelected];
                [button setTitleColor:JGColor(136, 136, 136, 1) forState:UIControlStateNormal];
                button.titleLabel.textAlignment=1;
                //        [button setImage:[UIImage imageNamed:@"round_down"] forState:UIControlStateNormal];
                //        [button setImage:[UIImage imageNamed:@"round_down"] forState:UIControlStateSelected];
                //        [button setTitleEdgeInsets:UIEdgeInsetsMake(0, -button.imageView.size.width, 0, button.imageView.size.width)];
                //        [button setImageEdgeInsets:UIEdgeInsetsMake(10, button.titleLabel.bounds.size.width, 10, -button.titleLabel.bounds.size.width)];
                [button addTarget:self action:@selector(qiTaiGengButtonFounction) forControlEvents:UIControlEventTouchUpInside];
                [view addSubview:button];
                return view;
            }
            
            //先判断是否可以展开
            NSMutableDictionary*dic=self.dataArray[section-1];
            NSMutableDictionary*keyValue=[Unit ParseJSONObject:dic[@"keyValue"]];

            UIView*rxheadView=[[UIView alloc]init];
            if (keyValue.count>0) {
                 rxheadView.frame=CGRectMake(0,0,kScreenWidth,100);
            }else{
                rxheadView.frame=CGRectMake(0,0,kScreenWidth,80);
            }
            UIImageView*imageView=[[UIImageView alloc]initWithFrame:CGRectMake(10,10,kScreenWidth-20,rxheadView.frame.size.height-15)];
            //背景
            imageView.layer.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0].CGColor;
            imageView.layer.cornerRadius = 8;
            imageView.layer.shadowColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:0.9].CGColor;
            imageView.layer.shadowOffset = CGSizeMake(0,0);
            imageView.layer.shadowOpacity = 1;
            imageView.layer.shadowRadius = 10;
            [rxheadView addSubview:imageView];
            
            //头像距离位置
            float myheight=0;
            if (keyValue.count>0) {
                myheight=30;
            }else{
                myheight=(rxheadView.frame.size.height-15)/2;
            }
            //头像
            UIImageView*iconImage=[[UIImageView alloc]initWithFrame:CGRectMake(30,myheight,24, 24)];
            iconImage.image=[UIImage imageNamed:[NSString stringWithFormat:@"%@_image",[Unit JSONString:dic key:@"itemCode"]]];
            iconImage.layer.masksToBounds=YES;
            iconImage.layer.borderWidth=1;;
            iconImage.layer.borderColor=[UIColor whiteColor].CGColor;
            
            [rxheadView addSubview:iconImage];
            //说明
            UILabel*itemNamelabel=[[UILabel alloc]init];
            itemNamelabel.text=self.dataArray[section-1][@"itemName"];
            itemNamelabel.font=JGFont(15);
            itemNamelabel.textColor=JGColor(51, 51, 51, 1);
            [rxheadView addSubview:itemNamelabel];

            [itemNamelabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.mas_equalTo(iconImage.mas_centerY);
                make.left.equalTo(iconImage.mas_right).offset(10);
            }];
            //文字
            UILabel*shuominglabel=[[UILabel alloc]init];
            shuominglabel.text=@"--";
            shuominglabel.textColor=JGColor(101, 187, 177, 1);
            [rxheadView addSubview:shuominglabel];
            [shuominglabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.mas_equalTo(itemNamelabel.mas_centerY);
                make.left.equalTo(itemNamelabel.mas_right).offset(20);
            }];
            
            //单位
            UILabel*danweilabel=[[UILabel alloc]init];
            danweilabel.text=@"--";
            [rxheadView addSubview:danweilabel];
            [danweilabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.mas_equalTo(itemNamelabel.mas_centerY);
                make.left.equalTo(shuominglabel.mas_right).offset(10);
            }];
            danweilabel.hidden=YES;
            
            //是否正常
            UILabel*typelabel=[[UILabel alloc]init];
            typelabel.frame=CGRectMake(30,myheight+24+10,40,20);
            [rxheadView addSubview:typelabel];
            typelabel.hidden=YES;
            if (keyValue.count>0) {
                //当有数据时统一配置
                if ([Unit JSONInt:dic key:@"execption"]==1) {
                    typelabel.hidden=NO;
                    typelabel.text=@"异常";
                    typelabel.font=JGFont(12);
                    typelabel.textColor=JGColor(239, 82, 80, 1);
                }
                shuominglabel.textColor=JGColor(101, 187, 177, 1);
                [shuominglabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:17]];
                danweilabel.hidden=NO;
                danweilabel.text=[Unit JSONString:dic key:@"unit"];
                danweilabel.textColor=JGColor(136, 136, 136, 1);
                if ([[RXTabViewHeightObjject getItemCodeNumber:dic] isEqualToString:@"血压"]) {
                    shuominglabel.text=[NSString stringWithFormat:@"%@/%@",[Unit JSONString:keyValue key:@"highValue"],[Unit JSONString:keyValue key:@"lowValue"]];
                }else if ([[RXTabViewHeightObjject getItemCodeNumber:dic] isEqualToString:@"血脂"]) {
                     shuominglabel.text=[NSString stringWithFormat:@"%@",[Unit JSONString:keyValue key:@"inValue"]];
                    if ([Unit JSONInt:dic key:@"execption"]==1) {
                        shuominglabel.hidden=YES;
                        shuominglabel.text=[Unit JSONString:dic key:@"testgrade"];
                        shuominglabel.textColor=JGColor(239, 82, 80, 1);
                    }
                }else{
                    shuominglabel.text=[NSString stringWithFormat:@"%@",[Unit JSONString:keyValue key:@"inValue"]];
                }
            }
            //添加button
            UIButton*addButton=[UIButton buttonWithType:UIButtonTypeCustom];
            [rxheadView addSubview:addButton];
            
            addButton.tag=section-1;
            addButton.userInteractionEnabled=YES;
            [addButton addTarget:self action:@selector(rxheadViewAddButton:) forControlEvents:UIControlEventTouchUpInside];
           
            addButton.selected=[Unit JSONBool:dic key:@"mySelectType"];
            [addButton setBackgroundImage:[UIImage imageNamed:@"向下"] forState:UIControlStateNormal];
            [addButton setBackgroundImage:[UIImage imageNamed:@"向上"] forState:UIControlStateSelected];
        
            //展开button
            UIButton*zhangkiaButton=[UIButton buttonWithType:UIButtonTypeCustom];
            [rxheadView addSubview:zhangkiaButton];
            zhangkiaButton.selected=[Unit JSONBool:dic key:@"myZhankaiType"];
            [zhangkiaButton setBackgroundImage:[UIImage imageNamed:@"Consummate_add_image"] forState:UIControlStateNormal];
            [zhangkiaButton setBackgroundImage:[UIImage imageNamed:@"取消"] forState:UIControlStateSelected];
            zhangkiaButton.tag=10000+section-1;
            [zhangkiaButton addTarget:self action:@selector(rxheadViewZhankaiButton:) forControlEvents:UIControlEventTouchUpInside];
            if (keyValue.count>0){
                addButton.frame=CGRectMake(kScreenWidth-20-20-42/2,20,42,42);
             zhangkiaButton.frame=CGRectMake(kScreenWidth-20-20-10-42-42/2,20,42,42);
            }else{
                addButton.hidden=YES;
                zhangkiaButton.frame=CGRectMake(kScreenWidth-20-20-42/2,myheight-10,42,42);
            }
            return rxheadView;
        }
    }
    if (self.dataArray.count>0) {
        if (section==self.dataArray.count+1+2) {
            YSHealthyTaskView *view = [[YSHealthyTaskView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 84.0/2) questionnaire:self.questionnaire tasks:self.taskList addTaskCallback:^{
                YSHealthyManageWebController *testWebController = [[YSHealthyManageWebController alloc] initWithWebType:YSHealthyManageAddTaskType uid:self.userCustome.uid];
                [self.navigationController pushViewController:testWebController animated:YES];
            }];
            [view setBackgroundColor:JGWhiteColor];
            return view;
        }
        if (section==self.dataArray.count+1+5) {
            if (self.response.invitationList.count>0) {
                YSHealthyInformationVIew *view = [[YSHealthyInformationVIew alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 84.0/2)  addTaskCallback:^{
                    //                YSHealthyManageWebController *testWebController = [[YSHealthyManageWebController alloc] initWithWebType:YSHealthyManageAddTaskType uid:self.userCustome.uid];
                    //                [self.navigationController pushViewController:testWebController animated:YES];
                }];
                [view setBackgroundColor:JGWhiteColor];
                return view;
            }
            return [UIView new];
        }
    }
    return [UIView new];
}

-(void)tapButtonFountion;{
    YSLinkCYDoctorWebController *cyDoctorController = [[YSLinkCYDoctorWebController alloc] initWithWebUrl:@"http://192.168.8.164:8082/carnation-apis-resource/resources/jkgl/report.html"];
    cyDoctorController.navTitle =@"完美档案";
    cyDoctorController.tag = 100;
    cyDoctorController.controllerPushType = YSControllerPushFromHealthyManagerType;
    [self.navigationController pushViewController:cyDoctorController animated:YES];
}
//vip续费界面
-(void)vipButtonFounction;{
    RXbutlerServiceViewController*vc=[[RXbutlerServiceViewController alloc]init];
    [self.navigationController pushViewController:vc animated:NO];
}
//显示更多
-(void)qiTaiGengButtonFounction;{
    RXMoreDetectionViewController*vc=[[RXMoreDetectionViewController alloc]init];
    [self.navigationController pushViewController:vc animated:NO];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==0) {
        return 300;
    }
    if (self.dataArray.count>0) {
        if (section-1<self.dataArray.count+1){
            if (section-1==self.dataArray.count){
                return 40;
            }
            NSMutableDictionary*dic=self.dataArray[section-1];
            NSMutableDictionary*keyValue=[Unit ParseJSONObject:dic[@"keyValue"]];
            if (keyValue.count>0) {
                 return 100;
            }
            return 80;
        }
    }
    if (self.dataArray.count>0) {
        if (section==self.dataArray.count+1+2){
            return 84.0/2;
        }
        if (section==self.dataArray.count+1+5) {
            if (self.response.invitationList.count>0) {
                return 84.0/2;
            }
            return 0.01;;
        }
    }
    return 10;
}
//首页展开
-(void)rxheadViewZhankaiButton:(UIButton*)button;{
     button.selected = !button.selected;
     NSDictionary*dic1=self.dataArray[button.tag-10000];
    NSMutableDictionary*dic=[[NSMutableDictionary alloc]initWithDictionary:dic1];
    if ([Unit JSONBool:dic key:@"myZhankaiType"]) {
        [dic setObject:[NSNumber numberWithBool:false] forKey:@"myZhankaiType"];
    }else{
        [dic setObject:[NSNumber numberWithBool:true] forKey:@"myZhankaiType"];
    }
    [dic setObject:[NSNumber numberWithBool:false] forKey:@"mySelectType"];
    [self.dataArray replaceObjectAtIndex:button.tag-10000 withObject:dic];
    [self.mtableview reloadData];
}
//首页button点击事件
-(void)rxheadViewAddButton:(UIButton*)button;{
    button.selected = !button.selected;
    NSDictionary*dic1=self.dataArray[button.tag];
    NSMutableDictionary*dic=[[NSMutableDictionary alloc]initWithDictionary:dic1];
    if ([Unit JSONBool:dic key:@"mySelectType"]) {
        [dic setObject:[NSNumber numberWithBool:false] forKey:@"mySelectType"];
        [dic setObject:[NSNumber numberWithBool:false] forKey:@"myZhankaiType"];
        [self.dataArray replaceObjectAtIndex:button.tag withObject:dic];
        [self.mtableview reloadData];
    }else{
        [dic setObject:[NSNumber numberWithBool:true] forKey:@"mySelectType"];
        [dic setObject:[NSNumber numberWithBool:false] forKey:@"myZhankaiType"];
        [self.dataArray replaceObjectAtIndex:button.tag withObject:dic];
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        //请求详情数据
        RXParamDetailRequest*request=[[RXParamDetailRequest alloc]init:GetToken];
        request.paramCode=[Unit JSONString:dic key:@"itemCode"];
        request.id=[Unit JSONString:dic key:@"id"];
        
        VApiManager *manager = [[VApiManager alloc]init];
        [manager RXMakeParamDetail:request success:^(AFHTTPRequestOperation *operation, RXParamDetailResponse *response) {
            dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0/*延迟执行时间*/ * NSEC_PER_SEC));
            
            dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            });
            if (!self.paramResponse) {
                self.paramResponse=[[RXParamDetailResponse alloc]init];
            }
            self.paramResponse=response;
            [self.mtableview reloadData];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0/*延迟执行时间*/ * NSEC_PER_SEC));
            
            dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            });
            [self.mtableview reloadData];
        }];
    }
}
//设置分组间隔
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section==0) {
        return 0.01;
    }
    if (section-1<self.dataArray.count+1){
        return 0.01;
    }
    if (section==self.dataArray.count+1+1) {
        return 0.01;
    }
    if (section==self.dataArray.count+1+4) {
        return 0.01;
    }
    return 0.01;
}
-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section;{
    UIView*view=[[UIView alloc]initWithFrame:CGRectMake(0,0,ScreenWidth,10)];
    view.backgroundColor=JGColor(250, 250, 250, 1);
    return view;
}
//跳转到测试界面
-(void)zhangKaiButtonFounction;{
    YSMultipleTypesTestController *multipleTypesTestController = [[YSMultipleTypesTestController alloc] initWithTestType:YSInputValueWithBloodPressureType];
    [self.navigationController pushViewController:multipleTypesTestController animated:YES];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;{
    
    if (self.dataArray.count>0) {
        if (indexPath.section-1<self.dataArray.count+1) {
            //其他更多
            if (indexPath.section-1==self.dataArray.count) {
                UITableViewCell*cell=[[UITableViewCell alloc]init];
                return cell;
            }
            if ([Unit JSONBool:self.dataArray[indexPath.section-1] key:@"myZhankaiType"]) {
                static  NSString *reusstring = @"RXZhangKaiTableViewCell";
                RXZhangKaiTableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:reusstring];
                if (cell==nil) {
                    cell=[[[NSBundle mainBundle]loadNibNamed:@"RXZhangKaiTableViewCell" owner:self options:nil]firstObject];
                }
                cell.separatorInset = UIEdgeInsetsMake(0,kScreenWidth, 0, 0);
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
                [cell.twoButton addTarget:self action:@selector(zhangKaiButtonFounction) forControlEvents:UIControlEventTouchUpInside];
                [cell.freeButton addTarget:self action:@selector(zhangKaiButtonFounction) forControlEvents:UIControlEventTouchUpInside];
                return cell;
            }else{
                //默认第一个显示
                if (indexPath.row==0) {
                    UITableViewCell*mainCell=[RXTabViewHeightObjject getTabViewCell:self.dataArray[indexPath.section-1]];
                
                    //运动
                    if ([mainCell isKindOfClass:[RXMotionTableViewCell class]]) {
                        RXMotionTableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:@"RXMotionTableViewCell"];
                        if(!cell){
                            cell = [[RXMotionTableViewCell alloc]initWithStyle:0 reuseIdentifier:@"RXMotionTableViewCell"];
                        }
                        cell.separatorInset = UIEdgeInsetsMake(0,kScreenWidth, 0, 0);
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                        return cell;
                    }
                    //血压
                    if([mainCell isKindOfClass:[RXBloodPressureTableViewCell class]]){
                        if ([[RXTabViewHeightObjject getItemCodeNumber:self.dataArray[indexPath.section-1]] isEqualToString:@"血压"]) {
                            static  NSString *reusstring = @"RXBloodPressureTableViewCell";
                            RXBloodPressureTableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:reusstring];
                            if (cell==nil) {
                                cell=[[RXBloodPressureTableViewCell alloc]initWithStyle:0 reuseIdentifier:@"RXBloodPressureTableViewID1"];
                            }
                            cell.separatorInset = UIEdgeInsetsMake(0,kScreenWidth, 0, 0);
                            cell.selectionStyle = UITableViewCellSelectionStyleNone;
                            NSMutableDictionary*dic=self.dataArray[indexPath.section-1];
                            cell.titlelabel.text=[Unit JSONString:dic key:@"testgrade"];
                            cell.titlelabel.textColor=JGColor(51, 51, 51, 1);
                            cell.jiankanglabel.text=[Unit JSONString:dic key:@"suggest"];
                            cell.jiankanglabel.textColor=JGColor(102, 102, 102, 1);
                            if (cell.jiankanglabel.text.length>0) {
                                cell.jiankanglabel.numberOfLines = 4;
                                [cell.jiankanglabel setRowSpace:10];
                            }
                            cell.jiankangTitle.text=[Unit JSONString:dic key:@"title"];
                            NSMutableDictionary*keyValue=[Unit ParseJSONObject:dic[@"keyValue"]];
                            cell.shoushuiNumberlabel.text=keyValue[@"lowValue"];
                            cell.shuzhangNumberlabel.text=keyValue[@"highValue"];
                            
                            //
                            //                            float lowValue=[keyValue[@"lowValue"] floatValue]/200.0;
                            //                            float hightValue=[keyValue[@"highValue"] floatValue]/200.0;
                            
                            //                        cell.showWaiImageWight.constant=cell.shouBackImage.frame.size.width*lowValue;;
                            
                            
                            //                    cell.showWaiImageWight.constant=cell.shouBackImage.frame.size.width*lowValue;
                            
                            //          cell.shouWaiImage.frame=CGRectMake(cell.shouWaiImage.frame.origin.x,cell.shouWaiImage.frame.origin.y,341,cell.shouWaiImage.frame.size.height);
                            //                cell.shuzhangWaiImage.frame=CGRectMake(cell.shuzhangWaiImage.frame.origin.x,cell.shuzhangWaiImage.frame.origin.y,cell.shouBackImage.frame.size.width*hightValue,cell.shuzhangWaiImage.frame.size.height);
                            return cell;
                        }
                        //体重
                        if ([[RXTabViewHeightObjject getItemCodeNumber:self.dataArray[indexPath.section-1]] isEqualToString:@"体重"]) {
                            static  NSString *reusstring = @"RXBloodPressureTableViewCell";
                            NSMutableDictionary*dic=self.dataArray[indexPath.section-1];
                            RXBloodPressureTableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:reusstring];
                            if (cell==nil) {
                                cell=[[RXBloodPressureTableViewCell alloc]initWithStyle:0 reuseIdentifier:@"RXBloodPressureTableViewID2"];
                            }
                            cell.separatorInset = UIEdgeInsetsMake(0,kScreenWidth, 0, 0);
                            cell.selectionStyle = UITableViewCellSelectionStyleNone;
                            cell.twoNamelabel.text=@"体重";
                            cell.twojiangTitle.text=[Unit JSONString:dic key:@"title"];
                            cell.twojianglabel.text=[Unit JSONString:dic key:@"suggest"];
                            cell.twojianglabel.textColor=JGColor(51, 51, 51, 1);
                            cell.twojianglabel.textColor=JGColor(102, 102, 102, 1);
                            if (cell.twojianglabel.text.length>0) {
                                cell.twojianglabel.numberOfLines = 4;
                                [cell.twojianglabel setRowSpace:10];
                            }
                            NSMutableDictionary*keyValue=[Unit ParseJSONObject:dic[@"keyValue"]];
                            cell.twoxueNumberlabel.text=[Unit JSONString:keyValue key:@"inValue"];
                            cell.separatorInset = UIEdgeInsetsMake(0,kScreenWidth, 0, 0);
                            cell.selectionStyle = UITableViewCellSelectionStyleNone;
                            return cell;
                        }
                        //血糖
                        if ([[RXTabViewHeightObjject getItemCodeNumber:self.dataArray[indexPath.section-1]] isEqualToString:@"血糖"]) {
                            NSMutableDictionary*dic=self.dataArray[indexPath.section-1];
                            static  NSString *reusstring = @"RXBloodPressureTableViewCell";
                            RXBloodPressureTableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:reusstring];
                            if (cell==nil) {
                                cell=[[RXBloodPressureTableViewCell alloc]initWithStyle:0 reuseIdentifier:@"RXBloodPressureTableViewID2"];
                            }
                            cell.twoNamelabel.text=@"血糖";
                            cell.twojiangTitle.text=[Unit JSONString:dic key:@"title"];
                            cell.twojianglabel.text=[Unit JSONString:dic key:@"suggest"];
                            cell.twojianglabel.textColor=JGColor(51, 51, 51, 1);
                            cell.twojianglabel.textColor=JGColor(102, 102, 102, 1);
                            if (cell.twojianglabel.text.length>0) {
                                cell.twojianglabel.numberOfLines = 4;
                                [cell.twojianglabel setRowSpace:10];
                            }
                            NSMutableDictionary*keyValue=[Unit ParseJSONObject:dic[@"keyValue"]];
                            cell.twoxueNumberlabel.text=[Unit JSONString:keyValue key:@"inValue"];
                            cell.separatorInset = UIEdgeInsetsMake(0,kScreenWidth, 0, 0);
                            cell.selectionStyle = UITableViewCellSelectionStyleNone;
                            return cell;
                        }
                        //血脂
                        if ([[RXTabViewHeightObjject getItemCodeNumber:self.dataArray[indexPath.section-1]] isEqualToString:@"血脂"]) {
                            static  NSString *reusstring = @"RXBloodPressureTableViewCell";
                            RXBloodPressureTableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:reusstring];
                            if (cell==nil) {
                                cell=[[RXBloodPressureTableViewCell alloc]initWithStyle:0 reuseIdentifier:@"RXBloodPressureTableViewID3"];
                            }
                            cell.separatorInset = UIEdgeInsetsMake(0,kScreenWidth, 0, 0);
                            cell.selectionStyle = UITableViewCellSelectionStyleNone;
                            return cell;
                        }
                    }
                    //血氧
                    if ([[RXTabViewHeightObjject getItemCodeNumber:self.dataArray[indexPath.section-1]] isEqualToString:@"血氧"]) {
                        if ([mainCell isKindOfClass:[RXMotionTableViewCell class]]) {
                            RXMotionTableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:@"RXMotionTableViewCell"];
                            if(!cell){
                                cell = [[RXMotionTableViewCell alloc]initWithStyle:0 reuseIdentifier:@"RXMotionTableViewCell"];
                            }
                            cell.separatorInset = UIEdgeInsetsMake(0,kScreenWidth, 0, 0);
                            cell.selectionStyle = UITableViewCellSelectionStyleNone;
                            return cell;
                        }
                    }
                    //体脂率
                    if ([[RXTabViewHeightObjject getItemCodeNumber:self.dataArray[indexPath.section-1]] isEqualToString:@"体脂率"]) {
                        if ([mainCell isKindOfClass:[RXMotionTableViewCell class]]) {
                            RXMotionTableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:@"RXMotionTableViewCell"];
                            if(!cell){
                                cell = [[RXMotionTableViewCell alloc]initWithStyle:0 reuseIdentifier:@"RXMotionTableViewCell"];
                            }
                            cell.separatorInset = UIEdgeInsetsMake(0,kScreenWidth, 0, 0);
                            cell.selectionStyle = UITableViewCellSelectionStyleNone;
                            return cell;
                        }
                    }
                    
                    //血尿酸
                    if ([[RXTabViewHeightObjject getItemCodeNumber:self.dataArray[indexPath.section-1]] isEqualToString:@"血尿酸"]) {
                        if ([mainCell isKindOfClass:[RXMotionTableViewCell class]]) {
                            RXMotionTableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:@"RXMotionTableViewCell"];
                            if(!cell){
                                cell = [[RXMotionTableViewCell alloc]initWithStyle:0 reuseIdentifier:@"RXMotionTableViewCell"];
                            }
                            cell.separatorInset = UIEdgeInsetsMake(0,kScreenWidth, 0, 0);
                            cell.selectionStyle = UITableViewCellSelectionStyleNone;
                            return cell;
                        }
                    }
                }
                //咨询
                if (indexPath.row==1) {
                    if (self.paramResponse.invitationList.count>0) {
                        NSMutableDictionary*dic;
                        static  NSString *reusstring = @"RXHealthyTableViewCell";
                        RXHealthyTableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:reusstring];
                        if (cell==nil) {
                            cell=[[NSBundle mainBundle]loadNibNamed:@"RXHealthyTableViewCell" owner:self options:nil][1];
                        }
                        if (self.paramResponse.invitationList.count>0) {
                            dic=self.response.invitationList[0];
                            [cell.twoIconimage sd_setImageWithURL:[NSURL URLWithString:self.paramResponse.invitationList[0][@"headImgPath"]]];
                            cell.twoConterlabel.text=self.paramResponse.invitationList[0][@"content"];
                        }
                        cell.separatorInset = UIEdgeInsetsMake(0,kScreenWidth, 0, 0);
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                        return cell;
                    }
                }
                //健康商品
                if (indexPath.row==2) {
                    RXShoppingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RXShoppingTableViewCell"];
                    if (cell == nil) {
                        cell = [[RXShoppingTableViewCell alloc] initWithStyle:UITableViewCellSelectionStyleNone reuseIdentifier:@"RXShoppingTableViewCell"];
                    }
                    cell.keywordGoodsList=[NSMutableArray arrayWithArray:self.paramResponse.keywordGoodsList];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    return cell;
                }
            }
        }
    }
    if (indexPath.section==self.dataArray.count+1+1) {
        static  NSString *reusstring = @"RXTravelTableViewCell";
        NSDictionary*dic;
        if (indexPath.row==0) {
            if (self.othersArray.count>0) {
                dic=self.othersArray[0];
            }else{
              return  [[UITableViewCell alloc]init];
            }
        }
        if (indexPath.row==1) {
            if (self.healthServiceRecommendBgBOArray.count>0) {
                dic=self.healthServiceRecommendBgBOArray[0];
            }else{
                return  [[UITableViewCell alloc]init];
            }
        }
        if (indexPath.row==2) {
            if (self.healthServiceRecommendJdBOArray.count>0) {
                dic=self.healthServiceRecommendJdBOArray[0];
            }else{
                return  [[UITableViewCell alloc]init];
            }
        }
        if (indexPath.row==3) {
            if (self.healthServiceRecommendXyBOArray.count>0) {
              dic=self.healthServiceRecommendXyBOArray[0];
            }else{
                return  [[UITableViewCell alloc]init];
            }
        }
        RXTravelTableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:reusstring];
        if (cell==nil) {
            if (indexPath.row==0) {
                  cell=[[NSBundle mainBundle]loadNibNamed:@"RXTravelTableViewCell" owner:self options:nil][1];
            }else{
                cell=[[NSBundle mainBundle]loadNibNamed:@"RXTravelTableViewCell" owner:self options:nil][0];
            }
        }
        cell.backgroundColor=[UIColor whiteColor];
        if (indexPath.row==0) {
            cell.twoTitlelabel.text=dic[@"title"];
//            cell.twoConterlabel
            cell.twoWenTilabel.text=dic[@"introduction"];
        }else{
            cell.titlelabel.text=dic[@"title"];
        }
        if (indexPath.row==1) {
            [cell.travelImage sd_setImageWithURL:[NSURL URLWithString:self.response.bgImg]];
        }
        if (indexPath.row==2) {
            [cell.travelImage sd_setImageWithURL:[NSURL URLWithString:self.response.jdImg]];
        }
        if (indexPath.row==3) {
            [cell.travelImage sd_setImageWithURL:[NSURL URLWithString:self.response.xyImg]];
        }
        cell.separatorInset = UIEdgeInsetsMake(0,kScreenWidth, 0, 0);
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;

    }else if (indexPath.section==self.dataArray.count+1+2) {
        YSHealthTaskTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"healthtaskcellid"];
        if (cell == nil) {
            cell = [[YSHealthTaskTableViewCell alloc] initWithStyle:UITableViewCellSelectionStyleNone reuseIdentifier:@"healthtaskcellid"];
            //设置你的cell
        }
        cell.models = [HealthyManageData taskDatasWithTaskList:self.taskList];
        cell.delegate = self;
        cell.addTask = ^{
            YSHealthyManageWebController *testWebController = [[YSHealthyManageWebController alloc] initWithWebType:YSHealthyManageAddTaskType uid:self.userCustome.uid];
            [self.navigationController pushViewController:testWebController animated:YES];
        };
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else if(indexPath.section==self.dataArray.count+1+3){
        YSJijfenrenwTableVIewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"jirirenwucellid"];
        if (cell == nil) {
            cell = [[YSJijfenrenwTableVIewCell alloc] initWithStyle:UITableViewCellSelectionStyleNone reuseIdentifier:@"jirirenwucellid"];
            //设置你的cell
        }
        if (self.userIntegral==nil) {
            cell.integral=nil;
        } else {
            cell.integral=_userIntegral;
        }
        cell.models = self.intergralListArrayData;
        cell.delegate = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else if(indexPath.section==self.dataArray.count+1+4){
        static  NSString *reusstring = @"RXAdvertisingTableViewCell";
        RXAdvertisingTableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:reusstring];
        if (cell==nil) {
            cell=[[[NSBundle mainBundle]loadNibNamed:@"RXAdvertisingTableViewCell" owner:self options:nil]firstObject];
        }
//        if (self.response.adContentBO.count>0) {
//            NSMutableDictionary*dic=self.response.adContentBO[0];
//            NSArray*adContent=dic[@"adContent"];
//            NSDictionary*dd=adContent[0];
//            [cell.back_image sd_setImageWithURL:[NSURL URLWithString:dd[@"pic"]]];
//        }
        cell.separatorInset = UIEdgeInsetsMake(0,kScreenWidth, 0, 0);
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;

    } else if(indexPath.section==self.dataArray.count+1+5){
        NSMutableDictionary*dic;
        static  NSString *reusstring = @"RXHealthyTableViewCell";
        RXHealthyTableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:reusstring];
        if (cell==nil) {
            cell=[[[NSBundle mainBundle]loadNibNamed:@"RXHealthyTableViewCell" owner:self options:nil]firstObject];
        }
        if (self.response.invitationList.count>0) {
            dic=self.response.invitationList[0];
            [cell.iconimage sd_setImageWithURL:[NSURL URLWithString:dic[@"headImgPath"]]];
            cell.conterlabel.text=dic[@"content"];
        }
        cell.separatorInset = UIEdgeInsetsMake(0,kScreenWidth, 0, 0);
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else if(indexPath.section==self.dataArray.count+1+6){
       RXShoppingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RXShoppingTableViewCell"];
        if (cell == nil) {
            cell = [[RXShoppingTableViewCell alloc] initWithStyle:UITableViewCellSelectionStyleNone reuseIdentifier:@"RXShoppingTableViewCell"];
        }
        cell.keywordGoodsList=[NSMutableArray arrayWithArray:self.response.keywordGoodsList];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    UITableViewCell*cell=[[UITableViewCell alloc]init];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section==self.dataArray.count+1+1) {
        NSDictionary*dic;
        if (indexPath.row==0) {
            if (self.othersArray.count>0) {
                dic=self.othersArray[0];
            }
        }
        if (indexPath.row==1) {
            if (self.healthServiceRecommendBgBOArray.count>0) {
                dic=self.healthServiceRecommendBgBOArray[0];
            }
        }
        if (indexPath.row==2) {
            if (self.healthServiceRecommendJdBOArray.count>0) {
                dic=self.healthServiceRecommendJdBOArray[0];
            }
        }
        if (indexPath.row==3) {
            if (self.healthServiceRecommendXyBOArray.count>0) {
                dic=self.healthServiceRecommendXyBOArray[0];
            }
        }
        YSLinkCYDoctorWebController *cyDoctorController = [[YSLinkCYDoctorWebController alloc] initWithWebUrl:@"http://192.168.8.164:8082/carnation-apis-resource/resources/jkgl/report.html"];
        cyDoctorController.navTitle =dic[@"title"];
        cyDoctorController.tag = 100;
        cyDoctorController.controllerPushType = YSControllerPushFromHealthyManagerType;
        [self.navigationController pushViewController:cyDoctorController animated:YES];
    }
}

//cell个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (self.dataArray.count>0) {
        if (section-1<self.dataArray.count+1) {
            if (section-1==self.dataArray.count) {
                return 0;
            }
            return [RXTabViewHeightObjject getTabviewNumber:self.dataArray[section-1] with:self.paramResponse];
        }
    }
    if (section==self.dataArray.count+1+1) {
        return 4;
    }
    if (section==self.dataArray.count+1+4) {
         return self.advertisingArray.count;
    }
    if (section==self.dataArray.count+1+5) {
       return self.response.invitationList.count;
    }
    if(section==self.dataArray.count+1+6){
        if (self.response.keywordGoodsList.count>0) {
            return 1;
        }
        return 0;
    }
    return 1;
}
//cell 高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.dataArray.count>0) {
        if (indexPath.section-1<self.dataArray.count+1){
            //其他更多无展开
            if (indexPath.section-1==self.dataArray.count){
                return 0;
            }
            if(indexPath.row==0){
                return [RXTabViewHeightObjject getTabViewHeight:self.dataArray[indexPath.section-1]];
            }
            //咨询
            if (self.paramResponse.invitationList.count>0) {
                if (indexPath.row==1) {
                    return 125+85.0/2;
                }
            }else{
                 return 0;
            }
            //商品推荐
            if (self.paramResponse.keywordGoodsList.count>0) {
                if (indexPath.row==2) {
                    return 280;
                }
            }else{
                 return 0;
            }
        }
    }
    if (indexPath.section==self.dataArray.count+1+1) {

        if (indexPath.row==0) {
            if (self.othersArray.count>0) {
                return 200;
            }
            return 0;
        }
        if (indexPath.row==1) {
            if (self.healthServiceRecommendBgBOArray.count>0) {
                return 200;
            }
            return 0;
        }
        if (indexPath.row==2) {
            if (self.healthServiceRecommendJdBOArray.count>0) {
                return 200;
            }
            return 0;
        }
        if (indexPath.row==3) {
            if (self.healthServiceRecommendXyBOArray.count>0) {
                return 160;
            }
            return 0;
        }
    }
    if (indexPath.section==self.dataArray.count+1+2) {
        if (self.taskList.result) {
            if (self.taskList.successCode) {
                if (self.taskList.healthTaskList.count) {
                    return 140.0;
                }else {
                    return kHealthyTaskCellHeight(140);
                }
            }else {
                return kHealthyTaskCellHeight(140);
            }
        }else{
            return kHealthyTaskCellHeight(140);
        }
    }
    if (indexPath.section==self.dataArray.count+1+3) {
         return 180;
    }
    if (indexPath.section==self.dataArray.count+1+4) {
//        if (self.response.adContentBO.count>0) {
//            NSMutableDictionary*dic=self.response.adContentBO[0];
//            return [Unit JSONDouble:dic key:@"adHeight"];
//        }
        return 0;
    }
    if (indexPath.section==self.dataArray.count+1+5) {
        return 125;
    }
    if (indexPath.section==self.dataArray.count+1+6) {
        return 280;
    }
    return 0;
}
/**个人信息**/
-(void)getRequest;{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    RXUserDetailRequest*request=[[RXUserDetailRequest alloc]init:GetToken];
    VApiManager *manager = [[VApiManager alloc]init];
    self.othersArray=[[NSMutableArray alloc]init];
    self.advertisingArray=[[NSMutableArray alloc]init];
    [manager RXMakeUserDetail:request
                      success:^(AFHTTPRequestOperation *operation, RXUserDetailResponse *response) {
                          
            dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0/*延迟执行时间*/ * NSEC_PER_SEC));
            dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                  [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            });
            if (!self.freeCollectionView) {
                [self.freeCollectionView p_dismissView];
                self.freeCollectionView=nil;
            }
            [self.healthServiceRecommendXyBOArray removeAllObjects];
            [self.healthServiceRecommendBgBOArray removeAllObjects];
            [self.healthServiceRecommendJdBOArray removeAllObjects];
            [self.othersArray removeAllObjects];
            [self.advertisingArray removeAllObjects];
            if (!self.response) {
                self.response=[[RXUserDetailResponse alloc]init];
            }
            self.response = response;
            if ([self.response.memberNotice isEqualToString:@"1"]) {
                self.freeCollectionView=[[RXFreeCollectionView alloc]init];
                [self.freeCollectionView showView:@"健康管家，定时监测您的身体状态，打造专属健康服务。点击领取即可免费使用1年" with:self with:@selector(freeCollectViewButton)];
            }
            //3种不同服务
            if (self.response.healthServiceRecommendXyBO) {
                [self.healthServiceRecommendXyBOArray addObject:self.response.healthServiceRecommendXyBO];
            }
            if (self.response.healthServiceRecommendBgBO) {
                [self.healthServiceRecommendBgBOArray addObject:self.response.healthServiceRecommendBgBO];
            }
            if (self.response.healthServiceRecommendJdBO) {
                [self.healthServiceRecommendJdBOArray addObject:self.response.healthServiceRecommendJdBO];
            }
            //完美档案
            if (self.response.others) {
                self.othersArray=[NSMutableArray arrayWithArray:self.response.others];
            }
            //广告位
            if (self.response.adContentBO) {
                self.advertisingArray=[NSMutableArray arrayWithArray:self.response.adContentBO];
            }
            if (self.response.healthList.count>0) {
                [self.dataArray removeAllObjects];
                for (NSDictionary*dic in self.response.healthList) {
                    NSMutableDictionary*dic1=[[NSMutableDictionary alloc]initWithDictionary:dic];
                    [dic1 setObject:[NSNumber numberWithBool:false] forKey:@"mySelectType"];
                    [dic1 setObject:[NSNumber numberWithBool:false] forKey:@"myZhankaiType"];
                    [self.dataArray addObject:dic1];
                }
            }
           [self.mtableview reloadData];
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
         [self.mtableview reloadData];
    }];
}
//领取会员
-(void)freeCollectViewButton;{
//    /v1/hp/getMemberDetail
}

@end
