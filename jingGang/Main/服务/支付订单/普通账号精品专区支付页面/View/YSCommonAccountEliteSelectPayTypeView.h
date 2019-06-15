//
//  YSCommonAccountEliteSelectPayTypeView.h
//  jingGang
//
//  Created by HanZhongchou on 2017/7/25.
//  Copyright © 2017年 dengxf_dev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YSScanPayViewController.h"
@class YSYgbPayModel;
@interface YSCommonAccountEliteSelectPayTypeView : UIView
@property (nonatomic,assign) YSSelectPayType selectPayType;
- (instancetype)initWithFrame:(CGRect)frame WithPayInfoModel:(YSYgbPayModel *)ygbPayModel;
@property (nonatomic,copy) void (^selectThirdpartMethod)(YSSelectPayType selectPayType);
/**
 *  健康豆支付密码输入框
 */
@property (nonatomic,strong) UITextField *textFieldCloudMoneyPassWord;

@end
