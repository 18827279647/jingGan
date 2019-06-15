//
//  YSYgbPayModel.h
//  jingGang
//
//  Created by HanZhongchou on 2017/4/12.
//  Copyright © 2017年 dengxf_dev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YSYgbPayModel : NSObject
// jj==奖金，去工资支付页面，cz去充值账户支付页面,
@property (nonatomic,copy) NSString *pay_mode;
//实际支付云购币总和
@property (nonatomic, copy) NSString *actualygPrice;
//实际支付现金总和
@property (nonatomic, copy) NSString *actualPrice;
//当前云购币余额
@property (nonatomic, strong) NSNumber *currentYgBalance;
//当前奖金余额
@property (nonatomic, strong) NSNumber *currentJjBalance;
//当前充值余额
@property (nonatomic, strong) NSNumber *currentCzBalance;
//订单id
@property (nonatomic,strong) NSNumber *orderID;
//订单编号
@property (nonatomic,copy)   NSString *orderNumber;
//订单总金额
@property (nonatomic,assign) CGFloat totalPrice;
//10奖金(工资)账户支付;20充值账户支付; 30现金支付
@property (nonatomic, strong) NSNumber *res;
//当前积分余额
@property (nonatomic, copy) NSNumber *currentIntegralBalance;
//实际支付积分
@property (nonatomic, copy) NSString *actualIntegralBalance;

@property (nonatomic,strong) NSNumber *orderStatus;
//当前平台健康豆余额
@property (nonatomic, copy) NSNumber *currentBalance;
@end
