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

//运动
#import "RXMotionTableViewCell.h"
//个人信息
#import "RXUserInfoVIew.h"
//血压
#import "RXBloodPressureTableViewCell.h"

static NSString *goodsCellID = @"goodsCellID";
static NSString *heathInfoCellID = @"heathInfoCellID";
//默认6个分组，根据数据添加
#define headIndex  12

@interface RXMainViewController ()<YSAPIManagerParamSource,YSAPICallbackProtocol,YSHealthManageHeaderViewDelegate,UICollectionViewDelegate,TZImagePickerControllerDelegate,UITableViewDelegate,UITableViewDataSource,YUFoldingTableViewDelegate>

@property(strong,nonatomic)UITableView*mtableview;
@property(strong,nonatomic)NSMutableArray*dataArray;
@property (strong,nonatomic) NSMutableDictionary *stepUserInfo;

//头部
//@property(weak,nonatomic)YSBaseInfoView*rxBaseInfoView;
@property(nonatomic,strong)RXUserInfoVIew*rxBaseInfoView;
//默认测试数据
@property(nonatomic,strong)NSArray*titleArray;
@property(nonatomic,strong)NSArray*iconArray;

@property(nonatomic,strong)YUFoldingTableView*foldingTableView;
@property(nonatomic,strong)UIView*foldview;

@property(nonatomic,strong)RXUserDetailResponse*response;
/*精准健康检测*/
@property(nonatomic,strong)NSMutableArray*reportArray;
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


//首页button选择状态
@property(assign,nonatomic)bool selectyudongBool;
@property(assign,nonatomic)bool selectxunyaBool;
@property(assign,nonatomic)bool selectxuetangBool;
@property(assign,nonatomic)bool selecttizhongBool;


//    精准健康检测报告
@property(nonatomic,strong)NSMutableArray*healthServiceRecommendBgBOArray;
@property(nonatomic,strong)NSMutableArray*healthServiceRecommendJdBOArray;
@property(nonatomic,strong)NSMutableArray*healthServiceRecommendXyBOArray;


@end

@implementation RXMainViewController

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
    
    //广告位数据
    self.reportArray=[[NSMutableArray alloc]init];
    self.advertisingArray=[[NSMutableArray alloc]init];
    [self.advertisingArray addObject:@{}];

    [self setUI];
    self.view.backgroundColor = [UIColor whiteColor];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"kUserDidLoadMainController" object:nil];
    });
}
-(void)setUI;{
    CGRect statusRect = [[UIApplication sharedApplication] statusBarFrame];
    int myhight=statusRect.size.height;
    self.selecttizhongBool=false;
    self.selectxunyaBool=false;
    self.selectyudongBool=false;
    self.selectxuetangBool=false;
    _mtableview=[[UITableView alloc]initWithFrame:CGRectMake(0,0,kScreenWidth,kScreenHeight+myhight) style:UITableViewStylePlain];
    _mtableview.tableFooterView = [UIView new];
    _mtableview.backgroundColor =JGColor(250, 250, 250, 1);
    _mtableview.delegate = self;
    _mtableview.dataSource = self;
    _mtableview.tableFooterView = [UIView new];
    _mtableview.sectionFooterHeight = 0;
    _mtableview.estimatedRowHeight = 0;
    _mtableview.estimatedSectionHeaderHeight = 0;
    _mtableview.estimatedSectionFooterHeight = 0;

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
    
    return headIndex;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    switch (section) {
        //第一个分组
        case 0:{
            CGRect statusRect = [[UIApplication sharedApplication] statusBarFrame];
            int myhight=statusRect.size.height;
            if (!self.rxBaseInfoView) {
                self.rxBaseInfoView=[[[NSBundle mainBundle]loadNibNamed:@"RXUserInfoVIew" owner:self options:nil]firstObject];
                self.rxBaseInfoView.userInfoTop.constant=myhight+30;
                self.rxBaseInfoView.frame=CGRectMake(0,0,kScreenWidth,300);
            }
            if (self.response) {
                self.rxBaseInfoView.nameLabel.text=self.response.healthUserBO[@"nickName"];
                self.rxBaseInfoView.iconImage.layer.masksToBounds=YES;
                self.rxBaseInfoView.iconImage.layer.cornerRadius=30;
                [self.rxBaseInfoView.iconImage sd_setImageWithURL:[NSURL URLWithString:self.response.healthUserBO[@"headImage"]]];
                int sexage=[self.response.healthUserBO[@"sex"] intValue];
                self.rxBaseInfoView.sexLabel.text=sexage==0?@"男":@"女";
                self.rxBaseInfoView.heightLabel.text=self.response.healthUserBO[@"height"];
                self.rxBaseInfoView.weghtlabel.text=self.response.healthUserBO[@"weight"];
            }
            return self.rxBaseInfoView;
            break;
        }
        //默认显示
        case 1:{
            RXYuHeadView*rxheadView=[[[NSBundle mainBundle]loadNibNamed:@"RXYuHeadView" owner:self options:nil]firstObject];
             rxheadView.backgroundColor=[UIColor whiteColor];
            rxheadView.iconImage.image=[UIImage imageNamed:@"consummate_yundong_image"];
                rxheadView.titelabel.text=@"运动";
            rxheadView.backImage.layer.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0].CGColor;
            rxheadView.backImage.layer.cornerRadius = 8;
            rxheadView.backImage.layer.shadowColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:0.9].CGColor;
            rxheadView.backImage.layer.shadowOffset = CGSizeMake(0,0);
            rxheadView.backImage.layer.shadowOpacity = 1;
            rxheadView.backImage.layer.shadowRadius = 10;
            rxheadView.addButton.tag=section;
            rxheadView.addButton.userInteractionEnabled=YES;
            [rxheadView.addButton addTarget:self action:@selector(rxheadViewAddButton:) forControlEvents:UIControlEventTouchUpInside];
            rxheadView.addButton.selected=NO;
            return rxheadView;
        }
        case 2:{
            RXYuHeadView*rxheadView=[[[NSBundle mainBundle]loadNibNamed:@"RXYuHeadView" owner:self options:nil]firstObject];
             rxheadView.backgroundColor=[UIColor whiteColor];
            rxheadView.iconImage.image=[UIImage imageNamed:@"consummate_xueya_image"];
            rxheadView.titelabel.text=@"血压";
            rxheadView.backImage.layer.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0].CGColor;
            rxheadView.backImage.layer.cornerRadius = 8;
            rxheadView.backImage.layer.shadowColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:0.9].CGColor;
            rxheadView.backImage.layer.shadowOffset = CGSizeMake(0,0);
            rxheadView.backImage.layer.shadowOpacity = 1;
            rxheadView.backImage.layer.shadowRadius = 10;
            rxheadView.addButton.tag=section;
            [rxheadView.addButton addTarget:self action:@selector(rxheadViewAddButton:) forControlEvents:UIControlEventTouchUpInside];
            return rxheadView;
        }
        case 3:{
            RXYuHeadView*rxheadView=[[[NSBundle mainBundle]loadNibNamed:@"RXYuHeadView" owner:self options:nil]firstObject];
             rxheadView.backgroundColor=[UIColor whiteColor];
            rxheadView.iconImage.image=[UIImage imageNamed:@"consummate_xuntang_image"];
            rxheadView.titelabel.text=@"血糖";
            rxheadView.backImage.layer.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0].CGColor;
            rxheadView.backImage.layer.cornerRadius = 8;
            rxheadView.backImage.layer.shadowColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:0.9].CGColor;
            rxheadView.backImage.layer.shadowOffset = CGSizeMake(0,0);
            rxheadView.backImage.layer.shadowOpacity = 1;
            rxheadView.backImage.layer.shadowRadius = 10;
            rxheadView.addButton.tag=section;
            [rxheadView.addButton addTarget:self action:@selector(rxheadViewAddButton:) forControlEvents:UIControlEventTouchUpInside];
            return rxheadView;
        }
        case 4:{
            RXYuHeadView*rxheadView=[[[NSBundle mainBundle]loadNibNamed:@"RXYuHeadView" owner:self options:nil]firstObject];
            rxheadView.backgroundColor=[UIColor whiteColor];
            rxheadView.iconImage.image=[UIImage imageNamed:@"Consummate_tizhong_image"];
            rxheadView.titelabel.text=@"体重";
            rxheadView.backImage.layer.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0].CGColor;
            rxheadView.backImage.layer.cornerRadius = 8;
            rxheadView.backImage.layer.shadowColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:0.9].CGColor;
            rxheadView.backImage.layer.shadowOffset = CGSizeMake(0,0);
            rxheadView.backImage.layer.shadowOpacity = 1;
            rxheadView.backImage.layer.shadowRadius = 10;
            rxheadView.addButton.tag=section;
            [rxheadView.addButton addTarget:self action:@selector(rxheadViewAddButton:) forControlEvents:UIControlEventTouchUpInside];

            return rxheadView;
            return [UIView new];
        }
        case 5:{
            UIView*view=[[UIView alloc]initWithFrame:CGRectMake(20,0,ScreenWidth-40,40)];
            view.backgroundColor=[UIColor whiteColor];
            UIButton*button=[UIButton buttonWithType:UIButtonTypeCustom];
            button.frame=view.frame;
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
            [view addSubview:button];
            
            return view;
        }
        case 7:{
            YSHealthyTaskView *view = [[YSHealthyTaskView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 84.0/2) questionnaire:self.questionnaire tasks:self.taskList addTaskCallback:^{
                YSHealthyManageWebController *testWebController = [[YSHealthyManageWebController alloc] initWithWebType:YSHealthyManageAddTaskType uid:self.userCustome.uid];
                [self.navigationController pushViewController:testWebController animated:YES];
            }];
            [view setBackgroundColor:JGWhiteColor];
            return view;
        }
        case 10:{
            YSHealthyInformationVIew *view = [[YSHealthyInformationVIew alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 84.0/2)  addTaskCallback:^{
                //                YSHealthyManageWebController *testWebController = [[YSHealthyManageWebController alloc] initWithWebType:YSHealthyManageAddTaskType uid:self.userCustome.uid];
                //                [self.navigationController pushViewController:testWebController animated:YES];
            }];
            [view setBackgroundColor:JGWhiteColor];
            return view;
        }
        break;
        default:
           return  [UIView new];
            break;
    }
    return [UIView new];
}
//首页button点击事件
-(void)rxheadViewAddButton:(UIButton*)button;{
    switch (button.tag) {
        case 1:{
            if (self.selectyudongBool) {
                    self.selectyudongBool=false;
                }else{
                    self.selectyudongBool=true;
                }
            }
            break;
        case 2:{
            if (self.selectxunyaBool) {
                self.selectxunyaBool=false;
            }else{
                self.selectxunyaBool=true;
            }
        }
        break;
        case 3:{
            if (self.selectxuetangBool) {
                self.selectxuetangBool=false;
            }else{
                self.selectxuetangBool=true;
            }
        }
        break;
        case 4:{
            if (self.selecttizhongBool) {
                self.selecttizhongBool=false;
            }else{
                self.selecttizhongBool=true;
            }
        }
            break;
        default:
            break;
    }
    [self.mtableview reloadData];
    
}
//设置分组间隔
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section==0) {
        return 0.01;
    }
    if (section==1) {
        return 0.01;
    }
    if (section==2) {
        return 0.01;
    }
    if (section==3) {
        return 0.01;
    }
    if (section==4) {
        return 0.01;
    }
    if (section==6) {
        return 0.01;
    }
    return 10;
}
-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section;{
    UIView*view=[[UIView alloc]initWithFrame:CGRectMake(0,0,ScreenWidth,10)];
    view.backgroundColor=JGColor(250, 250, 250, 1);
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    switch (section) {
        case 0:
            return 300;
            break;
        case 1:
            return 80;
            break;
        case 2:
            return 80;
            break;
        case 3:
            return 80;
            break;
        case 4:
            return 80;
            break;
        case 5:
            return 40;
            break;
        case 7:
            return 84.0/2;
            break;
        case 10:
            return 84.0/2;
            break;
        default:
            return 0.01;
            break;
    }
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;{
    if (indexPath.section==1) {
        RXMotionTableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:@"RXMotionTableViewCell"];
        if(!cell){
            cell = [[RXMotionTableViewCell alloc]initWithStyle:0 reuseIdentifier:@"RXMotionTableViewCell"];
        }
         cell.separatorInset = UIEdgeInsetsMake(0,kScreenWidth, 0, 0);
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    if (indexPath.section==2) {
        static  NSString *reusstring = @"RXBloodPressureTableViewCell";
        RXBloodPressureTableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:reusstring];
        if (cell==nil) {
            cell=[[RXBloodPressureTableViewCell alloc]initWithStyle:0 reuseIdentifier:@"RXBloodPressureTableViewID1"];
        }
        cell.separatorInset = UIEdgeInsetsMake(0,kScreenWidth, 0, 0);
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    if (indexPath.section==3) {
        static  NSString *reusstring = @"RXBloodPressureTableViewCell";
        RXBloodPressureTableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:reusstring];
        if (cell==nil) {
            cell=[[RXBloodPressureTableViewCell alloc]initWithStyle:0 reuseIdentifier:@"RXBloodPressureTableViewID2"];
        }
        cell.separatorInset = UIEdgeInsetsMake(0,kScreenWidth, 0, 0);
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    if (indexPath.section==4) {
        static  NSString *reusstring = @"RXBloodPressureTableViewID3";
        RXBloodPressureTableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:reusstring];
        if (cell==nil) {
            cell=[[RXBloodPressureTableViewCell alloc]initWithStyle:0 reuseIdentifier:@"a"];
        }
        cell.separatorInset = UIEdgeInsetsMake(0,kScreenWidth, 0, 0);
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    if (indexPath.section==6) {
        static  NSString *reusstring = @"RXTravelTableViewCell";
        RXTravelTableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:reusstring];
        if (cell==nil) {
            cell=[[[NSBundle mainBundle]loadNibNamed:@"RXTravelTableViewCell" owner:self options:nil]firstObject];
        }
        cell.backgroundColor=[UIColor whiteColor];
        NSDictionary*dic;
        if (indexPath.row==0) {
            if (self.healthServiceRecommendBgBOArray.count>0) {
                dic=self.healthServiceRecommendBgBOArray[0];
            }
        }
        if (indexPath.row==1) {
            if (self.healthServiceRecommendJdBOArray.count>0) {
                dic=self.healthServiceRecommendJdBOArray[0];
            }
        }
        if (indexPath.row==2) {
            if (self.healthServiceRecommendXyBOArray.count>0) {
              dic=self.healthServiceRecommendXyBOArray[0];
            }
        }
        cell.titlelabel.text=dic[@"title"];
        [cell.travelImage sd_setImageWithURL:[NSURL URLWithString:dic[@"mainImage"]]];
        cell.separatorInset = UIEdgeInsetsMake(0,kScreenWidth, 0, 0);
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
       
    }else if (indexPath.section==7) {
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
    }else if(indexPath.section==8){
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
    }else if(indexPath.section==9){
        static  NSString *reusstring = @"RXAdvertisingTableViewCell";
        RXAdvertisingTableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:reusstring];
        if (cell==nil) {
            cell=[[[NSBundle mainBundle]loadNibNamed:@"RXAdvertisingTableViewCell" owner:self options:nil]firstObject];
        }
        cell.separatorInset = UIEdgeInsetsMake(0,kScreenWidth, 0, 0);
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;

    } else if(indexPath.section==10){
        static  NSString *reusstring = @"RXHealthyTableViewCell";
        RXHealthyTableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:reusstring];
        if (cell==nil) {
            cell=[[[NSBundle mainBundle]loadNibNamed:@"RXHealthyTableViewCell" owner:self options:nil]firstObject];
        }
        cell.separatorInset = UIEdgeInsetsMake(0,kScreenWidth, 0, 0);
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else if(indexPath.section==11){
       RXShoppingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RXShoppingTableViewCell"];
        if (cell == nil) {
            cell = [[RXShoppingTableViewCell alloc] initWithStyle:UITableViewCellSelectionStyleNone reuseIdentifier:@"RXShoppingTableViewCell"];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    UITableViewCell*cell=[[UITableViewCell alloc]init];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;{
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (section) {
        case 1:{
            if (self.selectyudongBool) {
                return 1;
            }
            return 0;
        }
        case 2:{
            if (self.selectxunyaBool) {
                return 1;
            }
            return 0;
        }
        case 3:{
            if (self.selectxuetangBool) {
                return 1;
            }
            return 0;
        }
        case 4:{
            if (self.selecttizhongBool) {
                return 1;
            }
            return 0;
        }
        case 6:
            return 3;
            break;
        case 9:
            return self.advertisingArray.count;
            break;
        default:
            return 1;
            break;
    }
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 1:{
            return 260;
        }
        case 2:{
            return 300;
        }
        case 3:{
            return 250;
        }
        case 4:{
            return 250;
        }
        case 6:{
                if (indexPath.row==0) {
                    if (self.healthServiceRecommendBgBOArray.count>0) {
                        return 200;
                    }
                    return 0;
                }
                if (indexPath.row==1) {
                    if (self.healthServiceRecommendJdBOArray.count>0) {
                        return 200;
                    }
                    return 0;
                }
                if (indexPath.row==2) {
                    if (self.healthServiceRecommendXyBOArray.count>0) {
                        return 160;
                    }
                    return 0;
                }
            }
            break;
        case 7:{
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
            break;
        case 8:{
                return 180;
            }
            break;
        case 9:{
            return 100;
        }
            break;
        case 10:{
            return 125;
        }
            break;
        case 11:{
            return 200;
        }
        default:
            return 0;
            break;
    }
    return 0;
}

//请求个人信息
-(void)getRequest;{
    RXUserDetailRequest*request=[[RXUserDetailRequest alloc]init:@"54f15410-bcf9-41df-8508-6a2372b9ce30"];
    VApiManager *manager = [[VApiManager alloc]init];
    [manager RXMakeUserDetail:request
                      success:^(AFHTTPRequestOperation *operation, RXUserDetailResponse *response) {
            [self.healthServiceRecommendXyBOArray removeAllObjects];
            [self.healthServiceRecommendBgBOArray removeAllObjects];
            [self.healthServiceRecommendJdBOArray removeAllObjects];
            if (!self.response) {
                self.response=[[RXUserDetailResponse alloc]init];
            }
            self.response = response;
            if (self.response.healthServiceRecommendXyBO) {
                [self.healthServiceRecommendXyBOArray addObject:self.response.healthServiceRecommendXyBO];
            }
            if (self.response.healthServiceRecommendBgBO) {
                [self.healthServiceRecommendBgBOArray addObject:self.response.healthServiceRecommendBgBO];
            }
            if (self.response.healthServiceRecommendJdBO) {
                [self.healthServiceRecommendJdBOArray addObject:self.response.healthServiceRecommendJdBO];
            }
        [self.mtableview reloadData];
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         NSLog(@"%@",error);
          [self hiddenHud];
    }];
}
@end
