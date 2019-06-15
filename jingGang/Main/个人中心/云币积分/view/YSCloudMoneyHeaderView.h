//
//  YSCloudMoneyHeaderView.h
//  jingGang
//
//  Created by HanZhongchou on 16/9/7.
//  Copyright © 2016年 dengxf_dev. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSUInteger, BottomButtonType) {
    BottomButtonPayType = 0, // 充值
    BottomButtonCashType,    // 提现
};
@interface YSCloudMoneyHeaderView : UIView



//返回按钮block
@property (copy , nonatomic) void (^backButtonClickBlock)(void);
//健康豆规则按钮block
@property (copy , nonatomic) void (^cloudMoneyRuleButtonClickBlock)(void);
//充值按钮block
@property (copy , nonatomic) void (^prepaidButtonClickBlock)(BottomButtonType type);
//提现按钮block
@property (copy , nonatomic) void (^CashButtonClickBlock)(BottomButtonType type);

/**
 *  健康豆总额
 */
@property (nonatomic,copy) NSString *strCloudMoneyValue;

@end
