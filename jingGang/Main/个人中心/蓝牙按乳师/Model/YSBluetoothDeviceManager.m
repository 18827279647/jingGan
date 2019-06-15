//
//  YSBluetoothDeviceManager.m
//  jingGang
//
//  Created by dengxf on 17/6/26.
//  Copyright © 2017年 dengxf_dev. All rights reserved.
//

#import "YSBluetoothDeviceManager.h"
#import "BabyBluetooth.h"
#import "YSMassageBraMacro.h"
#import "JGDropdownMenu.h"
#import "YSCustomAlertViewConfig.h"
@interface YSBluetoothDeviceManager ()<YSCustomAlertViewConfigDelegate>

@property (strong,nonatomic) BabyBluetooth *babyBluetooth;
@property (strong,nonatomic) NSMutableArray *terminalNamesArray;
@property (strong,nonatomic) NSMutableArray *terminalPeripheralsArray;
@property (strong,nonatomic) NSMutableArray *peripheralIdentifierArray;
@property (strong,nonatomic) MSWeakTimer *searchDeviceTimer;
@property (assign, nonatomic) NSInteger searchTime;
@property (copy , nonatomic) void(^didSearchDeviceCallback)(NSArray *peripherals);
@property (assign, nonatomic) BOOL isConnected;
@property (strong,nonatomic) CBPeripheral *currentConnectedPeripheral;
@property (copy , nonatomic) bool_block_t connectResultCallback;
@property (nonatomic, strong) CBCharacteristic *charRead;
@property (nonatomic, strong) CBCharacteristic *charWrite;
/**
 *  蓝牙外设是否开启 */
@property (assign, nonatomic) BOOL isBluetoothOpen;

@property (strong,nonatomic) JGDropdownMenu  *loseConnectMenu;

@property (assign, nonatomic) BOOL loseConnectAlertDidShow;

@property (strong,nonatomic) YSCustomAlertViewConfig *alertViewConfig;

@property (strong,nonatomic) JGDropdownMenu *bluetoothOffMenu;

@property (assign, nonatomic) BOOL bluetoothOffAlertDidShow;

@property (assign, nonatomic) BOOL isCancelScan;

@end

@implementation YSBluetoothDeviceManager

#pragma mark getter methods

- (NSMutableArray *)terminalNamesArray {
    if (!_terminalNamesArray) {
        _terminalNamesArray = [[NSMutableArray alloc] init];
    }
    return _terminalNamesArray;
}

- (NSMutableArray *)terminalPeripheralsArray {
    if (!_terminalPeripheralsArray) {
        _terminalPeripheralsArray = [[NSMutableArray alloc] init];
    }
    return _terminalPeripheralsArray;
}

- (NSMutableArray *)peripheralIdentifierArray {
    if (!_peripheralIdentifierArray) {
        _peripheralIdentifierArray = [[NSMutableArray alloc] init];
    }
    return _peripheralIdentifierArray;
}

- (YSCustomAlertViewConfig *)alertViewConfig {
    if (!_alertViewConfig) {
        _alertViewConfig = [[YSCustomAlertViewConfig alloc] init];
        _alertViewConfig.delegate = self;
    }
    return _alertViewConfig;
}

- (JGDropdownMenu *)loseConnectMenu {
    if (!_loseConnectMenu) {
        _loseConnectMenu = [JGDropdownMenu menu];
        [_loseConnectMenu configTouchViewDidDismissController:NO];
        [_loseConnectMenu configBgShowMengban];
    }
    return _loseConnectMenu;
}

- (JGDropdownMenu *)bluetoothOffMenu {
    if (!_bluetoothOffMenu) {
        _bluetoothOffMenu = [JGDropdownMenu menu];
        [_bluetoothOffMenu configTouchViewDidDismissController:NO];
        [_bluetoothOffMenu configBgShowMengban];
    }
    return _bluetoothOffMenu;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        @weakify(self)
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loseConnect:) name:YSPeripheralLoseConnectAlertViewCallbackKey object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(closeAlertWithLoseConnect) name:YSCloseAlertWithLoseConnectKey object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(jumpBluetoothSetting:) name:YSJumpBluetoothSettingKey object:nil];
//        _isConnecting = NO;
        _isCancelScan = NO;
        _loseConnectAlertDidShow = NO;
        _bluetoothOffAlertDidShow = NO;
        _searchedPeripheralsListShow = NO;
        _babyBluetooth = [BabyBluetooth shareBabyBluetooth];
        _isBluetoothOpen = NO;
        _isConnected = NO;
        // 设置扫描到设备的委托
        [_babyBluetooth setBlockOnDiscoverToPeripherals:^(CBCentralManager *central, CBPeripheral *peripheral, NSDictionary *advertisementData, NSNumber *RSSI) {
            @strongify(self)
            
            if ([peripheral.name isEmpty] || [self.peripheralIdentifierArray containsObject:[self identifierWithPeripheral:peripheral]]) {
                return ;
            }
            
            [self invalidateSearchTimer];

            if (self.terminalNamesArray.count) {
                // 已存在搜索到的设备了，更新
                JGLog(@"---更新搜索设备列表");
                [self.terminalPeripheralsArray xf_safeAddObject:peripheral];
                [self.terminalNamesArray xf_safeAddObject:peripheral.name];
                [self.peripheralIdentifierArray xf_safeAddObject:[self identifierWithPeripheral:peripheral]];
//                [[NSNotificationCenter defaultCenter] postNotificationName:YSUpdateSearchPeriperalsKey object:[self.terminalPeripheralsArray copy]];
            }else {
                // 不存在需要将搜索到的设备 用列表呈现
                JGLog(@"已经找到第一台");
                [self.terminalPeripheralsArray xf_safeAddObject:peripheral];
                [self.terminalNamesArray xf_safeAddObject:peripheral.name];
                [self.peripheralIdentifierArray xf_safeAddObject:[self identifierWithPeripheral:peripheral]];
            }
#warning 暂时4秒控制 其实找到了之前连接的可以直接返回
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4. * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                if (!self.searchedPeripheralsListShow) {
                    if (self.isCancelScan) {
                        // 取消搜索了 不弹框 避免取消搜索后 仍弹出搜索设备列表弹框
                    }else{
                        BLOCK_EXEC(self.didSearchDeviceCallback,[self.terminalPeripheralsArray copy]);
                    }
                }
            });
        }];
        
        // 连接设备成功的委托
        //设置设备连接成功的委托,同一个baby对象，使用不同的channel切换委托回调
        [_babyBluetooth setBlockOnConnected:^(CBCentralManager *central, CBPeripheral *peripheral) {
            @strongify(self)
            JGLog(@"--连接操作完成");
//            self.isConnecting = NO;
            if (!peripheral.name) {
                [self showProgressViewWithText:@"连接失败！错误3001"];
                BLOCK_EXEC(self.connectResultCallback,NO);
                return;
            }
            // 如果已经连接成功过则断开其他的连接
            if (self.isConnected) {
                [self.babyBluetooth cancelPeripheralConnection:peripheral];
//                BLOCK_EXEC(self.connectResultCallback,NO);
                return;
            }
            JGLog(@"设备：%@--连接成功",peripheral.name);
            [self showProgressViewWithText:@"连接成功"];
            self.isConnected = YES;
            self.currentConnectedPeripheral = peripheral;
            [self.babyBluetooth AutoReconnect:peripheral];
            [self stopScanBluetooth];
            // 保存连接成功的 name
            NSArray *localPeripherals = [self achieve:kSaveConnectedPeripheralsKey];
            if (localPeripherals) {
                NSMutableArray *tempArray = [NSMutableArray arrayWithArray:localPeripherals];
                NSMutableDictionary *tempDict = [NSMutableDictionary dictionary];
                [tempDict xf_safeSetObject:peripheral.name forKey:YSSavePeripheralNameKey];
                [tempDict xf_safeSetObject:[self identifierWithPeripheral:peripheral] forKey:YSSavePeripheralIdentifierKey];
                [tempArray xf_safeAddObject:[tempDict copy]];
                [self save:[tempArray copy] key:kSaveConnectedPeripheralsKey];
            }else {
                NSMutableArray *tempArray = [NSMutableArray array];
                NSMutableDictionary *tempDict = [NSMutableDictionary dictionary];
                [tempDict xf_safeSetObject:peripheral.name forKey:YSSavePeripheralNameKey];
                [tempDict xf_safeSetObject:[self identifierWithPeripheral:peripheral] forKey:YSSavePeripheralIdentifierKey];
                [tempArray xf_safeAddObject:[tempDict copy]];
                [self save:[tempArray copy] key:kSaveConnectedPeripheralsKey];
            }
            BLOCK_EXEC(self.connectResultCallback,YES);
            // 2s后开启  电话防盗命令
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                switch ([YSBluetoothDeviceManager teleLostMode]) {
                    case YSBluetoothSettingIsOff:
                    {
                        // 发送关闭电话防盗
                        // 关闭防盗功能
                        switch ([YSBluetoothDeviceManager currentOperateScene]) {
                            case YSBluetoothOperateSceneWithSeaching:
                            {
                                [[YSBluetoothDeviceManager sharedInstance] sendCloseLostModeWithTimeValue:1 strongValue:1];
                                [[YSBluetoothDeviceManager sharedInstance] pauseMassageWithStrong:1];
                            }
                                break;
                            case YSBluetoothOperateSceneWithConnecting:
                            {
                                [[YSBluetoothDeviceManager sharedInstance] sendCloseLostModeWithTimeValue:[YSBluetoothDeviceManager sharedInstance].massageTime strongValue:[YSBluetoothDeviceManager sharedInstance].massageStrength];
                            }
                            default:
                                break;
                        }
                    }
                        break;
                    default:
                    {
                        // 设置防盗功能
                        switch ([YSBluetoothDeviceManager currentOperateScene]) {
                            case YSBluetoothOperateSceneWithSeaching:
                            {
                                [[YSBluetoothDeviceManager sharedInstance] sendOpenLostModeWithTimeValue:1 strongValue:1];
                                [[YSBluetoothDeviceManager sharedInstance] pauseMassageWithStrong:1];
                            }
                                break;
                            case YSBluetoothOperateSceneWithConnecting:
                            {
                                [[YSBluetoothDeviceManager sharedInstance] sendOpenLostModeWithTimeValue:[YSBluetoothDeviceManager sharedInstance].massageTime strongValue:[YSBluetoothDeviceManager sharedInstance].massageStrength];
                            }
                            default:
                                break;
                        }
                    }
                        break;
                }
            });
        }];
        
        //设备连接失败的委托
        [_babyBluetooth setBlockOnFailToConnect:^(CBCentralManager *central, CBPeripheral *peripheral, NSError *error) {
            @strongify(self)
//            self.isConnecting = NO;
            [self showProgressViewWithText:@"连接失败！错误3002"];
            BLOCK_EXEC(self.connectResultCallback,NO);
            JGLog(@"设备：%@--连接失败",peripheral.name);
        }];
        
#pragma mark 外设蓝牙开启状态
        [_babyBluetooth setBlockOnCentralManagerDidUpdateState:^(CBCentralManager *central) {
            @strongify(self)
            if (central.state == CBCentralManagerStatePoweredOn) {
                if (self.isBluetoothOpen) {
                    // 无处理
                }else {
                    self.isBluetoothOpen = YES;
                    switch ([YSBluetoothDeviceManager currentOperateScene]) {
                        case YSBluetoothOperateSceneWithSeaching:
                        {
                            [[NSNotificationCenter defaultCenter] postNotificationName:YSReserchPeripheralKey object:nil];
                        }
                            break;
                        case YSBluetoothOperateSceneWithConnecting:
                        {
                            JGLog(@"---重新开启蓝牙，搜索之前设备");
                            [SVProgressHUD showInView:[[[UIApplication sharedApplication].keyWindow subviews] lastObject]];
                            [[YSBluetoothDeviceManager sharedInstance] beginSearch:^(NSArray *peripherals) {
                                NSArray *localPeripherals = [self achieve:kSaveConnectedPeripheralsKey];
                                if (localPeripherals.count) {
                                    NSDictionary *lastPeripheralDict = [localPeripherals lastObject];
                                    NSString *lastPeripheralName = lastPeripheralDict[YSSavePeripheralNameKey];
                                    BOOL exsit = NO;
                                    CBPeripheral *tempPeripheral = nil;
                                    for (CBPeripheral *scanPeripheral in peripherals) {
                                        if ([scanPeripheral.name isEqualToString:lastPeripheralName]) {
                                            exsit = YES;
                                            tempPeripheral = scanPeripheral;
                                            break;
                                        }
                                    }
                                    
                                    if (exsit) {
                                        JGLog(@"----查找到那个已经失去连接的设备，并开始连接");
                                        [SVProgressHUD dismiss];
                                        [[YSBluetoothDeviceManager sharedInstance] connectPeripheral:tempPeripheral result:^(BOOL result) {
                                            [[YSBluetoothDeviceManager sharedInstance] pauseMassageWithStrong:3];
                                            if (result) {
                                                [self showProgressViewWithText:@"连接成功"];
                                            }else {
                                                [self showProgressViewWithText:@"连接失败"];
                                            }
                                        }];
                                    }else {
                                        JGLog(@"-----为查找到之前的设备");
                                        [SVProgressHUD dismiss];
                                        [[NSNotificationCenter defaultCenter] postNotificationName:YSConncetingSceneBackLastSceneKey object:nil];
                                    }
                                }
                            }];
                        }
                            break;
                        default:
                            break;
                    }
                }
//                if ([YSBluetoothDeviceManager currentOperateScene] == YSBluetoothOperateSceneWithConnecting) {
//                    [self startAutoSearchAndConnect];
//                }
            } else {
                self.isBluetoothOpen = NO;
                JGLog(@"----warn:外设蓝牙关闭");
                self.isConnected = NO;
                [self disconnect];
                [self.babyBluetooth cancelAllPeripheralsConnection];
                [self.babyBluetooth AutoReconnectCancel:self.currentConnectedPeripheral];
                self.currentConnectedPeripheral = nil;
            }
        }];
        
#pragma mark 设置设备断开连接的委托
        [_babyBluetooth setBlockOnDisconnect:^(CBCentralManager *central, CBPeripheral *peripheral, NSError *error) {
            JGLog(@"设备：%@--断开连接",peripheral.name);
            @strongify(self)
            if (!peripheral.name) {
                return;
            }
            self.isConnected = NO;
            [self.babyBluetooth cancelScan];
            [self.babyBluetooth AutoReconnectCancel:self.currentConnectedPeripheral];
            [self.babyBluetooth cancelAllPeripheralsConnection];
            
            // 显示断开连接
            if ([self isConfigUnbindLoseConnect]) {
                // 解绑设备 断开 不要弹窗
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self configUnbindLoseConnect:NO];
                });
            }else {
                [self showAlertWhenPeripheralLoseConnect];
            }
//            [self startAutoSearchAndConnect];
        }];
        
        // 设置读取characteristics的委托
        [_babyBluetooth setBlockOnReadValueForCharacteristic:^(CBPeripheral *peripheral, CBCharacteristic *characteristic, NSError *error) {
            @strongify(self);
            // 保存读和写的char
            if (characteristic.properties == CBCharacteristicPropertyWrite) {
                self.charWrite = characteristic;
            } else {
                self.charRead = characteristic;
                NSString *value = [self convertDataToHexStr:characteristic.value];
                if ([value length] == 40) {
                    JGLog(@"读取到:%@", value);
                    NSString *battery = [self hexToBattery:[value substringWithRange:NSMakeRange(8, 2)]];
                    JGLog(@"当前电量：%@",battery);
                }
            }
        }];

        // 设置搜索设备规则
        [_babyBluetooth setFilterOnDiscoverPeripherals:^BOOL(NSString *peripheralName, NSDictionary *advertisementData, NSNumber *RSSI) {
            if ([peripheralName isEmpty] || !peripheralName.length) {
                return NO;
            }
            if ([peripheralName hasPrefix:@"XMLY"]) {
                return YES;
            }
            return NO;
        }];
        
        // 设置连接设备规则
        [_babyBluetooth setFilterOnConnectToPeripherals:^BOOL(NSString *peripheralName, NSDictionary *advertisementData, NSNumber *RSSI) {
            @strongify(self);
            if (self.isConnected) {
                if (![peripheralName hasPrefix:@"XMLY"]) {
                    return NO;
                }else {
                    return YES;
                }
            }else {
                return NO;
            }
        }];
    }
    return self;
}

- (void)showProgressViewWithText:(NSString *)text {
//    UIWindow *keyWindow = [[[UIApplication sharedApplication] delegate] window];
//    MBProgressHUD *hud = [MBProgressHUD HUDForView:[[keyWindow subviews] lastObject]];
//    hud.labelText = text;
//    [hud show:YES];
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [hud hide:YES];
//    });
    [FTToastIndicator setToastIndicatorStyle:UIBlurEffectStyleDark];
    [FTToastIndicator showToastMessage:text];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [FTToastIndicator dismiss];
    });
}

/**
 *  当蓝牙关闭后 */
- (void)showBluetoothOffAlertView {
    if (self.bluetoothOffAlertDidShow) {
        return;
    }
    self.bluetoothOffAlertDidShow = YES;
    UIViewController *tempController = [[UIViewController alloc] init];
    tempController.view.backgroundColor = JGClearColor;
    tempController.view.width = ScreenWidth;
    tempController.view.height = ScreenHeight;
    UIView *alertView = [self.alertViewConfig alertView:YSCustomAlertWithBluetoothOff extParams:nil];
    alertView.width = ScreenWidth - 70;
    alertView.height = 235.0;
    alertView.center = tempController.view.center;
    [tempController.view addSubview:alertView];
    self.bluetoothOffMenu.contentController = tempController;
    [self.bluetoothOffMenu showAlertWithDuration:0.45];
    [[NSNotificationCenter defaultCenter] postNotificationName:YSPeripheralLoseConnectKey object:nil];
}

#pragma mark  解绑设备
- (void)unbindDevice {
    [[YSBluetoothDeviceManager sharedInstance] pauseMassageWithStrong:1];
    [[YSBluetoothDeviceManager sharedInstance] disconnect];
    [self remove:kSaveConnectedPeripheralsKey];
    [self configUnbindLoseConnect:YES];
}

- (void)configUnbindLoseConnect:(BOOL)configTag {
    if (configTag) {
        [self save:@1 key:@"configUnbindConnect"];
    }else{
        [self save:@0 key:@"configUnbindConnect"];
    }
}

- (BOOL)isConfigUnbindLoseConnect {
    return [[self achieve:@"configUnbindConnect"] boolValue];
}

/**
 *  当设备失去连接后，弹框处理 */
- (void)showAlertWhenPeripheralLoseConnect {
    if (self.loseConnectAlertDidShow) {
        return;
    }
    UIViewController *tempController = [[UIViewController alloc] init];
    tempController.view.backgroundColor = JGClearColor;
    tempController.view.width = ScreenWidth;
    tempController.view.height = ScreenHeight;
    UIView *alertView = [self.alertViewConfig alertView:YSCustomAlertWithLoseConnect extParams:nil];
    alertView.width = ScreenWidth - 70;
    alertView.height = 235.0;
    alertView.center = tempController.view.center;
    [tempController.view addSubview:alertView];
    self.loseConnectMenu.contentController = tempController;
    [self.loseConnectMenu showAlertWithDuration:0.45];
    [[NSNotificationCenter defaultCenter] postNotificationName:YSPeripheralLoseConnectKey object:nil];
    self.loseConnectAlertDidShow = YES;
}

- (void)jumpBluetoothSetting:(NSNotification *)noti {
    [self.bluetoothOffMenu dismiss];
    self.bluetoothOffAlertDidShow = NO;
}

- (void)closeAlertWithLoseConnect {
    [self.loseConnectMenu dismiss];
    self.loseConnectAlertDidShow = NO;
    if ([YSBluetoothDeviceManager currentOperateScene] == YSBluetoothOperateSceneWithConnecting) {
        [[NSNotificationCenter defaultCenter] postNotificationName:YSBackSearchingSceneAndUploadMassageTimeKey object:nil];
    }
}

- (void)loseConnect:(NSNotification *)notification {
    [self.loseConnectMenu dismiss];
    self.loseConnectAlertDidShow = NO;
    if (self.isBluetoothOpen) {
        // 蓝牙打开重新搜索
        switch ([YSBluetoothDeviceManager currentOperateScene]) {
            case YSBluetoothOperateSceneWithSeaching:
            {
                // 搜索设备页面
                JGLog(@"----warn:搜索设备页面--重新搜索");
                [[NSNotificationCenter defaultCenter] postNotificationName:YSLostConnectToResearchPeripheralKey object:nil];
            }
                break;
            case YSBluetoothOperateSceneWithConnecting:
            {
                // 设备连接页面
                JGLog(@"----warn:设备连接页面 需要重返到搜索页面");
                [[NSNotificationCenter defaultCenter] postNotificationName:YSLostConnectBackToResearchPeripheralKey object:nil];
            }
                break;
            case YSBluetoothOperateSceneWithElse:
            {
                
            }
                break;
            default:
                break;
        }
    }else {
        // 蓝牙未打开
        [self showBluetoothOffAlertView];
    }
}

- (void)startup {
    
}

#pragma mark 发送震动指令
- (void)sendShakeOrderWithTimeValue:(NSInteger)timeValue strongValue:(NSInteger)strongValue phoneLostMode:(BOOL)lostMode {
    NSString *cmd = [NSString stringWithFormat:@"AA%@%@00%@0000000055", [self ToHex:timeValue], [self ToHex:strongValue], [self ToHex:(lostMode)? 1 : 0]];
    [self writeToBluetoothWithValue:cmd];
}

#pragma mark 发送来电提醒指令
- (void)sendCallComingOrderWithTimeValue:(NSInteger)timeValue strongValue:(NSInteger)strongValue phoneLost:(BOOL)phoneLost {
    if (![YSBluetoothDeviceManager sharedInstance].isConnected) {
        return;
    }
    BOOL isOpenLoseMode = NO;
    switch ([YSBluetoothDeviceManager teleLostMode]) {
        case YSBluetoothSettingIsOff:
            isOpenLoseMode = NO;
            break;
        default:
            isOpenLoseMode = YES;
            break;
    }
    NSString *cmd = [NSString stringWithFormat:@"AA%@%@01%@0100000055", [self ToHex:timeValue], [self ToHex:strongValue], [self ToHex:isOpenLoseMode ? 1 : 0]];
    [self writeToBluetoothWithValue:cmd];
}

#pragma mark 打开防丢开关
- (void)sendOpenLostModeWithTimeValue:(NSInteger)timeValue strongValue:(NSInteger)strongValue {
    if (![YSBluetoothDeviceManager sharedInstance].isConnected) {
        return;
    }
    NSString *cmd = [NSString stringWithFormat:@"AA%@%@00010000000055", [self ToHex:timeValue], [self ToHex:strongValue]];
    [self writeToBluetoothWithValue:cmd];
}

#pragma mark 关闭防丢开关
- (void)sendCloseLostModeWithTimeValue:(NSInteger)timeValue strongValue:(NSInteger)strongValue {
    if (![YSBluetoothDeviceManager sharedInstance].isConnected) {
        return;
    }
    NSString *cmd = [NSString stringWithFormat:@"AA%@%@00000000000055",[self ToHex:timeValue],[self ToHex:strongValue]];
    [self writeToBluetoothWithValue:cmd];
}

- (void)pauseMassageWithStrong:(NSInteger)strongValue {
    [self sendShakeOrderWithTimeValue:0 strongValue:strongValue phoneLostMode:[YSBluetoothDeviceManager teleLostMode]];
}

#pragma mark  配置用户界面操作
+ (void)configOperateScene:(YSBluetoothOperateScene)operateScene {
    [self save:[NSNumber numberWithInteger:operateScene] key:kOperateSceneKey];
}

+ (YSBluetoothOperateScene)currentOperateScene {
    return [[self achieve:kOperateSceneKey] integerValue];
}

+ (void)configTeleRemind:(YSBluetoothDefaultSettingState)isRemind {
    [self save:[NSNumber numberWithInteger:isRemind] key:kConfigTeleRemindkey];
}

+ (YSBluetoothDefaultSettingState)teleRemind {
    return [[self achieve:kConfigTeleRemindkey] integerValue];
}

+ (void)configTeleLostMode:(YSBluetoothDefaultSettingState)isLost {
    [self save:[NSNumber numberWithInteger:isLost] key:kConfigTeleLostKey];
}

+(YSBluetoothDefaultSettingState)teleLostMode {
    return [[self achieve:kConfigTeleLostKey] integerValue];
}

#pragma 搜索蓝牙设备-----
- (void)beginSearch:(void (^)(NSArray *peripherals))result {
    /**
     *  清空数据 */
    self.isCancelScan = NO;
    [self.terminalPeripheralsArray removeAllObjects];
    [self.terminalNamesArray removeAllObjects];
    [self.peripheralIdentifierArray removeAllObjects];
    // 设置回调
    self.didSearchDeviceCallback = result;
    NSTimeInterval searchTime = 20;
    [self.searchDeviceTimer invalidate];
    self.searchDeviceTimer = nil;
    self.babyBluetooth.scanForPeripherals().begin().stop(searchTime);
    self.searchTime = 0;
    self.searchDeviceTimer = [MSWeakTimer scheduledTimerWithTimeInterval:1
                                                      target:self
                                                    selector:@selector(searchDeviceCountdown:)
                                                    userInfo:nil
                                                     repeats:YES
                                               dispatchQueue:dispatch_get_main_queue()];
}

- (void)searchDeviceCountdown:(MSWeakTimer *)timer {
    self.searchTime += 1;
    JGLog(@"---searchTime:%ld",self.searchTime);
    if (self.searchTime >= 20) {
        if (self.terminalNamesArray.count && self.terminalPeripheralsArray.count && self.peripheralIdentifierArray.count) {
            // 已经发现设备
            [self invalidateSearchTimer];
        }else {
            // 未发现可用设备
            [self invalidateSearchTimer];
            BLOCK_EXEC(self.didSearchDeviceCallback,@[]);
        }
    }
}

// 置空搜索蓝牙设备定时器
- (void)invalidateSearchTimer {
    [self.searchDeviceTimer invalidate];
    self.searchDeviceTimer = nil;
}

#pragma mark  连接蓝牙设备----
- (void)connectPeripheral:(CBPeripheral *)peripheral result:(bool_block_t)connectResultCallback {
    if (!peripheral) {
        return;
    }
//    if (self.isConnecting) {
//        return;
//    }
//    self.isConnecting = YES;
    if (peripheral.state == CBPeripheralStateDisconnected) {
        self.connectResultCallback = connectResultCallback;
        self.babyBluetooth.having(peripheral).connectToPeripherals().discoverServices().discoverCharacteristics()
        .readValueForCharacteristic().discoverDescriptorsForCharacteristic().readValueForDescriptors().begin();
    }
}

// 开始搜索自动连接
- (void)startAutoSearchAndConnect {
    
//    if (SEEKPLISTTHING(UD_BluetoothMac)) {
//        self.babyBluetooth.scanForPeripherals().connectToPeripherals().discoverServices().discoverCharacteristics()
//        .readValueForCharacteristic().discoverDescriptorsForCharacteristic().readValueForDescriptors().begin();
//    }
}

#pragma mark 断开设备---
- (void)disconnect {
    self.isConnected = NO;
    [self.babyBluetooth AutoReconnectCancel:self.currentConnectedPeripheral];
    self.currentConnectedPeripheral = nil;
    [self.babyBluetooth cancelScan];
    [self.babyBluetooth cancelAllPeripheralsConnection];
}

- (void)setIsConnected:(BOOL)isConnected {
    _isConnected = isConnected;
}

#pragma mark  ---成功连接到蓝牙设备后停止搜索设备
- (void)stopScanBluetooth {
    self.isCancelScan = YES;
    [self.babyBluetooth cancelScan];
    [self.searchDeviceTimer invalidate];
    self.searchDeviceTimer = nil;
}

#pragma mark 打开防丢开关---
- (void)openPhoneLostCmdWithStrong:(int)strongValue {
    if (!self.isConnected) {
        JGLog(@"openPhoneLostCmdWithStrong -- isConnected  is nil");
        return;
    }
    NSString *cmd = [NSString stringWithFormat:@"AA%@%@00010000000055", [self ToHex:10], [self ToHex:strongValue]];
    JGLog(@"---发送指令：%@", cmd);
    [self writeToBluetoothWithValue:cmd];
}

// 关闭防丢开关
- (void)closePhoneLostCmd {
    if (!self.isConnected) {
        JGLog(@"closePhoneLostCmd -- isConnected  is nil");
        return;
    }
    NSString *cmd = [NSString stringWithFormat:@"AA%@%@00000000000055",[self ToHex:10],[self ToHex:6]];
    NSLog(@"发送指令：%@", cmd);
    [self writeToBluetoothWithValue:cmd];
}


#pragma mark  private method
- (NSString *)ToHex:(long long int) num
{
    NSString * result = [NSString stringWithFormat:@"0%llx",num];
    return [result uppercaseString];
}

// 写数据
- (void)writeToBluetoothWithValue:(NSString *)value {
    if (self.charWrite == nil) {
        JGLog(@"输出为Nil");
        return;
    }
    
    if (!self.currentConnectedPeripheral) {
        JGLog(@"currentConnectedPeripheral is nil");
    }
    
    NSData *data = [self convertHexStrToData:value];
    [self.currentConnectedPeripheral writeValue:data forCharacteristic:self.charWrite type:CBCharacteristicWriteWithResponse];
}

- (NSData *)convertHexStrToData:(NSString *)str {
    if (!str || [str length] == 0) {
        return nil;
    }
    
    NSMutableData *hexData = [[NSMutableData alloc] initWithCapacity:8];
    NSRange range;
    if ([str length] % 2 == 0) {
        range = NSMakeRange(0, 2);
    } else {
        range = NSMakeRange(0, 1);
    }
    for (NSInteger i = range.location; i < [str length]; i += 2) {
        unsigned int anInt;
        NSString *hexCharStr = [str substringWithRange:range];
        NSScanner *scanner = [[NSScanner alloc] initWithString:hexCharStr];
        
        [scanner scanHexInt:&anInt];
        NSData *entity = [[NSData alloc] initWithBytes:&anInt length:1];
        [hexData appendData:entity];
        
        range.location += range.length;
        range.length = 2;
    }
    return hexData;
}
- (NSString *)convertDataToHexStr:(NSData *)data {
    if (!data || [data length] == 0) {
        return @"";
    }
    NSMutableString *string = [[NSMutableString alloc] initWithCapacity:[data length]];
    
    [data enumerateByteRangesUsingBlock:^(const void *bytes, NSRange byteRange, BOOL *stop) {
        unsigned char *dataBytes = (unsigned char*)bytes;
        for (NSInteger i = 0; i < byteRange.length; i++) {
            NSString *hexStr = [NSString stringWithFormat:@"%x", (dataBytes[i]) & 0xff];
            if ([hexStr length] == 2) {
                [string appendString:hexStr];
            } else {
                [string appendFormat:@"0%@", hexStr];
            }
        }
    }];
    return string;
}

- (NSString *)hexToBattery:(NSString *)result {
    NSString * temp10 = [NSString stringWithFormat:@"%lu",strtoul([result UTF8String],0,16)];
    //转成数字
    int cycleNumber = [temp10 intValue];
    int battery = cycleNumber * 100 / 100.0;
    if (battery >= 100) {
        battery = 100;
    }
    return [NSString stringWithFormat:@"电量：%d%%", battery];
}

- (void)alertView:(UIView *)alertView extMsgCode:(YSCustomAlertCallbackCode)extMsgCode {
    
}

- (NSString *)identifierWithPeripheral:(CBPeripheral *)peripheral {
    return [peripheral.identifier description];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
