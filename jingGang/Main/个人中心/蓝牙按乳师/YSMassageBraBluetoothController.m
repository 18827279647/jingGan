//
//  YSMassageBraBluetoothController.m
//  jingGang
//
//  Created by dengxf on 17/6/22.
//  Copyright © 2017年 dengxf_dev. All rights reserved.
//

#import "YSMassageBraBluetoothController.h"
#import "YSMassageBraMacro.h"
#import "YSBluetoothDeviceManager.h"
#import "JGDropdownMenu.h"
#import "YSCustomAlertViewConfig.h"
#import "YSBeginSearchButton.h"
#import "YSMassageDatasView.h"
#import "YSMassagePickerView.h"
#import "YSMassageSceneController.h"
#import "YSAcquireMassageDataManager.h"
#import "YSAuquireMassageDataModel.h"
#import "GlobeObject.h"
#import "YSMassageSettingController.h"

#define ShowSearchingAlert          [self showMenbanWithSize:CGSizeMake(70, 147) alertType:YSCustomAlertWithSeachingDevices extParams:nil];
#define ShowNoneDeviceAlert         [self showMenbanWithSize:CGSizeMake(70, 220) alertType:YSCustomAlertWithSearchDeviceNone extParams:nil];
//#define ShowMassageCompleteAlert    [self showMenbanWithSize:CGSizeMake(70, 252.) alertType:YSCuctomAlertWithMassageComplete];
#define ShowDeviceListAlert(x)      [self showMenbanWithSize:CGSizeMake(70, 294) alertType:YSCustomAlertWithConnectDeviceList extParams:x];

@interface YSMassageBraBluetoothController ()<YSCustomAlertViewConfigDelegate,YSAPIManagerParamSource,YSAPICallbackProtocol>

@property (strong,nonatomic) YSBeginSearchButton *beginMassageButton;

@property (strong,nonatomic) YSCustomAlertViewConfig *alertViewConfig;

@property (strong,nonatomic) JGDropdownMenu *menu;

@property (strong,nonatomic) YSMassageDatasView *massageDatasView;

@property (strong,nonatomic) YSMassagePickerView *strengthPickerView;

@property (strong,nonatomic) YSMassagePickerView *massageTimePickerView;

@property (strong,nonatomic) YSAcquireMassageDataManager *acquireDateManager;

@end

@implementation YSMassageBraBluetoothController

#pragma mark getter methods

- (YSAcquireMassageDataManager *)acquireDateManager {
    if (!_acquireDateManager) {
        _acquireDateManager = [[YSAcquireMassageDataManager alloc] init];
        _acquireDateManager.delegate = self;
        _acquireDateManager.paramSource = self;
    }
    return _acquireDateManager;
}

- (YSCustomAlertViewConfig *)alertViewConfig {
    if (!_alertViewConfig) {
        _alertViewConfig = [[YSCustomAlertViewConfig alloc] init];
        _alertViewConfig.delegate = self;
    }
    return _alertViewConfig;
}

- (JGDropdownMenu *)menu {
    if (!_menu) {
        _menu = [JGDropdownMenu menu];
        [_menu configTouchViewDidDismissController:NO];
        [_menu configBgShowMengban];
    }
    return _menu;
}

- (YSMassageDatasView *)massageDatasView {
    if (!_massageDatasView) {
        _massageDatasView = [[YSMassageDatasView alloc] init];
    }
    return _massageDatasView;
}

- (YSMassagePickerView *)massageTimePickerView {
    if (!_massageTimePickerView) {
        _massageTimePickerView = [[YSMassagePickerView alloc] init];
        _massageTimePickerView.titleText = @"按摩时长";
        _massageTimePickerView.selectedTitleText = @"0";
        _massageTimePickerView.unit = @"分钟";
        _massageTimePickerView.dialCount = 10;
        _massageTimePickerView.shouldAutoScrollAnimate = YES;
    }
    return _massageTimePickerView;
}

- (YSMassagePickerView *)strengthPickerView {
    if (!_strengthPickerView) {
        _strengthPickerView = [[YSMassagePickerView alloc] init];
        _strengthPickerView.titleText = @"按摩强度";
        _strengthPickerView.selectedTitleText = @"0";
        _strengthPickerView.unit = @"级强度";
        _strengthPickerView.dialCount = 6;
        _strengthPickerView.shouldAutoScrollAnimate = YES;
    }
    return _strengthPickerView;
}

#pragma mark --- 请求返回
- (void)managerCallBackDidSuccess:(YSAPIBaseManager *)manager {
    YSResponseDataReformer *reformer = [[YSResponseDataReformer alloc] init];
    YSAuquireMassageDataModel *data = [reformer reformDataWithAPIManager:manager];
    [self.massageDatasView startAnimateWithTodayTime:[data.massageDetails.time integerValue] todaySuggestTime:30 totleMassageTime:[data.massageDetails.allTime integerValue]];
}
#pragma mark --- 请求报错返回
- (void)managerCallBackDidFailed:(YSAPIBaseManager *)manager {
    [self.massageDatasView startAnimateWithTodayTime:0 todaySuggestTime:30 totleMassageTime:0];
}

#pragma mark --- 请求参数
- (NSDictionary *)paramsForApi:(YSAPIBaseManager *)manager{
    return @{};
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [YSBluetoothDeviceManager configOperateScene:YSBluetoothOperateSceneWithSeaching];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(researchPeripera:) name:YSLostConnectToResearchPeripheralKey object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(researchPeripera:) name:YSReserchPeripheralKey object:nil];
    [self.acquireDateManager requestData];
     [YSUMMobClickManager beginLogPageWithKey:[NSString stringWithFormat:@"%@%@",@"um_",NSStringFromClass([self class])]];
}
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [YSUMMobClickManager endLogPageWithKey:[NSString stringWithFormat:@"%@%@",@"um_",NSStringFromClass([self class])]];
}

// 失去连接后重新搜索
- (void)researchPeripera:(NSNotification *)noti {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.24 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self beginSearchDevice];
    });
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupBluetooth];
}

#pragma maek 监听搜索蓝牙设备时间
- (void)beginSearchDevice {
    if ([YSBluetoothDeviceManager sharedInstance].isConnected) {
        
    }else {
        ShowSearchingAlert;
    }
    @weakify(self);
    [[YSBluetoothDeviceManager sharedInstance] beginSearch:^(NSArray *peripherals) {
        @strongify(self);
        [self.menu dismiss];
        NSMutableArray *tempArray = [NSMutableArray array];
        [tempArray addObjectsFromArray:peripherals];
        [self dealSearchDeviceResult:[tempArray copy]];
    }];
}

- (void)dealSearchDeviceResult:(NSArray *)peripherals {
    if (peripherals.count) {
        BOOL isConnected = NO;
        NSString *lastConnectedPeripheralName;
        NSArray *localPeripherals = [self achieve:kSaveConnectedPeripheralsKey];
        if (localPeripherals.count) {
            NSDictionary *lastConnectPeripheralDict = [localPeripherals lastObject];
             lastConnectedPeripheralName = lastConnectPeripheralDict[YSSavePeripheralNameKey];
            isConnected = YES;
        }
        if (isConnected) {
            BOOL exsit = NO;
            CBPeripheral *tempPeripheral = nil;
            for (CBPeripheral *scanPeripheral in peripherals) {
                if ([scanPeripheral.name isEqualToString:lastConnectedPeripheralName]) {
                    // 优先连接最后一次的
                    exsit = YES;
                    tempPeripheral = scanPeripheral;
                    break;
                }
            }
            if (exsit) {
                // 搜索的设备中有最后一次连接过的
                [[YSBluetoothDeviceManager sharedInstance] connectPeripheral:tempPeripheral result:^(BOOL result) {
                    if (result) {
                        JGLog(@"--连接成功");
                        [[YSBluetoothDeviceManager sharedInstance] pauseMassageWithStrong:3];
                    }else {
                        JGLog(@"--连接失败");
                    }
                }];
            }else {
                // 搜索设备列表中连接过的
                NSMutableArray *tempPeripheraName = [NSMutableArray array];
                for (CBPeripheral *searchedPeripheral in peripherals) {
                    [tempPeripheraName xf_safeAddObject:searchedPeripheral.name];
                }
                NSMutableSet *localPeripheralSet = [NSMutableSet setWithArray:localPeripherals];
                NSMutableSet *searchedPeripheralSet = [NSMutableSet setWithArray:[tempPeripheraName copy]];
                [localPeripheralSet intersectSet:searchedPeripheralSet];
                if (localPeripheralSet.count) {
                    [localPeripheralSet enumerateObjectsUsingBlock:^(NSString * obj, BOOL * _Nonnull stop) {
                        if (obj) {
                            for (CBPeripheral *searchedPeripheral in peripherals) {
                                if ([searchedPeripheral.name isEqualToString:obj]) {
                                    [[YSBluetoothDeviceManager sharedInstance] connectPeripheral:searchedPeripheral result:^(BOOL result) {
                                        if (result) {
                                            [[YSBluetoothDeviceManager sharedInstance] pauseMassageWithStrong:3];
                                            JGLog(@"warn:------连接成功");
                                        }else {
                                            JGLog(@"warn:------连接失败");
                                        }
                                    }];
                                    break;
                                }
                            }
                            *stop = YES;
                        }
                    }];
                }else {
                    // 发现的设备中跟已连设备列表无交集
                    JGLog(@"---- 当前被搜索当中的设备不存在连接过的设备  展现列表");
                    [YSBluetoothDeviceManager sharedInstance].searchedPeripheralsListShow = YES;
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.32 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        ShowDeviceListAlert([YSCustomAlertViewConfig recombineDevicesList:peripherals]);
                    });
                }
            }
            
        }else {
            JGLog(@"---当前设备未连接过设备  展现列表");
            [YSBluetoothDeviceManager sharedInstance].searchedPeripheralsListShow = YES;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.32 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                ShowDeviceListAlert([YSCustomAlertViewConfig recombineDevicesList:peripherals]);
            });
        }
    }else {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.32 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            ShowNoneDeviceAlert;
        });
    }
}

- (void)setupBluetooth {
    [self setupNavBarPopButton];
    [self setupNavBarTitleViewWithText:@"智能胸部理疗仪"];
    self.view.backgroundColor = JGBaseColor;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"设置" style:UIBarButtonItemStyleDone target:self action:@selector(massageSetAction)];
    [[YSBluetoothDeviceManager sharedInstance] startup];
    // 初始化背景视图
    UIImageView *bgImageView = [self buildBgImageView];
    
    // 初始化开始按钮
    self.beginMassageButton = [self buildSearchButtonWithBgImageView:bgImageView];
    [bgImageView addSubview:self.beginMassageButton];
    [self.view addSubview:bgImageView];

    CGFloat marginyY = 0 ;
    if (iPhone5 || iPhone4) {
        marginyY = 54.;
    }else if (iPhone6) {
        marginyY = 70;
    }else{
        marginyY = 70;
    }
    self.massageDatasView.frame = CGRectMake(0, 0, bgImageView.width, marginyY);
    [bgImageView addSubview:self.massageDatasView];
    
    if (iPhone5 || iPhone4) {
        marginyY = 12.;
    }else if (iPhone6) {
        marginyY = 40;
    }else{
        marginyY = 40;
    }
    self.strengthPickerView.frame = CGRectMake(0, MaxY(self.massageDatasView) + marginyY, ScreenWidth, 120);
    [bgImageView addSubview:self.strengthPickerView];
    
    if (iPhone5 || iPhone4) {
        marginyY = 24;
    }else if (iPhone6) {
        marginyY = 38;
    }else{
        marginyY = 38;
    }
    self.massageTimePickerView.frame = CGRectMake(0, MaxY(self.strengthPickerView) + marginyY, ScreenWidth, 120);
    [bgImageView addSubview:self.massageTimePickerView];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        JGLog(@"#######开始搜索");
        if ([YSBluetoothDeviceManager sharedInstance].isConnected) {
            JGLog(@"---蓝压已连接");
            
        }else {
            if (![YSBluetoothDeviceManager sharedInstance].isBluetoothOpen) {
                [[YSBluetoothDeviceManager sharedInstance] showBluetoothOffAlertView];
                return ;
            }
            [self beginSearchDevice];
        }
    });
    
    @weakify(self);
    self.beginMassageButton.searchDeviceCallback = ^(){
#pragma mark -- 开始搜索
        @strongify(self);
        [self beginSearch];
    };
}

- (void)beginSearch {
    //        YSMassageSceneController *massageSceneController = [[YSMassageSceneController alloc] init];
    //        massageSceneController.massageTimeRank = self.massageTimePickerView.currenItemIndex;
    //        massageSceneController.massageStrengthRank = self.strengthPickerView.currenItemIndex;
    //        [self.navigationController pushViewController:massageSceneController animated:YES];
    //        return ;
    if (![YSBluetoothDeviceManager sharedInstance].isBluetoothOpen) {
        [[YSBluetoothDeviceManager sharedInstance] showBluetoothOffAlertView];
        return ;
    }
    if([YSBluetoothDeviceManager sharedInstance].isConnected) {
        YSMassageSceneController *massageSceneController = [[YSMassageSceneController alloc] init];
        massageSceneController.massageTimeRank = self.massageTimePickerView.currenItemIndex;
        massageSceneController.massageStrengthRank = self.strengthPickerView.currenItemIndex;
        [YSBluetoothDeviceManager sharedInstance].massageTime = self.massageTimePickerView.currenItemIndex;
        [YSBluetoothDeviceManager sharedInstance].massageStrength = self.strengthPickerView.currenItemIndex;
        [self.navigationController pushViewController:massageSceneController animated:YES];
    }else {
        [self beginSearchDevice];
    }
}

#pragma mark  - 设置
- (void)massageSetAction {
    if ([YSBluetoothDeviceManager sharedInstance].isConnected) {
        YSMassageSettingController *settingController = [[YSMassageSettingController alloc] init];
        @weakify(self);
        settingController.researchDeviceCallback = ^(){
            @strongify(self);
            [self showHudWithMsg:@"解绑成功"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                JGLog(@"#======解绑后重新搜索设备");
                [self hiddenHud];
                [self beginSearchDevice];
            });
        };
        [self.navigationController pushViewController:settingController animated:YES];
    }else {
        [self beginSearch];
    }
}

#pragma mark 初始化背景图片视图
- (UIImageView *)buildBgImageView {
    // ys_personal_device_bgimage
    UIImageView *bgImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ys_personal_device_bgimage"]];
    bgImageView.x = 0;
    bgImageView.y = 0;
    bgImageView.width = ScreenWidth;
    bgImageView.height = ScreenHeight - NavBarHeight;
    bgImageView.userInteractionEnabled = YES;
    return bgImageView;
}

- (YSBeginSearchButton *)beginMassageButton {
    if (!_beginMassageButton) {
        _beginMassageButton = [[YSBeginSearchButton alloc] init];
    }
    return _beginMassageButton;
}


#pragma 初始化开始按钮
- (YSBeginSearchButton *)buildSearchButtonWithBgImageView:(UIImageView *)bgImageView{
    self.beginMassageButton.width = 120;
    self.beginMassageButton.height = 120;
    self.beginMassageButton.x = (bgImageView.width - self.beginMassageButton.width) / 2;
    self.beginMassageButton.y = MaxY(bgImageView) - 26 - self.beginMassageButton.height;
    return self.beginMassageButton;
}

#pragma mark 返回一个弹框视图
- (UIView *)showMenbanWithSize:(CGSize)viewSize alertType:(YSCustomAlertType)alertType extParams:(id)exparams {
    UIViewController *controller = [[UIViewController alloc] init];
    controller.view.backgroundColor = JGClearColor;
    controller.view.width = ScreenWidth;
    controller.view.height = ScreenHeight;
    UIView *alertView = [self.alertViewConfig alertView:alertType extParams:exparams];
    alertView.width = ScreenWidth - viewSize.width;
    alertView.height = viewSize.height;
    alertView.center = controller.view.center;
    [controller.view addSubview:alertView];
    self.menu.contentController = controller;
    [self.menu showAlertWithDuration:0.45];
    return alertView;
}

#pragma mark ------YSCustomAlertViewConfigDelegate
- (void)alertView:(UIView *)alertView extMsgCode:(YSCustomAlertCallbackCode)extMsgCode {
    switch (extMsgCode) {
        case YSCustomAlertCallbackClose:
        {
            JGLog(@"---click close");
            [self.menu dismiss];
        }
            break;
        case YSCustomAlertCallbackResearch:
        {
            JGLog(@"---click research");
            [self.menu dismiss];
            if ([YSBluetoothDeviceManager sharedInstance].isBluetoothOpen) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self beginSearchDevice];
                });
            }else {
                [[YSBluetoothDeviceManager sharedInstance] showBluetoothOffAlertView];
            }
        }
            break;
        case YSCustomAlertConnectDevice:
        {
            JGLog(@"--连接蓝牙设备");
            [YSBluetoothDeviceManager sharedInstance].searchedPeripheralsListShow = NO;
            YSConnectDevicesListView *deviceListView = (YSConnectDevicesListView *)alertView;
            CBPeripheral *peripheral = deviceListView.peripheral;
            @weakify(self);
            [[YSBluetoothDeviceManager sharedInstance] connectPeripheral:peripheral result:^(BOOL result) {
                if (result) {
                    JGLog(@"---连接成功");
                    @strongify(self);
                    [self.menu dismiss];
                    [[YSBluetoothDeviceManager sharedInstance] pauseMassageWithStrong:3];
                }else {
                    JGLog(@"---连接失败");
                    [self.menu dismiss];
                }
            }];
        }
            break;
        case YSCustomAlertCallbackCloseWithSearchAlert:
        {
            JGLog(@"---停止搜索");
            [self.menu dismiss];
            [[YSBluetoothDeviceManager sharedInstance] stopScanBluetooth];
        }
            break;
        case YSCustomAlertCallbackCloseWithDeviceListAlert:
        {
            JGLog(@"---关闭搜索设备列表");
            [YSBluetoothDeviceManager sharedInstance].searchedPeripheralsListShow = NO;
            [self.menu dismiss];
        }
            break;
        default:
            break;
    }
}

- (void)dealloc {
    JGLog(@"--YSMassageBraBluetoothController dealloc");
}
@end
