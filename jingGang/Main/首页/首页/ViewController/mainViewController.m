//
//  mainViewController.m
//  jingGang
//
//  Created by yi jiehuang on 15/5/12.
//  Copyright (c) 2015年 yi jiehuang. All rights reserved.
//

#import "mainViewController.h"
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
@interface mainViewController ()<YSAPIManagerParamSource,YSAPICallbackProtocol,YSHealthManageHeaderViewDelegate,UICollectionViewDelegate,TZImagePickerControllerDelegate,UITableViewDelegate,UITableViewDataSource>

@property (strong,nonatomic) UITableView *tableView;
@property (strong,nonatomic) NSMutableDictionary *stepUserInfo;
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

@end

@implementation mainViewController

CGFloat dynamicCalculateConsultCellHeight(CGSize imageSize) {
    return ((ScreenWidth * imageSize.height ) / imageSize.width)  + KHealthyConsultMargin * 2;
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

- (UITableView *)tableView {
    if (!_tableView) {
        CGFloat tableX = 0;
        CGFloat tableY = 0;
        CGFloat tableW = ScreenWidth;
        if(iPhoneX_X){
            _tableH = ScreenHeight - NavBarHeight - kTopBarHeight -64;
        }else{
            _tableH = ScreenHeight - NavBarHeight - kTopBarHeight;
        }
       
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(tableX, tableY, tableW, _tableH) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.contentInset = UIEdgeInsetsMake(0, 0, 5.5f, 0);
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = JGColor(247, 247, 247, 1);
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

- (YSNearAdContentDataManager *)adContentDataManager {
    if (!_adContentDataManager) {
        _adContentDataManager = [[YSNearAdContentDataManager alloc] init];
        _adContentDataManager.delegate = self;
        _adContentDataManager.paramSource = self;
    }
    return _adContentDataManager;
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

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:YES];
    self.navigationController.navigationBar.barTintColor = COMMONTOPICCOLOR;
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:YES];
    self.navigationController.navigationBar.barTintColor = COMMONTOPICCOLOR;
    [YSUMMobClickManager endLogPageWithKey:[NSString stringWithFormat:@"%@%@",@"um_",NSStringFromClass([self class])]];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (IsEmpty(GetToken)) {
        [MBProgressHUD showSuccess:@"该功能需要登录才能使用" toView:self.view delay:1];
        return;
    }
    self.tabBarController.tabBar.hidden = NO;
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [UIView setAnimationsEnabled:YES];
    [self requestUserIntergral];
    [self requestMyIntegralExchangeList];
    [_tableView reloadData];
    [self requestStepData];

//    self.navigationController.navigationBar.barTintColor = [YSThemeManager themeColor];
}

- (void)userLoginSuccessToRefreshHealthyManagePageAction {
    [self refreshPage];
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
//    @weakify(self);
//    [YSHealthyMessageDatas chunYuDoctorEntrancePicRequestWithResult:^(BOOL show, UIImage *image, CGSize size) {
//        @strongify(self);
//        self.chunyuDoctorEntranceImageShow = show;
//        self.chunYuEntranceImage = image;
//        self.healthyConsultCellHeight = dynamicCalculateConsultCellHeight(size);
//        [self tableViewReloadDate];
//    }];queryFlipViewInfo
}

- (void)tableViewReloadDate {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
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
    [self reqeustNoticeMessageNoReadCount];
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
            [self clickAdvertItem:adItemContent itemIndex:0];
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
    if ([YSStepManager healthyKitAccess]) {
        @weakify(self);
        [YSStepManager healthStoreDataWithStartDate:nil endDate:nil WithFailAccess:^{
            @strongify(self);
            [self showErrorHudWithText:@"无数据获取权限"];
        } walkRunningCallback:^(NSNumber *walkRunning) {
            @strongify(self);
            [self.stepUserInfo xf_safeSetObject:walkRunning forKey:kStepCount];
//            _headerView.jrrwView.ljlc.text= [NSString stringWithFormat:@"累计里程：%@公里",[walkRunning stringValue]];
//            _headerView.jrrwView.processView.persentage=[walkRunning intValue]/80000;
//            NSIndexSet *set = [NSIndexSet indexSetWithIndex:3];
//            [self.tableView reloadSections:set withRowAnimation:UITableViewRowAnimationNone];
            
        } stepCallback:^(NSNumber *step) {
            CGFloat margin2=(self.tableView.size.width -95*3)/3;
            NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
            
            NSString * api_XYmaxValue = [[defaults objectForKey:@"XYmaxValue"] stringValue];
            NSString * api_XYminValue = [[defaults objectForKey:@"XYminValue"] stringValue];
            
            NSString * str = [NSString stringWithFormat:@"%@/%@",api_XYmaxValue,api_XYminValue];
            NSString * api_xinlv =[[defaults objectForKey:@"heartRateValue"] stringValue];
            NSString * api_xueyang =[[defaults objectForKey:@"xueyangRateValue"] stringValue];
            
                if (api_XYmaxValue == NULL) {
                [ _headerView.jrrwView.xueyang removeFromSuperview];
           _headerView.jrrwView.xueya= [_headerView.jrrwView genItem:@"xueya" titles:@[@"血压",@"--/--",@"mmHg"]];
                } else {
                    [_headerView.jrrwView.xueya removeFromSuperview];
                _headerView.jrrwView.xueya= [_headerView.jrrwView genItem:@"xueya" titles:@[@"血压",str,@"mmHg"]];
                }
       
         
            if (api_xinlv== NULL) {
                  [ _headerView.jrrwView.xueyang removeFromSuperview];
                _headerView.jrrwView.xinlv= [_headerView.jrrwView genItem:@"xinlv" titles:@[@"心率",@"--",@"BMP"]];
            }else{
                [_headerView.jrrwView.xinlv removeFromSuperview];
                _headerView.jrrwView.xinlv= [_headerView.jrrwView genItem:@"xinlv" titles:@[@"心率",api_xinlv,@"BMP"]];
            }
            
            if (api_xueyang==NULL) {
                  [ _headerView.jrrwView.xueyang removeFromSuperview];
               _headerView.jrrwView.xueyang= [_headerView.jrrwView genItem:@"xueyang" titles:@[@"血氧",@"--",@"%"]];
            } else {
                
                [ _headerView.jrrwView.xueyang removeFromSuperview];
                
              _headerView.jrrwView.xueyang= [_headerView.jrrwView genItem:@"xueyang" titles:@[@"血氧",api_xueyang,@"%"]];
            }
            _headerView.jrrwView.xueya.x =margin2;
            _headerView.jrrwView.xinlv.x=_headerView.jrrwView.xueya.x+_headerView.jrrwView.xueya.width+margin2+10;
            _headerView.jrrwView.xueyang.x=_headerView.jrrwView.xinlv.x+_headerView.jrrwView.xinlv.width+margin2;
            [_headerView.jrrwView.part2 addSubview:_headerView.jrrwView.xueya];
            [_headerView.jrrwView.part2 addSubview: _headerView.jrrwView.xinlv];
            [_headerView.jrrwView.part2 addSubview:_headerView.jrrwView.xueyang];
            
            @strongify(self);
            [self.stepUserInfo xf_safeSetObject:step forKey:kStepCount];
            
            
            NSString *string1 = [[NSUserDefaults standardUserDefaults] objectForKey:@"sdbs"];
            
            if(string1.length == 0){
                
                _headerView.jrrwView.count.text=@"- -";
                
                _headerView.jrrwView.ljlc.text =[NSString stringWithFormat:@"累计里程：--公里"];
                _headerView.jrrwView.reliangLabel.text = [NSString stringWithFormat:@"消耗热量：--卡"];
                 _headerView.jrrwView.mubiao.textColor=kGetColor(93,187,177);
                
                _headerView.jrrwView.processView.persentage= 0.00/80000;
                NSIndexSet *set = [NSIndexSet indexSetWithIndex:3];
                [self.tableView reloadSections:set withRowAnimation:UITableViewRowAnimationNone];
                
                
            }else  {
                
                _headerView.jrrwView.count.text=[step stringValue];
                double gongli = [step doubleValue] * 0.00065;
                _headerView.jrrwView.mubiao.text =[NSString stringWithFormat:@"设定目标：%@",string1];;
                _headerView.jrrwView.ljlc.text =[NSString stringWithFormat:@"累计里程：%.2f公里",gongli];
                int kaluli =  62*gongli*0.8;
                _headerView.jrrwView.reliangLabel.text = [NSString stringWithFormat:@"消耗热量：%d卡",kaluli];
                _headerView.jrrwView.processView.persentage= [step floatValue]/[string1 longValue];
                NSIndexSet *set = [NSIndexSet indexSetWithIndex:3];
                [self.tableView reloadSections:set withRowAnimation:UITableViewRowAnimationNone];
            }
         
        }];
    }
}

- (void)disafterDismiss {
    @weakify(self);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        @strongify(self);
        [self hiddenHud];
    });
}

- (void)setup {
    [YSThemeManager setNavigationTitle:@"今日任务" andViewController:self];
    [self setupNavRightButtonWithImage:@"ys_healthmanager_comment" showBage:NO number:1];
    self.automaticallyAdjustsScrollViewInsets = NO;
    @weakify(self);
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        @strongify(self);
        [self refreshPage];
        [self disafterDismiss];
    }];
    self.tableView.mj_header = header;
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
    [floatImageView addTapActionWithBlock:^(UIGestureRecognizer *gestureRecoginzer) {
        @strongify(self);
        [self enterActivityH5Controller];
    }];
    floatImageView.hidden = YES;
    self.floatImageView = floatImageView;
    [self.view addSubview:self.floatImageView];
}
/**
 *  进入活动页面 */
- (void)enterActivityH5Controller {
    YSActivityController *activityH5Controller = [[YSActivityController alloc] init];
    activityH5Controller.activityInfoItem = self.actInfoItem;
    [self.navigationController pushViewController:activityH5Controller animated:YES];
}

- (void)refreshPage {
    [self showHud];
    @weakify(self);
    [self chunYuDoctorEnterRequest];
    [HealthyManageData healthyManagerSuccess:^(YSUserCustomer *userCustomer, YSQuestionnaire *questionnaire, NSArray *postList,YSTodayTaskList *taskList,YSHealthyManageTestLinkConfig *testLinkConfig) {
        @strongify(self);
        [self.circles removeAllObjects];
        [self.circles xf_safeAddObjectsFromArray:postList];
        self.userCustome = userCustomer;
        self.userCustome.successCode = 1;
        self.questionnaire = questionnaire;
        self.questionnaire.successCode = 1;
        self.taskList = taskList;
        self.taskList.successCode = 1;
        [self.tableView.mj_header endRefreshing];
        [self tableViewReloadDate];
        [self hiddenHud];
    } fail:^{
        @strongify(self);
        [self.tableView.mj_header endRefreshing];
        [self hiddenHud];
        self.userCustome.successCode = 0;
        self.questionnaire.successCode = 0;
        self.taskList.successCode = 0;
        [self tableViewReloadDate];
    } error:^{
        @strongify(self);
        [self hiddenHud];
        [self.tableView.mj_header endRefreshing];
        self.userCustome.successCode = 0;
        self.questionnaire.successCode = 0;
        self.taskList.successCode = 0;
        [self tableViewReloadDate];
    } unlogined:^(NSArray *postList) {
        @strongify(self);
        [self.tableView.mj_header endRefreshing];
        [self.circles removeAllObjects];
        [self.circles xf_safeAddObjectsFromArray:postList];
        self.userCustome.successCode = 0;
        self.questionnaire.successCode = 0;
        self.taskList.successCode = 0;
        [self tableViewReloadDate];
        [self hiddenHud];
    } isCache:YES];
}

/**
 *  监听导航栏右侧按钮 */
- (void)rightItemAction {
    UNLOGIN_HANDLE
    NoticeController *noticeController = [[NoticeController alloc]init];
    [self.navigationController pushViewController:noticeController animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self.securityVerifyCodeImgManager requestData];
    
    
    
    [self setup];
    self.view.backgroundColor = JGColor(247, 247, 247, 1);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"kUserDidLoadMainController" object:nil];
    });
    self.navigationController.navigationBar.barStyle=UIStatusBarStyleLightContent;
    
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

#pragma mark  ********* TableView HeaderView ******
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    @weakify(self);
    switch (section) {
        case 0:{
            if (!self.headerView) {
                YSHealthManageHeaderView *headerView = [[YSHealthManageHeaderView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, [YSHealthManageHeaderView tableViewHearderHeight]) buttonClickCallback:^(NSInteger index) {
                    @strongify(self);
                    [self headerViewButtonClickWithIdex:index];
                } clickCallback:^(id obj){
//                    NSDictionary *dict = (NSDictionary *)obj;
                    DefuController *defuVC = [[DefuController alloc] init];
                    [self.navigationController pushViewController:defuVC animated:YES];
                }];
                headerView.delegate = self;
                self.headerView = headerView;
            }
            
            // 赋值广告数据
            self.headerView.adContentItem = self.adContentItem;
            //去做任务赚积分
            self.headerView.goMissionButtonClickBlock = ^{
                UNLOGIN_HANDLE
                @strongify(self);
                YSGoMissionController *goMissionController = [[YSGoMissionController alloc]init];
                [self.navigationController pushViewController:goMissionController animated:YES];
            };
            self.headerView.userClickedTestActionCallback = ^(NSString *buttonClickCurrentTitle){
                UNLOGIN_HANDLE
                @strongify(self);
                if (!self.userCustome.successCode) {
                    [UIAlertView xf_showWithTitle:@"账号信息出错或账号已过期,请重新登录!" message:nil delay:1.2 onDismiss:NULL];
                    return;
                }
                YSHealthyManageWebController *testWebController = [[YSHealthyManageWebController alloc] initWithWebType:YSHealthyManageHealthyTestType uid:self.userCustome.uid];
                [self.navigationController pushViewController:testWebController animated:YES];
            };
            [YSBaseInfoManager loadBaseInfo:^(NSString *city, YSWeatherInfo *weatherInfo) {
                @strongify(self);
                if (weatherInfo) {
                    [self.headerView setBaseInfoWithCity:city weatherInfo:weatherInfo];
                }else {
                    weatherInfo = [[YSWeatherInfo alloc] init];
                    weatherInfo.temperature = @"20℃";
                    weatherInfo.weather = @"晴天";
                    weatherInfo.weatherTag =  @"0";
                    [self.headerView setBaseInfoWithCity:city weatherInfo:weatherInfo];
                }
            }];
            [self.headerView setUserInfoWithUserCustomer:self.userCustome questionnaire:self.questionnaire];
            return self.headerView;
        }
            break;
        case 1:
        {
            return [UIView new];
        }
            break;
        case 2:
        {
            YSHealthyTaskView *view = [[YSHealthyTaskView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 84.0/2) questionnaire:self.questionnaire tasks:self.taskList addTaskCallback:^{
                YSHealthyManageWebController *testWebController = [[YSHealthyManageWebController alloc] initWithWebType:YSHealthyManageAddTaskType uid:self.userCustome.uid];
                [self.navigationController pushViewController:testWebController animated:YES];
            }];
            [view setBackgroundColor:JGWhiteColor];
            return view;
        }
            break;
        case 3:
        {
            return [UIView new];
        }
            break;
        case 4:
        {
            UIView *healthyCircle = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 84.0/2)];
            UILabel *lab = [[UILabel alloc] init];
            lab.x = 12.0f+21;
            lab.y = 0;
            lab.width = ScreenWidth;
            lab.height = healthyCircle.height;
            lab.font = JGRegularFont(15);
            lab.text =@"积分兑换";
            lab.backgroundColor = JGClearColor;
            healthyCircle.backgroundColor = JGWhiteColor;
            [healthyCircle addSubview:lab];
            
            UIView *themeView = [[UIView alloc] initWithFrame:CGRectMake(16, 0, 5, 20)];
            themeView.layer.cornerRadius = 2.5;
            
            themeView.backgroundColor = [YSThemeManager themeColor];
            [healthyCircle addSubview:themeView];
            themeView.centerY=lab.centerY;
            
            UILabel *moreButton=[UILabel new];
            moreButton.textAlignment=NSTextAlignmentRight;
            moreButton.text= @"更多";
            moreButton.textColor = [YSThemeManager themeColor];
            moreButton.font = JGRegularFont(13);
            moreButton.x = ScreenWidth - 150 - 16;
            moreButton.width = 150;
            moreButton.height = healthyCircle.height;;
            moreButton.y = 5;
            [moreButton addTapActionWithBlock:^(UIGestureRecognizer *gestureRecoginzer) {
                @strongify(self);
                [self gotojifenshangcheng];
            }];
            moreButton.userInteractionEnabled=YES;
            [healthyCircle addSubview:moreButton];
            
            UIView * bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, healthyCircle.height - 0.5, ScreenWidth, 0.5)];
            bottomView.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.2];
            [healthyCircle addSubview:bottomView];
            return healthyCircle;
        }
            break;
        default:
            break;
    }
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    switch (section) {
        case 0:
        {
            return 400;//(358.5 - 9.2 - 4) + self.adContentItem.adTotleHeight;
        }
            break;
        case 1:
            return 8.;
            break;
        case 2:
            return 84.0 / 2;
            break;
        case 4:
            return 84.0 / 2;
            break;
        default:
            break;
    }
    return 4;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 6;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
//        case 0:
//            return [HealthyManageData suggestDatasWithQuestionnaire:self.questionnaire].count;
//            break;
        case 1:
            return 1;
            break;
        case 2:
            return 1;//[HealthyManageData taskDatasWithTaskList:self.taskList].count;
            break;
        case 3:
            return 1;
            break;
        case 4:
            return 1;//self.circles.count;
        default:
            break;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
//        case 0:
//            return 36.0f;
//            break;
        case 1:
        {
            return 0.001f;
        }
            break;
        case 2:
        {
            if (self.taskList.result) {
                if (self.taskList.successCode) {
                    if (self.taskList.healthTaskList.count) {
                        return 140.0;
                    }else {
//                        return kHealthyTaskCellHeight([self.taskList.result integerValue]);
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
        case 3:
            return 180;//kHealthyStepCellHeight;
            break;
        case 4:
        {
            return  ((self.intergralProductsListArrayData.count%2)+self.intergralProductsListArrayData.count/2)*(ScreenWidth-80)/2;
        }
            break;
        default:
            break;
    }
    return 0;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0:
        {
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
            id dic = [[HealthyManageData suggestDatasWithQuestionnaire:self.questionnaire] xf_safeObjectAtIndex:indexPath.row];
            if ([dic isKindOfClass:[NSDictionary class]]) {
                NSString *suggestId = dic[@"id"];
                YSHealthyManageWebController *suggestWeb = [[YSHealthyManageWebController alloc] initWithWebType:YSHealthyManageHealthySuggestType uid:self.userCustome.uid];
                suggestWeb.proposalID = suggestId;
                [self.navigationController pushViewController:suggestWeb animated:YES];
            }else {
            }
        }
            break;
        case 3:
        {
            if ([self.questionnaire.result integerValue] == 15) {
                
            }else {
                [tableView deselectRowAtIndexPath:indexPath animated:YES];
            }
        }
            break;
        case 5:
        {
            /**
             *  push到帖子详情 */
            [self _pushCircleDetailControllerWithIndexPath:indexPath];
        }
        default:
            break;
    }
}

- (void)_pushCircleDetailControllerWithIndexPath:(NSIndexPath *)indexPath {
    YSFriendCircleFrame *frame = [self.circles xf_safeObjectAtIndex:indexPath.row];
    YSFriendCircleDetailController *friendCircleDetailController = [[YSFriendCircleDetailController alloc] initWithCircleModel:frame];
    [self.navigationController pushViewController:friendCircleDetailController animated:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
//        static NSString *CellId = @"identifierId";
//        UITableViewCell *cell   = [tableView dequeueReusableCellWithIdentifier:CellId];
//        if (!cell) {
//            cell = [[UITableViewCell  alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellId];
//            UIView *bottomView = [[UIView alloc] init];
//            bottomView.tag = 1000 + indexPath.row;
//            [cell.contentView addSubview:bottomView];
//        }
////        id text = [[HealthyManageData suggestDatasWithQuestionnaire:self.questionnaire] xf_safeObjectAtIndex:indexPath.row];
////        if ([text isKindOfClass:[NSMutableAttributedString class]]) {
////            cell.textLabel.attributedText = text;
////            cell.accessoryType = UITableViewCellAccessoryNone;
////            cell.selectionStyle = UITableViewCellSelectionStyleNone;
////        }else if([text isKindOfClass:[NSDictionary class]]){
////            NSDictionary *dic = (NSDictionary *)text;
////            cell.textLabel.text = [dic objectForKey:@"proposalTitle"];
////            cell.textLabel.font = JGFont(12);
////            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
////            cell.selectionStyle = UITableViewCellSelectionStyleGray;
////        }
//        UIView *bottomView = [cell.contentView viewWithTag:1000 + indexPath.row];
//        bottomView.y = 35.5f;
//        bottomView.width = ScreenWidth;
//        bottomView.height = .5;
//        bottomView.backgroundColor = JGColor(247, 247, 247, 1);
        
        
        return NULL;
    }else if (indexPath.section == 1){
        if (self.chunyuDoctorEntranceImageShow) {
            @weakify(self);
            YSHealthyConsultCell *cell = [YSHealthyConsultCell setupWithTableView:tableView consultCallback:^{
                @strongify(self);
//                JGLog(@"--- 去咨询");
                [self showHud];
                [YSHealthyMessageDatas  chunYuDoctorUrlRequestWithResult:^(BOOL ret, NSString *msg) {
                    [self hiddenHud];
                    if (ret) {
                        YSLinkCYDoctorWebController *cyDoctorController = [[YSLinkCYDoctorWebController alloc] initWithWebUrl:msg];
                        cyDoctorController.tag = 100;
                        cyDoctorController.controllerPushType = YSControllerPushFromHealthyManagerType;
                        [self.navigationController pushViewController:cyDoctorController animated:YES];
                    }else {
                        [UIAlertView xf_showWithTitle:msg message:nil delay:2.0 onDismiss:NULL];
                    }
                }];
            }];
            cell.consultImage = self.chunYuEntranceImage;
            return cell;
        }else {
            static NSString *cellId = @"kDoctorConsultHiddenCell";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
            }
            return cell;
        }
    }else if (indexPath.section  == 2) {
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
        return cell;
    }else if (indexPath.section == 3) {
//        @weakify(self);
//        return [YSHealthyStepCell setupWithTableView:tableView data:self.stepUserInfo updateStep:^{
//            @strongify(self);stepUserInfo
//            [UIAl ertView xf_showWithTitle:@"正在更新记步数据..." message:nil delay:2.0 onDismiss:NULL];
//            [self requestStepData];
//        }];
        YSJijfenrenwTableVIewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"jirirenwucellid"];
        if (cell == nil) {
            cell = [[YSJijfenrenwTableVIewCell alloc] initWithStyle:UITableViewCellSelectionStyleNone reuseIdentifier:@"jirirenwucellid"];
            //设置你的cell
        }
        if (self.userIntegral==nil) {
            cell.integral=nil;
        } else {
            cell.integral=self.userIntegral;
        }
        cell.models = self.intergralListArrayData;
        cell.delegate = self;
        return cell;
    }else if (indexPath.section == 4) {
        YSjifenduihuanView *cell = [tableView dequeueReusableCellWithIdentifier:@"jifenduihuanCellid"];
        if (cell == nil) {
            cell = [[YSjifenduihuanView alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"jifenduihuanCellid"];
        }
        cell.models = self.intergralProductsListArrayData;
        cell.delegate = self;
        return cell;
    }
    return nil;
}

- (void)configCell:(YSFriendCircleCell *)cell cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YSFriendCircleFrame *frame = [self.circles xf_safeObjectAtIndex:indexPath.row];
    frame.hiddenToolBar = NO;
    frame.hiddenCommentsBgView = NO;
    cell.circleFrame = frame;
    YSFriendCircleModel *friendCircleModel = frame.friendCircleModel;
    @weakify(self);
    /**
     *  进入详情 */
    cell.friendCircleClickCallback = ^(ToolsButtonsClickType type) {
        @strongify(self);
        [self fixesToolsActionWithType:type indexPath:indexPath];
    };
    cell.clickImageCallback = ^(NSInteger imageIndex) {
    };
    cell.clickUserIconCallback = ^{
        @strongify(self);
        [self _personalInfoControllerWithUid:friendCircleModel.uid];
    };
    cell.clickTopicCallback = ^(NSString *topic) {
        @strongify(self);
        [self _topicControllerWithLabelName:topic];
    };
}

/**
 *  分享帖子 */
- (void)shareCircleWithCircleFrame:(YSFriendCircleFrame *)frame{
    UNLOGIN_HANDLE
    //先把平台会员总数请求到了之后再开始分享
    VApiManager *vapiManager = [[VApiManager alloc] init];
    CountUserRegisterCountRequest *requst = [[CountUserRegisterCountRequest alloc]init:@""];
    [self showHud];
    @weakify(self);
    [vapiManager countUserRegisterCount:requst success:^(AFHTTPRequestOperation *operation, CountUserRegisterCountResponse *response) {
        @strongify(self);
        [self hiddenHud];
        YSShareManager *shareManager = [[YSShareManager alloc] init];
//        NSString *shareContent = frame.friendCircleModel.content.length > 15?[frame.friendCircleModel.content substringToIndex:14]:frame.friendCircleModel.content;
        NSDictionary *dictUserInfo = [NSDictionary dictionaryWithDictionary:[kUserDefaults objectForKey:kUserCustomerKey]];
        NSString *shareUrl = KFriendCircleShareLink(frame.friendCircleModel.postId,dictUserInfo[@"invitationCode"]);
        NSInteger userRegisterCountAll = [response.userRegisterCount integerValue];
        NSString *strShareContent = kShareFriendCirclePost(userRegisterCountAll);
        YSShareConfig *config = [YSShareConfig configShareWithTitle:[YSLoginManager userNickName] content:strShareContent UrlImage:frame.friendCircleModel.headImgPath shareUrl:shareUrl];
        [shareManager shareWithObj:config showController:self];
        self.shareManager = shareManager;
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        @strongify(self);
        [self hiddenHud];
        [UIAlertView xf_showWithTitle:@"网络好像是不很给力，请检查网络后再试" message:nil delay:1.0 onDismiss:NULL];
    }];
}

- (void)fixesToolsActionWithType:(ToolsButtonsClickType)type indexPath:(NSIndexPath *)indexPath {
    YSFriendCircleFrame *frame = [self.circles xf_safeObjectAtIndex:indexPath.row];
    YSFriendCircleModel *friendCircleModel = frame.friendCircleModel;
    NSString *postId = friendCircleModel.postId;
    switch (type) {
        case ToolsButtonClickWithShareType:
        {
            /**
             *  分享 */
            [self shareCircleWithCircleFrame:frame];
        }
            break;
        case ToolsButtonClickWithConmmentType:
        {
            /**
             *  push到帖子详情 */
            [self _pushCircleDetailControllerWithIndexPath:indexPath];
        }
            break;
            
       
        case ToolsButtonClickWithAgreeType:
        {
            /**
             *  点赞、取消点赞处理 */
            UNLOGIN_HANDLE
            if ([friendCircleModel.ispraise integerValue]) {
                /**
                 *  已点过赞，  取消点赞请求 */
                @weakify(self);
                [YSFriendCircleRequestManager cancelAgreeWithPostId:[postId integerValue] success:^{
                    @strongify(self);
                    friendCircleModel.ispraise = @"0";
                    if ([NSString stringWithFormat:@"%zd",[friendCircleModel.praiseNum integerValue] - 1] < 0) {
                        friendCircleModel.praiseNum = @"0";
                    }else {
                        friendCircleModel.praiseNum = [NSString stringWithFormat:@"%zd",[friendCircleModel.praiseNum integerValue] - 1];
                    }
                    frame.friendCircleModel = friendCircleModel;
                    [self.circles xf_safeReplaceObjectAtIndex:indexPath.row withObject:frame];
                    [self.tableView reloadRow:indexPath.row inSection:5 withRowAnimation:UITableViewRowAnimationNone];
                    [self showSuccessHudWithText:@"取消点赞"];
                } fail:^{
                    [self showSuccessHudWithText:@"点赞失败"];
                } error:^{
                    [self showSuccessHudWithText:@"网络错误"];
                }];
            }else {
                /**
                 *  未点过赞， 点赞请求*/
                UNLOGIN_HANDLE
                @weakify(self);
                [YSFriendCircleRequestManager agreeWithPostId:[postId integerValue] success:^{
                    @strongify(self);
                    friendCircleModel.ispraise = @"1";
                    friendCircleModel.praiseNum = [NSString stringWithFormat:@"%zd",[friendCircleModel.praiseNum integerValue] + 1];
                    frame.friendCircleModel = friendCircleModel;
                    [self.circles xf_safeReplaceObjectAtIndex:indexPath.row withObject:frame];
                    [self.tableView reloadRow:indexPath.row inSection:5 withRowAnimation:UITableViewRowAnimationNone];
                    [self showSuccessHudWithText:@"点赞成功"];
                } fail:^{
                    [self showSuccessHudWithText:@"点赞失败"];
                } error:^{
                    [self showSuccessHudWithText:@"网络错误"];
                }];
            }
        }
            break;
        default:
            break;
    }
}

#pragma mark ---------标签页面---------
- (void)_topicControllerWithLabelName:(NSString *)labelName {
    @weakify(self);
    [YSFriendCircleRequestManager postListWithPostName:labelName pageNum:1 pageSize:10 success:^(NSArray *lists){
        @strongify(self);
        [self pushTopicControllerWithLabelName:labelName lists:lists];
    } fail:^{
        @strongify(self);
        [self pushTopicControllerWithLabelName:labelName lists:nil];
    } error:^{
        @strongify(self);
        [self pushTopicControllerWithLabelName:labelName lists:nil];
    }];
}

- (void)pushTopicControllerWithLabelName:(NSString *)labelName lists:(NSArray *)lists {
    YSFriendCircleController *friendCircleController = [[YSFriendCircleController alloc] init];
    [friendCircleController setupNavBarPopButton];
    [YSThemeManager setNavigationTitle:labelName andViewController:friendCircleController];
    if (lists) {
        friendCircleController.datas = lists;
        [self topicHeaderRequest:friendCircleController labelName:labelName];
        [self topicFooterRequest:friendCircleController labelName:labelName];
    }
    [self.navigationController pushViewController:friendCircleController animated:YES];
}

/**
 *  话题加载刷新 */
- (void)topicHeaderRequest:(YSFriendCircleController *)friendCircleController labelName:(NSString *)labelName {
    @weakify(friendCircleController);
    friendCircleController.headerCallback = ^(){
        [YSFriendCircleRequestManager postListWithPostName:labelName pageNum:1 pageSize:10 success:^(NSArray *lists) {
            @strongify(friendCircleController);
            friendCircleController.datas = lists;
            [friendCircleController.tableView.mj_header endRefreshing];
        } fail:^{
            @strongify(friendCircleController);
            [friendCircleController.tableView.mj_header endRefreshing];
        } error:^{
            @strongify(friendCircleController);
            [friendCircleController.tableView.mj_header endRefreshing];
        }];
    };
}

- (void)topicFooterRequest:(YSFriendCircleController *)friendCircleController labelName:(NSString *)labelName {
    @weakify(friendCircleController);
    friendCircleController.footerCallback = ^(){
        @strongify(friendCircleController);
        if (friendCircleController.currentRequestPage == 1 ) {
            friendCircleController.currentRequestPage = 2;
        }
        @weakify(friendCircleController);
        [YSFriendCircleRequestManager postListWithPostName:labelName pageNum:friendCircleController.currentRequestPage pageSize:10 success:^(NSArray *lists) {
            @strongify(friendCircleController);
            if (lists.count > 0) {
                friendCircleController.moreDatas = lists;
                friendCircleController.currentRequestPage += 1;
            }
            [friendCircleController.tableView.mj_footer endRefreshing];
        } fail:^{
            @strongify(friendCircleController);
            [friendCircleController.tableView.mj_footer endRefreshing];
        } error:^{
            @strongify(friendCircleController);
            [friendCircleController.tableView.mj_footer endRefreshing];
        }];
    };
}

#pragma mark -----------个人页面------------
- (void)_personalInfoControllerWithUid:(NSString *)uid {
    @weakify(self);
    /**
     *  请求用户帖子列表信息 */
    [YSFriendCircleRequestManager circlePersonalInfomationWithUid:uid pageNum:1 pageSize:10 success:^(NSArray *lists,YSCircleUserInfo *userInfo){
        @strongify(self);
        // 个人信息请求成功
        [self _personalInfoSuccessWithLists:lists userInfo:userInfo uid:uid];
        
    } fail:^{
        
    } error:^{
        
    }];
}

/**
 *  个人信息请求成功 */
- (void)_personalInfoSuccessWithLists:(NSArray *)lists userInfo:(YSCircleUserInfo *)userInfo uid:(NSString *)uid {
    YSCirclePersonalInfoView *infoView = [[YSCirclePersonalInfoView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 200) configData:userInfo];
    YSFriendCircleController *friendCircleController = [[YSFriendCircleController alloc] init];
    friendCircleController.datas = lists;
    friendCircleController.tableView.tableHeaderView = infoView;
   [friendCircleController setupNavBarPopButton];
    [YSThemeManager setNavigationTitle:@"个人信息" andViewController:friendCircleController];
    [self _personalInfoFooterRequestWithController:friendCircleController uid:uid];
    [self _personalInfoHeaderRequestWithController:friendCircleController uid:uid];
    [self.navigationController pushViewController:friendCircleController animated:YES];
}

/**
 *  个人信息加载更多 */
- (void)_personalInfoFooterRequestWithController:(YSFriendCircleController *)personalInfoController uid:(NSString *)uid {
    @weakify(personalInfoController);
    personalInfoController.footerCallback = ^(){
        @strongify(personalInfoController);
        @weakify(personalInfoController);
        if (personalInfoController.currentRequestPage < 2) {
            personalInfoController.currentRequestPage = 2;
        }
        [YSFriendCircleRequestManager circlePersonalInfomationWithUid:uid pageNum:personalInfoController.currentRequestPage pageSize:10 success:^(NSArray *lists, YSCircleUserInfo *userInfo) {
            @strongify(personalInfoController);
            personalInfoController.moreDatas = lists;
            if (lists.count > 1) {
                personalInfoController.currentRequestPage += 1 ;
            }
            [personalInfoController.tableView.mj_footer endRefreshing];
        } fail:^{
            @strongify(personalInfoController);
            [personalInfoController.tableView.mj_footer endRefreshing];
        } error:^{
            @strongify(personalInfoController);
            [personalInfoController.tableView.mj_footer endRefreshing];
        }];
    };
}

#pragma mark - 请求未读消息数量
-(void)reqeustNoticeMessageNoReadCount {
    if (GetToken) {
        VApiManager *manager = [[VApiManager alloc] init];
        UserMessageListRequest *request = [[UserMessageListRequest alloc]init:GetToken];
        request.api_type = @"1";
        request.api_pageNum = @1;
        request.api_pageSize = @10;
        @weakify(self);
        [manager userMessageList:request success:^(AFHTTPRequestOperation *operation, UserMessageListResponse *response) {
            @strongify(self);
            
            if (response.unreadMessageNo.integerValue > 0) {
                [self setupNavRightButtonWithImage:@"ys_healthmanager_comment" showBage:YES number:[response.unreadMessageNo integerValue]];
            }else{
                [self setupNavRightButtonWithImage:@"ys_healthmanager_comment" showBage:NO number:0];
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
        }];
    }else{//没登录就设置为0
        [self setupNavRightButtonWithImage:@"ys_healthmanager_comment" showBage:NO number:0];
    }
}

/**
 *  个人信息请求刷新 */
- (void)_personalInfoHeaderRequestWithController:(YSFriendCircleController *)personalInfoController uid:(NSString *)uid
{
    @weakify(personalInfoController);
    personalInfoController.headerCallback = ^{
        /**
         *  刷新 */
        [YSFriendCircleRequestManager  circlePersonalInfomationWithUid:uid pageNum:1 pageSize:10 success:^(NSArray *lists, YSCircleUserInfo *userInfo) {
            @strongify(personalInfoController);
            personalInfoController.datas = lists;
            [personalInfoController.tableView.mj_header endRefreshing];
            [MBProgressHUD showSuccess:@"更新数据" toView:personalInfoController.view];
        } fail:^{
            @strongify(personalInfoController);
            [MBProgressHUD showError:@"请求失败" toView:personalInfoController.view];
        } error:^{
            @strongify(personalInfoController);
            [MBProgressHUD showError:@"请求错误" toView:personalInfoController.view];
        }];
    };
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
    
    [self.tableView reloadData];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
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


- (void)requestMyIntegralExchangeList {
    IntegralListByCriteriaRequest *request = [[IntegralListByCriteriaRequest alloc] init:GetToken];
    request.api_mobileRecommend = @"2";
    request.api_pageSize = @4;
    request.api_pageNum = @1;
    VApiManager *manager = [[VApiManager alloc] init];
   
    
    [manager integralListByCriteria:request success:^(AFHTTPRequestOperation *operation, IntegralListByCriteriaResponse *response) {
        
        NSLog(@"%@.....",operation);
        
            NSArray *arrayList = [response.integralList copy];
            [self.intergralProductsListArrayData removeAllObjects];
            for (NSInteger i = 0; i < arrayList.count; i++) {
                NSDictionary *dicDetailsList = [NSDictionary dictionaryWithDictionary:arrayList[i]];
                [self.intergralProductsListArrayData addObject:[JGIntegralCommendGoodsModel objectWithKeyValues:dicDetailsList]];
            }
            [self.tableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        [MBProgressHUD hideHUDForView:weak_self.view animated:YES];
//        [weak_self.tableView.mj_header endRefreshing];
//        [weak_self.tableView.mj_footer endRefreshing];
    }];
}
-(void)gotojifenshangcheng{
    IntegralNewHomeController *integralShopHomeController = [[IntegralNewHomeController alloc] init];
    integralShopHomeController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:integralShopHomeController animated:YES];
}
//获取用积分信息

@end
