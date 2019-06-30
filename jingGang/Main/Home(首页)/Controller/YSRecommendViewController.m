//
//  YSRecommendViewController.m
//  jingGang
//
//  Created by 左衡 on 2018/7/28.
//  Copyright © 2018年 dengxf_dev. All rights reserved.
//

#import "YSRecommendViewController.h"
#import "YSRecommendHeaderView.h"
#import "YSPredictTableViewCell.h"
#import "YSSeviceTableViewCell.h"
#import "YSGoodsTableViewCell.h"
#import "YSHotInfoTableViewCell.h"
#import "HomeConst.h"
#import "GlobeObject.h"
#import "YSSurroundAreaCityInfo.h"
#import "YSLocationManager.h"
#import "RecommentCodeDefine.h"
#import "YSRecommendHeaderViewModel.h"
#import "MJExtension.h"
#import "WebDayVC.h"
#import "DefuController.h"
#import "YSHealthySelfTestController.h"
#import "ListVC.h"
#import "foodViewController.h"
#import "JGCustomTestFaceController.h"
#import "testchildViewController.h"
#import "YSHealthyMessageController.h"
#import "NewCenterVC.h"
#import "HealthyManageData.h"
#import "YYKitMacro.h"
#import "YSHealthyManageWebController.h"
#import "VApiManager.h"
#import "YSHealthAIOController.h"
#import "YSLinkCYDoctorWebController.h"
#import "KJGoodsDetailViewController.h"
#import "YSAdContentView.h"
#import "YSAdContentItem.h"
#import "YSConfigAdRequestManager.h"
#import "WSJMerchantDetailViewController.h"
#import "ServiceDetailController.h"
#import "YSActivityController.h"
#import "YSBaseInfoManager.h"
#import "JGActivityHelper.h"
#import "AppDelegate+JGActivity.h"
#import "YSLoginManager.h"


static NSString *predictCellID = @"predictCellID";
static NSString *seviceCellID = @"seviceCellID";
static NSString *goodsCellID = @"goodsCellID";
static NSString *heathInfoCellID = @"heathInfoCellID";

@interface YSRecommendViewController ()<UITableViewDelegate,UITableViewDataSource,SDCycleScrollViewDelegate,UICollectionViewDelegate>
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)YSRecommendHeaderView *headerView;
@property (nonatomic, strong)NSArray *sectionTitles;
@property (nonatomic, strong)VApiManager *vapiManager;
@property (nonatomic, strong)NSMutableArray *advListArray;
@property (strong,nonatomic)YSHealthyManageTestLinkConfig *testLinkConfig;
@property (nonatomic, strong)NSArray *GoodsModels;
@property (nonatomic, strong)NSMutableArray *InfosModels;
@property (assign, nonatomic) NSInteger pageNum;
/**
 *  用户信息 */
@property (strong,nonatomic) YSUserCustomer *userCustome;
//广告位视图
@property (strong,nonatomic) YSAdContentView *adContentView;
@property (strong,nonatomic) YSAdContentItem *adContentItem;

@property (strong,nonatomic) UIImageView *floatImageView;

@property (strong,nonatomic) YSActivitiesInfoItem *actInfoItem;
@end

@implementation YSRecommendViewController
- (VApiManager *)vapiManager
{
    if (_vapiManager == nil) {
        _vapiManager = [[VApiManager alloc ]init];
    }
    return _vapiManager;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUpUI];
    [self initData];
    if ([YSLocationManager locationAvailable]) {
        [YSLocationManager beginLocateSuccess:^{ } fail:^{ }];
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateUserLocationCoordinate) name:kDidUpdateUserLocationKey object:nil];
}

- (void)setUpUI{
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = JGColor(249, 249, 249, 1);
    _headerView = [[YSRecommendHeaderView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenWidth*262/750 + 150)];
    _headerView.delegate = self;
    _tableView.tableHeaderView = _headerView;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView registerClass:[YSPredictTableViewCell class] forCellReuseIdentifier:predictCellID];
    [_tableView registerClass:[YSSeviceTableViewCell class] forCellReuseIdentifier:seviceCellID];
    [_tableView registerClass:[YSGoodsTableViewCell class] forCellReuseIdentifier:goodsCellID];
    [_tableView registerClass:[YSHotInfoTableViewCell class] forCellReuseIdentifier:heathInfoCellID];
    //健康资讯数据
    self.InfosModels = [NSMutableArray array];
    @weakify(self);
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        @strongify(self);
        [self requestData];
    }];
    [self.view addSubview:_tableView];
    
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

- (void)initData{
    _sectionTitles = @[@"健康预测",@"健康服务",@"商品推荐",@"热门资讯"];
    [self requestData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - tableView delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _sectionTitles.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return 1;
            break;
        case 1:
            return 1;
            break;
        case 2:
            return 1;
            break;
        case 3:
            return self.InfosModels.count;
            break;
        default:
            return 0;
            break;
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
            return (ScreenWidth - 32 - 8)/2.0 * predictCellWH + 16;
            break;
        case 1:
            return  self.adContentItem.adTotleHeight;// (ScreenWidth - 32 - 10)/3 * seviceCellWH + 16;
            break;
        case 2:
            return 200;
            break;
        case 3:
            return 125;//
            break;
        default:
            return 106;
            break;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section==1)return 0;
    return 40;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *backGroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 30)];
    
    UIView *themeView = [[UIView alloc] initWithFrame:CGRectMake(16, 15, 5, 20)];
    themeView.layer.cornerRadius = 2.5;
    themeView.backgroundColor = [YSThemeManager themeColor];
    [backGroundView addSubview:themeView];
    
    UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(themeView.frame) + 8, 8, ScreenWidth - 16, 32)];
    titleLab.text = _sectionTitles[section];
    [backGroundView addSubview:titleLab];
    return backGroundView;
}
#define user_tiezi @"/circle/look_invitation?invitationId="
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0://健康预测
        {
            YSPredictTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:predictCellID];
            cell.delegate = self;
            return cell;
        }
            break;
        case 1://健康服务
        {
            YSSeviceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:seviceCellID];
            cell.delegate = self;
             @weakify(self);
            if (!self.adContentView) {
            YSAdContentView *adContentView = [[YSAdContentView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, self.adContentItem.adTotleHeight) clickItem:^(YSNearAdContent *adItem) {
                if ([adItem.needLogin integerValue]) {
                                // 需要登录
                        BOOL ret = CheckLoginState(YES);
                        if (!ret) {
                                    // 没登录 直接返回
                            return;
                    }
                }
                switch (adItem.type) {
                case 2:
                    {
                        NSLog(@"%zd",adItem.type);
                         // 商品
                        KJGoodsDetailViewController *goodsDetailVC = [[KJGoodsDetailViewController alloc] init];
                        goodsDetailVC.goodsID = [NSNumber numberWithInteger:[adItem.link integerValue]];
                        goodsDetailVC.hidesBottomBarWhenPushed = YES;
                        [self.navigationController pushViewController:goodsDetailVC animated:YES];
                    
                    }
                        break;
                    case 1:
                    {
                     
                        YSLinkCYDoctorWebController *cyDoctorController = [[YSLinkCYDoctorWebController alloc] initWithWebUrl:adItem.link];
                        cyDoctorController.navTitle =adItem.name;
                        cyDoctorController.tag = 100;
                        cyDoctorController.controllerPushType = YSControllerPushFromHealthyManagerType;
                        [self.navigationController pushViewController:cyDoctorController animated:YES];
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
                            
            }];
                        adContentView.adContentItem = self.adContentItem;
                        [cell addSubview:adContentView];
                        self.adContentView = adContentView;
                    }else {
                        self.adContentView.frame = CGRectMake(0, 0, kScreenWidth, self.adContentItem.adTotleHeight);
                        self.adContentView.adContentItem = self.adContentItem;
                    }
            return cell;
        }
            break;
        case 2://商品推荐
        {
            YSGoodsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:goodsCellID];
            cell.models = _GoodsModels;
            cell.delegate = self;
            return cell;
        }
            break;
        case 3://健康咨询
        {
            static NSString *cellId = @"yshotinfotableviewcell";
            YSHotInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:heathInfoCellID];
            if (!cell) {
                cell = [[YSHotInfoTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellId];
            }
             NSDictionary * dic = [self.InfosModels objectAtIndex:indexPath.row];
            NSString *url = [NSString stringWithFormat:@"%@%@%@",Base_URL,user_tiezi,[dic objectForKey:@"id"]];
            cell.strUrl = url;
            cell.models=self.InfosModels[indexPath.row];
            cell.dic = [self.InfosModels objectAtIndex:indexPath.row];
            cell.nav1 = self.navigationController;
            [cell panduandianzan];
            return cell;
        }
            break;
        default:
        {
            UITableViewCell *cell = [[UITableViewCell alloc] init];
            return cell;
        }
            break;
    }
}

//健康服务点击
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    switch (collectionView.tag) {
        case YSHeaderViewType:
        {
            switch (indexPath.row) {
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
                    YSHealthySelfTestController *healthySelfTestController = [[YSHealthySelfTestController alloc] init];
                    [self.navigationController pushViewController:healthySelfTestController animated:YES];
                }
                    break;
                case 2:
                {
                    /**
                     *  食物计算器 */
                    ListVC *listVC = [[ListVC alloc] init];
                    listVC.listType = FoodCalculatorType;
                    [self.navigationController pushViewController:listVC animated:YES];
                }
                    break;
                case 3:
                {
                    /**
                     *  膳食建议管理 */
                    foodViewController * foodVc = [[foodViewController alloc]init];
                    [self.navigationController pushViewController:foodVc animated:YES];
                }
                    break;
                case 4:
                {
                    /**
                     *  医学美容 */
                    JGCustomTestFaceController *face = [[JGCustomTestFaceController alloc] init];
                    [self.navigationController pushViewController:face animated:YES];
                }
                    break;
                case 5:
                {
                    /**
                     *  形体计算器 */
                    testchildViewController * testChildVc = [[testchildViewController alloc]init];
                    [self.navigationController pushViewController:testChildVc animated:YES];
                }
                    break;
                case 6:
                {
                    YSHealthyMessageController *healthyMessageController =[[YSHealthyMessageController alloc] init];
                    [self.navigationController pushViewController:healthyMessageController animated:YES];
                }
                    break;
                case 7:
                {
                    NewCenterVC *newVc = [[NewCenterVC alloc]init];
                    newVc.index = 4;
                    [self.navigationController pushViewController:newVc animated:YES];
                }
                    break;
                default:
                    break;
            }
        }
            break;
        case YSPredictType:
        {
            BOOL ret = CheckLoginState(YES);
            if (!ret) {
                // 没登录 直接返回
                return;
            }
            if (indexPath.row == 0) {
                  NSDictionary *dict = [kUserDefaults objectForKey:kUserCustomerKey];
                YSHealthyManageWebController *testWebController = [[YSHealthyManageWebController alloc] initWithWebType:YSHealthyManageHealthyTestType uid:dict[@"uid"]];
                [self.navigationController pushViewController:testWebController animated:YES];
                
            }else if (indexPath.row == 1){
                  NSDictionary *dict = [kUserDefaults objectForKey:kUserCustomerKey];
                YSHealthyManageWebController *illnessTestController = [[YSHealthyManageWebController alloc] initWithWebType:YSHealthyManageIllnessTestType uid:nil];
                illnessTestController.linkConfig = [NSString stringWithFormat:@"%@/v1/jibing/indexList?userID=%@",Base_URL,dict[@"uid"]];// 接口问题，返回数据有误，临时处理 self.testLinkConfig.jiBingURL];
                [self.navigationController pushViewController:illnessTestController animated:YES];
            }else if (indexPath.row == 2){
                
            [UIAlertView xf_showWithTitle:@"新功能开发完善中，敬请期待" message:nil delay:2.0 onDismiss:NULL];
                //中医检测
//                YSHealthyManageWebController *illnessTestController = [[YSHealthyManageWebController alloc] initWithWebType:YSZhongYiManageIllnessTestTy uid:nil];
//                illnessTestController.linkConfig =  [NSString stringWithFormat:@"%@/v1/wenjuan/questionnaire_zytz?userID=%@",Base_URL,self.userCustome.uid];
////
//                [self.navigationController pushViewController:illnessTestController animated:YES];
            }
        }
            break;
        case YSServiceType:
        {
            if (indexPath.row == 0) {
                // 快速问医生
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
            }else if (indexPath.row == 1) {
                // 找名医挂号
                YSHealthAIOController *healthAIOController = [[YSHealthAIOController alloc] init];
                healthAIOController.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:healthAIOController animated:YES];
            }else if (indexPath.row == 2) {
                //精准健康检测
                YSHealthAIOController *healthAIOController = [[YSHealthAIOController alloc] init];
                healthAIOController.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:healthAIOController animated:YES];
            }
        }
            break;
        case YSGoodRecommendType:{
            
            GoodsDetailModel *model=_GoodsModels[indexPath.row];
            KJGoodsDetailViewController *goodsDetailVC = [[KJGoodsDetailViewController alloc] init];
            goodsDetailVC.goodsID = model.GoodsDetailModelID;
            goodsDetailVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:goodsDetailVC animated:YES];
        }
            break;
        default:
            break;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section==3){
        static NSString *heathInfoCellID = @"RXHotInfoTableViewCell";
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        [[NSUserDefaults standardUserDefaults]setObject:[self.InfosModels objectAtIndex:indexPath.row] forKey:@"circleTitle"];
        WebDayVC *weh = [[WebDayVC alloc]init];
        NSDictionary * dic = [self.InfosModels objectAtIndex:indexPath.row];
        [[NSUserDefaults standardUserDefaults]setObject:dic[@"title"]  forKey:@"circleTitle"];
        NSString *url = [NSString stringWithFormat:@"%@%@%@",Base_URL,user_tiezi,[dic objectForKey:@"id"]];
        weh.strUrl = url;
        weh.ind = 1;
        weh.dic = [self.InfosModels objectAtIndex:indexPath.row];
        weh.backBlock = ^(){
        };
        UINavigationController *nas = [[UINavigationController alloc]initWithRootViewController:weh];
        nas.navigationBar.barTintColor = COMMONTOPICCOLOR;
        [self presentViewController:nas animated:YES completion:^{
        }];
    }
}
#pragma mark - dataRequest
- (void)requestData{
    //个人信息
    WEAK_SELF
    [HealthyManageData healthyManagerSuccess:^(YSUserCustomer *userCustomer, YSQuestionnaire *questionnaire, NSArray *postList,YSTodayTaskList *taskList,YSHealthyManageTestLinkConfig *testLinkConfig) {
        weak_self.userCustome = userCustomer;
        weak_self.userCustome.successCode = 1;
        weak_self.testLinkConfig = testLinkConfig;
    } fail:^{
        weak_self.userCustome.successCode = 0;
    } error:^{
        weak_self.userCustome.successCode = 0;
    } unlogined:^(NSArray *postList) {
        weak_self.userCustome.successCode = 0;
    } isCache:NO];
    
    //轮播图
    SnsRecommendListRequest *request = [[SnsRecommendListRequest alloc] init:GetToken];
    //    request.api_cityId = self.cityID;
    if ([YSSurroundAreaCityInfo isElseCity]) {
        request.api_cityId = [YSSurroundAreaCityInfo achieveElseSelectedAreaInfo].areaId;
    }else {
        YSLocationManager *locationManager = [YSLocationManager sharedInstance];
        request.api_cityId = locationManager.cityID;
    }
    request.api_posCode =Main_scroll_ad_code;
    
    [self.vapiManager snsRecommendList:request success:^(AFHTTPRequestOperation *operation, SnsRecommendListResponse *response) {
        //头部模型数组
        [weak_self hiddenHud];
        if (0<response.advList.count) {
            weak_self.advListArray = [NSMutableArray arrayWithCapacity:response.advList.count];
            NSMutableArray *urlArray = [NSMutableArray array];
            for (NSDictionary *dic in response.advList) {
              
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
                    [weak_self.advListArray addObject:[PositionAdvertBO objectWithKeyValues:dic]];
                   [urlArray addObject:dic[@"adImgPath"]];
                }
            }
            weak_self.headerView.imageURLStringsGroup = urlArray;
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [weak_self hiddenHud];
    }];
    
    //商品推荐
    [self _requestGoodsShowcaseGoodsDataWithCaseID];
    @weakify(self);
    [self showHud];
    self.pageNum = 1;
    [YSHealthyMessageDatas healthyMessageMostDaysSuccess:^(NSArray *datas) {
        @strongify(self);
        [self.InfosModels removeAllObjects];
        [self.InfosModels xf_safeAddObjectsFromArray:datas];
        [self.tableView reloadData];
        [self hiddenHud];
    } fail:^{
        @strongify(self);
        [self hiddenHud];
    } pageNumber:self.pageNum];
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        @strongify(self);
        if (self.pageNum == 1) {
            self.pageNum = 2;
        }
        [YSHealthyMessageDatas healthyMessageMostDaysSuccess:^(NSArray *datas) {
            @strongify(self);
            [self.InfosModels xf_safeAddObjectsFromArray:datas];
            [self.tableView reloadData];
            [self hiddenHud];
            self.pageNum += 1;
            [self.tableView.mj_footer endRefreshing];
        } fail:^{
            @strongify(self);
            [self hiddenHud];
            [self.tableView.mj_footer endRefreshing];
        } pageNumber:self.pageNum];
    }];
    [self.tableView.mj_header endRefreshing];
}
/**
 *  头部轮播图数组
 */
- (NSMutableArray *)advListArray
{
    if (!_advListArray) {
        _advListArray = [NSMutableArray array];
    }
    return _advListArray;
}
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    
    BOOL ret = CheckLoginState(YES);
    if (!ret) {
        // 没登录 直接返回
        return;
    }
    
    NSLog(@"轮播图点击");
//    [self toCheckUserIsBindTel:^(BOOL result) {
//
//        if (result) {
    
            PositionAdvertBO *model = self.advListArray[index];
            [YSUMMobClickManager beginLogPageWithKey:[NSString stringWithFormat:@"%@%@%@%@",@"um_",@"Near_",@"Banner_",model.adType]];
            NSLog(@"?????????<<<<<<<<<%@>>>>>>",model.adUrl);
            
            
            
            
            if (model.itemId) {
                NSNumber *detailID = @(model.itemId.integerValue);
                
                if (model.adType.integerValue == 5) {
                    //商户详情
                    WSJMerchantDetailViewController *goodStoreVC = [[WSJMerchantDetailViewController alloc] init];
                    goodStoreVC.api_classId = detailID;
                    goodStoreVC.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:goodStoreVC animated:YES];
                }else if ([model.adType integerValue] == 2){
                    
                    KJGoodsDetailViewController *goodsDetailVC = [[KJGoodsDetailViewController alloc] init];
                    goodsDetailVC.goodsID = [NSNumber numberWithInteger:[model.itemId integerValue]];
                    goodsDetailVC.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:goodsDetailVC animated:YES];
                    
                }else if([model.adType integerValue] == 1){
                    //帖子
                    
                    NSLog(@"我草有毒吧");
                    if ([model.itemId containsString:@"yjkindex" options:(NSWidthInsensitiveSearch)])
                    {
                        if (CRIsNullOrEmpty(GetToken)) {
                            YSLoginPopManager *loginPopManager = [[YSLoginPopManager alloc] init];
                            [loginPopManager showLogin:^{
                                
                            } cancelCallback:^{
                            }];
                            return;
                        }
                    }

                    YSActivityController *activityController = [[YSActivityController alloc] init];
                    activityController.hidesBottomBarWhenPushed = YES;
                    
                    
                    
                    activityController.activityUrl = model.itemId;
                    
                    //                   NSLog(@"+++++++++%@",activityController.activityUrl);
                    
                    activityController.activityTitle = model.adTitle;
                    
                    [self.navigationController pushViewController:activityController animated:YES];
                }else if ([model.adType integerValue] == 6){
                    //服务详情
                    ServiceDetailController *serviceDetailVC = [[ServiceDetailController alloc] init];
                    serviceDetailVC.serviceID = detailID;
                    serviceDetailVC.hidesBottomBarWhenPushed = YES;
                    //            serviceDetailVC.api_areaId = self.cityID;
                    [self.navigationController pushViewController:serviceDetailVC animated:YES];
                    
                }else if ([model.adType isEqualToString:@"4"]) {
                    // 资讯
                    WebDayVC *weh = [[WebDayVC alloc]init];
                    [[NSUserDefaults standardUserDefaults]setObject:model.adTitle  forKey:@"circleTitle"];
                    NSString *url = [NSString stringWithFormat:@"%@%@",Base_URL,model.adUrl];
                    NSLog(@"URL______?????????<<<<<<<<<%@>>>>>>",url);
                    
                    weh.strUrl = url;
                    weh.ind = 1;
                    weh.titleStr = model.adTitle;
                    weh.hiddenBottomToolView = YES;
                    UINavigationController *nas = [[UINavigationController alloc]initWithRootViewController:weh];
                    nas.navigationBar.barTintColor = [YSThemeManager themeColor];
                    [self.navigationController presentViewController:nas animated:YES completion:nil];
                }else if ([model.adType isEqualToString:@"7"]) {
                    
                    // 原生类别区分 link
                    if ([model.adUrl isEqualToString:YSAdvertOriginalTypeAIO]) {
                        // 跳转精准健康检测
                        YSHealthAIOController *healthAIOController = [[YSHealthAIOController alloc] init];
                        healthAIOController.hidesBottomBarWhenPushed = YES;
                        [self.navigationController pushViewController:healthAIOController animated:YES];
                    }else if ([model.adUrl isEqualToString:YSAdvertOriginalTypeCYDoctor]) {
                        // 春雨医生
                        [self showHud];
                        @weakify(self);
                        @weakify(model);
                        [YSHealthyMessageDatas  chunYuDoctorUrlRequestWithResult:^(BOOL ret, NSString *msg) {
                            @strongify(self);
                            @strongify(model);
                            [self hiddenHud];
                            if (ret) {
                                YSLinkCYDoctorWebController *cyDoctorController = [[YSLinkCYDoctorWebController alloc] initWithWebUrl:msg];
                                cyDoctorController.navTitle = model.adTitle;
                                cyDoctorController.tag = 100;
                                cyDoctorController.controllerPushType = YSControllerPushFromHealthyManagerType;
                                [self.navigationController pushViewController:cyDoctorController animated:YES];
                            }else {
                                [UIAlertView xf_showWithTitle:msg message:nil delay:2.0 onDismiss:NULL];
                            }
                        }];
                    }
                }
            }
            
            
//
//        }else {
//            // 未绑定，收缩
//            [UIAlertView xf_showWithTitle:@"尚未绑定手机号!" message:nil delay:1.2 onDismiss:NULL];
//        }
//    }];
    
   
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
        [self.tableView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        //请求猜您喜欢数据
        //        [self _requestGuessYouLikeData];
        
    }];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat sectionHeaderHeight = 40;
    if(scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0,0);
    } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
    }
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
#pragma mark 健康管理广告位接口调用
        @weakify(self);
    //打开一体机,在线问诊
    [[YSConfigAdRequestManager sharedInstance] requestAdContent:YSAdContentWithHealthyManagerType
          cacheItem:^(YSAdContentItem *cacheItem) {
                     // 返回一个缓存广告位对象
                        return ;
                        @strongify(self);
         self.adContentItem = cacheItem;
                [_tableView reloadData];
                                           }
               result:^(YSAdContentItem *adContentItem) {
         @strongify(self);
                   if (!adContentItem) {
                            self.adContentItem = adContentItem;
                                [_tableView reloadData];
                        }else if ([adContentItem.receiveCode isEqualToString:[[YSConfigAdRequestManager sharedInstance] requestAdContentCodeWithRequestType:YSAdContentWithHealthyManagerType]]) {
                        self.adContentItem = adContentItem;
                                [_tableView reloadData];
                }
            }];
    
  
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    [JGActivityHelper controllerDidAppear:@"healthmanage.com" requestStatus:^(YSActivityInfoRequestStatus status) {
        switch (status) {
            case YSActivityInfoRequestIdleStatus:
            {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [JGActivityHelper controllerDidAppear:@"healthmanage.com" requestStatus:NULL];
                });
            }
                break;
            default:
                break;
        }
    }];;
    @weakify(self);
    [JGActivityHelper controllerFloatImageDidAppear:@"healthmanage.com" result:^(BOOL ret, UIImage *floatImge, YSActivitiesInfoItem *actInfoItem,YSActivityInfoRequestStatus status) {
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
                            [JGActivityHelper controllerFloatImageDidAppear:@"healthmanage.com" result:^(BOOL ret, UIImage *floatImge, YSActivitiesInfoItem *actInfoItem, YSActivityInfoRequestStatus status) {
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
   
}
- (void)updateUserLocationCoordinate {
    @weakify(self);
    [YSLocationManager  reverseGeoResult:^(NSString *city) {
        @strongify(self);
        [YSBaseInfoManager storageCity:city];
    } fail:^{ } addressComponentCallback:^(BMKAddressComponent *componet) { } callbackType:YSLocationCallbackCityType];
}

- (void)enterActivityH5Controller {
    YSActivityController *activityH5Controller = [[YSActivityController alloc] init];
    activityH5Controller.activityInfoItem = self.actInfoItem;
    [self.navigationController pushViewController:activityH5Controller animated:YES];
}


- (void)toCheckUserIsBindTel:(bool_block_t)bindResult {
    [YSLoginManager thirdPlatformUserBindingCheckSuccess:^(BOOL isBinding, UIViewController *controller) {
        BLOCK_EXEC(bindResult,isBinding);
    } fail:^{
        [UIAlertView xf_showWithTitle:@"网络错误或数据出错!" message:nil delay:1.2 onDismiss:NULL];
    } controller:self unbindTelphoneSource:YSUserBindTelephoneSourceHealthyComposeStatusType isRemind:NO];
}


@end
