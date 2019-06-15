//
//  YSBluetoothDeviceManager.h
//  jingGang
//
//  Created by dengxf on 17/6/26.
//  Copyright © 2017年 dengxf_dev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JGSingleton.h"

typedef NS_ENUM(NSUInteger, YSBluetoothOperateScene) {
    YSBluetoothOperateSceneWithSeaching = 4000,
    YSBluetoothOperateSceneWithConnecting,
    YSBluetoothOperateSceneWithElse,
};

typedef NS_ENUM(NSUInteger, YSBluetoothDefaultSettingState) {
    /**
     *  默认开启状态 */
    YSBluetoothSettingDefaultOnState = 0,
    /**
     *  设置开启状态 */
    YSBluetoothSettingIsOn,
    /**
     *  设置关闭状态 */
    YSBluetoothSettingIsOff
};

@class CBPeripheral;

@interface YSBluetoothDeviceManager : JGSingleton

@property (strong,nonatomic,readonly) CBPeripheral *currentConnectedPeripheral;
@property (assign, nonatomic,readonly) BOOL isConnected;
@property (assign, nonatomic) NSInteger massageTime;
@property (assign, nonatomic) NSInteger massageStrength;
@property (assign, nonatomic,readonly) BOOL isBluetoothOpen;

/**
 *  搜索设备列表是否在显示 默认是NO */
@property (assign, nonatomic) BOOL searchedPeripheralsListShow;

- (void)startup;

/**
 *  搜索设备 */
- (void)beginSearch:(void(^)(NSArray *peripherals))result;

/**
 *  停止搜索 */
- (void)stopScanBluetooth;

/**
 *  连接设备 */
- (void)connectPeripheral:(CBPeripheral *)peripheral result:(bool_block_t)connectResultCallback;

/**
 *  断开设备 */
- (void)disconnect;

/**
 *  发送震动指令 */
- (void)sendShakeOrderWithTimeValue:(NSInteger)timeValue strongValue:(NSInteger)strongValue phoneLostMode:(BOOL)lostMode;

/**
 *  发送来电提醒指令 */
- (void)sendCallComingOrderWithTimeValue:(NSInteger)timeValue strongValue:(NSInteger)strongValue phoneLost:(BOOL)phoneLost;

/**
 *  打开防丢开关 */
- (void)sendOpenLostModeWithTimeValue:(NSInteger)timeValue strongValue:(NSInteger)strongValue;

/**
 *  关闭防丢开关 */
- (void)sendCloseLostModeWithTimeValue:(NSInteger)timeValue strongValue:(NSInteger)strongValue;

/**
 *  暂停按摩 */
- (void)pauseMassageWithStrong:(NSInteger)strongValue;

/**
 *  配置界面类型 */
+ (void)configOperateScene:(YSBluetoothOperateScene)operateScene;

/**
 *  获取当前界面类型 */
+ (YSBluetoothOperateScene)currentOperateScene;

/**
 *  来电提醒设置 */
+ (void)configTeleRemind:(YSBluetoothDefaultSettingState)isRemind;

+ (YSBluetoothDefaultSettingState)teleRemind;

+ (void)configTeleLostMode:(YSBluetoothDefaultSettingState)isLost;

+ (YSBluetoothDefaultSettingState)teleLostMode;

/**
 *  蓝牙关闭后 */
- (void)showBluetoothOffAlertView;

/**
 *  解绑设备 */
- (void)unbindDevice;
@end
