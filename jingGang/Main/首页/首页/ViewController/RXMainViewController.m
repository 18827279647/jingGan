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

//提示框
#import "TBAlertController.h"

#import "RXWeekViewController.h"
#import "RXWebViewController.h"
#import "RXWmViewController.h"
#import "YSHealthAIOController.h"
#import "RXLISHIViewController.h"
#import "RXMoreWebViewController.h"


//获取h5
#import "RXUserH5UrlResponse.h"
#import "NSDate+ChineseDay.h"

//引导页
#import "RXGuideManager.h"

#import "WebDayVC.h"


static NSString *goodsCellID = @"goodsCellID";
static NSString *heathInfoCellID = @"RXHotInfoTableViewCell";

//默认有12个分组，根据数据添加,
#define headIndex 8

@interface RXMainViewController ()<YSAPIManagerParamSource,YSAPICallbackProtocol,YSHealthManageHeaderViewDelegate,UICollectionViewDelegate,TZImagePickerControllerDelegate,UITableViewDelegate,UITableViewDataSource,shopinageDelegate>

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

@property(nonatomic,strong)NSTimer*MjTimer;


@property(nonatomic,assign)double myKaluli;
@property(nonatomic,assign)double myGongli;
@property(nonatomic,assign)int myStep;

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
        
        //[MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
       // [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
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
//
//    [self hiddenHud];
//    [self showHud];
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
//        [self hiddenHud];
    } fail:^{
        @strongify(self);
//        [self hiddenHud];
        self.userCustome.successCode = 0;
        self.questionnaire.successCode = 0;
        self.taskList.successCode = 0;
        [self tableViewReloadDate];
    } error:^{
        @strongify(self);
//        [self hiddenHud];
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
//        [self hiddenHud];
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
//        [self hiddenHud];
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
    [self.dataArray addObject:@{@"itemName":@"运动",@"mySelectType":@"false",@"myZhankaiType":@"false",@"itemCode":@12}];
    [self.dataArray addObject:@{@"itemName":@"血压",@"mySelectType":@"false",@"myZhankaiType":@"false",@"itemCode":@4}];
    [self.dataArray addObject:@{@"itemName":@"血糖",@"mySelectType":@"false",@"myZhankaiType":@"false",@"itemCode":@9}];
    [self.dataArray addObject:@{@"itemName":@"体重",@"mySelectType":@"false",@"myZhankaiType":@"false",@"itemCode":@16}];
    self.view.backgroundColor = [UIColor whiteColor];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"kUserDidLoadMainController" object:nil];
    });
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getRequest) name:@"manualTestNotification" object:nil];
    //设置引导页
    [self showPageView];
    //设置运动，并上传数据，避免后台崩溃
    [self setYunDong];
    
    [self getRequest];
}
-(void)setYunDong;{
    if ([YSStepManager healthyKitAccess]) {
        @weakify(self);
        [YSStepManager healthStoreDataWithStartDate:nil endDate:nil WithFailAccess:^{
            @strongify(self);
            [self showErrorHudWithText:@"无运动数据获取权限"];
            NSMutableDictionary*dic=[[NSMutableDictionary alloc]init];
            [dic setObject:[NSString stringWithFormat:@"%d",0] forKey:@"inValue"];
            [self getRuest:dic];
        } walkRunningCallback:^(NSNumber *walkRunning) {
        } stepCallback:^(NSNumber *step) {
            if ([step intValue]==0) {
                self.myStep= [step intValue];
                self.myGongli=[step doubleValue] * 0.00065;
                self.myKaluli=62*self.myGongli*0.8;
            }else{
                self.myStep= [step intValue];
                self.myGongli=[step doubleValue] * 0.00065;
                self.myKaluli=62*self.myGongli*0.8;
                [self.mtableview reloadData];
            }
            NSMutableDictionary*dic=[[NSMutableDictionary alloc]init];
            [dic setObject:[NSString stringWithFormat:@"%d",self.myStep] forKey:@"inValue"];
            [self getRuest:dic];
        }];
    }
}

-(void)getRuest:(NSMutableDictionary*)paramJson;{
    
    [paramJson setObject:@"3" forKey:@"type"];
    //提交数据
    RXSubmitDataRequest*request=[[RXSubmitDataRequest alloc]init:GetToken];
    request.paramCode=12;
    request.paramJson=[self dictionaryToJson:paramJson];
    VApiManager *manager = [[VApiManager alloc]init];
    [manager RXSubmitDataRequest:request success:^(AFHTTPRequestOperation *operation, RXSubmitDataResponse *response) {
        [self hideAllHUD];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self hideAllHUD];
    }];
}
#pragma mark 字典转化字符串
-(NSString*)dictionaryToJson:(NSMutableDictionary *)dic
{
    NSString *jsonString = nil;
    NSError *error;
    if (dic == nil) {
        return jsonString;
    }
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    if (! jsonData) {
        
    } else {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    return jsonString;
}

//设置引导页
-(void)showPageView;{
    // 判断是否已显示过
    if (![[NSUserDefaults standardUserDefaults] boolForKey:RXGuidePageHomeKey]) {
        CRUserSetBOOL(YES, RXGuidePageHomeKey);
        // 显示
        [[RXGuideManager shareManager] showGuidePageWithType:RXGuidePageTypeHome completion:^{
            [[RXGuideManager shareManager]showGuidePageWithType:RXGuidePageTypeMajor completion:^{
                [[RXGuideManager shareManager]showGuidePageWithType:RXGuidePageTypeThree completion:^{
                    [[RXGuideManager shareManager]showGuidePageWithType:RXGuidePageTypeFive];
                }];
            }];
        }];
    }
}
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
    
    [_mtableview registerClass:[YSHotInfoTableViewCell class] forCellReuseIdentifier:heathInfoCellID];
    
    self.mtableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self getRequest];
    }];

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
    
    
//    //商品推荐
//    [self _requestGoodsShowcaseGoodsDataWithCaseID];
//    @weakify(self);
////    [self showHud];
//    self.pageNum = 1;
//    [YSHealthyMessageDatas healthyMessageMostDaysSuccess:^(NSArray *datas) {
//        @strongify(self);
//        [self.InfosModels removeAllObjects];
//        [self.InfosModels xf_safeAddObjectsFromArray:datas];
//        [self.mtableview reloadData];
////        [self hiddenHud];
//    } fail:^{
//        @strongify(self);
////        [self hiddenHud];
//    } pageNumber:self.pageNum];
    
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
            
    
            @weakify(self);
            [YSBaseInfoManager loadBaseInfo:^(NSString *city, YSWeatherInfo *weatherInfo) {
                @strongify(self);
               // NSString *dateText = [NSDate getChineseCalendarWithDate:[NSDate date]];
                if (weatherInfo) {
                    self.rxBaseInfoView.wearherLable.text = [NSString stringWithFormat:@"今天  %@  %@",weatherInfo.weather,weatherInfo.temperature];
                    self.rxBaseInfoView.weatherImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"weatherStatus%02ld",[weatherInfo.weatherTag integerValue]]];
                }else {
                    weatherInfo = [[YSWeatherInfo alloc] init];
                    weatherInfo.temperature = @"20℃";
                    weatherInfo.weather = @"晴天";
                    weatherInfo.weatherTag =  @"0";
                    self.rxBaseInfoView.wearherLable.text = [NSString stringWithFormat:@"今天  %@  %@",weatherInfo.weather,weatherInfo.temperature];
                    self.rxBaseInfoView.weatherImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"weatherStatus%02ld",[weatherInfo.weatherTag integerValue]]];
                }
            }];
        
        }
        self.rxBaseInfoView.yichangBottom.constant=0;
        self.rxBaseInfoView.yichangbackImage.hidden=YES;
        self.rxBaseInfoView.yichangImage.hidden=YES;
        self.rxBaseInfoView.yichanglabel.hidden=YES;
        
        if (self.response) {
            if (self.response.hasHealth==1) {
                self.rxBaseInfoView.yichangBottom.constant=50;
                self.rxBaseInfoView.yichangbackImage.hidden=NO;
                self.rxBaseInfoView.yichangImage.hidden=NO;
                self.rxBaseInfoView.yichanglabel.hidden=NO;
                self.rxBaseInfoView.yichanglabel.textColor=JGColor(255, 130, 46, 1);
                self.rxBaseInfoView.yichanglabel.font=JGFont(13);
                self.rxBaseInfoView.yichangbackImage.backgroundColor=[UIColor colorWithRed:255/255.0 green:253/255.0 blue:246/255.0 alpha:1.0];
            }
            //姓名
            self.rxBaseInfoView.nameLabel.text=self.response.healthUserBO[@"nickName"]?self.response.healthUserBO[@"nickName"]:@"--";
            self.rxBaseInfoView.nameLabel.font=JGFont(14);
            //头像
            [self.rxBaseInfoView.iconImage sd_setImageWithURL:[NSURL URLWithString:self.response.healthUserBO[@"headImage"]]];
            //年龄
            self.rxBaseInfoView.ageLabel.text=self.response.healthUserBO[@"age"]?self.response.healthUserBO[@"age"]:@"--";
            //性别
            int sexage=[self.response.healthUserBO[@"sex"] intValue];
            self.rxBaseInfoView.sexLabel.text=sexage==1?@"男":@"女";
            //身高
            self.rxBaseInfoView.heightLabel.text=self.response.healthUserBO[@"height"]?self.response.healthUserBO[@"height"]:@"--";
            if (![self.response.healthUserBO[@"height"] isEqualToString:@"--"]) {
                 [[NSUserDefaults standardUserDefaults] setObject:self.response.healthUserBO[@"height"] forKey:@"_sbHeight"];
            }else{
                 [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"_sbHeight"];
            }
            //体重
            self.rxBaseInfoView.weghtlabel.text=self.response.healthUserBO[@"weight"]?self.response.healthUserBO[@"weight"]:@"--";
            //说明
            self.rxBaseInfoView.shuoMingLabel.text=[NSString stringWithFormat:@"   %@     ",self.response.messageTitle?self.response.messageTitle:@"--"];
            self.rxBaseInfoView.shuoMingLabel.font=JGFont(10);
            self.rxBaseInfoView.shuoMingLabel.backgroundColor=JGColor(73, 140, 122,0.5);
            
            self.rxBaseInfoView.vipLabel.textColor=[UIColor whiteColor];
            self.rxBaseInfoView.vipLabel.font=JGFont(12);
            if (self.response.isMember!=1) {
                self.rxBaseInfoView.vipLabel.text=@"您的健康管家VIP已到期";
            }else{
                self.rxBaseInfoView.vipLabel.text=[NSString stringWithFormat:@"%@到期",self.response.offTime];
            }
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
            if ([Unit JSONInt:dic key:@"execption"]==1) {
                imageView.layer.backgroundColor = [UIColor colorWithRed:255/255.0 green:253/255.0 blue:246/255.0 alpha:1.0].CGColor;
            }else{
                imageView.layer.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0].CGColor;
            }
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
                make.left.equalTo(shuominglabel.mas_right).offset(5);
            }];
            danweilabel.hidden=YES;
            
            //是否正常
            UILabel*typelabel=[[UILabel alloc]init];
            typelabel.frame=CGRectMake(30,myheight+24+10,40,20);
            [rxheadView addSubview:typelabel];
            
            //时间
            UILabel*timelabel=[[UILabel alloc]init];
            timelabel.frame=CGRectMake(kScreenWidth-20-50,myheight+24+10,50,20);
            timelabel.textColor=JGColor(170, 170, 170, 1);
            timelabel.font=JGFont(12);
            timelabel.textAlignment=NSTextAlignmentRight;
            [rxheadView addSubview:timelabel];
            
            //来源
            UILabel*laiyuanlabel=[[UILabel alloc]init];
            [rxheadView addSubview:laiyuanlabel];
            [laiyuanlabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.mas_equalTo(typelabel.mas_centerY);
                make.left.equalTo(itemNamelabel.mas_right).offset(20);
            }];
            laiyuanlabel.hidden=YES;
            timelabel.hidden=YES;
            typelabel.hidden=YES;
            
            if ([[RXTabViewHeightObjject getItemCodeNumber:dic] isEqualToString:@"运动"]){
                if (self.myStep!=0) {
                    shuominglabel.textColor=JGColor(101, 187, 177, 1);
                    [shuominglabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:17]];
                    shuominglabel.text=[NSString stringWithFormat:@"%d",self.myStep];
                    self.myGongli=self.myStep * 0.00065;
                    self.myKaluli=62*self.myGongli*0.8;
                    danweilabel.hidden=NO;
                    danweilabel.text=@"步";
                    danweilabel.textColor=JGColor(136, 136, 136, 1);
                    danweilabel.font=JGFont(12);
                }else{
                    shuominglabel.text=@"--";
                }
            }else{
                if (keyValue.count>0) {
                    //当有数据时统一配置
                    if ([Unit JSONInt:dic key:@"execption"]==1) {
                        typelabel.hidden=NO;
                        typelabel.text=[NSString stringWithFormat:@" %@ ",[Unit JSONString:dic key:@"testgrade"]];
                        typelabel.frame=CGRectMake(30,myheight+24+10,12*typelabel.text.length,20);
                        typelabel.font=JGFont(12);
                        typelabel.textColor=JGColor(239, 82, 80, 1);
                        typelabel.backgroundColor=JGColor(252, 238, 233, 1);
                        typelabel.layer.masksToBounds=YES;
                        typelabel.layer.cornerRadius=10;
                        typelabel.textAlignment=1;
                    }
                    if ([Unit JSONString:dic key:@"timeName"].length>0) {
                        timelabel.hidden=NO;
                        timelabel.text=[Unit JSONString:dic key:@"timeName"];
                    }
                    laiyuanlabel.hidden=NO;
                    laiyuanlabel.textColor=JGColor(153, 153, 153, 1);
                    laiyuanlabel.font=JGFont(12);
                    if ([Unit JSONInt:keyValue key:@"type"]==0) {
                        laiyuanlabel.text=[NSString stringWithFormat:@"来源:健康一体机录入"];
                    }else if ([Unit JSONInt:keyValue key:@"type"]==1) {
                        laiyuanlabel.text=[NSString stringWithFormat:@"来源:手动录入"];
                    }else if ([Unit JSONInt:keyValue key:@"type"]==2) {
                        laiyuanlabel.text=[NSString stringWithFormat:@"来源:智能硬件录入"];
                    }else if ([Unit JSONInt:keyValue key:@"type"]==3) {
                        laiyuanlabel.text=[NSString stringWithFormat:@"来源:手机检测"];
                    }else{
                        laiyuanlabel.hidden=YES;
                    }
                    shuominglabel.textColor=JGColor(101, 187, 177, 1);
                    [shuominglabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:17]];
                    danweilabel.hidden=NO;
                    danweilabel.text=[Unit JSONString:dic key:@"unit"];
                    danweilabel.textColor=JGColor(136, 136, 136, 1);
                    danweilabel.font=JGFont(12);
                    
                    if ([[RXTabViewHeightObjject getItemCodeNumber:dic] isEqualToString:@"血压"]) {
                        shuominglabel.text=[NSString stringWithFormat:@"%@/%@",[Unit JSONString:keyValue key:@"highValue"],[Unit JSONString:keyValue key:@"lowValue"]];
                    }else if ([[RXTabViewHeightObjject getItemCodeNumber:dic] isEqualToString:@"血脂"]) {
                        shuominglabel.text=[NSString stringWithFormat:@"%@",[Unit JSONString:dic key:@"testgrade"]?[Unit JSONString:dic key:@"testgrade"]:@"--"];
                    }else if ([[RXTabViewHeightObjject getItemCodeNumber:dic] isEqualToString:@"体脂"]) {
                        shuominglabel.text=[NSString stringWithFormat:@"%@",[Unit JSONString:keyValue key:@"inValue"]?[Unit JSONString:keyValue key:@"inValue"]:@"--"];
                    }else if ([[RXTabViewHeightObjject getItemCodeNumber:dic] isEqualToString:@"腰臀比"]) {
                        shuominglabel.text=[NSString stringWithFormat:@"%@",[Unit JSONString:keyValue key:@"whrValue"]?[Unit JSONString:keyValue key:@"whrValue"]:@"--"];
                    }else if ([[RXTabViewHeightObjject getItemCodeNumber:dic] isEqualToString:@"视力"]) {
                        shuominglabel.text=[NSString stringWithFormat:@"%@",[Unit JSONString:keyValue key:@"lowValue"]?[Unit JSONString:keyValue key:@"lowValue"]:@"--"];
                    }else if ([[RXTabViewHeightObjject getItemCodeNumber:dic] isEqualToString:@"听力"]) {
                        shuominglabel.text=[NSString stringWithFormat:@"%@",[Unit JSONString:keyValue key:@"lowValue"]?[Unit JSONString:keyValue key:@"lowValue"]:@"--"];
                    }else{
                        shuominglabel.text=[NSString stringWithFormat:@"%@",[Unit JSONString:keyValue key:@"inValue"]?[Unit JSONString:keyValue key:@"inValue"]:@"--"];
                    }
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
            if ([RXTabViewHeightObjject getType:dic]) {
                if (keyValue.count>0){
                    addButton.frame=CGRectMake(kScreenWidth-20-20-42/2,20,42,42);
                    zhangkiaButton.frame=CGRectMake(kScreenWidth-20-20-10-42-42/2,20,42,42);
                }else{
                    addButton.hidden=YES;
                    zhangkiaButton.frame=CGRectMake(kScreenWidth-20-20-42/2,myheight-10,42,42);
                }
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
//商品列表
-(void)getKeyGoodId:(NSNumber*)goodId;{
    KJGoodsDetailViewController *goodsDetailVC = [[KJGoodsDetailViewController alloc] init];
    goodsDetailVC.goodsID = goodId;
    goodsDetailVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:goodsDetailVC animated:YES];
}

-(void)tapButtonFountion;{
    NSString*string=@"我的健康报告";
    RXWmViewController*view=[[RXWmViewController alloc]init];
    view.titlestring=string;
    view.urlstring=self.response.url;
    [self.navigationController pushViewController:view animated:NO];
}
//vip续费界面
-(void)vipButtonFounction;{
    RXbutlerServiceViewController*vc=[[RXbutlerServiceViewController alloc]init];
    [self.navigationController pushViewController:vc animated:NO];
}
//显示更多
-(void)qiTaiGengButtonFounction;{
    RXMoreDetectionViewController*vc=[[RXMoreDetectionViewController alloc]init];
    vc.url=self.response.url;
    [self.navigationController pushViewController:vc animated:NO];
}

//周报，月报
-(void)motionzhouButtonFountion:(UIButton*)button;{

    NSString*title=@"week";
    //周报
    if (button.tag==1) {
        title=@"week";
    }
    //月报
    if (button.tag==2) {
        title=@"month";
    }
    RXWeekViewController*view=[[RXWeekViewController alloc]init];
    view.type=title;
    //    view.urlstring=@"http://192.168.8.164:8082/carnation-apis-resource/resources/jkgl/weekly.html";
    view.urlstring=@"http://api.bhesky.com/resources/jkgl/weekly.html";
    [self.navigationController pushViewController:view animated:NO];
}
//历史记录
-(void)motionlishiButtonFountion:(UIButton*)button;{    
    NSMutableDictionary*dic=self.dataArray[button.tag];
    NSString*stringTitle=[RXTabViewHeightObjject getItemCodeNumber:dic];
    NSString*string=stringTitle;
    RXMoreWebViewController*view=[[RXMoreWebViewController alloc]init];
    view.titlestring=string;
    view.urlstring=@"http://api.bhesky.com/resources/jkgl/resultList.html";
    view.code=[NSString stringWithFormat:@"%d",[Unit JSONInt:dic key:@"itemCode"]];
    NSMutableArray*array=[[NSMutableArray alloc]init];
    for (NSMutableDictionary*dic in [RXTabViewHeightObjject getMorenArray]) {
        NSString*string=[RXTabViewHeightObjject getItemCodeNumber:dic];
        if ([string isEqualToString:@"听力"]||[string isEqualToString:@"视力"]||[string isEqualToString:@"肺活量"]) {
            break;
        }
        [array addObject:[Unit JSONString:dic key:@"itemName"]];
    }
    view.type=true;
    view.dataArray=[RXTabViewHeightObjject getMorenArray];
    view.titleArray=array;
    [self.navigationController pushViewController:view animated:NO];
}
//完美档案等
-(void)gengDuoButton:(UIButton*)button;{
    NSString*string=@"完美档案";
    if ([button.titleLabel.text isEqualToString:@"wm"]) {
        string=@"完美档案报告";
    }
    if ([button.titleLabel.text isEqualToString:@"jb"]) {
        string=@"综合健康数据健康解读";
    }
    if ([button.titleLabel.text isEqualToString:@"xy"]) {
        string=@"健康西游";
    }
    if([button.titleLabel.text isEqualToString:@"bg"]){
        string=@"精准检测报告";
    }
    RXWmViewController*view=[[RXWmViewController alloc]init];
    view.type=button.titleLabel.text;
    view.titlestring=string;
//    view.urlstring=@"http://192.168.8.164:8082/carnation-apis-resource/resources/jkgl/otherReport.html";
    view.urlstring=@"http://api.bhesky.com/resources/jkgl/otherReport.html";
    [self.navigationController pushViewController:view animated:NO];
}
-(void)travelLabelTap:(UITapGestureRecognizer*)tap;{
    NSInteger index=tap.view.tag;
    NSString*type=@"xy";
    NSString*string=@"完美档案";
    if (index==0) {
        string=@"完美档案报告";
        type=@"wm";
    }
    if(index==1){
        string=@"精准检测报告";
        type=@"bg";
    }
    if (index==2) {
        string=@"健康解读";
         type=@"jb";
    }
    if (index==3) {
        string=@"健康西游";
        type=@"xy";
    }
    RXWmViewController*view=[[RXWmViewController alloc]init];
    view.type=type;
    view.titlestring=string;
//    view.urlstring=@"http://192.168.8.164:8082/carnation-apis-resource/resources/jkgl/otherReport.html";
    view.urlstring=@"http://api.bhesky.com/resources/jkgl/otherReport.html";
    [self.navigationController pushViewController:view animated:NO];
}
//首页
-(void)travelImageTap;{
    RXUserH5UrlRequest*request=[[RXUserH5UrlRequest alloc]init:GetToken];
    request.code=@"4";
    VApiManager *manager = [[VApiManager alloc]init];
    [self showHUD];
    [manager RXRXUserH5UrlRequest:request
                          success:^(AFHTTPRequestOperation *operation, RXUserH5UrlResponse *response) {
          [self hideAllHUD];
          if (response.isMember==0) {
              [self showStringHUD:@"会员到期" second:0];
//              dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0/*延迟执行时间*/ * NSEC_PER_SEC));
//              dispatch_after(delayTime, dispatch_get_main_queue(), ^{
//                  RXbutlerServiceViewController*vc=[[RXbutlerServiceViewController alloc]init];
//                  [self.navigationController pushViewController:vc animated:NO];
//              });
          }else{
              NSString*string=@"我的健康报告";
              RXWmViewController*view=[[RXWmViewController alloc]init];
              view.titlestring=string;
              view.htmlstring=response.messageH5;
              [self.navigationController pushViewController:view animated:NO];
          }
      } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
          [self hideAllHUD];
          [self showStringHUD:@"网络错误" second:0];
      }];
}
-(void)travelImageTapOne;{
    YSHealthAIOController *healthAIOController = [[YSHealthAIOController alloc] init];
    healthAIOController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:healthAIOController animated:YES];
}
-(void)travelImageTapTwo;{
    
    if (self.response.isMember!=1){
        TBAlertController *controller = [TBAlertController alertControllerWithTitle:@"提示" message:@"您的健康管家服务已到期，请先续费后再查看您的专属健康报告。" preferredStyle:TBAlertControllerStyleAlert];
        TBAlertAction *clickme = [TBAlertAction actionWithTitle:@"立即续费" style: TBAlertActionStyleDestructive handler:^(TBAlertAction * _Nonnull action) {
            RXbutlerServiceViewController*vc=[[RXbutlerServiceViewController alloc]init];
            [self.navigationController pushViewController:vc animated:NO];
        }];
        TBAlertAction *cancel = [TBAlertAction actionWithTitle:@"暂不考虑" style: TBAlertActionStyleCancel handler:^(TBAlertAction * _Nonnull action) {
        }];
        [controller addAction:clickme];
        [controller addAction:cancel];
        [self presentViewController:controller animated:YES completion:nil];
    }else{
//        if([self.response.memberLastTime integerValue]==0) {
//            TBAlertController *controller = [TBAlertController alertControllerWithTitle:@"提示" message:@"您的健康管家服务已到期，请先续费后再查看您的专属健康报告。" preferredStyle:TBAlertControllerStyleAlert];
//            TBAlertAction *clickme = [TBAlertAction actionWithTitle:@"立即续费" style: TBAlertActionStyleDestructive handler:^(TBAlertAction * _Nonnull action) {
//                RXbutlerServiceViewController*vc=[[RXbutlerServiceViewController alloc]init];
//                [self.navigationController pushViewController:vc animated:NO];
//            }];
//            TBAlertAction *cancel = [TBAlertAction actionWithTitle:@"暂不考虑" style: TBAlertActionStyleCancel handler:^(TBAlertAction * _Nonnull action) {
//            }];
//            [controller addAction:clickme];
//            [controller addAction:cancel];
//            [self presentViewController:controller animated:YES completion:nil];
//        }else{
            NSMutableDictionary*dic=self.healthServiceRecommendJdBOArray[0];
            NSString*string=@"数据解读";
            RXWmViewController*view=[[RXWmViewController alloc]init];
            view.titlestring=string;
            view.htmlstring=[Unit JSONString:dic key:@"h5"];
            [self.navigationController pushViewController:view animated:NO];
//        }
    }
}
-(void)travelImageTapFree;{
    if (self.response.isMember!=1){
        TBAlertController *controller = [TBAlertController alertControllerWithTitle:@"提示" message:@"您的健康管家服务已到期，请先续费后再查看您的专属健康报告。" preferredStyle:TBAlertControllerStyleAlert];
        TBAlertAction *clickme = [TBAlertAction actionWithTitle:@"立即续费" style: TBAlertActionStyleDestructive handler:^(TBAlertAction * _Nonnull action) {
            RXbutlerServiceViewController*vc=[[RXbutlerServiceViewController alloc]init];
            [self.navigationController pushViewController:vc animated:NO];
        }];
        TBAlertAction *cancel = [TBAlertAction actionWithTitle:@"暂不考虑" style: TBAlertActionStyleCancel handler:^(TBAlertAction * _Nonnull action) {
        }];
        [controller addAction:clickme];
        [controller addAction:cancel];
        [self presentViewController:controller animated:YES completion:nil];
    }else{
//        if([self.response.memberLastTime integerValue]==0) {

//        }else{
            NSMutableDictionary*dic=self.healthServiceRecommendXyBOArray[0];
            NSString*string=@"健康西游";
            RXWmViewController*view=[[RXWmViewController alloc]init];
            view.titlestring=string;
            view.htmlstring=[Unit JSONString:dic key:@"h5"];
            [self.navigationController pushViewController:view animated:NO];
//        }
    }
}
//点击展开界面
-(void)oneOneButtonFountion:(UIButton*)button;{
    
    NSInteger index=[button.titleLabel.text integerValue];
    NSMutableDictionary*dic=self.dataArray[index-1];
    NSMutableArray*array=[RXTabViewHeightObjject getRXZhangKaiTablelViewImageArray:dic];
    NSString*string=array[button.tag];
    if ([string isEqualToString:@"智能设备"]) {
        [self showStringHUD:@"功能正在开发,请期待" second:0];
        return;
    }
    if ([[RXTabViewHeightObjject getItemCodeNumber:dic] isEqualToString:@"运动"]&&[string isEqualToString:@"手机检测"]) {
        if ([YSStepManager healthyKitAccess]) {
            @weakify(self);
            [YSStepManager healthStoreDataWithStartDate:nil endDate:nil WithFailAccess:^{
                @strongify(self);
                [self showErrorHudWithText:@"无运动数据获取权限"];
            } walkRunningCallback:^(NSNumber *walkRunning) {
            } stepCallback:^(NSNumber *step) {
                if ([step intValue]==0) {
                    [self showErrorHudWithText:@"无法获取运动数据，请检查"];
                    self.myStep= [step intValue];
                    self.myGongli=[step doubleValue] * 0.00065;
                    self.myKaluli=62*self.myGongli*0.8;
                    [self.mtableview reloadData];
                }else{
                    [self showErrorHudWithText:@"数据已经更新"];
                    self.myStep= [step intValue];
                    self.myGongli=[step doubleValue] * 0.00065;
                    self.myKaluli=62*self.myGongli*0.8;
                    [self.mtableview reloadData];
                }
            }];
        }
    }else{
        YSMultipleTypesTestController *multipleTypesTestController = [[YSMultipleTypesTestController alloc] initWithTestType:YSInputValueWithBloodPressureType];
        multipleTypesTestController.rxArray=array;
        multipleTypesTestController.rxDic=dic;
        multipleTypesTestController.rxIndex=button.tag;
        [self.navigationController pushViewController:multipleTypesTestController animated:YES];
    }
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
        [self showHUD];
        VApiManager *manager = [[VApiManager alloc]init];
        [manager RXMakeParamDetail:request success:^(AFHTTPRequestOperation *operation, RXParamDetailResponse *response) {
            [self hideAllHUD];
            if (!self.paramResponse) {
                self.paramResponse=[[RXParamDetailResponse alloc]init];
            }
            self.paramResponse=response;
            [self.mtableview reloadData];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [self hideAllHUD];
            [self showStringHUD:@"网络错误" second:0];
            [dic setObject:[NSNumber numberWithBool:false] forKey:@"mySelectType"];
            [dic setObject:[NSNumber numberWithBool:false] forKey:@"myZhankaiType"];
            [self.dataArray replaceObjectAtIndex:button.tag withObject:dic];
            [self.mtableview reloadData];
        }];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==0) {
        CGRect statusRect = [[UIApplication sharedApplication] statusBarFrame];
        int myhight=statusRect.size.height;
        if (self.response) {
            if (self.response.hasHealth==1) {
                return 270+40+myhight;
            }
            return 270+myhight;
        }
        return 270+myhight;
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

#define user_tiezi @"/circle/look_invitation?invitationId="
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
                NSMutableDictionary*dic=self.dataArray[indexPath.section-1];
                if (cell==nil) {
                    NSInteger index=[RXTabViewHeightObjject getRXZhangKaiTableViewCell:dic];
                    if (index==1) {
                        cell=[[NSBundle mainBundle]loadNibNamed:@"RXZhangKaiTableViewCell" owner:self options:nil][3];
                    }
                    if (index==2) {
                        cell=[[NSBundle mainBundle]loadNibNamed:@"RXZhangKaiTableViewCell" owner:self options:nil][2];
                    }
                    if (index==3) {
                        cell=[[NSBundle mainBundle]loadNibNamed:@"RXZhangKaiTableViewCell" owner:self options:nil][1];
                    }
                    if (index==4) {
                        cell=[[NSBundle mainBundle]loadNibNamed:@"RXZhangKaiTableViewCell" owner:self options:nil][0];
                    }
                }
                //处理显示图片
                [RXTabViewHeightObjject getButtonShowCell:cell with:dic];
                //背景
                if ([Unit JSONInt:dic key:@"execption"]==1) {
                    cell.backgroundColor = [UIColor colorWithRed:255/255.0 green:253/255.0 blue:246/255.0 alpha:1.0];
                }else{
                    cell.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0];
                }
                NSInteger index=[RXTabViewHeightObjject getRXZhangKaiTableViewCell:dic];
                if (index==1) {
                    [cell.fiveOneButton addTarget:self action:@selector(oneOneButtonFountion:) forControlEvents:UIControlEventTouchUpInside];
                    cell.fiveOneButton.titleLabel.text=[NSString stringWithFormat:@"%ld",indexPath.section];
                }else if (index==2) {
                    [cell.freeOneButton addTarget:self action:@selector(oneOneButtonFountion:) forControlEvents:UIControlEventTouchUpInside];
                    [cell.freeTwoButton addTarget:self action:@selector(oneOneButtonFountion:) forControlEvents:UIControlEventTouchUpInside];
        
                    cell.freeTwoButton.titleLabel.text=[NSString stringWithFormat:@"%ld",indexPath.section];
                    cell.freeOneButton.titleLabel.text=[NSString stringWithFormat:@"%ld",indexPath.section];
                    
                }else if (index==3) {
        
                    [cell.twoOneButon addTarget:self action:@selector(oneOneButtonFountion:) forControlEvents:UIControlEventTouchUpInside];
                    [cell.twoTwoButton addTarget:self action:@selector(oneOneButtonFountion:) forControlEvents:UIControlEventTouchUpInside];
                    [cell.twoFreeButton addTarget:self action:@selector(oneOneButtonFountion:) forControlEvents:UIControlEventTouchUpInside];
                    
                    cell.twoOneButon.titleLabel.text=[NSString stringWithFormat:@"%ld",indexPath.section];
                    cell.twoTwoButton.titleLabel.text=[NSString stringWithFormat:@"%ld",indexPath.section];
                    cell.twoFreeButton.titleLabel.text=[NSString stringWithFormat:@"%ld",indexPath.section];
    
                }else if (index==4) {
                    [cell.oneOneButton addTarget:self action:@selector(oneOneButtonFountion:) forControlEvents:UIControlEventTouchUpInside];
                    [cell.oneTwoButton addTarget:self action:@selector(oneOneButtonFountion:) forControlEvents:UIControlEventTouchUpInside];
                    [cell.oneFreeButton addTarget:self action:@selector(oneOneButtonFountion:) forControlEvents:UIControlEventTouchUpInside];
                    [cell.oneFiveButton addTarget:self action:@selector(oneOneButtonFountion:) forControlEvents:UIControlEventTouchUpInside];
                    
                    cell.oneOneButton.titleLabel.text=[NSString stringWithFormat:@"%ld",indexPath.section];
                    cell.oneTwoButton.titleLabel.text=[NSString stringWithFormat:@"%ld",indexPath.section];
                    cell.oneFreeButton.titleLabel.text=[NSString stringWithFormat:@"%ld",indexPath.section];
                    cell.oneFiveButton.titleLabel.text=[NSString stringWithFormat:@"%ld",indexPath.section];
                }
                cell.separatorInset = UIEdgeInsetsMake(0,kScreenWidth, 0, 0);
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                return cell;
            }else{
                //默认第一个显示
                if (indexPath.row==0) {
                    UITableViewCell*mainCell=[RXTabViewHeightObjject getTabViewCell:self.dataArray[indexPath.section-1]];
                    //运动
                    if ([mainCell isKindOfClass:[RXMotionTableViewCell class]]) {
                        
                        NSMutableDictionary*dic=self.dataArray[indexPath.section-1];
                        
                        RXMotionTableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:@"RXMotionTableViewCell"];
                        if(!cell){
                            cell = [[RXMotionTableViewCell alloc]initWithStyle:0 reuseIdentifier:@"RXMotionTableViewCell"];
                        }
                        cell.separatorInset = UIEdgeInsetsMake(0,kScreenWidth, 0, 0);
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                        
                        //背景
                        if ([Unit JSONInt:dic key:@"execption"]==1) {
                            cell.backgroundColor = [UIColor colorWithRed:255/255.0 green:253/255.0 blue:246/255.0 alpha:1.0];
                        }else{
                            cell.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0];
                        }
                        
                        cell.motionyueButton.hidden=YES;
                        cell.motionzhouButton.hidden=YES;
                        cell.motionlishiButton.hidden=YES;
                        
                        //周报是否显示
                        if (self.paramResponse.hasWeek==1) {
                            cell.motionzhouButton.hidden=NO;
                        }
                        if (self.paramResponse.hasMonth==1) {
                            cell.motionyueButton.hidden=NO;
                        }
                        if (self.paramResponse.hasHistory==1) {
                            cell.motionlishiButton.hidden=NO;
                        }
                        //默认样式
                        [cell.motionzhouButton setTitleColor:JGColor(245, 166, 35, 1) forState:UIControlStateNormal];
                        [cell.motionyueButton setTitleColor:JGColor(245, 166, 35, 1) forState:UIControlStateNormal];
                        [cell.motionlishiButton setTitleColor:JGColor(245, 166, 35, 1) forState:UIControlStateNormal];
                        
                        [cell.motionzhouButton setTitleColor:JGColor(245, 166, 35, 1) forState:UIControlStateSelected];
                        [cell.motionyueButton setTitleColor:JGColor(245, 166, 35, 1) forState:UIControlStateSelected];
                        [cell.motionlishiButton setTitleColor:JGColor(245, 166, 35, 1) forState:UIControlStateSelected];
                        
                        cell.motionlishiButton.layer.masksToBounds=YES;
                        cell.motionyueButton .layer.masksToBounds=YES;
                        cell.motionzhouButton.layer.masksToBounds=YES;
                        
                        cell.motionlishiButton.layer.cornerRadius=10;
                        cell.motionyueButton.layer.cornerRadius=10;
                        cell.motionzhouButton.layer.cornerRadius=10;
                        
                        cell.motionlishiButton.layer.borderWidth=1;
                        cell.motionyueButton.layer.borderWidth=1;
                        cell.motionzhouButton.layer.borderWidth=1;
                        
                        cell.motionlishiButton.layer.borderColor=JGColor(245, 166, 35, 1).CGColor;
                        cell.motionyueButton.layer.borderColor=JGColor(245, 166, 35, 1).CGColor;
                        cell.motionzhouButton.layer.borderColor=JGColor(245, 166, 35, 1).CGColor;
                    
                        //默认视图
                        CircleLoader *view=[[CircleLoader alloc]initWithFrame:CGRectMake(ScreenWidth/2-150/2-10,cell.iconImage.frame.origin.y,cell.iconImage.frame.size.width,cell.iconImage.frame.size.height)];
                        //设置轨道宽度
                        view.lineWidth=8.0;
                        //设置是否转到 YES进度不用设置
                        view.animationing=NO;
                        [cell addSubview:view];
                        
                        [cell.motionzhouButton addTarget:self action:@selector(motionzhouButtonFountion:) forControlEvents:UIControlEventTouchUpInside];
                        [cell.motionyueButton addTarget:self action:@selector(motionzhouButtonFountion:) forControlEvents:UIControlEventTouchUpInside];
                    
                        [cell.motionlishiButton addTarget:self action:@selector(motionlishiButtonFountion:) forControlEvents:UIControlEventTouchUpInside];
                        cell.motionlishiButton.tag=indexPath.section-1;
    
                        NSMutableDictionary*keyValue=[Unit ParseJSONObject:dic[@"keyValue"]];
                        if ([[RXTabViewHeightObjject getItemCodeNumber:dic] isEqualToString:@"运动"]) {
                            cell.motionCenterlabel.text=@"今日步数";
                            cell.motionCenterNumberlabel.text=[NSString stringWithFormat:@"%d",self.myStep];
                            cell.motionNamelabel.hidden=YES;
                           
                            cell.rexiaolabel.text=[NSString stringWithFormat:@"消耗热量:%.1f卡",self.myKaluli];
                            cell.lejulabel.text=[NSString stringWithFormat:@"累计里程:%.1f公里",self.myGongli];
                            
                            NSString*string=[[NSUserDefaults standardUserDefaults] objectForKey:@"sdbs"];
                            if (string.length>0) {
                                cell.motionCenterMulabel.text=[NSString stringWithFormat:@"目标%@步",string];
                                float myIndex=[string floatValue];
                                float floatMy=self.myStep/myIndex;
                                view.progressValue=floatMy;
                            }else{
                                cell.motionCenterMulabel.text=[NSString stringWithFormat:@"未设置目标步数"];
                                //设置进度
                                view.progressValue=0;
                            }
                            //设置轨道颜色
                            view.trackTintColor=JGColor(204, 240, 236, 1);
                            //设置进度条颜色
                            view.progressTintColor=JGColor(74, 205, 190, 1);
                      
                        }else if ([[RXTabViewHeightObjject getItemCodeNumber:dic] isEqualToString:@"体脂"]) {
                            cell.motionCenterlabel.hidden=YES;
                            cell.motionCenterMulabel.text=@"体脂率(%)";
                            cell.motionCenterNumberlabel.text=[NSString stringWithFormat:@"%@",[Unit JSONString:keyValue key:@"inValue"]];
                            cell.motionyueButton.hidden=YES;
                            cell.motionzhouButton.hidden=YES;
                            cell.jiaoimage.hidden=YES;
                            cell.rexiaolabel.hidden=YES;
                            cell.reImage.hidden=YES;
                            cell.lejulabel.hidden=YES;
                            cell.motionTitlelabel.text=@"体脂:";
                            cell.motionNamelabel.text=[Unit JSONString:dic key:@"testgrade"];
                            
                            cell.motionCenterNumberlabel.textColor=JGColor(34, 34, 34, 1);
                            [cell.motionCenterNumberlabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:30]];
                            //设置轨道颜色
                            view.trackTintColor=JGColor(249, 235, 226, 1);
                            //设置进度条颜色
                            view.progressTintColor=JGColor(252, 143, 101, 1);
                            view.progressValue=[[Unit JSONString:keyValue key:@"inValue"] floatValue]*0.01;
                        }else if ([[RXTabViewHeightObjject getItemCodeNumber:dic] isEqualToString:@"血氧"]) {
                            cell.motionCenterlabel.hidden=YES;
                            cell.motionCenterMulabel.text=@"血氧(%)";
                            cell.motionCenterNumberlabel.text=[Unit JSONString:keyValue key:@"inValue"];
                            cell.motionyueButton.hidden=YES;
                            cell.motionzhouButton.hidden=YES;
                            cell.jiaoimage.hidden=YES;
                            cell.rexiaolabel.hidden=YES;
                            cell.reImage.hidden=YES;
                            cell.lejulabel.hidden=YES;
                            cell.motionTitlelabel.text=@"血氧：";
                            cell.motionNamelabel.text=[Unit JSONString:dic key:@"testgrade"];
                            
                            [cell.motionCenterNumberlabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:30]];
                            //设置轨道颜色
                            view.trackTintColor=JGColor(249, 235, 226, 1);
                            //设置进度条颜色
                            view.progressTintColor=JGColor(252, 143, 101, 1);
                            view.progressValue=[[Unit JSONString:keyValue key:@"inValue"] floatValue]*0.01;
                        }
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
                            cell.shoushuiNumberlabel.text=keyValue[@"highValue"];
                            cell.shuzhangNumberlabel.text= keyValue[@"lowValue"];
                           
                            cell.lishiButton.hidden=YES;
                            cell.zhouButton.hidden=YES;
                            cell.yueButton.hidden=YES;
                            //周报是否显示
                            if (self.paramResponse.hasWeek==1) {
                                cell.zhouButton.hidden=NO;
                            }
                            if (self.paramResponse.hasMonth==1) {
                                cell.yueButton.hidden=NO;
                            }
                            if (self.paramResponse.hasHistory==1) {
                                cell.lishiButton.hidden=NO;
                            }
                            //取名字反了
                            float shunzhangNumber=[keyValue[@"highValue"] floatValue]/200;
                            if (shunzhangNumber>1) {
                                shunzhangNumber=1;
                            }
                            if (shunzhangNumber<=0.15) {
                                shunzhangNumber=0.25;
                            }
                            
                            float shuoNumber=[keyValue[@"lowValue"] floatValue]/200;
                            if (shuoNumber>1) {
                                shuoNumber=1;
                            }
                            if (shuoNumber<=0.15) {
                                shuoNumber=0.25;
                            }
                            cell.shouTrailling.constant=-(1- shunzhangNumber)*cell.shouBackImage.frame.size.width;
                            cell.shuzhangTrailling.constant= -(1-shuoNumber)*cell.shouBackImage.frame.size.width;
                           
                            [cell.zhouButton addTarget:self action:@selector(motionzhouButtonFountion:) forControlEvents:UIControlEventTouchUpInside];
                            [cell.yueButton addTarget:self action:@selector(motionzhouButtonFountion:) forControlEvents:UIControlEventTouchUpInside];
                            
                            [cell.lishiButton addTarget:self action:@selector(motionlishiButtonFountion:) forControlEvents:UIControlEventTouchUpInside];
                            cell.lishiButton.tag=indexPath.section-1;
                            
                            //背景
                            if ([Unit JSONInt:dic key:@"execption"]==1) {
                                cell.backgroundColor = [UIColor colorWithRed:255/255.0 green:253/255.0 blue:246/255.0 alpha:1.0];
                            }else{
                                cell.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0];
                            }
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
                            cell.twoxuelabel.text=[Unit JSONString:dic key:@"itemName"];
                            cell.separatorInset = UIEdgeInsetsMake(0,kScreenWidth, 0, 0);
                            cell.selectionStyle = UITableViewCellSelectionStyleNone;
                            cell.twoNamelabel.text=[Unit JSONString:dic key:@"itemName"];
                            cell.twojianglabel.text=[Unit JSONString:dic key:@"suggest"];
                            cell.twojiangTitle.text=[Unit JSONString:dic key:@"title"];
                            cell.twojianglabel.text=[Unit JSONString:dic key:@"suggest"];
                            cell.twojianglabel.textColor=JGColor(102, 102, 102, 1);
                            if (cell.twojianglabel.text.length>0) {
                                cell.twojianglabel.numberOfLines = 4;
                                [cell.twojianglabel setRowSpace:10];
                            }
                            NSMutableDictionary*keyValue=[Unit ParseJSONObject:dic[@"keyValue"]];
                            cell.twoxueNumberlabel.text=[Unit JSONString:keyValue key:@"inValue"];
                             //进度条
                            float tizhongNumber=[keyValue[@"inValue"] floatValue]/100;
                            if (tizhongNumber>1) {
                                tizhongNumber=1;
                            }
                            if (tizhongNumber<=0.15) {
                                tizhongNumber=0.25;
                            }
                            cell.xueTangTrailling.constant=-(1-tizhongNumber)*cell.twoxuebackImage.frame.size.width;
        
                            cell.separatorInset = UIEdgeInsetsMake(0,kScreenWidth, 0, 0);
                            cell.selectionStyle = UITableViewCellSelectionStyleNone;
                            cell.twoxueStartlabel.text=@"0";
                            cell.twoxueEndlabel.text=@"100";
                            //背景
                            if ([Unit JSONInt:dic key:@"execption"]==1) {
                                cell.backgroundColor = [UIColor colorWithRed:255/255.0 green:253/255.0 blue:246/255.0 alpha:1.0];
                            }else{
                                cell.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0];
                            }
                            
                            [cell.twoyueButton addTarget:self action:@selector(motionzhouButtonFountion:) forControlEvents:UIControlEventTouchUpInside];
                            [cell.twozhouButton addTarget:self action:@selector(motionzhouButtonFountion:) forControlEvents:UIControlEventTouchUpInside];
                            
                            [cell.twolishiButton addTarget:self action:@selector(motionlishiButtonFountion:) forControlEvents:UIControlEventTouchUpInside];
                            
                            cell.twolishiButton.tag=indexPath.section-1;
                            
                            cell.twolishiButton.hidden=YES;
                            cell.twozhouButton.hidden=YES;
                            cell.twoyueButton.hidden=YES;
                            //周报是否显示
                            if (self.paramResponse.hasWeek==1) {
                                cell.twozhouButton.hidden=NO;
                            }
                            if (self.paramResponse.hasMonth==1) {
                                cell.twoyueButton.hidden=NO;
                            }
                            if (self.paramResponse.hasHistory==1) {
                                cell.twolishiButton.hidden=NO;
                            }
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
                            cell.twoxuelabel.text=[Unit JSONString:dic key:@"itemName"];
                            cell.twoNamelabel.text=[Unit JSONString:dic key:@"itemName"];
                            cell.twoxuelabel.text=[Unit JSONString:dic key:@"itemName"];
                            cell.twojiangTitle.text=[Unit JSONString:dic key:@"title"];
                            cell.twojianglabel.text=[Unit JSONString:dic key:@"suggest"];
                            cell.twojianglabel.textColor=JGColor(102, 102, 102, 1);
                            if (cell.twojianglabel.text.length>0) {
                                cell.twojianglabel.numberOfLines = 4;
                                [cell.twojianglabel setRowSpace:10];
                            }
                            NSMutableDictionary*keyValue=[Unit ParseJSONObject:dic[@"keyValue"]];
                            cell.twoxueNumberlabel.text=[Unit JSONString:keyValue key:@"inValue"];
                             //进度条
                            float tizhongNumber=[keyValue[@"inValue"] floatValue]/100;
                            if (tizhongNumber>1) {
                                tizhongNumber=1;
                            }
                            if (tizhongNumber<=0.15) {
                                tizhongNumber=0.25;
                            }
                            cell.xueTangTrailling.constant=-(1-tizhongNumber)*cell.twoxuebackImage.frame.size.width;
                            
                            cell.separatorInset = UIEdgeInsetsMake(0,kScreenWidth, 0, 0);
                            cell.selectionStyle = UITableViewCellSelectionStyleNone;
                            cell.twoxueStartlabel.text=@"0";
                            cell.twoxueEndlabel.text=@"100";
                            
                            cell.twoxueWaiImage.backgroundColor=JGColor(101, 187, 177, 1);
                            cell.twoxuebackImage.backgroundColor=JGColor(210, 242, 238, 1);
                            
                            //背景
                            if ([Unit JSONInt:dic key:@"execption"]==1) {
                                cell.backgroundColor = [UIColor colorWithRed:255/255.0 green:253/255.0 blue:246/255.0 alpha:1.0];
                            }else{
                                cell.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0];
                            }
                            [cell.twoyueButton addTarget:self action:@selector(motionzhouButtonFountion:) forControlEvents:UIControlEventTouchUpInside];
                            [cell.twozhouButton addTarget:self action:@selector(motionzhouButtonFountion:) forControlEvents:UIControlEventTouchUpInside];
                            
                            [cell.twolishiButton addTarget:self action:@selector(motionlishiButtonFountion:) forControlEvents:UIControlEventTouchUpInside];
                            cell.twolishiButton.tag=indexPath.section-1;
                            
                            cell.twolishiButton.hidden=YES;
                            cell.twozhouButton.hidden=YES;
                            cell.twoyueButton.hidden=YES;
                            //周报是否显示
                            if (self.paramResponse.hasWeek==1) {
                                cell.twozhouButton.hidden=NO;
                            }
                            if (self.paramResponse.hasMonth==1) {
                                cell.twoyueButton.hidden=NO;
                            }
                            if (self.paramResponse.hasHistory==1) {
                                cell.twolishiButton.hidden=NO;
                            }
                            return cell;
                        }
                        //尿酸
                        if ([[RXTabViewHeightObjject getItemCodeNumber:self.dataArray[indexPath.section-1]] isEqualToString:@"尿酸"]) {
                            NSMutableDictionary*dic=self.dataArray[indexPath.section-1];
                            static  NSString *reusstring = @"RXBloodPressureTableViewCell";
                            RXBloodPressureTableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:reusstring];
                            if (cell==nil) {
                                cell=[[RXBloodPressureTableViewCell alloc]initWithStyle:0 reuseIdentifier:@"RXBloodPressureTableViewID2"];
                            }
                            cell.twoNamelabel.text=[Unit JSONString:dic key:@"itemName"];
                            cell.twoxuelabel.text=[Unit JSONString:dic key:@"itemName"];
                            cell.twojiangTitle.text=[Unit JSONString:dic key:@"title"];
                            cell.twojianglabel.text=[Unit JSONString:dic key:@"suggest"];
                            cell.twojianglabel.textColor=JGColor(102, 102, 102, 1);
                            if (cell.twojianglabel.text.length>0) {
                                cell.twojianglabel.numberOfLines = 4;
                                [cell.twojianglabel setRowSpace:10];
                            }
                            NSMutableDictionary*keyValue=[Unit ParseJSONObject:dic[@"keyValue"]];
                            cell.twoxueNumberlabel.text=[Unit JSONString:keyValue key:@"inValue"];
                            cell.separatorInset = UIEdgeInsetsMake(0,kScreenWidth, 0, 0);
                            cell.selectionStyle = UITableViewCellSelectionStyleNone;
                            cell.twoxueStartlabel.text=@"0";
                            cell.twoxueEndlabel.text=@"1000";
                            
                            cell.twoxueWaiImage.backgroundColor=JGColor(252, 98, 100, 1);
                            cell.twoxuebackImage.backgroundColor=JGColor(252, 238, 233, 1);
                            
                            //进度条
                            float tizhongNumber=[keyValue[@"inValue"] floatValue]/1000;
                            if (tizhongNumber>1) {
                                tizhongNumber=1;
                            }
                            if (tizhongNumber<=0.15) {
                                tizhongNumber=0.25;
                            }
                            cell.xueTangTrailling.constant=-(1-tizhongNumber)*cell.twoxuebackImage.frame.size.width;
                            
                            //背景
                            if ([Unit JSONInt:dic key:@"execption"]==1) {
                                cell.backgroundColor = [UIColor colorWithRed:255/255.0 green:253/255.0 blue:246/255.0 alpha:1.0];
                            }else{
                                cell.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0];
                            }
                            [cell.twoyueButton addTarget:self action:@selector(motionzhouButtonFountion:) forControlEvents:UIControlEventTouchUpInside];
                            [cell.twozhouButton addTarget:self action:@selector(motionzhouButtonFountion:) forControlEvents:UIControlEventTouchUpInside];
                            
                            [cell.twolishiButton addTarget:self action:@selector(motionlishiButtonFountion:) forControlEvents:UIControlEventTouchUpInside];
                            cell.twolishiButton.tag=indexPath.section-1;
                            cell.twolishiButton.hidden=YES;
                            cell.twozhouButton.hidden=YES;
                            cell.twoyueButton.hidden=YES;
                            //周报是否显示
                            if (self.paramResponse.hasWeek==1) {
                                cell.twozhouButton.hidden=NO;
                            }
                            if (self.paramResponse.hasMonth==1) {
                                cell.twoyueButton.hidden=NO;
                            }
                            if (self.paramResponse.hasHistory==1) {
                                cell.twolishiButton.hidden=NO;
                            }
                            return cell;
                        }
                        //血脂
                        if ([[RXTabViewHeightObjject getItemCodeNumber:self.dataArray[indexPath.section-1]] isEqualToString:@"血脂"]) {
                            
                            NSMutableDictionary*dic=self.dataArray[indexPath.section-1];
                            static  NSString *reusstring = @"RXBloodPressureTableViewCell";
                            RXBloodPressureTableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:reusstring];
                            if (cell==nil) {
                                cell=[[RXBloodPressureTableViewCell alloc]initWithStyle:0 reuseIdentifier:@"RXBloodPressureTableViewID3"];
                            }
                            cell.freeNamelabel.text=[Unit JSONString:dic key:@"itemName"];
                            cell.freeTitlelabel.text=[Unit JSONString:dic key:@"testgrade"];
                            
                            NSMutableDictionary*keyValue=[Unit ParseJSONObject:dic[@"keyValue"]];
                            cell.freeTcNumberlabel.text=[Unit JSONString:keyValue key:@"tcValue"];
                            cell.freeTGNumberlabel.text=[Unit JSONString:keyValue key:@"tgValue"];
                            cell.freeHDLCNumberlabel.text=[Unit JSONString:keyValue key:@"hdlcValue"];
                            cell.freeLDLCNumberlabel.text=[Unit JSONString:keyValue key:@"ldlcValue"];
                            
                            //进度条
                            float tcNumber=[keyValue[@"tcValue"] floatValue]/100;
                            if (tcNumber>1) {
                                tcNumber=1;
                            }
                            if (tcNumber<=0.15) {
                                tcNumber=0.25;
                            }
                            cell.tcTrailling.constant=-(1-tcNumber)*cell.freeTcBackImage.frame.size.width;

                            float tgNumber=[keyValue[@"tgValue"] floatValue]/100;
                            if (tgNumber>1) {
                                tgNumber=1;
                            }
                            if (tgNumber<=0.15) {
                                tgNumber=0.25;
                            }
                            cell.tgTrailling.constant=-(1-tgNumber)*cell.freeTGbackImage.frame.size.width;

                            float hdlcNumber=[keyValue[@"hdlcValue"] floatValue]/100;
                            if (hdlcNumber>1) {
                                hdlcNumber=1;
                            }
                            if (hdlcNumber<=0.15) {
                                hdlcNumber=0.25;
                            }
                            cell.hdlcTrailing.constant=-(1-hdlcNumber)*cell.freeHDLCBackimage.frame.size.width;

                            float ldlcNumber=[keyValue[@"ldlcValue"] floatValue]/100;
                            if (ldlcNumber>1) {
                                ldlcNumber=1;
                            }
                            if (ldlcNumber<=0.15) {
                                ldlcNumber=0.25;
                            }
                            cell.ldlcTrailing.constant=-(1-ldlcNumber)*cell.freeLDLCBackImage.frame.size.width;

                            
                            cell.freeJikanglabel.text=[Unit JSONString:dic key:@"suggest"];
                            cell.freeJikangTitellabel.text=[Unit JSONString:dic key:@"title"];
                            if (cell.freeJikanglabel.text.length>0) {
                                cell.freeJikanglabel.numberOfLines = 4;
                                [cell.freeJikanglabel setRowSpace:10];
                            }
                            cell.separatorInset = UIEdgeInsetsMake(0,kScreenWidth, 0, 0);
                            cell.selectionStyle = UITableViewCellSelectionStyleNone;
                            
                            //背景
                            if ([Unit JSONInt:dic key:@"execption"]==1) {
                                cell.backgroundColor = [UIColor colorWithRed:255/255.0 green:253/255.0 blue:246/255.0 alpha:1.0];
                            }else{
                                cell.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0];
                            }
                            cell.freelishiButton.hidden=YES;
                            [cell.freelishiButton addTarget:self action:@selector(motionlishiButtonFountion:) forControlEvents:UIControlEventTouchUpInside];
                            cell.freelishiButton.tag=indexPath.section-1;
                            if (self.paramResponse.hasHistory==1) {
                                cell.freelishiButton.hidden=NO;
                            }
                            return cell;
                        }
                    }
                }
                //咨询
                if (indexPath.row==1) {
                    if (self.paramResponse.invitationList.count>0) {
                        static NSString *cellId = @"RXHotInfoTableViewShowCell";
                        YSHotInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RXHotInfoTableViewShowCell"];
                        if (!cell) {
                            cell = [[YSHotInfoTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"RXHotInfoTableViewShowCell"];
                        }
                        NSDictionary * dic = self.paramResponse.invitationList[0];
                        NSString *url = [NSString stringWithFormat:@"%@%@%@",Base_URL,user_tiezi,[dic objectForKey:@"id"]];
                        cell.strUrl = url;
                        cell.models=self.paramResponse.invitationList[0];
                        cell.dic =self.paramResponse.invitationList[0];
                        cell.nav1 = self.navigationController;
                        cell.separatorInset = UIEdgeInsetsMake(0,kScreenWidth, 0, 0);
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                        [cell panduandianzan];
                        cell.isRX=true;
                        
                        NSMutableDictionary*dic1=self.dataArray[indexPath.section-1];
                        //背景
                        if ([Unit JSONInt:dic1 key:@"execption"]==1) {
                            cell.backgroundColor = [UIColor colorWithRed:255/255.0 green:253/255.0 blue:246/255.0 alpha:1.0];
                        }else{
                            cell.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0];
                        }
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
                    cell.delegate=self;
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    NSMutableDictionary*dic=self.dataArray[indexPath.section-1];
                    cell.dic=dic;
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

        cell.twoGengDuolabel.textColor=JGColor(136, 136, 136, 1);
        cell.twoGengDuolabel.userInteractionEnabled=YES;
        cell.conterGengDuolabel.userInteractionEnabled=YES;
        cell.conterGengDuolabel.textColor=JGColor(136, 136, 136, 1);
        if (indexPath.row==0) {
             NSString*mainContent=dic[@"introduction"];
            if (mainContent.length>0) {
                cell.twoWenTilabel.text=mainContent;
                cell.twoWenTilabel.numberOfLines = 2;
                [cell.twoWenTilabel setRowSpace:10];
            }
            cell.twoTitlelabel.text=@"完美档案报告";
            [cell.twoTitlelabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:16]];
            cell.twoTitlelabel.textColor=JGColor(51, 51, 51, 1);
            [cell.twoButton addTarget:self action:@selector(gengDuoButton:) forControlEvents:UIControlEventTouchUpInside];
            cell.twoButton.titleLabel.text=@"wm";

            
            cell.twoBackImage.userInteractionEnabled=YES;
            cell.userInteractionEnabled=YES;
            
            UITapGestureRecognizer*tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(travelImageTap)];
            [cell.twoBackImage addGestureRecognizer:tap];
            

            UITapGestureRecognizer*taplabel=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(travelLabelTap:)];
            cell.twoGengDuolabel.tag=indexPath.row;
            [cell.twoGengDuolabel addGestureRecognizer:taplabel];
            
        }else if(indexPath.row==1){
            cell.conterMaskImage.hidden=YES;
            cell.conterlabel.hidden=YES;
            cell.contertwoLabel.hidden=YES;
            cell.titlelabel.text=@"精准健康检测报告";
            [cell.titlelabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:16]];
            cell.titlelabel.textColor=JGColor(51, 51, 51, 1);
            cell.travelButton.titleLabel.text=@"bg";
            [cell.travelButton addTarget:self action:@selector(gengDuoButton:) forControlEvents:UIControlEventTouchUpInside];
            
            UITapGestureRecognizer*taplabel=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(travelLabelTap:)];
            cell.conterGengDuolabel.tag=indexPath.row;;
            [cell.conterGengDuolabel addGestureRecognizer:taplabel];
        }else if(indexPath.row==2){
            NSString*mainContent=dic[@"mainContent"];
            cell.conterMaskImage.hidden=YES;
            cell.conterlabel.hidden=YES;
            cell.contertwoLabel.hidden=YES;
            if (mainContent.length>0) {
                cell.conterlabel.text=mainContent;
                cell.conterlabel.font=JGFont(14);
                cell.conterMaskImage.hidden=NO;
                cell.conterlabel.hidden=NO;
            }
            cell.titlelabel.text=@"综合健康数据解读";
            [cell.titlelabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:16]];
            cell.titlelabel.textColor=JGColor(51, 51, 51, 1);
            cell.travelButton.titleLabel.text=@"jb";
            [cell.travelButton addTarget:self action:@selector(gengDuoButton:) forControlEvents:UIControlEventTouchUpInside];
            UITapGestureRecognizer*taplabel=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(travelLabelTap:)];
            cell.conterGengDuolabel.tag=indexPath.row;;
            [cell.conterGengDuolabel addGestureRecognizer:taplabel];
            
        }else if(indexPath.row==3){
            NSString*mainContent=dic[@"mainContent"];
            cell.conterMaskImage.hidden=YES;
            cell.conterlabel.hidden=YES;
            cell.contertwoLabel.hidden=NO;
            cell.conterMaskImage.hidden=YES;
            cell.conterlabel.hidden=YES;
            if (mainContent.length>0) {
                cell.contertwoLabel.text=mainContent;
                cell.contertwoLabel.font=JGFont(15);
                cell.contertwoLabel.numberOfLines = 2;
                [cell.contertwoLabel setRowSpace:5];
            }
            cell.titlelabel.text=@"健康西游";
            cell.travelButton.titleLabel.text=@"xy";
            [cell.titlelabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:16]];
            cell.titlelabel.textColor=JGColor(51, 51, 51, 1);
            [cell.travelButton addTarget:self action:@selector(gengDuoButton:) forControlEvents:UIControlEventTouchUpInside];
            UITapGestureRecognizer*taplabel=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(travelLabelTap:)];
            cell.conterGengDuolabel.tag=indexPath.row;;
            [cell.conterGengDuolabel addGestureRecognizer:taplabel];
        }
        cell.userInteractionEnabled=YES;
        cell.travelImage.userInteractionEnabled=YES;
        
        if (indexPath.row==1) {
            [cell.travelImage sd_setImageWithURL:[NSURL URLWithString:self.response.bgImg]];
            UITapGestureRecognizer*tapOne=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(travelImageTapOne)];
            [cell.travelImage addGestureRecognizer:tapOne];
        }
        if (indexPath.row==2) {
            [cell.travelImage sd_setImageWithURL:[NSURL URLWithString:self.response.jdImg]];
            UITapGestureRecognizer*tapTwo=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(travelImageTapTwo)];
            [cell.travelImage addGestureRecognizer:tapTwo];
        }
        if (indexPath.row==3) {
            [cell.travelImage sd_setImageWithURL:[NSURL URLWithString:self.response.xyImg]];
            UITapGestureRecognizer*tapFree=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(travelImageTapFree)];
            [cell.travelImage addGestureRecognizer:tapFree];
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
        static NSString *cellId = @"RXHotInfoTableViewCell";
        YSHotInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:heathInfoCellID];
        if (!cell) {
            cell = [[YSHotInfoTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellId];
        }
        NSDictionary * dic =self.response.invitationList[0];
        NSString *url = [NSString stringWithFormat:@"%@%@%@",Base_URL,user_tiezi,[dic objectForKey:@"id"]];
        cell.strUrl = url;
        cell.models=self.response.invitationList[0];
        cell.dic =self.response.invitationList[0];
        cell.nav1 = self.navigationController;
        cell.separatorInset = UIEdgeInsetsMake(0,kScreenWidth, 0, 0);
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell panduandianzan];
        cell.isRX=true;
        return cell;
    }else if(indexPath.section==self.dataArray.count+1+6){
        RXShoppingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RXShoppingTableViewCell"];
        if (cell == nil) {
            cell = [[RXShoppingTableViewCell alloc] initWithStyle:UITableViewCellSelectionStyleNone reuseIdentifier:@"RXShoppingTableViewCell"];
        }
        cell.delegate=self;
        cell.keywordGoodsList=[NSMutableArray arrayWithArray:self.response.keywordGoodsList];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.type=true;
        return cell;
    }
    UITableViewCell*cell=[[UITableViewCell alloc]init];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (self.dataArray.count>0) {
        if (indexPath.section-1<self.dataArray.count+1) {
        
            if (indexPath.row==1) {
                if (self.paramResponse.invitationList.count>0) {
                    [[NSUserDefaults standardUserDefaults]setObject:[self.InfosModels objectAtIndex:indexPath.row] forKey:@"circleTitle"];
                    WebDayVC *weh = [[WebDayVC alloc]init];
                    NSDictionary * dic = self.paramResponse.invitationList[0];
                    [[NSUserDefaults standardUserDefaults]setObject:dic[@"title"]  forKey:@"circleTitle"];
                    NSString *url = [NSString stringWithFormat:@"%@%@%@",Base_URL,user_tiezi,[dic objectForKey:@"id"]];
                    weh.strUrl = url;
                    weh.ind = 1;
                    weh.dic =self.paramResponse.invitationList[0];
                    weh.backBlock = ^(){
                    };
                    UINavigationController *nas = [[UINavigationController alloc]initWithRootViewController:weh];
                    nas.navigationBar.barTintColor = COMMONTOPICCOLOR;
                    [self presentViewController:nas animated:YES completion:^{
                    }];
                }
            }
        }
    }
    if (indexPath.section==self.dataArray.count+1+5) {
        [[NSUserDefaults standardUserDefaults]setObject:[self.InfosModels objectAtIndex:indexPath.row] forKey:@"circleTitle"];
        WebDayVC *weh = [[WebDayVC alloc]init];
        NSDictionary * dic = self.response.invitationList[0];
        [[NSUserDefaults standardUserDefaults]setObject:dic[@"title"]  forKey:@"circleTitle"];
        NSString *url = [NSString stringWithFormat:@"%@%@%@",Base_URL,user_tiezi,[dic objectForKey:@"id"]];
        weh.strUrl = url;
        weh.ind = 1;
        weh.dic =self.response.invitationList[0];
        weh.backBlock = ^(){
        };
        UINavigationController *nas = [[UINavigationController alloc]initWithRootViewController:weh];
        nas.navigationBar.barTintColor = COMMONTOPICCOLOR;
        [self presentViewController:nas animated:YES completion:^{
        }];
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
                    return 250;
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
        return 250;
    }
    return 0;
}

//请求超时
-(void)chaoshiFunotion;{
    if (self.MjTimer!=nil) {
        [self.MjTimer invalidate];
        self.MjTimer=nil;
        [self.mtableview.mj_header endRefreshing];
    }
    [self showStringHUD:@"请求超时,请刷新重试" second:0];
}


/**个人信息**/
-(void)getRequest;{
    //设置超时
    if (self.MjTimer!=nil) {
        [self.MjTimer invalidate];
        self.MjTimer=nil;
    }
    self.MjTimer=[NSTimer scheduledTimerWithTimeInterval:10.0f target:self selector:@selector(chaoshiFunotion) userInfo:nil  repeats:NO];
    
    self.response=[[RXUserDetailResponse alloc]init];
    [self showHUD];
    RXUserDetailRequest*request=[[RXUserDetailRequest alloc]init:GetToken];
    VApiManager *manager = [[VApiManager alloc]init];
    [manager RXMakeUserDetail:request
                      success:^(AFHTTPRequestOperation *operation, RXUserDetailResponse *response) {
            //设置超时
            if (self.MjTimer!=nil) {
              [self.MjTimer invalidate];
              self.MjTimer=nil;
            }
            self.othersArray=[[NSMutableArray alloc]init];
            self.advertisingArray=[[NSMutableArray alloc]init];
            dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0/*延迟执行时间*/ * NSEC_PER_SEC));
            dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                [self hideAllHUD];
                [self.mtableview.mj_header endRefreshing];
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
            self.response = response;
            //是否领取过会员
            int index=[Unit JSONInt:[[NSMutableDictionary alloc]initWithDictionary:self.response.healthUserBO] key:@"isGet"];
            if (index==0){
                  if ([self.response.isLA isEqualToString:@"0"]) {
                      self.freeCollectionView=[[RXFreeCollectionView alloc]init];
                      [self.freeCollectionView showView:@"健康管家，定时监测您的身体状态，打造专属健康服务。点击领取即可免费体验1个月" with:self with:@selector(freeCollectViewButton)];
                  }else{
                      self.freeCollectionView=[[RXFreeCollectionView alloc]init];
                      [self.freeCollectionView showView:@"健康管家，定时监测您的身体状态，打造专属健康服务。点击领取即可免费使用1年" with:self with:@selector(freeCollectViewButton)];
                  }
            }else{
                //是否需要提示
                if ([self.response.memberNotice isEqualToString:@"1"]){
                    
                    if ([self.response.memberLastTime integerValue]>0&&[self.response.memberLastTime integerValue]<5) {
                        TBAlertController *controller = [TBAlertController alertControllerWithTitle:@"提示" message:[NSString stringWithFormat:@"您的健康管家数据服务还有%@天到期，到期后所有监测服务将不再支持",self.response.memberLastTime] preferredStyle:TBAlertControllerStyleAlert];
                        TBAlertAction *clickme = [TBAlertAction actionWithTitle:@"立即续费" style: TBAlertActionStyleDestructive handler:^(TBAlertAction * _Nonnull action) {
                            RXbutlerServiceViewController*vc=[[RXbutlerServiceViewController alloc]init];
                            [self.navigationController pushViewController:vc animated:NO];
                        }];
                        TBAlertAction *cancel = [TBAlertAction actionWithTitle:@"暂不考虑" style: TBAlertActionStyleCancel handler:^(TBAlertAction * _Nonnull action) {
                        }];
                        [controller addAction:clickme];
                        [controller addAction:cancel];
                        [self presentViewController:controller animated:YES completion:nil];
                    }else if ([self.response.memberLastTime integerValue]==0) {
                        TBAlertController *controller = [TBAlertController alertControllerWithTitle:@"提示" message:@"您的健康管家服务已到期，请先续费后再查看您的专属健康报告。" preferredStyle:TBAlertControllerStyleAlert];
                        TBAlertAction *clickme = [TBAlertAction actionWithTitle:@"立即续费" style: TBAlertActionStyleDestructive handler:^(TBAlertAction * _Nonnull action) {
                            RXbutlerServiceViewController*vc=[[RXbutlerServiceViewController alloc]init];
                            [self.navigationController pushViewController:vc animated:NO];
                        }];
                        TBAlertAction *cancel = [TBAlertAction actionWithTitle:@"暂不考虑" style: TBAlertActionStyleCancel handler:^(TBAlertAction * _Nonnull action) {
                        }];
                        [controller addAction:clickme];
                        [controller addAction:cancel];
                        [self presentViewController:controller animated:YES completion:nil];
                    }
                    
                }
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
            [self.InfosModels xf_safeAddObjectsFromArray:self.response.invitationList];
            //广告位
//            if (self.response.adContentBO) {
//                self.advertisingArray=[NSMutableArray arrayWithArray:self.response.adContentBO];
//            }
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
         [self hideAllHUD];
         [self.mtableview reloadData];
         [self showStringHUD:@"网络错误" second:0];
         //设置超时
         if (self.MjTimer!=nil) {
             [self.MjTimer invalidate];
             self.MjTimer=nil;
         }
         [self.mtableview.mj_header endRefreshing];
    }];
}
//领取会员
-(void)freeCollectViewButton;{
    RXMemberDetailRequest*request=[[RXMemberDetailRequest alloc]init:GetToken];
    VApiManager *manager = [[VApiManager alloc]init];
    [manager RXMemberDetailRequest:request success:^(AFHTTPRequestOperation *operation, RXMemberDetailResponse *response) {
         [self.freeCollectionView p_dismissView];
        dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0/*延迟执行时间*/ * NSEC_PER_SEC));
        dispatch_after(delayTime, dispatch_get_main_queue(), ^{
            if (response.isSuccuess==1) {
                [self showStringHUD:@"领取成功" second:0];
            }else{
                [self showStringHUD:@"领取失败" second:0];
            }
        });
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.freeCollectionView p_dismissView];
        [self showStringHUD:@"网络错误" second:0];
    }];
}
-(void)dealloc;{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"manualTestNotification" object:nil];
}
@end
