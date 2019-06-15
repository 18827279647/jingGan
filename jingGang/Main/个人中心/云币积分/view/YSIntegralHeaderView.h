//
//  YSIntegralHeaderView.h
//  jingGang
//
//  Created by HanZhongchou on 16/9/6.
//  Copyright © 2016年 dengxf_dev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YSIntegralHeaderView : UIView

//返回按钮block
@property (copy , nonatomic) void (^backButtonClickBlock)(void);
//积分规则按钮block
@property (copy , nonatomic) void (^integralRuleButtonClickBlock)(void);
//去赚积分按钮block
@property (copy , nonatomic) void (^goGainIntegarlButtonClickBlock)(void);
//去兑换按钮block
@property (copy , nonatomic) void (^integralExchangeButtonClickBlock)(void);

// 积分转换
@property (copy , nonatomic) voidCallback integralSwitchCallback;


/**
 *  总积分
 */
@property (nonatomic,copy) NSString *strIntegralValue;


@end
