//
//  YSHealthAIOController.m
//  jingGang
//
//  Created by dengxf on 2017/8/29.
//  Copyright © 2017年 dengxf_dev. All rights reserved.
//

#import "YSHealthAIOController.h"
#import "YSCheckUserIsBindIdentityCardDataManager.h"
#import "YSCheckUserBingIdentityCardItem.h"
#import "YSAIONoneDataView.h"
#import "YSGetAIODataManager.h"
#import "YSAIODataItem.h"
#import "YSAIOHealthDataContentView.h"
#import "JGDropdownMenu.h"
#import "YSAIODatePickerView.h"
#import "YSEnvironmentConfig.h"
#import "YSLinkElongHotelWebController.h"
#import "YSBindIdentityCardController.h"
#import "YSAchiveAIOInfoDataManager.h"
#import "YSUserAIOInfoItem.h"
#import "RXWebViewController.h"

typedef NS_ENUM(NSUInteger, YSAIODataRequestType) {
    YSAIODataRequestNoneType = 60,
    YSAIODataRequestRefreshType,
    YSAIODataRequestSelectedDateType,
};

@interface YSHealthAIOController ()<YSAPICallbackProtocol,YSAPIManagerParamSource,YSAIOHealthDataContentViewDelegate>

@property (strong,nonatomic) YSCheckUserIsBindIdentityCardDataManager *bindIdentityCardDataManager;

@property (strong,nonatomic) YSGetAIODataManager *getAIODataManager;

@property (strong,nonatomic) YSAIONoneDataView *noneDataView;

@property (strong,nonatomic) YSAIOHealthDataContentView *contentView;

@property (strong,nonatomic) JGDropdownMenu *menu;

@property (copy , nonatomic) NSString *requestDateString;

@property (assign, nonatomic) YSAIODataRequestType aioDataRequestType;

@property (assign, nonatomic) BOOL isPush;

@property (strong,nonatomic) YSAchiveAIOInfoDataManager *achiveAIOInfoDataManager;

@end

@implementation YSHealthAIOController

- (instancetype)init
{
    self = [super init];
    if (self) {
        _isPush = YES;
    }
    return self;
}


- (YSAIONoneDataView *)noneDataView {
    if (!_noneDataView) {
        _noneDataView = [[YSAIONoneDataView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - NavBarHeight)];
        @weakify(self);
        _noneDataView.modifyIdentityInfoCallback = ^{
            @strongify(self);
            [self toBindIdentityCardControllerWithSourceType:YSIdentityContollerSourceModifyType];
        };
        [self.view addSubview:_noneDataView];
    }
    return _noneDataView;
}

- (YSAIOHealthDataContentView *)contentView {
    if (!_contentView) {
        _contentView = [[YSAIOHealthDataContentView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
        @weakify(self);
        _contentView.tableViewRefreshCallback = ^{
            @strongify(self);
            [self showHud];
            self.aioDataRequestType = YSAIODataRequestRefreshType;
            [self.getAIODataManager requestData];
        };
        _contentView.delegate = self;
        [self.view addSubview:_contentView];
    }
    return _contentView;
}

- (YSCheckUserIsBindIdentityCardDataManager *)bindIdentityCardDataManager {
    if (!_bindIdentityCardDataManager) {
        _bindIdentityCardDataManager = [[YSCheckUserIsBindIdentityCardDataManager alloc] init];
        _bindIdentityCardDataManager.delegate = self;
        _bindIdentityCardDataManager.paramSource = self;
    }
    return _bindIdentityCardDataManager;
}

- (YSGetAIODataManager *)getAIODataManager {
    if (!_getAIODataManager) {
        _getAIODataManager = [[YSGetAIODataManager alloc] init];
        _getAIODataManager.delegate = self;
        _getAIODataManager.paramSource = self;
    }
    return _getAIODataManager;
}

- (YSAchiveAIOInfoDataManager *)achiveAIOInfoDataManager {
    if (!_achiveAIOInfoDataManager) {
        _achiveAIOInfoDataManager = [[YSAchiveAIOInfoDataManager alloc] init];
        _achiveAIOInfoDataManager.delegate = self;
        _achiveAIOInfoDataManager.paramSource = self;
    }
    return _achiveAIOInfoDataManager;
}

// 获取用户健康数据信息
- (void)getAIODateRequestWithType:(YSAIODataRequestType)requestType {
    [self showHud];
    self.aioDataRequestType = requestType;
    [self.getAIODataManager requestData];
}

#pragma mark --- 请求参数
- (NSDictionary *)paramsForApi:(YSAPIBaseManager *)manager {
    if ([manager isKindOfClass:[YSCheckUserIsBindIdentityCardDataManager class]]) {
        return @{};
    }else if ([manager isKindOfClass:[YSGetAIODataManager class]]) {
        switch (self.aioDataRequestType) {
            case YSAIODataRequestNoneType:
            {
                return @{};
            }
                break;
            case YSAIODataRequestRefreshType:
            {
                return @{};
            }
                break;
            case YSAIODataRequestSelectedDateType:
            {
                return @{
                            @"time":self.requestDateString
                        };
            }
                break;
            default:
                break;
        }
    }else if ([manager isKindOfClass:[YSAchiveAIOInfoDataManager class]]) {
        return @{};
    }
    return @{};
}

#pragma mark --- 请求返回
- (void)managerCallBackDidSuccess:(YSAPIBaseManager *)manager {
    [self hiddenHud];
    YSResponseDataReformer *reformer = [[YSResponseDataReformer alloc] init];
    if ([manager isKindOfClass:[YSCheckUserIsBindIdentityCardDataManager class]]) {
        YSCheckUserBingIdentityCardItem *item = [reformer reformDataWithAPIManager:manager];
        if (!item.m_status) {
            if (item.result) {
                // 已经绑定身份证号码 获取最新一体机数据
                [self getAIODateRequestWithType:YSAIODataRequestNoneType];
                if (item.updateNum >= 3) {
                    // 已经修改了三次
                    [self buildNavRightItem:NO];
                }else {
                    [self buildNavRightItem:YES];
                }
            }else {
                // 未绑定身份证号码
                [self showNoneDataView];
                [self buildNavRightItem:NO];
                @weakify(self);
                [UIAlertView xf_shoeWithTitle:@"" message:@"为保障您的信息安全，需要先\n添加身份证号码才能查看数据哦！" buttonsAndOnDismiss:@"取消",@"去添加",^(UIAlertView *alertView,NSUInteger index) {
                    @strongify(self);
                    if (index) {
                        // 添加身份证信息
                        [self toBindIdentityCardControllerWithSourceType:YSIdentityControllerSourceAddType];
                    }else {
                        // 取消
                        [self popViewController];
                    }
                }];
            }
        }else {
            [UIAlertView xf_showWithTitle:@"提示" message:item.m_errorMsg delay:2.0 onDismiss:NULL];
        }
    }else if ([manager isKindOfClass:[YSGetAIODataManager class]]) {
        YSAIODataItem *item = [reformer reformDataWithAPIManager:manager];
        [self dealGetAIODataWithItem:item];
    }else if ([manager isKindOfClass:[YSAchiveAIOInfoDataManager class]]) {
        YSUserAIOInfoItem *item = [reformer reformDataWithAPIManager:manager];
        [self dealAchieveUserAIOInfoWithItem:item];
    }
}

- (void)buildNavRightItem:(BOOL)isBuild {
    if (isBuild) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"修改身份证" style:UIBarButtonItemStylePlain target:self action:@selector(modifyIdentityCard:)];
    }else {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:[UIView new]];
    }
}

// 处理用户健康体检数据情况
- (void)dealGetAIODataWithItem:(YSAIODataItem *)item {
    if (self.aioDataRequestType == YSAIODataRequestRefreshType) {
        [self endTableViewRefresh];
    }
    if (!item.m_status) {
        [self showContentView];
//        self.contentView.dataItem = item;
    }else {
        [self buildNavRightItem:NO];
        [self showNoneDataView];
    }
}

// 点击修改身份证信息，校验修改次数
- (void)dealAchieveUserAIOInfoWithItem:(YSUserAIOInfoItem *)item {
    if (!item.m_status) {
        if (item.aioBinding.updateNum >= 3) {
            [self showToastIndicatorWithText:@"身份证只能修改三次，您已超过次数！" dismiss:2];
        }else {
            // 用户可修改
            [self pushBindIdentityCardWithSouceType:YSIdentityContollerSourceModifyType infoItem:item];
        }
    }else {
        [UIAlertView xf_showWithTitle:@"提示" message:item.m_errorMsg delay:2.0 onDismiss:NULL];
    }
}

#pragma mark --- 请求报错返回
- (void)managerCallBackDidFailed:(YSAPIBaseManager *)manager {
    [self hiddenHud];
    [UIAlertView xf_showWithTitle:@"提示" message:@"网络错误，重新再试!" delay:2.0 onDismiss:NULL];
    if ([manager isKindOfClass:[YSGetAIODataManager class]]) {
        if (self.aioDataRequestType == YSAIODataRequestRefreshType) {
            [self endTableViewRefresh];
        }
    }
}

- (void)endTableViewRefresh {
    [self.contentView endTableViewRefresh];
}

- (void)toBindIdentityCardControllerWithSourceType:(YSIdentityControllerSourceType)souceType {
    switch (souceType) {
        case YSIdentityControllerSourceAddType:
        {
            [self pushBindIdentityCardWithSouceType:souceType infoItem:nil];
        }
            break;
        case YSIdentityContollerSourceModifyType:
        {
            [self showHud];
            [self.achiveAIOInfoDataManager requestData];
        }
            break;
        default:
            break;
    }
}

- (void)pushBindIdentityCardWithSouceType:(YSIdentityControllerSourceType)souceType infoItem:(YSUserAIOInfoItem *)infoItem
{
    YSBindIdentityCardController *bindController = [[YSBindIdentityCardController alloc] init];
    bindController.sourceType = souceType;
    if (infoItem) {
        bindController.infoItem = infoItem;
    }
    @weakify(self);
    bindController.bindIdentityCardSucceedCallback = ^(YSIdentityControllerSourceType sourceType,NSString *idCard,NSInteger updateNum) {
        @strongify(self);
        [self getAIODateRequestWithType:YSAIODataRequestNoneType];
        if (updateNum >= 3) {
            [self buildNavRightItem:NO];
        }else {
            [self buildNavRightItem:YES];
        }
    };
    bindController.cancelBindIdCardCallback = ^{
        @strongify(self);
        [self checkUserBindIdentityCard];
    };
    [self.navigationController pushViewController:bindController animated:YES];
}

- (void)showNoneDataView {
    self.noneDataView.hidden = NO;
    [self hiddenContetnView];
}

- (void)showContentView {
    [self hiddenNoneDataView];
    self.contentView.hidden = NO;
    if (self.isPush) {
        self.contentView.hidden = YES;
//        self.contentView.aioHearderView.isRemind = YES;
//        self.contentView.aioHearderView.height = 90.;
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            [UIView animateWithDuration:2. delay:0. options:UIViewAnimationOptionCurveEaseInOut animations:^{
//                self.contentView.aioHearderView.height = 60.;
//
//            } completion:^(BOOL finished) {
//                self.contentView.aioHearderView.isRemind = NO;
//                [self.contentView.tableView reloadData];
//            }];
//        });
        RXWebViewController*view=[[RXWebViewController alloc]init];
        //view.urlstring=@"http://192.168.8.164:8082/carnation-apis-resource/resources/jkgl/healthData.html";
        view.urlstring=@"http://api.bhesky.com/resources/jkgl/healthData.html";
        view.titlestring=@"健康数据";
        [self.navigationController pushViewController:view animated:NO];
        self.isPush = NO;
    }else {
        self.contentView.aioHearderView.isRemind = NO;
        self.contentView.aioHearderView.height = 60.;
    }
}

- (void)hiddenContetnView {
    self.contentView.hidden = YES;
}

- (void)hiddenNoneDataView {
    self.noneDataView.hidden = YES;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [YSUMMobClickManager beginLogPageWithKey:[NSString stringWithFormat:@"%@%@",@"um_",NSStringFromClass([self class])]];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [YSUMMobClickManager endLogPageWithKey:[NSString stringWithFormat:@"%@%@",@"um_",NSStringFromClass([self class])]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setup];
}

- (void)bindTeleSucceccAction:(NSNotification *)noti {
    [self checkUserBindIdentityCard];
}

- (void)bindTeleFailAction:(NSNotification *)noti {
    [self popViewController];
}

- (void)setup {
    [self setupNavBarPopButton];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.navigationController.navigationBar.translucent = NO;
    if ([self respondsToSelector:@selector(automaticallyAdjustsScrollViewInsets)]) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(bindTeleSucceccAction:) name:kUserBindTeleSuccessKey object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(bindTeleFailAction:) name:kUserBindTeleFailKey object:nil];
    [YSThemeManager setNavigationTitle:@"健康数据" andViewController:self];
    self.view.backgroundColor = JGBaseColor;
    // 检测用户是否绑定过手机号码 没有绑定需要提醒
    [self showHud];
    @weakify(self)
    [self checkUserIsBindTele:^(BOOL result) {
        @strongify(self);
        [self hiddenHud];
        if (result) {
            // 已经绑定过手机 去查询用户是否绑定过身份证号码
            [self checkUserBindIdentityCard];
        }else {
            // 未绑定过手机号码 提示用户绑定手机号码
            [self showNoneDataView];
            [UIAlertView xf_shoeWithTitle:nil message:@"为了您的身份信息安全，请先绑定手机号码哦！" buttonsAndOnDismiss:@"取消",@"去绑定",^(UIAlertView *alert,NSUInteger index) {
                if (index == 0) {
                    // 取消，返回到上一页
                    [self popViewController];
                    
                }else {
                    // 检测用户是否绑定过手机号码 没有去绑定手机号码页面
                    [self checkUserIsBindTele:^(BOOL result) {
                        if (result) {
                            [self checkUserBindIdentityCard];
                        }
                    } isRemind:NO];
                }
            }];
        }
    } isRemind:YES];
}

- (void)popViewController{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"kPostDismissChunYuDoctorWebKey" object:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)backToLastController{
    [self popViewController];
}

- (void)checkUserIsBindTele:(bool_block_t)bindResult isRemind:(BOOL)isRemind {
    [YSLoginManager thirdPlatformUserBindingCheckSuccess:^(BOOL isBinding, UIViewController *controller) {
        BLOCK_EXEC(bindResult,isBinding);
    } fail:^{
        [UIAlertView xf_showWithTitle:@"网络错误或数据出错!" message:nil delay:1.2 onDismiss:NULL];
    } controller:self unbindTelphoneSource:YSUserBindTelephoneSourecHealthRecordType isRemind:isRemind];
}

- (void)modifyIdentityCard:(UIBarButtonItem *)barButtonItem {
    [self toBindIdentityCardControllerWithSourceType:YSIdentityContollerSourceModifyType];
}

- (NSDictionary *)userInfo {
    return [YSLoginManager userCustomer];
}

// 查看用户是否绑定身份证号码
- (void)checkUserBindIdentityCard {
    [self showHud];
    [self.bindIdentityCardDataManager requestData];
}

#pragma mark YSAIOHealthDataContentViewDelegate
- (void)contentView:(YSAIOHealthDataContentView *)contentView didSelectTime:(NSString *)currentTime {
//    JGDropdownMenu *menu = [JGDropdownMenu menu];
//    [menu configTouchViewDidDismissController:NO];
//    [menu configBgShowMengban];
//    UIViewController *controllerView = [UIViewController new];
//    controllerView.view.backgroundColor = JGClearColor;
//    controllerView.view.width = ScreenWidth;
//    controllerView.view.height = ScreenHeight;
//    YSAIODatePickerView *datePickerView = [[YSAIODatePickerView alloc] initWithFrame:CGRectMake(0, ScreenHeight - 216 - 42, ScreenWidth, 216 + 42)];
//    @weakify(self);
//    datePickerView.cancelPickerCallback = ^{
//        @strongify(self);
//        [self.menu dismiss];
//    };
//
//    datePickerView.selectedDateCallback = ^(NSString *msg) {
//        @strongify(self);
//        [self.menu dismiss];
//        [self.contentView.aioHearderView configHeaderDate:msg];
//        // 去请求
//        self.requestDateString = msg;
//        [self getAIODateRequestWithType:YSAIODataRequestSelectedDateType];
//    };
//    [controllerView.view addSubview:datePickerView];
//    menu.contentController = controllerView;
//    [menu showWithFrameWithDuration:0.32];
//    self.menu = menu;
}

- (void)contentView:(YSAIOHealthDataContentView *)contentView didSelecteDetailRowWithUrl:(NSString *)detailUrl itemTitle:(NSString *)title characteristicCode:(NSString *)characteristicCode
{
//    // 数据详情页统计
//    [YSUMMobClickManager beginLogPageWithKey:[NSString stringWithFormat:@"%@%@",@"um_",title]];
//    NSString *link = [NSString stringWithFormat:@"%@%@?uid=%@",[YSEnvironmentConfig mobileWebUrl],detailUrl,[self userInfo][@"uid"]];
//    YSLinkElongHotelWebController *elongHotelWebController = [[YSLinkElongHotelWebController alloc] initWithWebUrl:link];
////    elongHotelWebController.title = title;
//    [YSThemeManager setNavigationTitle:title andViewController:elongHotelWebController];
//    [elongHotelWebController buildRightItemWithTilte:@"数据说明" params:characteristicCode navTitle:title];
//    [self.navigationController pushViewController:elongHotelWebController animated:YES];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
