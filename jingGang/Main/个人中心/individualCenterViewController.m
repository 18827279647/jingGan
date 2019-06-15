//
//  individualCenterViewController.m
//  jingGang
//
//  Created by yi jiehuang on 15/5/8.
//  Copyright (c) 2015年 yi jiehuang. All rights reserved.
//
#import "LJViewController.h"
#import "individualCenterViewController.h"
#import "Header.h"
#import "individualTableViewCell.h"
#import "NewCenterVC.h" //wy
#import "BaseInfoVC.h"  //wy
#import "PersonalInfoViewController.h"
#import "myDecieseViewController.h"
#import "userDefaultManager.h"
#import "SettingVC.h"
#import "MyStore.h"
#import "VApiManager.h"
#import "userDefaultManager.h"
#import "OrderViewController.h"
#import "WSJMeEvaluateViewController.h"
#import "SalesReturnListVC.h"
#import "GlobeObject.h"
#import "MyErWeiMaController.h"
#import "WIntegralListViewController.h"
#import "TakePhotoUpdateImg.h"
#import "JGIntegralValueController.h"
#import "PushNofiticationController.h"
#import "JGHealthStoreController.h"
#import "AppDelegate+JGActivity.h"
#import "JGIndividualCenterTopView.h"
#import "UserInfoViewController.h"
#import "JGNoLoginStatusView.h"
#import "YSFriendCircleController.h"
#import "YSFriendCircleRequestManager.h"
#import "YSMyHealthMissonController.h"
#import "YSCloudMoneyDetailController.h"
#import "YSCloudBuyMoneyController.h"
#import "YSLoginManager.h"
#import "YSGoMissionController.h"
#import "YSLoginManager.h"
#import "YSPersonalUnloginView.h"
#import "YSMyCenterLoginView.h"
#import "YSLoginPopManager.h"
#import "RigisterOrForgetPasswordController.h"
#import "JGActivityHelper.h"
#import "YSThumbnailManager.h"
#import "YSMyDevicesListControlller.h"
#import "JGDropdownMenu.h"
#import "UIView+MDFAnimation.h"
#import "YSVersionConfig.h"
#import "YSNearServiceClassController.h"
#import "JGCouponViewController.h"
#import "WSJManagerAddressViewController.h"
#import "JGIntegarlCloudController.h"
#import "YSActivityController.h"
#import "YSHealthAIOController.h"
#import "HongbaoViewController.h"
#import "XRViewController.h"
#import "HongBaoTCViewController.h"
#import "JGRedEnvelopeCardVC.h"
@interface individualCenterViewController ()<JGIntegralValueControllerDelegate,JGIndividualCenterTopViewDelegate,JGNoLoginStatusViewDelegate>


//@property (nonatomic, strong) individualSignView *signPrompt;//签到提示

@property (nonatomic,strong) UITableView *myTableView;
/**
 *  标题名称数组
 */
@property (nonatomic,strong) NSArray *cellTitleArray;
/**
 *  cell图片数组
 */
@property (nonatomic,strong) NSArray *cellImageNameArray;
/**
 *  用户积分
 */
@property (nonatomic,copy) NSString *strUsersIntegral;
/**
 *  用户健康豆
 */
@property (nonatomic,copy) NSString *strUsersYunMoney;
/**
 *  头部View
 */
@property (nonatomic,strong) JGIndividualCenterTopView *viewTop;
/**
 *  未登陆状态下的头部view
 */
@property (nonatomic,strong) JGNoLoginStatusView *noLoginStatusView;
/**
 *  去除CN账号后奖金的健康豆数量,因为提现只允许提纯健康豆部分，奖金部分不允许提现
 */
@property (nonatomic,copy) NSString *strNoCNCloudVelues;

@property (strong,nonatomic) YSPersonalUnloginView *unloginView;
@property (strong,nonatomic) YSMyCenterLoginView *myCenterLoginView;

@property (strong,nonatomic) UIImageView *floatImageView;
@property (strong,nonatomic) YSActivitiesInfoItem *actInfoItem;

@property (assign, nonatomic) BOOL refreshDataCalled;
@property (assign, nonatomic) int userType;

@property (copy, nonatomic) NSString *  YqM;
@end

@implementation individualCenterViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden=YES;

    if (IsEmpty(GetToken)) {
        [Util enterLoginPage];
    }
    
    [self reqeustconfirmJiankangdouReadCount];
    [self reqeustconfirmYouhuiquanReadCount];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userLoginSuccessToRefreshPersonalPageAction) name:@"kUserThirdLoginSuccessNotiKey" object:nil];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];

    if (IsEmpty(GetToken)) {
        [self.navigationController setNavigationBarHidden:NO animated:YES];
        self.myTableView.tableHeaderView = self.noLoginStatusView;
        self.myTableView.hidden = YES;
//        self.unloginView.hidden = NO;
        self.myCenterLoginView.hidden=NO;
        return;
    }else{
        //避免重复赋值
        [self.navigationController setNavigationBarHidden:NO animated:YES];
        self.myTableView.frame = CGRectMake(0,0, __MainScreen_Width, __MainScreen_Height - 49);
        if (self.myTableView.tableHeaderView != self.viewTop) {
            self.myTableView.tableHeaderView = self.viewTop;
        }
        self.myTableView.hidden = NO;
//        self.unloginView.hidden = YES;
        self.myCenterLoginView.hidden=YES;
        if (!self.refreshDataCalled) {
            self.refreshDataCalled = YES;
            [self getUserInfo];
        }
    }
    self.navigationController.navigationBar.barStyle=UIStatusBarStyleLightContent;

    self.navigationController.navigationBar.hidden=YES;
    
    [super viewDidAppear:YES];
    [JGActivityHelper controllerDidAppear:@"shopm.com" requestStatus:^(YSActivityInfoRequestStatus status) {
        switch (status) {
            case YSActivityInfoRequestIdleStatus:
            {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [JGActivityHelper controllerDidAppear:@"shopm.com" requestStatus:NULL];
                });
            }
                break;
            default:
                break;
        }
    }];;
    @weakify(self);
    [JGActivityHelper controllerFloatImageDidAppear:@"shopm.com" result:^(BOOL ret, UIImage *floatImge, YSActivitiesInfoItem *actInfoItem,YSActivityInfoRequestStatus status) {
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
                            [JGActivityHelper controllerFloatImageDidAppear:@"shopm.com" result:^(BOOL ret, UIImage *floatImge, YSActivitiesInfoItem *actInfoItem, YSActivityInfoRequestStatus status) {
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

- (void)showRefreshView {
    return;
    if ([self achieve:@"kNewfreshImageShow"]) {
        return;
    }
    [self save:@1 key:@"kNewfreshImageShow"];
    NSIndexPath *myDeviceCellIndexPath = [NSIndexPath indexPathForRow:2 inSection:1];
    individualTableViewCell *myDeviceCell = (individualTableViewCell *)[self.myTableView cellForRowAtIndexPath:myDeviceCellIndexPath];
    CGRect rect = [self.myTableView convertRect:myDeviceCell.frame toView:self.myTableView];
    
    JGDropdownMenu *menu = [JGDropdownMenu menu];
    [menu configTouchViewDidDismissController:NO];
    UIViewController *alertController = [[UIViewController alloc] init];
    alertController.view.backgroundColor = JGClearColor;
    alertController.view.width = ScreenWidth;
    alertController.view.height = ScreenHeight;
    UIImageView *refreshImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ys_personal_newremind"]];
    refreshImageView.width = [YSAdaptiveFrameConfig width:309.];
    refreshImageView.height = (refreshImageView.width * 134) / 618.;
    refreshImageView.x = ScreenWidth - refreshImageView.width - 12.;
    refreshImageView.y = CGRectGetMinY(rect) - refreshImageView.height  + NavBarHeight + 12.4;
    [alertController.view addSubview:refreshImageView];
    
    UIImageView *iconImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ys_personal_newremindicon"]];
    iconImageView.width = 30.;
    iconImageView.height = 48.;
    iconImageView.x = refreshImageView.x + 11.2;
    iconImageView.y = refreshImageView.y - 8;
    [alertController.view addSubview:iconImageView];
    
    menu.contentController = alertController;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.34 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [menu showAlertWithDuration:0.45];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.45 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [iconImageView mdf_shake];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4. * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [menu dismiss];
            });
        });
        
    });
}

- (void)userLoginSuccessToRefreshPersonalPageAction {
    //避免重复赋值
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    self.myTableView.frame = CGRectMake(0, 0, __MainScreen_Width, __MainScreen_Height - 49 );
    if (self.myTableView.tableHeaderView != self.viewTop) {
        self.myTableView.tableHeaderView = self.viewTop;
    }
    self.myTableView.hidden = NO;
//    self.unloginView.hidden = YES;
    self.myCenterLoginView.hidden=YES;
    if (!self.refreshDataCalled) {
        self.refreshDataCalled = YES;
        [self getUserInfo];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    self.navigationController.navigationBar.hidden=NO;
    
    [super viewWillDisappear:animated];
    // 友盟统计
    [YSUMMobClickManager endLogPageWithKey:kPersonalCenterViewController];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    [YSThemeManager setNavigationTitle:@"我的" andViewController:self];
    [self.view addSubview:self.myTableView];
//    [self.view addSubview:self.unloginView];
    [self.view addSubview:self.myCenterLoginView];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.hidden=YES;
    self.navigationController.navigationBar.barStyle=UIStatusBarStyleLightContent;
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
}

#pragma mark - tableViewDelagete
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.cellTitleArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *array = self.cellTitleArray[section];
    return [array count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
        CGFloat rowHeightScale = 320.0 / 44.0;
        return kScreenWidth / rowHeightScale;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellStr = @"cellStr";
    individualTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellStr];
    if (!cell) {
        NSArray *arr = [[NSBundle mainBundle] loadNibNamed:@"individualTableViewCell" owner:self options:nil];
        cell = [arr objectAtIndex:0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }

    NSArray *arrayImageName = self.cellImageNameArray[indexPath.section];
    cell.leftImg.image = [UIImage imageNamed:arrayImageName[indexPath.row]];
    NSArray *arrayTitle = self.cellTitleArray[indexPath.section];
    cell.midelLab.text = arrayTitle[indexPath.row];
    if (indexPath.section == 1 && indexPath.row == 1) {
        if ([[self achieve:@"kMyDocumentClickedKey"] boolValue]) {
            cell.hiddenRightImageView = YES;
        }else {
            cell.hiddenRightImageView = NO;
        }
    }else { 
        cell.hiddenRightImageView = YES;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 4.0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 4.0)];
    view.backgroundColor = [UIColor clearColor];
    
    return view;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 0.5)];
    view.backgroundColor = [YSThemeManager getTableViewLineColor];
    
    return view;
}

#pragma mark ----JGIntegralValueControllerDelegate
- (void)nofiticationCloudMoneyValueChange:(NSString *)cloudMoneyChangeStr
{
    self.viewTop.strUsersYunMoney = cloudMoneyChangeStr;
}

#pragma mark -----JGIndividualCenterTopViewDelegate
//个人中心我的模块中的点击事件
//@[@"健康任务",@"健康档案",@"健康设备",@"我的订单",@"优惠券",@"收货地址",@"兑换订单",@"商品退货",@"服务订单",@"便民出行订单",@"我发的帖子",@"我的收藏",@"设置"];
- (void)myBlockButtonClick:(int)index
{
    if (IsEmpty(GetToken)) {
        [MBProgressHUD showSuccess:@"该功能需要登录才能使用" toView:self.view delay:1];
        return;
    }
    AppDelegate *appDelegate = kAppDelegate;
    //标志从个人中心进入的
    appDelegate.isPersonCenterTtravel = YES;
    UIViewController *VC;
    switch (index) {
        case -1:{
            NewCenterVC *newVc = [[NewCenterVC alloc]init];
            newVc.index = 0;
            VC = newVc;
        }break;
        case 0:{//健康任务
            YSMyHealthMissonController *myHealthMissonController = [[YSMyHealthMissonController alloc]init];
            VC = myHealthMissonController;
           }break;
        case 1:{//健康档案
                NewCenterVC *newVc = [[NewCenterVC alloc]init];
                newVc.index = 4;
                VC = newVc;
                if ([[self achieve:@"kMyDocumentClickedKey"] boolValue]) {
                    
                }else {
                    [self save:@1 key:@"kMyDocumentClickedKey"];
                }
        }break;
        case 2:{// 健康设备
//                YSMyDevicesListControlller *devicesListController = [YSMyDevicesListControlller new];
//                VC = devicesListController;
            
            YSHealthAIOController *healthAIOController = [[YSHealthAIOController alloc] init];
            healthAIOController.hidesBottomBarWhenPushed = YES;
            VC = healthAIOController;
        
        }break;
        case 3:{//我的订单
            OrderViewController *GoodsOrderVC = [[OrderViewController alloc]init];
             VC = GoodsOrderVC;
        }break;
//        case 4:{//优惠券
//            JGCouponViewController *JGCouponVC = [[JGCouponViewController alloc]init];
//            VC = JGCouponVC;
//        }break;
         case 4:{//收货地址
             WSJManagerAddressViewController *WSJManagerAddressVC = [[WSJManagerAddressViewController alloc]init];
             WSJManagerAddressVC.type = personalCenter;
             VC = WSJManagerAddressVC;
         }break;
         case 5:{//兑换订单
             WIntegralListViewController *WIntegralListVC = [[WIntegralListViewController alloc]init];
             VC = WIntegralListVC;
         }break;
        case 6:{//商品退货
            SalesReturnListVC *salesReturnListVC = [[SalesReturnListVC alloc]init];
            VC = salesReturnListVC;
        }break;
//        case 8:{//领劵中心
//            LJViewController *LJVC = [[LJViewController alloc]init];
//            VC = LJVC;
//        }break;
        case 7:{//服务订单
            NSLog(@"点这里了吗");
            YSNearServiceClassController *onlineVC = [[YSNearServiceClassController alloc]init];
            onlineVC.type=@"服务订单";
            VC = onlineVC;
        }break;
        case 8:{//便民出行订单
            YSNearServiceClassController *onlineVC = [[YSNearServiceClassController alloc]init];
            onlineVC.type=@"便民出行订单";
            VC = onlineVC;
        }break;
        case 9:{//健康圈
                YSFriendCircleController *friendCircleController = [[YSFriendCircleController alloc] init];
                //[friendCircleController setupNavBarPopButton];
            [YSThemeManager setNavigationTitle:@"我发的帖子" andViewController:friendCircleController];
                [friendCircleController.view showHud];
                friendCircleController.shouldShowDeleteButton = YES;
                [friendCircleController configTableViewHeaderRefresh];
                [friendCircleController configTableViewFooterFefresh];
                @weakify(friendCircleController);
                [YSFriendCircleRequestManager userCirclesSuccess:^(NSArray *frames) {
                    @strongify(friendCircleController);
                    friendCircleController.datas = frames;
                    [friendCircleController.view hiddenHud];
                } failCallback:^{
                    @strongify(friendCircleController);
                    [friendCircleController.view hiddenHud];
                } errorCallback:^{
                    @strongify(friendCircleController);
                    [friendCircleController.view hiddenHud];
                } pageNum:1 pageSize:10];
                friendCircleController.headerCallback = ^(){
                    @strongify(friendCircleController);
                    [YSFriendCircleRequestManager userCirclesSuccess:^(NSArray *frames) {
                        friendCircleController.datas = frames;
                        [friendCircleController.view hiddenHud];
                        [friendCircleController.tableView.mj_header endRefreshing];
                        friendCircleController.currentRequestPage = 1;
                    } failCallback:^{
                        [friendCircleController.view hiddenHud];
                        [friendCircleController.tableView.mj_header endRefreshing];
                        
                    } errorCallback:^{
                        [friendCircleController.view hiddenHud];
                        [friendCircleController.tableView.mj_header endRefreshing];
                        
                    } pageNum:1 pageSize:10];
                };
                
                friendCircleController.footerCallback = ^(){
                    @strongify(friendCircleController);
                    if (friendCircleController.currentRequestPage == 1) {
                        friendCircleController.currentRequestPage = 2;
                    }
                    [YSFriendCircleRequestManager userCirclesSuccess:^(NSArray *frames) {
                        friendCircleController.moreDatas = frames;
                        [friendCircleController.view hiddenHud];
                        friendCircleController.currentRequestPage += 1;
                        [friendCircleController.tableView.mj_footer endRefreshing];
                        
                    } failCallback:^{
                        [friendCircleController.view hiddenHud];
                        [friendCircleController.tableView.mj_footer endRefreshing];
                        
                    } errorCallback:^{
                        [friendCircleController.view hiddenHud];
                        [friendCircleController.tableView.mj_footer endRefreshing];
                        
                    } pageNum:friendCircleController.currentRequestPage pageSize:10];
                };
               [self.navigationController pushViewController:friendCircleController animated:YES];
                //VC = friendCircleController;
                return;
            } break;
        case 10:{//我的收藏
                NewCenterVC *newVc = [[NewCenterVC alloc]init];
                newVc.index = 6;
                VC = newVc;
        }break;
        case 11:{//设置
                SettingVC *settingVc = [[SettingVC alloc]init];
                VC = settingVc;
            } break;
        default:
            break;
    }
    if (VC) {
        [self.navigationController pushViewController:VC animated:YES];
    }else{
        [MBProgressHUD showSuccess:@"该功能正在开发中..." toView:self.view delay:1];
    }
}
- (void)UsersYunMoneyButtonAndUsersIntegralButtonClick:(IntegralCloudValueValueType)type
{
    UIViewController *valueController;
    if (type == CloudValueButtonType) {
        // 健康豆按钮
        YSCloudMoneyDetailController *VC = [[YSCloudMoneyDetailController alloc] init];
        VC.strCloudVelues = self.strNoCNCloudVelues;
//        去除CN账号后奖金的健康豆数量,因为提现只允许提纯健康豆部分，奖金部分不允许提现
        valueController = VC;
    }else if (type == CloudValueBuyMoneyType){
        // 云购币按钮
        YSCloudBuyMoneyController *cloudBuyMoneyVC = [[YSCloudBuyMoneyController alloc]init];
        valueController = cloudBuyMoneyVC;
    }else if (type == IntegralButtonType){
        // 积分按钮
        JGRedEnvelopeCardVC *VC = [JGRedEnvelopeCardVC new];
        
        
        valueController = VC;
//        YSGoMissionController *VC = [[YSGoMissionController alloc]init];
//        VC.enterControllerType = YSEnterEarnInteralControllerWithHealthyManagerMainPage;
//
//        valueController = VC;
    }else if (type == ViewRuleType){
        // 查看规则
//        YSGoMissionController *VC = [[YSGoMissionController alloc]init];
//        VC.enterControllerType = YSEnterEarnInteralControllerWithHealthyManagerMainPage;
//        valueController = VC;
      
            JGIntegarlCloudController *VC = [[JGIntegarlCloudController alloc] init];
            VC.RuleValueType = IntegralRuleType;
            valueController = VC;
   
        
        
     
    }else if (type == InvitationFriendType){
        // 邀请好友 新红包页面
       // MyErWeiMaController *invitationVC = [[MyErWeiMaController alloc] init];
       // valueController = invitationVC;
           NSLog(@"_YqM%@",_YqM);
        if (_userType == 2) {
            HongbaoViewController * hongbao = [[HongbaoViewController alloc] init];
             hongbao.string = @"hongbaobeijing1";
            valueController = hongbao;
        }else if(_userType == 1){
            HongbaoViewController * hongbao = [[HongbaoViewController alloc] init];
           hongbao.string = @"bongbaobeijing";
            valueController = hongbao;
        }else if (_userType == 0){
            XRViewController * Xr = [[XRViewController alloc] init];
            valueController = Xr;
        }
      
        
    }
    
    if (valueController) {
        [self.navigationController pushViewController:valueController animated:YES];
    }
}

/**
 *  个人中心按钮点击事件
 */
- (void)usersInfoCenterButtonClick
{
    UserInfoViewController *userInfoVC = [[UserInfoViewController alloc]init];
    [self.navigationController pushViewController:userInfoVC animated:YES];
}

#pragma mark --- JGNoLoginStatusViewDelegate
- (void)goToLoginVCButtonClick
{
    AppDelegate * app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [app beGinLoginWithType:YSLoginCommonCloseType toLogin:NO];
}
//获取用户信息
-(void)getUserInfo
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.refreshDataCalled = NO;
    });
    AppDelegate * app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [app queryUserDidCheckWithState:^(YSUserSignViewState state) {
        switch (state) {
            case YSUserSignViewStateWithClickedButton:
                
                break;
            case YSUserSignViewStateWithShowBegin:
                
                break;
            case YSUserSignViewStateWithShowing:
                
                break;
            default:
            {
                [self showRefreshView];
            }
                break;
        }
    }];

    NSString *accessToken = [userDefaultManager GetLocalDataString:@"Token"];
    UsersCustomerSearchRequest * usersCustomerSearchRequest = [[UsersCustomerSearchRequest alloc]init:accessToken];
    @weakify(self);
    [self showHud];
    [self.vapiManager usersCustomerSearch:usersCustomerSearchRequest success:^(AFHTTPRequestOperation *operation, UsersCustomerSearchResponse *response) {
        @strongify(self);
        [self hiddenHud];
        NSMutableDictionary *dict = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingAllowFragments error:nil];
        NSDictionary   *dictUserList = [dict objectForKey:@"customer"];
        _userType =  [response.userType intValue];
        CRUserSetObj(response.userType, kUserStatuskey);
        _YqM = [NSString stringWithFormat:@"%@", [dictUserList objectForKey:@"invitationCode"]];
        
        NSLog(@"_YqM%@",_YqM);
        //刷新顶部页面
        [self refreshTopViewValue];
        //昵称
        self.viewTop.strNickName = [NSString stringWithFormat:@"%@",dictUserList[@"nickName"]];
        //头像url
        
         NSDictionary *dictUserInfo = [kUserDefaults objectForKey:kUserCustomerKey];
        NSLog(@"dictUserInfo%@",dictUserInfo[@"headImgPath"]);
        self.viewTop.strHeadImageUrl = [YSThumbnailManager personalCenterUserHeaderPhotoPicUrlString:[NSString stringWithFormat:@"%@",dictUserList[@"headImgPath"]]];
        
        if ([[dictUserList objectForKey:kCNUserAccountFlagKey] integerValue]) {
            [YSLoginManager setCNTag:YES];
            [YSLoginManager setCNAccount:YES];
            [self.viewTop updateShopIntegral:[[response cnIntegral] integerValue] isCNUser:YES];
        }else {
            [YSLoginManager setCNTag:NO];
            [YSLoginManager setCNAccount:NO];
            [self.viewTop updateShopIntegral:0 isCNUser:NO];
        }
        
        //性别
        self.viewTop.strSex = [NSString stringWithFormat:@"%@",dictUserList[@"sex"]];
        //云购币赋值，字段在dictUserList字典外，所以是直接从response里直接取出来的
        self.viewTop.strCloudBuyMoney = [NSString stringWithFormat:@"%@",response.cNRepeat];
        //健康豆，，，需要健康豆+奖金之后再显示
        self.strUsersYunMoney = [NSString stringWithFormat:@"%.2f",response.countMoney.floatValue];
        self.viewTop.strUsersYunMoney = self.strUsersYunMoney;
        
        //预分润
        self.viewTop.strBeforehandMoney = [NSString stringWithFormat:@"%.2f",response.recordBalance.floatValue];
        
        
        
        //积分显示
        self.strUsersIntegral = [NSString stringWithFormat:@"%@",dict[@"showNum"]];
        self.viewTop.strUsersIntegral = self.strUsersIntegral;
        // 去除CN账号后奖金的健康豆数量,因为提现只允许提纯健康豆部分，奖金部分不允许提现
        //可提现健康豆
        self.strNoCNCloudVelues = [NSString stringWithFormat:@"%.2f",response.availableBalance.floatValue];
        
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"kUserHeadImgChangedNotification" object:[dictUserList objectForKey:@"headImgPath"]];
        
        [[NSUserDefaults standardUserDefaults]setObject:dictUserList forKey:kUserCustomerKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            @strongify(self);
            [self hiddenHud];
            [MBProgressHUD showSuccess:@"网络错误，请检查网络" toView:self.view delay:1];
    }];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//更新头部view
- (void)refreshTopViewValue
{
    [self.viewTop refreshTopView];
}

#pragma mark - getter

- (UITableView *)myTableView {
    if (!_myTableView) {
        _myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, __MainScreen_Width, __MainScreen_Height) style:UITableViewStyleGrouped];
        _myTableView.delegate = self;
        _myTableView.estimatedRowHeight= 0;
        _myTableView.estimatedSectionHeaderHeight=0;
        _myTableView.estimatedSectionFooterHeight=0;
        _myTableView.separatorColor = [YSThemeManager getTableViewLineColor];
        _myTableView.dataSource = self;
        _myTableView.backgroundColor = UIColorFromRGB(0xf7f7f7);
//        _myTableView.backgroundColor = [UIColor redColor];
        
        if (@available(iOS 11.0, *)) {
           _myTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
        
    }

    
    return _myTableView;
}

#pragma mark -----didselect ---wy
//tableView  didSelectEvent
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
 
}

- (NSArray *)cellTitleArray
{
    if (!_cellTitleArray) {
        
        _cellTitleArray = [NSArray arrayWithObjects: nil];
        
        
    }
    return _cellTitleArray;
}

- (NSArray *)cellImageNameArray
{
    if (!_cellImageNameArray) {
        NSArray *arr = [NSArray arrayWithObjects:@"My_InvitateFriend", nil];
        NSArray *arr1 = [NSArray arrayWithObjects:@"My_Health_mission",@"My_Health_Files",@"My_Device",@"My_Health_Zone", nil];
        NSArray *arr2 = [NSArray arrayWithObjects:@"My_Health_Store",@"My_Near_service", nil];
        NSArray *arr3 = [NSArray arrayWithObjects:@"My_collect",@"My_Setting", nil];
        _cellImageNameArray = [NSArray arrayWithObjects:arr,arr1,arr2,arr3, nil];
    }
    return _cellImageNameArray;
}


- (JGIndividualCenterTopView *)viewTop
{
    if (!_viewTop) {
        CGFloat topViewHeightScale =  1125/495;//320.0/115.0;
        _viewTop = [[JGIndividualCenterTopView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenWidth / topViewHeightScale+965)];
        _viewTop.delegate = self;
    }
    return _viewTop;
}

- (JGNoLoginStatusView *)noLoginStatusView
{
    if (!_noLoginStatusView) {
        CGFloat topViewHeightScale = 375.0/75.0;
        _noLoginStatusView = [[JGNoLoginStatusView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenWidth/topViewHeightScale)];
        _noLoginStatusView.delegate = self;
    }
    return _noLoginStatusView;
}
-(YSMyCenterLoginView *)myCenterLoginView{
    if (!_myCenterLoginView) {
        @weakify(self);
        _myCenterLoginView = [[YSMyCenterLoginView alloc] initWithFrame:self.view.bounds loginCallback:
                        ^{
                            // 弹出登录窗口
                            @strongify(self);
                            [self toLogin];
                        }
                                              quickRegisterCallback:
                        ^{
                            // 注册入口
                            @strongify(self);
                            [self toRegisterOrForgetPasswordWithPageType:RegisterType];
                        }
                                             forgetPasswordCallback:
                        ^{
                            // 忘记密码入口
                            @strongify(self);
                            [self toRegisterOrForgetPasswordWithPageType:ForgetPasswordType];
                        }];
    }
    return _myCenterLoginView;
}
- (YSPersonalUnloginView *)unloginView {
    if (!_unloginView) {
        @weakify(self);
        _unloginView = [[YSPersonalUnloginView alloc] initWithFrame:self.view.bounds loginCallback:
                        ^{
                            // 弹出登录窗口
                            @strongify(self);
                            [self toLogin];
                        }
        quickRegisterCallback:
                        ^{
                            // 注册入口
                            @strongify(self);
                            [self toRegisterOrForgetPasswordWithPageType:RegisterType];
                               }
        forgetPasswordCallback:
                        ^{
                            // 忘记密码入口
                            @strongify(self);
                            [self toRegisterOrForgetPasswordWithPageType:ForgetPasswordType];
                        }];
    }
    return _unloginView;
}

/**
 *  去登录 */
- (void)toLogin {
    YSLoginPopManager * loginManager = [[YSLoginPopManager alloc] init];
    [loginManager showLogin:^{
        
    } cancelCallback:^{
        
    }];
}

/**
 *  去注册或者忘记密码 */
- (void)toRegisterOrForgetPasswordWithPageType:(RegisterPageType)pageType {
    RigisterOrForgetPasswordController *registerForgetPasswdVC = [[RigisterOrForgetPasswordController alloc] init];
    registerForgetPasswdVC.registerPageType = pageType;
    UINavigationController *registerForgetPasswdNav = [[UINavigationController alloc] initWithRootViewController:registerForgetPasswdVC];
    [self.navigationController presentViewController:registerForgetPasswdNav animated:YES completion:NULL];
}

-(BOOL)prefersStatusBarHidden

{
    return NO;// 返回YES表示隐藏，返回NO表示显示
}
- (void)enterActivityH5Controller {
    YSActivityController *activityH5Controller = [[YSActivityController alloc] init];
    activityH5Controller.activityInfoItem = self.actInfoItem;
    [self.navigationController pushViewController:activityH5Controller animated:YES];
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
                hongbao.isJK =YES;
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
