//
//  YSMassageSceneController.m
//  jingGang
//
//  Created by dengxf on 17/6/29.
//  Copyright © 2017年 dengxf_dev. All rights reserved.
//

#import "YSMassageSceneController.h"
#import "YSMassageProgressView.h"
#import "YSBluetoothDeviceManager.h"
#import "YSMassagePickerView.h"
#import "YSMassageButtonView.h"
#import "YSMassageSettingController.h"
#import "YSCustomAlertViewConfig.h"
#import "JGDropdownMenu.h"
#import "YSMassageBraMacro.h"
#import "YSUploadMassageDataManager.h"
#import "GlobeObject.h"

typedef NS_ENUM(NSUInteger, YSUploadMassageDataType) {
    YSUploadMassageDataWithCompleteType = 40,
    YSUploadMassageDataWithEndType
};

@import CoreTelephony;

#define ShowClickEndAlert           [self showMenbanWithSize:CGSizeMake(70, 288) alertType:YSCustomAlertClickEndMassage extParams:nil];
#define ShowMassageCompleteAlert(text)    [self showMenbanWithSize:CGSizeMake(70, 268) alertType:YSCustomAlertWithMassageComplete extParams:text];
#define ShowTeleComingBreakAlert    [self showMenbanWithSize:CGSizeMake(70, 220) alertType:YSCustomAlertWithMassageTeleComingBreak extParams:nil]


@interface YSMassageSceneController ()<YSCustomAlertViewConfigDelegate,YSMassagePickerViewDelegate,YSAPIManagerParamSource,YSAPICallbackProtocol>

@property (strong,nonatomic) YSMassageProgressView *progressView;

@property (strong,nonatomic) YSMassagePickerView *strengthPickerView;

@property (nonatomic, strong) CTCallCenter * center;

@property (strong,nonatomic) YSCustomAlertViewConfig *alertViewConfig;

@property (strong,nonatomic) JGDropdownMenu *menu;

@property (strong,nonatomic) YSMassageButtonView *massageButtons;

@property (strong,nonatomic) YSUploadMassageDataManager *uploadDataManager;

@property (assign, nonatomic) YSUploadMassageDataType uploadDataType;

@property (copy , nonatomic) bool_block_t uploadResultCallback;


@end

@implementation YSMassageSceneController

- (YSUploadMassageDataManager *)uploadDataManager {
    if (!_uploadDataManager) {
        _uploadDataManager = [[YSUploadMassageDataManager alloc] init];
        _uploadDataManager.delegate = self;
        _uploadDataManager.paramSource = self;
    }
    return _uploadDataManager;
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

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [YSBluetoothDeviceManager configOperateScene:YSBluetoothOperateSceneWithConnecting];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(backToResearchPeriperals:) name:YSLostConnectBackToResearchPeripheralKey object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loseConnect:) name:YSPeripheralLoseConnectKey object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(backToResearchPeriperals:) name:YSConncetingSceneBackLastSceneKey object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(backAndUploadData) name:YSBackSearchingSceneAndUploadMassageTimeKey object:nil];
}

- (void)backAndUploadData {
    for (UIViewController *controller in self.navigationController.viewControllers) {
        if ([controller isKindOfClass:NSClassFromString(@"YSMassageBraBluetoothController")]) {
            self.massageTimeRank = self.progressView.massageTime;
            [[YSBluetoothDeviceManager sharedInstance] pauseMassageWithStrong:self.massageStrengthRank];
            @weakify(self);
            [self uploadMassageDataWithType:YSUploadMassageDataWithEndType result:^(BOOL result) {
                @strongify(self);
                [self backtoMassageSearchingController];
            }];
        }
    }
}

- (void)loseConnect:(NSNotification *)noti {
    [self setNavTitle:@"暂停按摩"];
    [self.progressView pause];
    [self.massageButtons  sendPauseEvent];
}

- (void)backToResearchPeriperals:(NSNotification *)noti {
    
    for (UIViewController *controller in self.navigationController.viewControllers) {
        if ([controller isKindOfClass:NSClassFromString(@"YSMassageBraBluetoothController")]) {
            self.massageTimeRank = self.progressView.massageTime;
            [[YSBluetoothDeviceManager sharedInstance] pauseMassageWithStrong:self.massageStrengthRank];
            @weakify(self);
            [self uploadMassageDataWithType:YSUploadMassageDataWithEndType result:^(BOOL result) {
                @strongify(self);
                [[NSNotificationCenter defaultCenter] postNotificationName:YSReserchPeripheralKey object:nil];
                [self backtoMassageSearchingController];
            }];
        }
    }
}

- (YSMassagePickerView *)strengthPickerView {
    if (!_strengthPickerView) {
        _strengthPickerView = [[YSMassagePickerView alloc] init];
        _strengthPickerView.titleText = @"按摩强度";
        _strengthPickerView.selectedTitleText = @"0";
        _strengthPickerView.unit = @"级强度";
        _strengthPickerView.dialCount = 6;
        _strengthPickerView.shouldAutoScrollAnimate = NO;
        _strengthPickerView.defaultItem = self.massageStrengthRank;
        _strengthPickerView.delegate = self;
    }
    return _strengthPickerView;
}

#pragma mark --- 请求返回
- (void)managerCallBackDidSuccess:(YSAPIBaseManager *)manager {
    YSResponseDataReformer *reformer = [[YSResponseDataReformer alloc] init];
    YSBaseResponseItem *baseItem = [reformer reformDataWithAPIManager:manager];
    BLOCK_EXEC(self.uploadResultCallback,YES);
    if (baseItem.m_status) {
        JGLog(@"upload fail");
    }else {
        JGLog(@"upload success");
    }
    [SVProgressHUD dismiss];
    switch (self.uploadDataType) {
        case YSUploadMassageDataWithCompleteType:
        {
            NSString *showText = [NSString stringWithFormat:@"真棒！您又坚持完成了%ld分钟的按摩！离健康与美丽又进一步。",(NSInteger)self.massageTimeRank];
            ShowMassageCompleteAlert(showText);
        }
            break;
        case YSUploadMassageDataWithEndType:
        {
            [self backtoMassageSearchingController];
        }
            break;
        default:
            break;
    }
}
#pragma mark --- 请求报错返回
- (void)managerCallBackDidFailed:(YSAPIBaseManager *)manager {
    [SVProgressHUD dismiss];
    BLOCK_EXEC(self.uploadResultCallback,NO);
    switch (self.uploadDataType) {
        case YSUploadMassageDataWithCompleteType:
        {
            // 完成
            NSString *showText = [NSString stringWithFormat:@"真棒！您又坚持完成了%ld分钟的按摩！离健康与美丽又进一步。",(NSInteger)self.massageTimeRank];
            ShowMassageCompleteAlert(showText);
        }
            break;
        case YSUploadMassageDataWithEndType:
        {
            // 结束
            [self backtoMassageSearchingController];
        }
            break;
        default:
            break;
    }
}

#pragma mark --- 请求参数
- (NSDictionary *)paramsForApi:(YSAPIBaseManager *)manager{
    JGLog(@"----按摩时间:%ld",(NSInteger)self.massageTimeRank);
    return @{
                @"time":[NSNumber numberWithInteger:(NSInteger)self.massageTimeRank]
             };
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self massageInit];
    [self setup];
    [self startMassage];
}

- (void)uploadMassageDataWithType:(YSUploadMassageDataType)type result:(bool_block_t)result{
    [SVProgressHUD showInView:self.view status:@"上传数据..."];
    self.uploadResultCallback = result;
    self.uploadDataType = type;
    [self.uploadDataManager requestData];
}

- (void)startMassage {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.progressView start];
        [self sendMassageOrder];
    });
}

- (void)sendMassageOrder {
    [self setNavTitle:@"正在按摩"];
    BOOL isOpen = NO;
    switch ([YSBluetoothDeviceManager teleLostMode]) {
        case YSBluetoothSettingIsOff:
            isOpen = NO;
            break;
        default:
            isOpen = YES;
            break;
    }

    [[YSBluetoothDeviceManager sharedInstance] sendShakeOrderWithTimeValue:(NSInteger)self.massageTimeRank strongValue:self.massageStrengthRank phoneLostMode:isOpen];
}

- (void)massageInit {
    JGLog(@"\n---- 开始按摩 ------");
    JGLog(@"\n---- 按摩强度:%ld ------",self.massageStrengthRank);
    JGLog(@"\n---- 按摩时间:%f ----",self.massageTimeRank);
    self.center = [[CTCallCenter alloc] init];
    @weakify(self);
    self.center.callEventHandler  = ^(CTCall * call) {
        dispatch_async(dispatch_get_main_queue(), ^{
            JGLog(@"来电状态：%@", call.callState);
            @strongify(self);
            if (![YSBluetoothDeviceManager sharedInstance].isConnected) {
                return ;
            }
//            if (![YSBluetoothDeviceManager teleRemind]) {
//                return;
//            }
            YSBluetoothDefaultSettingState teleComingState = [YSBluetoothDeviceManager teleRemind];
            BOOL ret = NO;
            switch (teleComingState) {
                case YSBluetoothSettingIsOff:
                    ret = NO;
                    break;
                default:
                    ret = YES;
                    break;
            }
            if (!ret) {
                return;
            }
            
            if ([call.callState isEqualToString:@"CTCallStateIncoming"]) {
                // 发送来电提醒指令
                BOOL teleComingState = NO;
                YSBluetoothDefaultSettingState state = [YSBluetoothDeviceManager teleLostMode];
                switch (state) {
                    case YSBluetoothSettingIsOff:
                        teleComingState = NO;
                        break;
                    default:
                        teleComingState = YES;
                        break;
                }
                [[YSBluetoothDeviceManager sharedInstance] sendCallComingOrderWithTimeValue:(NSInteger)self.massageTimeRank strongValue:self.massageStrengthRank phoneLost:teleComingState];
            }else if ([call.callState isEqualToString:@"CTCallStateDisconnected"]) {
                // 断开通话 弹出继续按摩
                ShowTeleComingBreakAlert;
                [self handlePauseEvent];
                [self.massageButtons sendPauseEvent];
            }
        });
    };
}

- (void)setup {
    self.view.backgroundColor = JGBaseColor;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:@selector(leftBarButtonAction)];
    [self setNavTitle:@"正在按摩"];
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"设置" style:UIBarButtonItemStyleDone target:self action:@selector(massageSetAction)];
    
    UIImageView *bgImageView = [self buildBgImageView];
    [self.view addSubview:bgImageView];
    
    self.progressView = [self buildProgressView];
    [bgImageView addSubview:self.progressView];
    
    CGFloat margin = 0;
    if (iPhone5 || iPhone4) {
        margin = -6;
    }else {
        margin = 0;
    }
    self.strengthPickerView.frame = CGRectMake(0, MaxY(self.progressView) + margin, ScreenWidth, 120);
    [bgImageView addSubview:self.strengthPickerView];

    @weakify(self);
    if (iPhone5 || iPhone4) {
        margin = 32;
    }else {
        margin = 48;
    }
    YSMassageButtonView *massageButtons = [[YSMassageButtonView alloc] initWithFrame: CGRectMake(0, bgImageView.height - 80 - margin, ScreenWidth, 80) bgColor:@[[UIColor colorWithHexString:@"#ff6500"],[UIColor colorWithHexString:@"#ffb900"],[YSThemeManager buttonBgColor]] space:6 clickCallback:^(NSString *buttonTitle){
        @strongify(self);
        [self dealEventWithButtonTitle:buttonTitle];
    }];
    [bgImageView addSubview:massageButtons];
    self.massageButtons = massageButtons;
}

- (void)dealEventWithButtonTitle:(NSString *)title {
    if ([title isEqualToString:@"结束"]) {
        [self handleEndEvent];
    }else if ([title isEqualToString:@"暂停"]) {
        [self handlePauseEvent];
    }else if ([title isEqualToString:@"继续"]) {
        [self handleContinueEvent];
    }
}

#pragma mark 结束
- (void)handleEndEvent {
    [self setNavTitle:@"暂停按摩"];
    ShowClickEndAlert;
}

#pragma mark 暂停
- (void)handlePauseEvent {
    [self setNavTitle:@"暂停按摩"];
    [self.progressView pause];
    [[YSBluetoothDeviceManager sharedInstance] pauseMassageWithStrong:self.massageStrengthRank];
}

#pragma mark 继续
- (void)handleContinueEvent {
    if ([YSBluetoothDeviceManager sharedInstance].isConnected && [YSBluetoothDeviceManager sharedInstance].isBluetoothOpen) {
        [self.progressView resume];
        [self sendMassageOrder];
        [self setNavTitle:@"正在按摩"];
        return;
    }
}


#pragma mark 初始化背景图片视图
- (UIImageView *)buildBgImageView {
    UIImageView *bgImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ys_personal_device_bgimage"]];
    bgImageView.x = 0;
    bgImageView.y = 0;
    bgImageView.width = ScreenWidth;
    bgImageView.height = ScreenHeight - NavBarHeight;
    bgImageView.userInteractionEnabled = YES;
    return bgImageView;
}

- (YSMassageProgressView *)buildProgressView {
    CGFloat progressx = [YSAdaptiveFrameConfig width:64];
    CGFloat margin = 0;
    if (iPhone5 || iPhone4) {
        margin = 12;
    }else {
        margin = 24;
    }
    YSMassageProgressView *progressView = [[YSMassageProgressView alloc] initWithFrame:CGRectMake(progressx, margin, ScreenWidth - 2 * progressx,  ScreenWidth - 2 * progressx)];
    progressView.countDownTime = (NSInteger)self.massageTimeRank * 60;
    @weakify(self);
    progressView.endCallback = ^(){
        // 按摩结束
        @strongify(self);
        [self uploadDataWithComplete];
        [[YSBluetoothDeviceManager sharedInstance] pauseMassageWithStrong:self.massageStrengthRank];
        [self setNavTitle:@"完成按摩"];
    };
    return progressView;
}

- (void)uploadDataWithComplete {
    [self uploadMassageDataWithType:YSUploadMassageDataWithCompleteType result:NULL];
}

- (void)massageSetAction {
    YSMassageSettingController *settingController = [[YSMassageSettingController alloc] init];
    [self.navigationController pushViewController:settingController animated:YES];
}

- (void)leftBarButtonAction {
    
}

- (void)setNavTitle:(NSString *)text {
    if ([self.navigationItem.titleView isKindOfClass:[UILabel class]]) {
        UILabel *titleLab = (UILabel *)self.navigationItem.titleView;
        titleLab.text = text;
    }else {
        [self setupNavBarTitleViewWithText:text];
    }
}
#pragma mark 返回一个弹框视图
- (UIView *)showMenbanWithSize:(CGSize)viewSize alertType:(YSCustomAlertType)alertType extParams:(id)exparams{
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
    [self.menu dismiss];
    switch (extMsgCode) {
        case YSCustomAlertEndWithContinue:
        {
            // 继续按摩
            [self handleContinueEvent];
            [self.massageButtons sendcontinueEvent];
        }
            break;
        case YSCustomAlertEndWithEnd:
        {
            // 结束按摩
            self.massageTimeRank = self.progressView.massageTime;
            [[YSBluetoothDeviceManager sharedInstance] pauseMassageWithStrong:self.massageStrengthRank];
            [self uploadMassageDataWithType:YSUploadMassageDataWithEndType result:NULL];
        }
            break;
        case YSCustomAlertCallbackComplete:
        {
            // 按摩完成
            [self backtoMassageSearchingController];
        }
            break;
        case YSCustomAlertCallbackTeleComingBreak:
        {
            // 来电中断，继续按摩
            [self handleContinueEvent];
            [self.massageButtons sendcontinueEvent];
        }
            break;
        default:
            break;
    }
}

/**
 *  回到蓝牙配置页面 */
- (void)backtoMassageSearchingController {
    for (UIViewController *controller in self.navigationController.viewControllers) {
        if ([controller isKindOfClass:NSClassFromString(@"YSMassageBraBluetoothController")]) {
            [self.navigationController popToViewController:controller animated:YES];
        }
    }
}

#pragma mark YSMassagePickerViewDelegate
- (void)pickerView:(YSMassagePickerView *)pickerView selectedItem:(NSInteger)item
{
    self.massageStrengthRank = item + 1;
    [YSBluetoothDeviceManager sharedInstance].massageStrength =  item + 1;
    [self sendMassageOrder];
}

- (void)dealloc {
    JGLog(@"----YSMassageSceneController dealloc");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
