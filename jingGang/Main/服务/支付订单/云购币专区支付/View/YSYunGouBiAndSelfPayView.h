//
//  YSYunGouBiAndSelfPayView.h
//  jingGang
//
//  Created by HanZhongchou on 2017/3/17.
//  Copyright © 2017年 dengxf_dev. All rights reserved.
//



//云购币专区自己的币种支付方式
typedef enum : NSUInteger {
    laboragePayType,    //工资支付
    RechargePayType,         //充值账户余额支付
}yunGouBiSelfPayType;


#import <UIKit/UIKit.h>
@class YSYgbPayModel;
@interface YSYunGouBiAndSelfPayView : UIView




- (instancetype)initWithFrame:(CGRect)frame WithType:(yunGouBiSelfPayType)yunGouBiSelfPayType ygbPayModel:(YSYgbPayModel* )ygbPayModel;


@property (nonatomic,assign)yunGouBiSelfPayType  yunGouBiSelfPayType;
@property (nonatomic,strong) UITextField *textFieldPwd;

@end
