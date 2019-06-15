//
//  YSMassageSettingController.m
//  jingGang
//
//  Created by dengxf on 17/7/3.
//  Copyright © 2017年 dengxf_dev. All rights reserved.
//

#import "YSMassageSettingController.h"
#import "YSMassageSettingCell.h"
#import "YSBluetoothDeviceManager.h"
#import "YSCustomAlertViewConfig.h"
#import "JGDropdownMenu.h"

@interface YSMassageSettingController ()<UITableViewDelegate,UITableViewDataSource,YSCustomAlertViewConfigDelegate>

@property (strong,nonatomic) UITableView *tableView;

@property (strong,nonatomic) YSCustomAlertViewConfig *alertViewConfig;

@property (strong,nonatomic) JGDropdownMenu *menu;

@end

@implementation YSMassageSettingController

#pragma mark  getter method
- (JGDropdownMenu *)menu {
    if (!_menu) {
        _menu = [JGDropdownMenu menu];
        [_menu configTouchViewDidDismissController:NO];
        [_menu configBgShowMengban];
    }
    return _menu;
}

- (YSCustomAlertViewConfig *)alertViewConfig {
    if (!_alertViewConfig) {
        _alertViewConfig = [[YSCustomAlertViewConfig alloc] init];
        _alertViewConfig.delegate = self;
    }
    return _alertViewConfig;
}
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
        _tableView.contentInset = UIEdgeInsetsMake(6., 0, 0, 0);
        _tableView.backgroundColor = JGBaseColor;
        [_tableView  setSeparatorColor:[JGBaseColor colorWithAlphaComponent:0.0]];
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setup];
    self.tableView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight - NavBarHeight);
}

- (void)setup {
    self.view.backgroundColor = JGBaseColor;
    [self setupNavBarPopButton];
    [self setupNavBarTitleViewWithText:@"设置"];
    [self buildSetting];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0 ) {
        return 120;
    }else
        return [YSAdaptiveFrameConfig height:112.0];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return [YSSettingMyDeviceCell setupWithTableView:tableView unbindCallback:^{
            // 解绑
            [self showMenbanWithSize:CGSizeMake(70, 225) alertType:YSCustomAlertWithUnbindDevice extParams:nil];
        }];
    }else {
        YSMassageSettingCell *cell = [YSMassageSettingCell setupWithTableView:tableView dict:[[YSMassageSettingData datas] xf_safeObjectAtIndex:indexPath.row] indexPath:indexPath];
        if (indexPath.row == 1) {
            switch ([YSBluetoothDeviceManager teleRemind]) {
                case YSBluetoothSettingIsOff:
                    cell.isOn = NO;
                    break;
                default:
                    cell.isOn = YES;
                    break;
            }
        }else if (indexPath.row == 2) {
            switch ([YSBluetoothDeviceManager teleLostMode]) {
                case YSBluetoothSettingIsOff:
                    cell.isOn = NO;
                    break;
                default:
                    cell.isOn = YES;
                    break;
            }
        }
        @weakify(self);
        @weakify(indexPath);
        cell.swtichValueChangeCallback = ^(BOOL isOn) {
            @strongify(self);
            @strongify(indexPath);
            [self configMassageSetingWithIndexPath:indexPath isOn:isOn];
        };
        return cell;
    }
    return nil;
}

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

- (void)configMassageSetingWithIndexPath:(NSIndexPath *)indexPath isOn:(BOOL)isOn {
    if (indexPath.row == 1 ) {
        // 来电提醒
        if (isOn) {
            [YSBluetoothDeviceManager configTeleRemind:YSBluetoothSettingIsOn];
        }else {
            [YSBluetoothDeviceManager configTeleRemind:YSBluetoothSettingIsOff];
        }
    }else if(indexPath.row == 2){
        // 电话防盗
        if (isOn) {
            [YSBluetoothDeviceManager configTeleLostMode:YSBluetoothSettingIsOn];
        }else {
            [YSBluetoothDeviceManager configTeleLostMode:YSBluetoothSettingIsOff];
        }
        
        if (isOn) {
            // 设置防盗功能
                [[YSBluetoothDeviceManager sharedInstance] sendOpenLostModeWithTimeValue:1 strongValue:1];
                [[YSBluetoothDeviceManager sharedInstance] pauseMassageWithStrong:1];
        }else {
            // 关闭防盗功能
                [[YSBluetoothDeviceManager sharedInstance] sendCloseLostModeWithTimeValue:1 strongValue:1];
                [[YSBluetoothDeviceManager sharedInstance] pauseMassageWithStrong:1];
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

}

- (void)alertView:(UIView *)alertView extMsgCode:(YSCustomAlertCallbackCode)extMsgCode {
    [self.menu dismiss];
    switch (extMsgCode) {
        case YSCustomAlertCallbackUnbindDevice:
        {
            JGLog(@"----解绑设备");
            [[YSBluetoothDeviceManager sharedInstance] unbindDevice];
            [SVProgressHUD showInView:[[[UIApplication sharedApplication].keyWindow subviews] lastObject] status:@"正在解绑..."];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2. * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [SVProgressHUD dismiss];
                BLOCK_EXEC(self.researchDeviceCallback);
                [self.navigationController popViewControllerAnimated:YES];
            });
        }
            break;
        case YSCustomAlertCallbackCloseUnbindAlert:
        {
            JGLog(@"--close unbind alert");
        }
        default:
            break;
    }
}

@end
