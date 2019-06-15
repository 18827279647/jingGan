//
//  JGCashView.h
//  jingGang
//
//  Created by dengxf on 16/1/7.
//  Copyright © 2016年 yi jiehuang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KKScrollView.h"
#import "JGUserSelectCashTypeController.h"
#import "JGCloudAndValueManager.h"
#import "MoneyFreePoundageResponse.h"
/**
 *  设置支付密码类型
 */
typedef NS_ENUM(NSUInteger, JGSettingPayPasswordType) {
    /**
     *  设置支付密码 */
    SettingPayPasswordType = 0,
    /**
     *  忘记密码去设置 */
    ForgetPayPasswordType
};

typedef void(^SettingPayPasswordAction)(JGSettingPayPasswordType type);

/***  健康豆提现视图 */
@interface JGCashView : UIView

/**
 *  支付的图标 */
@property (weak, nonatomic) IBOutlet UIImageView *incoImage;

/**
 *  用户可用健康豆 */
@property (copy , nonatomic) NSString *totleValue;

/**
 *  查询用户默认提现账户表单
 */
@property (strong,nonatomic) CloudForm *cloudPredepositCash;

/**
 *  支付名称 */
@property (weak, nonatomic) IBOutlet UILabel *payTypeName;

/**
 *  支付信息 */
@property (weak, nonatomic) IBOutlet UILabel *payTypeInfo;

@property (weak, nonatomic) IBOutlet UIView *valueView;

@property (strong,nonatomic) MoneyFreePoundageResponse *moneyFreePoundageResponse;

/**
 *  用户设置支付密码 */
@property (copy , nonatomic) SettingPayPasswordAction settingPayPasswordAction;

// 选择支付方式
- (IBAction)selecetPayTypeAction:(UIButton *)sender;

- (instancetype)initWithCashActionSuccess:(void(^)(CloudBuyerCashSaveResponse *))cashSuccess;

@end
