//
//  YSCustomAlertView.m
//  jingGang
//
//  Created by dengxf on 17/6/26.
//  Copyright © 2017年 dengxf_dev. All rights reserved.
//

#import "YSCustomAlertViewConfig.h"
#import "GlobeObject.h"
#import "YSConnectDeviceCell.h"
#import "YSMassageBraMacro.h"

#define AlertCallback(x) [NSNumber numberWithInteger:x]

#pragma mark 解绑设备
@implementation YSUnbindDeviceAlertView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.layer.cornerRadius = 6;
        self.backgroundColor = JGWhiteColor;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    UIImageView *iconImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ys_device_personal_unbindicon"]];
    iconImageView.y = 36.;
    iconImageView.width = 140;
    iconImageView.height = 42;
    iconImageView.x = (self.width - iconImageView.width) / 2;
    [self addSubview:iconImageView];
    
    CGFloat closeButtonWidth = 14.;
    CGFloat closeButtonHeight = 15.;
    CGFloat closeButtonx = self.width - closeButtonWidth - 14.;
    CGFloat closeButtony = 14.;
    JGTouchEdgeInsetsButton *closeButton = [JGTouchEdgeInsetsButton buttonWithType:UIButtonTypeCustom];
    closeButton.frame = CGRectMake(closeButtonx, closeButtony, closeButtonWidth, closeButtonHeight);
    [closeButton setImage:[UIImage imageNamed:@"ys_personal_device_alertclose"] forState:UIControlStateNormal];
    closeButton.touchEdgeInsets = UIEdgeInsetsMake(-6, -6, -6, -6);
    [self addSubview:closeButton];
    [closeButton addTarget:self action:@selector(closeButtonClickAction) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *textLab = [UILabel new];
    textLab.x = 24.;
    textLab.y = MaxY(iconImageView) + 24;
    textLab.width = self.width - textLab.x *2;
    textLab.height = 44.;
    textLab.textAlignment = NSTextAlignmentCenter;
    textLab.textColor = [UIColor colorWithHexString:@"#4a4a4a"];
    textLab.numberOfLines = 0;
    UIFont *font ;
    if (iPhone4 || iPhone5) {
        textLab.numberOfLines = 2;
    }
    font = YSPingFangRegular(14);
    textLab.font = font;
    textLab.text = @"确定解绑该设备吗？解绑之后再使用需要重新绑定哦！";
    [self addSubview:textLab];
    
    UIButton *sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
    sureButton.x = 36.;
    sureButton.y = MaxY(textLab) + 24;
    sureButton.width = self.width - sureButton.x  * 2;
    sureButton.height = 38;
    sureButton.layer.cornerRadius = sureButton.height / 2 - 3;
    sureButton.clipsToBounds = YES;
    sureButton.backgroundColor = [YSThemeManager buttonBgColor];
    [sureButton setTitle:@"确定" forState:UIControlStateNormal];
    [sureButton setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
    sureButton.titleLabel.font = YSPingFangRegular(14);
    [sureButton addTarget:self action:@selector(unbindButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:sureButton];
}

- (void)closeButtonClickAction {
    BLOCK_EXEC(self.unbindButtonClick,AlertCallback(YSCustomAlertCallbackCloseUnbindAlert));
}

- (void)unbindButtonAction:(UIButton *)button {
    BLOCK_EXEC(self.unbindButtonClick,AlertCallback(YSCustomAlertCallbackUnbindDevice));
}

@end

#pragma mark 外设蓝牙未打开
@implementation YSBluetoothOffAlertView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.layer.cornerRadius = 6;
        self.backgroundColor = JGWhiteColor;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    UIImageView *iconImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ys_personal_device_bluetoothoff"]];
    iconImageView.y = 36.;
    iconImageView.width = 52;
    iconImageView.height = 52;
    iconImageView.x = (self.width - iconImageView.width) / 2;
    [self addSubview:iconImageView];
    
    UILabel *textLab = [UILabel new];
    textLab.x = 24.;
    textLab.y = MaxY(iconImageView) + 24;
    textLab.width = self.width - textLab.x *2;
    textLab.height = 44.;
    textLab.textAlignment = NSTextAlignmentCenter;
    textLab.textColor = [UIColor colorWithHexString:@"#4a4a4a"];
    textLab.numberOfLines = 1;
    UIFont *font ;
    if (iPhone4 || iPhone5) {
        textLab.numberOfLines = 2;
    }
    font = YSPingFangRegular(14);
    textLab.font = font;
    textLab.text = @"您的蓝牙未开启哦！请先开启蓝牙！";
    [self addSubview:textLab];
    
    UIButton *openBluetoothButton = [UIButton buttonWithType:UIButtonTypeCustom];
    openBluetoothButton.x = 36.;
    openBluetoothButton.y = MaxY(textLab) + 24;
    openBluetoothButton.width = self.width - openBluetoothButton.x  * 2;
    openBluetoothButton.height = 38;
    openBluetoothButton.layer.cornerRadius = openBluetoothButton.height / 2 - 3;
    openBluetoothButton.clipsToBounds = YES;
    openBluetoothButton.backgroundColor = [YSThemeManager buttonBgColor];
    [openBluetoothButton setTitle:@"立刻开启" forState:UIControlStateNormal];
    [openBluetoothButton setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
    openBluetoothButton.titleLabel.font = YSPingFangRegular(14);
    [openBluetoothButton addTarget:self action:@selector(openBluetoothButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:openBluetoothButton];
    
    CGFloat closeButtonWidth = 14.;
    CGFloat closeButtonHeight = 15.;
    CGFloat closeButtonx = self.width - closeButtonWidth - 14.;
    CGFloat closeButtony = 14.;
    JGTouchEdgeInsetsButton *closeButton = [JGTouchEdgeInsetsButton buttonWithType:UIButtonTypeCustom];
    closeButton.frame = CGRectMake(closeButtonx, closeButtony, closeButtonWidth, closeButtonHeight);
    [closeButton setImage:[UIImage imageNamed:@"ys_personal_device_alertclose"] forState:UIControlStateNormal];
    closeButton.touchEdgeInsets = UIEdgeInsetsMake(-6, -6, -6, -6);
    [self addSubview:closeButton];
    [closeButton addTarget:self action:@selector(closeButtonClickAction) forControlEvents:UIControlEventTouchUpInside];
}

- (void)closeButtonClickAction {
    [[NSNotificationCenter defaultCenter] postNotificationName:YSJumpBluetoothSettingKey object:nil];
}

- (void)openBluetoothButtonAction:(UIButton *)button {

//    //将字符串转换为16进制
//    NSData *encryptString = [[NSData alloc] initWithBytes:(unsigned char []){0x70,0x72,0x65,0x66,0x73,0x3a,0x72,0x6f,0x6f,0x74,0x3d,0x4e,0x4f,0x54,0x49,0x46,0x49,0x43,0x41,0x54,0x49,0x4f,0x4e,0x53,0x5f,0x49,0x44} length:27];
//
//    NSString *string = [[NSString alloc] initWithData:encryptString encoding:NSUTF8StringEncoding];
//    NSURL *url=[NSURL URLWithString:string];
//
////    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:string] options:@{} completionHandler:nil];
//
//    if ([[UIApplication sharedApplication] canOpenURL:url])
//    {
//        [[UIApplication sharedApplication] openURL:url];
//    }
//    [[NSNotificationCenter defaultCenter] postNotificationName:YSJumpBluetoothSettingKey object:nil];
}

@end


#pragma mark 断开连接
@implementation YSLoseConnectAlertView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.layer.cornerRadius = 6;
        self.backgroundColor = JGWhiteColor;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    UIImageView *iconImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ys_peronal_device_loseconnect"]];
    iconImageView.y = 36.;
    iconImageView.width = 140;
    iconImageView.height = 42;
    iconImageView.x = (self.width - iconImageView.width) / 2;
    [self addSubview:iconImageView];
    
    UILabel *textLab = [UILabel new];
    textLab.x = 24.;
    textLab.y = MaxY(iconImageView) + 24;
    textLab.width = self.width - textLab.x *2;
    textLab.height = 44.;
    textLab.textAlignment = NSTextAlignmentCenter;
    textLab.textColor = [UIColor colorWithHexString:@"#4a4a4a"];
    if (iPhone5 || iPhone4) {
        textLab.font = JGRegularFont(12);
    }else {
        textLab.font = YSPingFangRegular(14);
    }
    textLab.text = @"蓝牙君突然与您的设备失去了联系,需要您重新连接啦!";
    textLab.numberOfLines = 0;
    [self addSubview:textLab];
    
    UIButton *reconnectButton = [UIButton buttonWithType:UIButtonTypeCustom];
    reconnectButton.x = 36.;
    reconnectButton.y = MaxY(textLab) + 24;
    reconnectButton.width = self.width - reconnectButton.x  * 2;
    reconnectButton.height = 38;
    reconnectButton.layer.cornerRadius = reconnectButton.height / 2 - 3;
    reconnectButton.clipsToBounds = YES;
    reconnectButton.backgroundColor = [YSThemeManager buttonBgColor];
    [reconnectButton setTitle:@"重新连接" forState:UIControlStateNormal];
    [reconnectButton setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
    reconnectButton.titleLabel.font = YSPingFangRegular(14);
    [reconnectButton addTarget:self action:@selector(reconnectButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:reconnectButton];
    
    CGFloat closeButtonWidth = 14.;
    CGFloat closeButtonHeight = 15.;
    CGFloat closeButtonx = self.width - closeButtonWidth - 14.;
    CGFloat closeButtony = 14.;
    JGTouchEdgeInsetsButton *closeButton = [JGTouchEdgeInsetsButton buttonWithType:UIButtonTypeCustom];
    closeButton.frame = CGRectMake(closeButtonx, closeButtony, closeButtonWidth, closeButtonHeight);
    [closeButton setImage:[UIImage imageNamed:@"ys_personal_device_alertclose"] forState:UIControlStateNormal];
    closeButton.touchEdgeInsets = UIEdgeInsetsMake(-6, -6, -6, -6);
    [self addSubview:closeButton];
    [closeButton addTarget:self action:@selector(closeButtonClickAction) forControlEvents:UIControlEventTouchUpInside];
}

- (void)closeButtonClickAction {
    BLOCK_EXEC(self.closeWithLoseConnectCallback);
}

- (void)reconnectButtonAction:(UIButton *)button {
    BLOCK_EXEC(self.reconnectCallback,[NSNumber numberWithInteger:YSCustomAlertCallbackLoseConnect]);
}

@end

#pragma mark 设置来电提醒后 终端按摩
@implementation YSTeleComingMassageBreakAlertView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.layer.cornerRadius = 6;
        self.backgroundColor = JGWhiteColor;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    UIImageView *iconImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ys_personal_device_searchnone"]];
    iconImageView.y = 36.;
    iconImageView.width = 140;
    iconImageView.height = 42;
    iconImageView.x = (self.width - iconImageView.width) / 2;
    [self addSubview:iconImageView];
    
    UILabel *textLab = [UILabel new];
    textLab.x = 24.;
    textLab.y = MaxY(iconImageView) + 24;
    textLab.width = self.width - textLab.x *2;
    textLab.height = 44.;
    textLab.textAlignment = NSTextAlignmentCenter;
    textLab.textColor = [UIColor colorWithHexString:@"#4a4a4a"];
    if (iPhone4 || iPhone5) {
        textLab.font = JGRegularFont(13);
    }else {
        textLab.font = YSPingFangRegular(14);
    }
    textLab.text = @"主人,您的按摩因为来电提醒中断了哦,赶紧继续吧!";
    textLab.numberOfLines = 0;
    [self addSubview:textLab];
    
    UIButton *continueButton = [UIButton buttonWithType:UIButtonTypeCustom];
    continueButton.x = 36.;
    continueButton.y = MaxY(textLab) + 24;
    continueButton.width = self.width - continueButton.x  * 2;
    continueButton.height = 38;
    continueButton.layer.cornerRadius = continueButton.height / 2 - 3;
    continueButton.clipsToBounds = YES;
    continueButton.backgroundColor = [YSThemeManager buttonBgColor];
    [continueButton setTitle:@"继续" forState:UIControlStateNormal];
    [continueButton setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
    continueButton.titleLabel.font = YSPingFangRegular(14);
    [continueButton addTarget:self action:@selector(continueButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:continueButton];
}

- (void)continueButtonAction:(UIButton *)button {
    BLOCK_EXEC(self.breakCallback,[NSNumber numberWithInteger:YSCustomAlertCallbackTeleComingBreak]);
}

@end

@interface YSMassageCompletedAlertView ()


@property (copy , nonatomic) NSString *successText;

@end

#pragma mark 按摩完成
@implementation YSMassageCompletedAlertView

- (instancetype)initWithSuccessText:(NSString *)text
{
    self = [super init];
    if (self) {
        _successText = text;
        self.layer.cornerRadius = 6;
        self.backgroundColor = JGWhiteColor;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    UIImageView *iconImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ys_personal_device_completeicon"]];
    iconImageView.y = 36.;
    iconImageView.width = 135;
    iconImageView.height = 60;
    iconImageView.x = (self.width - iconImageView.width) / 2;
    [self addSubview:iconImageView];
    
    UILabel *textLab = [UILabel new];
    textLab.x = 16.;
    textLab.y = MaxY(iconImageView) + 24;
    textLab.width = self.width - textLab.x *2;
    textLab.height = 44.;
    textLab.textAlignment = NSTextAlignmentCenter;
    textLab.textColor = [UIColor colorWithHexString:@"#4a4a4a"];
    if (iPhone5 || iPhone4) {
        textLab.font = YSPingFangRegular(11);
        textLab.height += 20.;
    }else {
        textLab.font = YSPingFangRegular(14);
    }
    textLab.numberOfLines = 0;
    textLab.text = self.successText;
    [self addSubview:textLab];
    
    UIButton *completeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    completeButton.x = 36.;
    completeButton.y = MaxY(textLab) + 24;
    completeButton.width = self.width - completeButton.x  * 2;
    completeButton.height = 38;
    completeButton.layer.cornerRadius = completeButton.height / 2 - 3;
    completeButton.clipsToBounds = YES;
    completeButton.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
    [completeButton setTitle:@"查看我的成果" forState:UIControlStateNormal];
    [completeButton setTitleColor:[YSThemeManager buttonBgColor] forState:UIControlStateNormal];
    completeButton.titleLabel.font = YSPingFangRegular(14);
    completeButton.layer.borderWidth = 0.8;
    completeButton.layer.borderColor = [YSThemeManager buttonBgColor].CGColor;
    [completeButton addTarget:self action:@selector(completeButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:completeButton];
}

- (void)completeButtonAction:(UIButton *)button {
    BLOCK_EXEC(self.completeCallback,[NSNumber numberWithInteger:YSCustomAlertCallbackComplete]);
}

@end

#pragma mark  点击结束按摩
@interface YSMassageEndAlertView ()

@end

@implementation YSMassageEndAlertView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.layer.cornerRadius = 6;
        self.backgroundColor = JGWhiteColor;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    UIImageView *iconImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ys_personal_device_endicon"]];
    iconImageView.width = 50;
    iconImageView.height = 50.;
    iconImageView.x = (self.width - iconImageView.width) / 2.;
    iconImageView.y = 35.;
    [self addSubview:iconImageView];
    
    UILabel *textLab = [UILabel new];
    textLab.x = 24.;
    textLab.y = MaxY(iconImageView) + 24;
    textLab.width = self.width - textLab.x *2;
    textLab.height = 44.;
    textLab.textAlignment = NSTextAlignmentCenter;
    textLab.textColor = [UIColor colorWithHexString:@"#4a4a4a"];
    textLab.font = YSPingFangRegular(14);
    textLab.text = @"您确定结束按摩吗？再坚持一小步，就能向美丽迈进一大步！";
    textLab.numberOfLines = 0;
    [self addSubview:textLab];
    
    UIButton *continueButton = [UIButton buttonWithType:UIButtonTypeCustom];
    continueButton.x = 36.;
    continueButton.y = MaxY(textLab) + 24;
    continueButton.width = self.width - continueButton.x  * 2;
    continueButton.height = 38;
    continueButton.layer.cornerRadius = continueButton.height / 2 - 3;
    continueButton.clipsToBounds = YES;
    continueButton.backgroundColor = [YSThemeManager buttonBgColor];
    [continueButton setTitle:@"继续" forState:UIControlStateNormal];
    [continueButton setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
    continueButton.titleLabel.font = YSPingFangRegular(14);
    [continueButton addTarget:self action:@selector(continueButtonClickAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:continueButton];
    
    UIButton *endButton = [UIButton buttonWithType:UIButtonTypeCustom];
    endButton.frame = continueButton.frame;
    endButton.y = MaxY(continueButton) + 16.;
    endButton.layer.cornerRadius = continueButton.layer.cornerRadius;
    endButton.clipsToBounds = YES;
    endButton.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
    [endButton setTitleColor:[YSThemeManager themeColor] forState:UIControlStateNormal];
    endButton.titleLabel.font = continueButton.titleLabel.font;
    [endButton setTitle:@"结束" forState:UIControlStateNormal];
    endButton.layer.borderWidth = 0.8;
    endButton.layer.borderColor = [YSThemeManager buttonBgColor].CGColor;
    [endButton addTarget:self action:@selector(endButtonClickAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:endButton];
}

- (void)continueButtonClickAction:(UIButton *)button {
    BLOCK_EXEC(self.endButtonClickCallback,[NSNumber numberWithInteger:YSCustomAlertEndWithContinue]);
}

- (void)endButtonClickAction:(UIButton *)button {
    BLOCK_EXEC(self.endButtonClickCallback,[NSNumber numberWithInteger:YSCustomAlertEndWithEnd]);
}
@end

#pragma mark --连接蓝牙设备列表
@interface YSConnectDevicesListView ()<UITableViewDelegate,UITableViewDataSource>

@property (strong,nonatomic) UIImageView *bluetoothIcon;

@property (strong,nonatomic) UIImageView *deviceIcon;

@property (strong,nonatomic) UILabel *titleLab;

@property (strong,nonatomic) UIImageView *progressImageView;

@property (strong,nonatomic) NSMutableArray *peripherals;

@property (strong,nonatomic) UITableView *devicesListTableView;

@property (strong,nonatomic) CBPeripheral *peripheral;

@end

@implementation YSConnectDevicesListView

- (instancetype)initWithPeripherals:(NSArray *)peripherals
{
    self = [super init];
    if (self) {
        _peripherals = [NSMutableArray arrayWithArray:peripherals];
        self.layer.cornerRadius = 6;
        self.backgroundColor = JGWhiteColor;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updatePeripherals:) name:YSUpdateSearchPeriperalsKey object:nil];
    }
    return self;
}

- (void)updatePeripherals:(NSNotification *)noti {
    if ([noti.object isKindOfClass:[NSArray class]] || [noti.object isKindOfClass:[NSMutableArray class]] ) {
        NSArray *temps =  [YSCustomAlertViewConfig recombineDevicesList:(NSArray *)noti.object];
        [self.peripherals removeAllObjects];
        [self.peripherals xf_safeAddObjectsFromArray:temps];
        [self.devicesListTableView reloadData];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat bluetoothIconWidth = 42;
    CGFloat bluetoothIconHeight = 42;
    CGFloat bluetoothx = self.width / 2 - 64;
    CGFloat bluetoothy = 36;
    if (self.bluetoothIcon) {
        self.bluetoothIcon.width = bluetoothIconWidth;
        self.bluetoothIcon.height = bluetoothIconHeight;
        self.bluetoothIcon.x = bluetoothx;
        self.bluetoothIcon.y = bluetoothy;
    }else {
        UIImageView *bluetoothIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ys_personal_device_bluetoothicon"]];
        bluetoothIcon.width = bluetoothIconWidth;
        bluetoothIcon.height = bluetoothIconHeight;
        bluetoothIcon.x = bluetoothx;
        bluetoothIcon.y = bluetoothy;
        [self addSubview:bluetoothIcon];
        self.bluetoothIcon = bluetoothIcon;
    }
    
    CGFloat progressImageWidth = 26.;
    CGFloat progressImageHeight  = 5.;
    CGFloat progressImagex = (self.width - progressImageWidth) / 2;
    CGFloat progressImagey = self.bluetoothIcon.y + (bluetoothIconHeight - progressImageHeight) / 2;
    
    NSArray * images = @[[UIImage imageNamed:@"ys_personal_device_search_01"],[UIImage imageNamed:@"ys_personal_device_search_02"],[UIImage imageNamed:@"ys_personal_device_search_03"],[UIImage imageNamed:@"ys_personal_device_search_04"]];
    
    if (self.progressImageView) {
        self.progressImageView.frame = CGRectMake(progressImagex, progressImagey, progressImageWidth, progressImageHeight);
    }else {
        UIImageView *progressImageView = [[UIImageView alloc] initWithFrame:CGRectMake(progressImagex, progressImagey, progressImageWidth, progressImageHeight)];
        [self addSubview:progressImageView];
        self.progressImageView = progressImageView;
    }
    [self.progressImageView setAnimationImages:images];
    [self.progressImageView setAnimationDuration:0.8];
    self.progressImageView.animationRepeatCount = 0;
    if (self.progressImageView.isAnimating) {
        
    }else {
        [self.progressImageView startAnimating];
    }
    
    CGFloat deviceIconWidth = 34.;
    CGFloat deviceIconHeight= 34.;
    CGFloat deviceIconx = self.width / 2 + 44;
    CGFloat deviceIcony = 36.5;
    if (self.deviceIcon) {
        self.deviceIcon.width = deviceIconWidth;
        self.deviceIcon.height = deviceIconHeight;
        self.deviceIcon.x = deviceIconx;
        self.deviceIcon.y = deviceIcony;
    }else {
        UIImageView *deviceIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ys_personal_deveice_deviceicon"]];
        deviceIcon.width = deviceIconWidth;
        deviceIcon.height = deviceIconHeight;
        deviceIcon.x = deviceIconx;
        deviceIcon.y = deviceIcony;
        [self addSubview:deviceIcon];
        self.deviceIcon = deviceIcon;
    }
    
    CGFloat titlex = 0.;
    CGFloat titley = MaxY(self.deviceIcon) + 24;
    CGFloat titleWidth = self.width;
    CGFloat titleHeight = 17.;
    
    if (self.titleLab) {
        self.titleLab.x = titlex;
        self.titleLab.y = titley;
        self.titleLab.width = titleWidth;
        self.titleLab.height = titleHeight;
    }else {
        UILabel *titleLab = [UILabel new];
        titleLab.x = titlex;
        titleLab.y = titley;
        titleLab.width = titleWidth;
        titleLab.height = titleHeight;
        titleLab.textAlignment = NSTextAlignmentCenter;
        titleLab.text = @"请选择您要连接的设备";
        titleLab.font = JGRegularFont(15);
        titleLab.textColor = [UIColor colorWithHexString:@"#4a4a4a" alpha:1];
        [self addSubview:titleLab];
        self.titleLab = titleLab;
    }
    
    CGFloat listx = 0.;
    CGFloat listy = MaxY(self.titleLab) + 20.;
    CGFloat listWidth = self.width;
    CGFloat listHeight = self.height - listy;
    if (self.devicesListTableView) {
        self.devicesListTableView.frame = CGRectMake(listx, listy, listWidth, listHeight);
    }else {
        UITableView *devicesListTableView = [[UITableView alloc] initWithFrame:CGRectMake(listx, listy, listWidth, listHeight) style:UITableViewStylePlain];
        devicesListTableView.tableFooterView = [UIView new];
        devicesListTableView.rowHeight = 48.;
        devicesListTableView.delegate = self;
        devicesListTableView.dataSource = self;
        devicesListTableView.layer.cornerRadius = 6.;
        devicesListTableView.clipsToBounds = YES;
        devicesListTableView.backgroundColor = JGColor(245, 245, 245, 1);
        [devicesListTableView  setSeparatorColor:[JGBaseColor colorWithAlphaComponent:0.0]];
        [self addSubview:devicesListTableView];
        self.devicesListTableView = devicesListTableView;
    }
    
    CGFloat closeButtonWidth = 14.;
    CGFloat closeButtonHeight = 15.;
    CGFloat closeButtonx = self.width - closeButtonWidth - 14.;
    CGFloat closeButtony = 14.;
    JGTouchEdgeInsetsButton *closeButton = [JGTouchEdgeInsetsButton buttonWithType:UIButtonTypeCustom];
    closeButton.frame = CGRectMake(closeButtonx, closeButtony, closeButtonWidth, closeButtonHeight);
    [closeButton setImage:[UIImage imageNamed:@"ys_personal_device_alertclose"] forState:UIControlStateNormal];
    closeButton.touchEdgeInsets = UIEdgeInsetsMake(-6, -6, -6, -6);
    [self addSubview:closeButton];
    [closeButton addTarget:self action:@selector(closeButtonClickAction) forControlEvents:UIControlEventTouchUpInside];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.peripherals.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dataDict = [self.peripherals xf_safeObjectAtIndex:indexPath.row];
    YSConnectDeviceCell *cell = [YSConnectDeviceCell setupCellWithTableView:tableView];
    cell.dataDict = dataDict;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *dataDict = [self.peripherals xf_safeObjectAtIndex:indexPath.row];
    CBPeripheral *peripheral = dataDict[@"peripheral"];
    self.peripherals = [[YSCustomAlertViewConfig didSelcteRecombineWithDatas:self.peripherals selecteRow:indexPath.row] mutableCopy];
    [tableView reloadData];
    self.peripheral = peripheral;
    BLOCK_EXEC(self.connectPeripheralCallback,peripheral);
}

- (void)closeButtonClickAction {
    BLOCK_EXEC(self.closeListsCallback);
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end

#pragma mark  按摩完成
@interface YSMassageCompletedAlert ()

@property (strong,nonatomic) UIImageView *completedImageView;
@property (strong,nonatomic) UILabel *subtitle1Lab;
@property (strong,nonatomic) UILabel *subtitle2Lab;
@property (strong,nonatomic) UIButton *viewAchievementButton;

@end

@implementation YSMassageCompletedAlert

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.layer.cornerRadius = 6;
        self.backgroundColor = JGWhiteColor;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    // 270 * 120
    CGFloat completeImageWidth = 270 / 2.;
    CGFloat completeImageHeight = 120 / 2.0;
    CGFloat completeImagex = (self.width - completeImageWidth) / 2;
    CGFloat completeImagey = 36.;
    if (self.completedImageView) {
        self.completedImageView.frame = CGRectMake(completeImagex, completeImagey, completeImageWidth, completeImageHeight);
    }else {
        UIImageView *completedImageView  = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ys_personal_device_completeicon"]];
        completedImageView.frame = CGRectMake(completeImagex, completeImagey, completeImageWidth, completeImageHeight);
        [self addSubview:completedImageView];
        self.completedImageView = completedImageView;
    }
    
    CGFloat subtitle1x = 0.;
    CGFloat subtitle1y = MaxY(self.completedImageView) + 26;
    CGFloat subtitle1Width = self.width;
    CGFloat subtitle1Heigth = 19.;
    if (self.subtitle1Lab) {
        self.subtitle1Lab.frame = CGRectMake(subtitle1x, subtitle1y, subtitle1Width, subtitle1Heigth);
    }else {
        UILabel *subtitle1Lab = [UILabel new];
        subtitle1Lab.x = 0.;
        subtitle1Lab.y = subtitle1y;
        subtitle1Lab.width = subtitle1Width;
        subtitle1Lab.height = subtitle1Heigth;
        subtitle1Lab.textAlignment = NSTextAlignmentCenter;
        subtitle1Lab.textColor = [UIColor colorWithHexString:@"#4a4a4a" alpha:1];
        UIFont *textFont;
        if (iPhone5) {
            textFont = JGFont(13);
        }else {
            textFont = JGRegularFont(14);
        }
        subtitle1Lab.font = textFont;
        [self addSubview:subtitle1Lab];
        self.subtitle1Lab = subtitle1Lab;
    }
    self.subtitle1Lab.text = @"真棒！您又坚持完成了10分钟的按摩！";
    
    CGFloat subtitle2x = subtitle1x;
    CGFloat subtitle2y = MaxY(self.subtitle1Lab) + 2;
    CGFloat subtitle2Width = self.width;
    CGFloat subtitle2Height = self.subtitle1Lab.height;
    if (self.subtitle2Lab) {
        self.subtitle2Lab.frame = CGRectMake(subtitle2x, subtitle2y, subtitle2Width, subtitle2Height);
    }else {
        UILabel *subtitle2Lab = [UILabel new];
        subtitle2Lab.frame = CGRectMake(subtitle2x, subtitle2y, subtitle2Width, subtitle2Height);
        subtitle2Lab.textAlignment = self.subtitle1Lab.textAlignment;
        subtitle2Lab.textColor = self.subtitle1Lab.textColor;
        subtitle2Lab.font = self.subtitle1Lab.font;
        [self addSubview:subtitle2Lab];
        self.subtitle2Lab = subtitle2Lab;
    }
    self.subtitle2Lab.text = @"离健康与美丽又进一步";
    
    CGFloat viewAchievementButtonx = [YSAdaptiveFrameConfig width:26.];
    CGFloat viewAchievementButtony = MaxY(self.subtitle2Lab) + 26;
    CGFloat viewAchievementButtonWidth = self.width - viewAchievementButtonx * 2;
    CGFloat viewAchievementButtonHeigth = [YSAdaptiveFrameConfig height:38.];
    if (self.viewAchievementButton) {
        self.viewAchievementButton.frame = CGRectMake(viewAchievementButtonx, viewAchievementButtony, viewAchievementButtonWidth, viewAchievementButtonHeigth);
    }else {
        UIButton *viewAchievementButton = [UIButton buttonWithType:UIButtonTypeCustom];
        viewAchievementButton.frame = CGRectMake(viewAchievementButtonx, viewAchievementButtony, viewAchievementButtonWidth, viewAchievementButtonHeigth);
        viewAchievementButton.layer.cornerRadius = viewAchievementButton.height / 2 - [YSAdaptiveFrameConfig height:3.];
        viewAchievementButton.clipsToBounds = YES;
        viewAchievementButton.layer.borderWidth = 0.85;
        viewAchievementButton.layer.borderColor = [YSThemeManager buttonBgColor].CGColor;
        [viewAchievementButton setTitle:@"查看我的成就" forState:UIControlStateNormal];
        viewAchievementButton.titleLabel.font = JGRegularFont(15);
        [viewAchievementButton setTitleColor:[YSThemeManager themeColor] forState:UIControlStateNormal];
        [self addSubview:viewAchievementButton];
        self.viewAchievementButton = viewAchievementButton;
    }
}

@end

#pragma mark  搜索无设备
@interface YSSearchDeviceNoneAlert ()

@property (strong,nonatomic) UIImageView *bluetoothIcon;
@property (strong,nonatomic) UIImageView *deviceIcon;
@property (strong,nonatomic) UILabel *titleLab;
@property (strong,nonatomic) UIButton *researchButton;
@property (strong,nonatomic) UIButton *closeButton;

@end

@implementation YSSearchDeviceNoneAlert

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.layer.cornerRadius = 6.;
        self.backgroundColor = JGWhiteColor;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat closeButtonWidth = 14.;
    CGFloat closeButtonHeight = 15.;
    CGFloat closeButtonx = self.width - closeButtonWidth - 14.;
    CGFloat closeButtony = 14.;
    if (self.closeButton) {
        self.closeButton.frame = CGRectMake(closeButtonx, closeButtony, closeButtonWidth, closeButtonHeight);
    }else{
        JGTouchEdgeInsetsButton *closeButton = [JGTouchEdgeInsetsButton buttonWithType:UIButtonTypeCustom];
        closeButton.frame = CGRectMake(closeButtonx, closeButtony, closeButtonWidth, closeButtonHeight);
        [closeButton setImage:[UIImage imageNamed:@"ys_personal_device_alertclose"] forState:UIControlStateNormal];
        closeButton.touchEdgeInsets = UIEdgeInsetsMake(-6, -6, -6, -6);
        [self addSubview:closeButton];
        self.closeButton = closeButton;
    }
    
    [self.closeButton addTarget:self action:@selector(closeButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    CGFloat bluetoothIconWidth = 140.;
    CGFloat bluetoothIconHeight = 42;
    CGFloat bluetoothx = self.width / 2 - 70.;
    CGFloat bluetoothy = 36.;
    if (self.bluetoothIcon) {
        self.bluetoothIcon.width = bluetoothIconWidth;
        self.bluetoothIcon.height = bluetoothIconHeight;
        self.bluetoothIcon.x = bluetoothx;
        self.bluetoothIcon.y = bluetoothy;
    }else {
        UIImageView *bluetoothIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ys_peronal_device_loseconnect"]];
        bluetoothIcon.width = bluetoothIconWidth;
        bluetoothIcon.height = bluetoothIconHeight;
        bluetoothIcon.x = bluetoothx;
        bluetoothIcon.y = bluetoothy;
        [self addSubview:bluetoothIcon];
        self.bluetoothIcon = bluetoothIcon;
    }
    
    CGFloat titlex = 0.;
    CGFloat titley = MaxY(self.bluetoothIcon) + 24;
    CGFloat titleWidth = self.width;
    CGFloat titleHeight = 17.;
    
    if (self.titleLab) {
        self.titleLab.x = titlex;
        self.titleLab.y = titley;
        self.titleLab.width = titleWidth;
        self.titleLab.height = titleHeight;
    }else {
        UILabel *titleLab = [UILabel new];
        titleLab.x = titlex;
        titleLab.y = titley;
        titleLab.width = titleWidth;
        titleLab.height = titleHeight;
        titleLab.textAlignment = NSTextAlignmentCenter;
        titleLab.text = @"很遗憾！未搜索到可用设备哦~";
        titleLab.font = JGRegularFont(14);
        titleLab.textColor = [UIColor colorWithHexString:@"#4a4a4a" alpha:1];
        [self addSubview:titleLab];
        self.titleLab = titleLab;
    }
    
    CGFloat researchButtonx = 18.;
    CGFloat researchButtony = MaxY(self.titleLab) + 32;
    CGFloat researchButtonWidth = self.width - researchButtonx * 2;
    CGFloat researchButtonHeight = 38.;
    if (self.researchButton) {
        self.researchButton.frame = CGRectMake(researchButtonx, researchButtony, researchButtonWidth, researchButtonHeight);
    }else {
        UIButton *researchButton = [UIButton buttonWithType:UIButtonTypeCustom];
        researchButton.frame = CGRectMake(researchButtonx, researchButtony, researchButtonWidth, researchButtonHeight);
        researchButton.layer.cornerRadius = researchButton.size.height / 2;
        researchButton.clipsToBounds = YES;
        researchButton.backgroundColor = [YSThemeManager buttonBgColor];
        [researchButton setTitle:@"重新搜索" forState:UIControlStateNormal];
        [researchButton setTitleColor:[UIColor colorWithHexString:@"#ffffff" alpha:1] forState:UIControlStateNormal];
        researchButton.titleLabel.font = JGRegularFont(14);
        [self addSubview:researchButton];
        self.researchButton = researchButton;
    }
    [self.researchButton addTarget:self action:@selector(researchDevice:) forControlEvents:UIControlEventTouchUpInside];
}

// 重新搜索
- (void)researchDevice:(UIButton *)button {
    BLOCK_EXEC(self.noneCallback,AlertCallback(YSCustomAlertCallbackResearch));
}

- (void)closeButtonAction:(UIButton *)button {
    BLOCK_EXEC(self.noneCallback,AlertCallback(YSCustomAlertCallbackClose));
}


@end

#pragma mark  搜索设备
@interface YSSearchDeviceAlert ()

@property (strong,nonatomic) UIImageView *bluetoothIcon;

@property (strong,nonatomic) UIImageView *deviceIcon;

@property (strong,nonatomic) UILabel *titleLab;

@property (strong,nonatomic) UIImageView *progressImageView;

@end

@implementation YSSearchDeviceAlert

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.layer.cornerRadius = 6.;
        self.backgroundColor = JGWhiteColor;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat bluetoothIconWidth = 42;
    CGFloat bluetoothIconHeight = 42;
    CGFloat bluetoothx = self.width / 2 - 64;
    CGFloat bluetoothy = 36.;
    if (self.bluetoothIcon) {
        self.bluetoothIcon.width = bluetoothIconWidth;
        self.bluetoothIcon.height = bluetoothIconHeight;
        self.bluetoothIcon.x = bluetoothx;
        self.bluetoothIcon.y = bluetoothy;
    }else {
        UIImageView *bluetoothIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ys_personal_device_bluetoothicon"]];
        bluetoothIcon.width = bluetoothIconWidth;
        bluetoothIcon.height = bluetoothIconHeight;
        bluetoothIcon.x = bluetoothx;
        bluetoothIcon.y = bluetoothy;
        [self addSubview:bluetoothIcon];
        self.bluetoothIcon = bluetoothIcon;
    }
    
    CGFloat progressImageWidth = 26.;
    CGFloat progressImageHeight  = 5.;
    CGFloat progressImagex = (self.width - progressImageWidth) / 2;
    CGFloat progressImagey = self.bluetoothIcon.y + (bluetoothIconHeight - progressImageHeight) / 2;
    
    NSArray * images = @[[UIImage imageNamed:@"ys_personal_device_search_01"],[UIImage imageNamed:@"ys_personal_device_search_02"],[UIImage imageNamed:@"ys_personal_device_search_03"],[UIImage imageNamed:@"ys_personal_device_search_04"]];

    if (self.progressImageView) {
        self.progressImageView.frame = CGRectMake(progressImagex, progressImagey, progressImageWidth, progressImageHeight);
    }else {
        UIImageView *progressImageView = [[UIImageView alloc] initWithFrame:CGRectMake(progressImagex, progressImagey, progressImageWidth, progressImageHeight)];
        [self addSubview:progressImageView];
        self.progressImageView = progressImageView;
    }
    [self.progressImageView setAnimationImages:images];
    [self.progressImageView setAnimationDuration:0.8];
    self.progressImageView.animationRepeatCount = 0;
    if (self.progressImageView.isAnimating) {
        
    }else {
        [self.progressImageView startAnimating];
    }
    
    CGFloat deviceIconWidth = 42;
    CGFloat deviceIconHeight= 42;
    CGFloat deviceIconx = self.width / 2 + 44;
    CGFloat deviceIcony = 36.5;
    if (self.deviceIcon) {
        self.deviceIcon.width = deviceIconWidth;
        self.deviceIcon.height = deviceIconHeight;
        self.deviceIcon.x = deviceIconx;
        self.deviceIcon.y = deviceIcony;
    }else {
        UIImageView *deviceIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ys_personal_deveice_deviceicon"]];
        deviceIcon.width = deviceIconWidth;
        deviceIcon.height = deviceIconHeight;
        deviceIcon.x = deviceIconx;
        deviceIcon.y = deviceIcony;
        [self addSubview:deviceIcon];
        self.deviceIcon = deviceIcon;
    }
 
    CGFloat titlex = 0.;
    CGFloat titley = MaxY(self.deviceIcon) + 24;
    CGFloat titleWidth = self.width;
    CGFloat titleHeight = 17.;
    
    if (self.titleLab) {
        self.titleLab.x = titlex;
        self.titleLab.y = titley;
        self.titleLab.width = titleWidth;
        self.titleLab.height = titleHeight;
    }else {
        UILabel *titleLab = [UILabel new];
        titleLab.x = titlex;
        titleLab.y = titley;
        titleLab.width = titleWidth;
        titleLab.height = titleHeight;
        titleLab.textAlignment = NSTextAlignmentCenter;
        titleLab.text = @"蓝牙君在努力搜索设备中......";
        titleLab.font = JGRegularFont(14);
        titleLab.textColor = [UIColor colorWithHexString:@"#4a4a4a" alpha:1];
        [self addSubview:titleLab];
        self.titleLab = titleLab;
    }
    
    CGFloat closeButtonWidth = 14.;
    CGFloat closeButtonHeight = 15.;
    CGFloat closeButtonx = self.width - closeButtonWidth - 14.;
    CGFloat closeButtony = 14.;
    JGTouchEdgeInsetsButton *closeButton = [JGTouchEdgeInsetsButton buttonWithType:UIButtonTypeCustom];
    closeButton.frame = CGRectMake(closeButtonx, closeButtony, closeButtonWidth, closeButtonHeight);
    [closeButton setImage:[UIImage imageNamed:@"ys_personal_device_alertclose"] forState:UIControlStateNormal];
    closeButton.touchEdgeInsets = UIEdgeInsetsMake(-6, -6, -6, -6);
    [self addSubview:closeButton];
    [closeButton addTarget:self action:@selector(closeButtonClickAction) forControlEvents:UIControlEventTouchUpInside];
}

- (void)closeButtonClickAction {
    JGLog(@"---停止搜索");
    BLOCK_EXEC(self.closeCallback);
}

@end

@interface YSCustomAlertViewConfig ()


@end

@implementation YSCustomAlertViewConfig

+ (NSArray *)didSelcteRecombineWithDatas:(NSArray *)datas selecteRow:(NSInteger)row {
    
    NSMutableArray *tempArray = [NSMutableArray array];
    for (NSDictionary *data in datas) {
        NSMutableDictionary *tempDict = [NSMutableDictionary dictionaryWithDictionary:data];
        [tempDict xf_safeSetObject:@1 forKey:@"hidden"];
        [tempArray xf_safeAddObject:tempDict];
    }
    
    NSDictionary *dataDict = [datas xf_safeObjectAtIndex:row];
    NSMutableDictionary *tempDict = [NSMutableDictionary dictionaryWithDictionary:dataDict];
    [tempDict xf_safeSetObject:@0 forKey:@"hidden"];
    [tempArray replaceObjectAtIndex:row withObject:tempDict];
    return [tempArray copy];
}

+ (NSArray *)recombineDevicesList:(NSArray *)deviceList {
    if (!deviceList.count) {
        return @[];
    }
    NSMutableArray *tempArray = [NSMutableArray array];
    for (CBPeripheral *peripheral in deviceList) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict xf_safeSetObject:peripheral forKey:@"peripheral"];
        [dict xf_safeSetObject:@1 forKey:@"hidden"];
        [tempArray xf_safeAddObject:[dict copy]];
    }
    return [tempArray copy];
}


- (UIView * )alertView:(YSCustomAlertType)alertType extParams:(id)params
{
    UIView *alerView = nil;
    switch (alertType) {
        case YSCustomAlertWithSeachingDevices:
        {
            YSSearchDeviceAlert *serachView = [[YSSearchDeviceAlert alloc] init];
            @weakify(self);
            @weakify(serachView);
            serachView.closeCallback = ^() {
                @strongify(self);
                @strongify(serachView);
                if ([self.delegate respondsToSelector:@selector(alertView:extMsgCode:)]) {
                    [self.delegate alertView:serachView extMsgCode:YSCustomAlertCallbackCloseWithSearchAlert];
                }
            };
            alerView = serachView;
        }
            break;
        case YSCustomAlertWithSearchDeviceNone:
        {
            YSSearchDeviceNoneAlert *noneAlert = [[YSSearchDeviceNoneAlert alloc] init];
            @weakify(self);
            @weakify(noneAlert);
            noneAlert.noneCallback = ^(NSNumber *code) {
                @strongify(self);
                @strongify(noneAlert);
                if ([self.delegate respondsToSelector:@selector(alertView:extMsgCode:)]) {
                    [self.delegate alertView:noneAlert extMsgCode:[code integerValue]];
                }
            };
            alerView = noneAlert;
        }
            break;
        case YSCuctomAlertWithMassageComplete:
        {
            YSMassageCompletedAlert *completeAlert = [[YSMassageCompletedAlert alloc] init];
            alerView = completeAlert;
        }
            break;
        case YSCustomAlertWithConnectDeviceList:
        {
            YSConnectDevicesListView *connectDeviceListAlert = [[YSConnectDevicesListView alloc] initWithPeripherals:(NSArray *)params];
            @weakify(self);
            @weakify(connectDeviceListAlert);
            connectDeviceListAlert.connectPeripheralCallback = ^(CBPeripheral *peripheral){
                @strongify(self);
                @strongify(connectDeviceListAlert);
                if ([self.delegate respondsToSelector:@selector(alertView:extMsgCode:)]) {
                    [self.delegate alertView:connectDeviceListAlert extMsgCode:YSCustomAlertConnectDevice];
                }
            };
            connectDeviceListAlert.closeListsCallback = ^(){
                @strongify(self);
                @strongify(connectDeviceListAlert);
                if ([self.delegate respondsToSelector:@selector(alertView:extMsgCode:)]) {
                    [self.delegate alertView:connectDeviceListAlert extMsgCode:YSCustomAlertCallbackCloseWithDeviceListAlert];
                }
            };
            alerView = connectDeviceListAlert;
        }
            break;
        case YSCustomAlertClickEndMassage:
        {
            YSMassageEndAlertView *endAlertView = [[YSMassageEndAlertView alloc] init];
            @weakify(self);
            @weakify(endAlertView);
            endAlertView.endButtonClickCallback = ^(NSNumber *msgCodeNumber){
                @strongify(self);
                @strongify(endAlertView);
                if ([self.delegate respondsToSelector:@selector(alertView:extMsgCode:)]) {
                    [self.delegate alertView:endAlertView extMsgCode:[msgCodeNumber integerValue]];
                }
            };
            alerView = endAlertView;
        }
            break;
        case YSCustomAlertWithMassageComplete:
        {
            YSMassageCompletedAlertView *completeAlertView = [[YSMassageCompletedAlertView alloc] initWithSuccessText:params
                                                              ];
            @weakify(self);
            @weakify(completeAlertView);
            completeAlertView.completeCallback = ^(NSNumber *msgCodeNumber){
                @strongify(self);
                @strongify(completeAlertView);
                if ([self.delegate respondsToSelector:@selector(alertView:extMsgCode:)]) {
                    [self.delegate alertView:completeAlertView extMsgCode:[msgCodeNumber integerValue]];
                }
            };
            alerView = completeAlertView;
        }
            break;
        case YSCustomAlertWithMassageTeleComingBreak:
        {
            YSTeleComingMassageBreakAlertView *teleComingBreakAlertView = [[YSTeleComingMassageBreakAlertView alloc] init];
            @weakify(self);
            @weakify(teleComingBreakAlertView);
            teleComingBreakAlertView.breakCallback = ^(NSNumber *msgCodeNumber){
                @strongify(self);
                @strongify(teleComingBreakAlertView);
                if ([self.delegate respondsToSelector:@selector(alertView:extMsgCode:)]) {
                    [self.delegate alertView:teleComingBreakAlertView extMsgCode:[msgCodeNumber integerValue]];
                }
            };
            alerView = teleComingBreakAlertView;
        }
            break;
        case YSCustomAlertWithLoseConnect:
        {
            YSLoseConnectAlertView *loseConnectAlertView = [[YSLoseConnectAlertView alloc] init];
            loseConnectAlertView.reconnectCallback = ^(NSNumber *msgCodeNumber){
                [[NSNotificationCenter defaultCenter] postNotificationName:YSPeripheralLoseConnectAlertViewCallbackKey object:nil];
            };
            loseConnectAlertView.closeWithLoseConnectCallback = ^{
                [[NSNotificationCenter defaultCenter] postNotificationName:YSCloseAlertWithLoseConnectKey object:nil];
            };
            alerView = loseConnectAlertView;
        }
            break;
        case YSCustomAlertWithBluetoothOff:
        {
            YSBluetoothOffAlertView *bluetoothOffAlertView = [[YSBluetoothOffAlertView alloc] init];
            alerView = bluetoothOffAlertView;
        }
            break;
        case YSCustomAlertWithUnbindDevice:
        {
            YSUnbindDeviceAlertView *unbindDeviceAlertView = [[YSUnbindDeviceAlertView alloc] init];
            @weakify(self);
            @weakify(unbindDeviceAlertView);
            unbindDeviceAlertView.unbindButtonClick = ^(NSNumber *msgCodeNumber){
                @strongify(self);
                @strongify(unbindDeviceAlertView);
                if ([self.delegate respondsToSelector:@selector(alertView:extMsgCode:)]) {
                    [self.delegate alertView:unbindDeviceAlertView extMsgCode:[msgCodeNumber integerValue]];
                }
            };
            alerView = unbindDeviceAlertView;
        }
            break;
        default:
            break;
    }
    return alerView;
}

@end
