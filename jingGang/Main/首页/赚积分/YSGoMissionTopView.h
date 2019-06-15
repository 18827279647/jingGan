//
//  YSGoMissionTopView.h
//  jingGang
//
//  Created by HanZhongchou on 16/8/25.
//  Copyright © 2016年 dengxf_dev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YSGoMissionTopView : UIView
/**
 *  用户当前积分
 */
@property (weak, nonatomic) IBOutlet UIButton *buttonIntegral;
/**
 *  今日已赚积分
 */
@property (weak, nonatomic) IBOutlet UILabel *labelIntegralToday;

/**
 *  今日还可赚取积分
 */
@property (weak, nonatomic) IBOutlet UILabel *labelIntegralCeiling;
/**
 *  去积分规则
 */
@property (nonatomic,copy) void (^integralRuleButtonClickBlock)(void);
/**
 *  返回键
 */

@property (nonatomic,copy) void (^backButtonClickBlock)(void);
/**
 *  去积分明细页面
 */
@property (nonatomic,copy) void (^goIntegralDetailList)(void);
/**
 *  去积分兑换
 */

@property (nonatomic,copy) void (^gojifenduihuanList)(void);




@property (nonatomic,copy) void (^gojifenzhuanhuanlist)(void);

@end
