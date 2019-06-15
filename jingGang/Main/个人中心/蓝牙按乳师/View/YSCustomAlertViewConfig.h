//
//  YSCustomAlertView.h
//  jingGang
//
//  Created by dengxf on 17/6/26.
//  Copyright © 2017年 dengxf_dev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreBluetooth/CoreBluetooth.h>
/**
 *  回调参数 */
typedef NS_ENUM(NSUInteger, YSCustomAlertCallbackCode) {
    /**
     *  关闭弹框，无任何操作 */
    YSCustomAlertCallbackClose = 7001,
    /**
     *  未搜索到设备，点击重新搜索 */
    YSCustomAlertCallbackResearch,
    /**
     *  开始连接蓝牙设备 */
    YSCustomAlertConnectDevice,
    /**
     *  结束弹框，点击继续回调 */
    YSCustomAlertEndWithContinue,
    /**
     *  结束弹框，点击结束回调 */
    YSCustomAlertEndWithEnd,
    /**
     *  按摩结束，查看成果 */
    YSCustomAlertCallbackComplete,
    /**
     *  来电提醒中断，继续按摩 */
    YSCustomAlertCallbackTeleComingBreak,
    /**
     *  失去连接 */
    YSCustomAlertCallbackLoseConnect,
    /**
     *  确定解绑 */
    YSCustomAlertCallbackUnbindDevice,
    /**
     *  关闭解绑弹窗 */
    YSCustomAlertCallbackCloseUnbindAlert,
    /**
     *  搜索设备关闭弹窗 */
    YSCustomAlertCallbackCloseWithSearchAlert,
    /**
     *  搜索设备列表关闭弹窗 */
    YSCustomAlertCallbackCloseWithDeviceListAlert
};

// 弹框类型
typedef NS_ENUM(NSUInteger, YSCustomAlertType) {
    /**
     *  搜索设备 */
    YSCustomAlertWithSeachingDevices = 0,
    /**
     *  未搜索到设备 */
    YSCustomAlertWithSearchDeviceNone,
    /**
     *  按摩完成 */
    YSCuctomAlertWithMassageComplete,
    /**
     *  连接设备列表 */
    YSCustomAlertWithConnectDeviceList,
    /**
     *  按摩结束提示 */
    YSCustomAlertClickEndMassage,
    /**
     *  按摩完成 */
    YSCustomAlertWithMassageComplete,
    /**
     *  来电提醒中断 */
    YSCustomAlertWithMassageTeleComingBreak,
    /**
     *  失去连接 */
    YSCustomAlertWithLoseConnect,
    /**
     *  蓝牙未开启 */
    YSCustomAlertWithBluetoothOff,
    /**
     *  解绑蓝牙设备 */
    YSCustomAlertWithUnbindDevice
};

@interface YSUnbindDeviceAlertView : UIView

@property (copy , nonatomic) id_block_t unbindButtonClick;

@end

@interface YSBluetoothOffAlertView : UIView

@end

@interface YSLoseConnectAlertView : UIView

@property (copy , nonatomic) id_block_t reconnectCallback;
@property (copy , nonatomic) voidCallback closeWithLoseConnectCallback;

@end

@interface YSTeleComingMassageBreakAlertView : UIView

@property (copy , nonatomic) id_block_t breakCallback;

@end

@interface YSMassageCompletedAlertView : UIView

- (instancetype)initWithSuccessText:(NSString *)text;

@property (copy , nonatomic) id_block_t completeCallback;

@end

@interface YSMassageEndAlertView : UIView

@property (copy , nonatomic) id_block_t endButtonClickCallback;

@end

@interface YSConnectDevicesListView : UIView

- (instancetype)initWithPeripherals:(NSArray *)peripherals;
@property (strong,nonatomic,readonly) CBPeripheral *peripheral;

@property (copy , nonatomic) id_block_t connectPeripheralCallback;

@property (copy , nonatomic) voidCallback closeListsCallback;

@end

@interface YSMassageCompletedAlert : UIView 

@end

#pragma mark  ---暂时未发现设备
@interface YSSearchDeviceNoneAlert : UIView

@property (copy , nonatomic) id_block_t noneCallback;

@end

#pragma mark 正在搜索设备
@interface YSSearchDeviceAlert : UIView

@property (copy , nonatomic) voidCallback closeCallback;


@end

@protocol YSCustomAlertViewConfigDelegate <NSObject>

- (void)alertView:(UIView *)alertView extMsgCode:(YSCustomAlertCallbackCode)extMsgCode;

@end

@interface YSCustomAlertViewConfig : NSObject

@property (assign, nonatomic) id<YSCustomAlertViewConfigDelegate> delegate;

@property (copy , nonatomic) id_block_t extIdCallback;

- (UIView *)alertView:(YSCustomAlertType)alertType extParams:(id)params;

+ (NSArray *)didSelcteRecombineWithDatas:(NSArray *)datas selecteRow:(NSInteger)row;

+ (NSArray *)recombineDevicesList:(NSArray *)deviceList;

@end
