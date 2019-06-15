//
//  Role.h
//  VApiSDK_iOS
//
//  Created by duocai on 14-6-14.
//  Copyright (c) 2014年 duocai. All rights reserved.
//

#import "Mantle.h"

@interface ygPayMode : MTLModel <MTLJSONSerializing>

	//10奖金账户支付JJ;20充值账户支付cZ; 30现金支付CASH
	@property (nonatomic, readonly, copy) NSNumber *res;
	//实际支付云购币总和
	@property (nonatomic, readonly, copy) NSNumber *actualygPrice;
	//实际支付现金总和
	@property (nonatomic, readonly, copy) NSNumber *actualPrice;
	//当前与购币余额
	@property (nonatomic, readonly, copy) NSNumber *currentYgBalance;
	//当前奖金余额
	@property (nonatomic, readonly, copy) NSNumber *currentJjBalance;
	//当前充值余额
	@property (nonatomic, readonly, copy) NSNumber *currentCzBalance;
	//选择支付方式
	@property (nonatomic, readonly, copy) NSString *payMode;
	//云购账户状态
	@property (nonatomic, readonly, copy) NSNumber *yGWalletStatus;
	//工资账户状态
	@property (nonatomic, readonly, copy) NSNumber *jJWalletStatus;
	//充值账户状态
	@property (nonatomic, readonly, copy) NSNumber *cZWalletStatus;
	//当前积分余额
	@property (nonatomic, readonly, copy) NSNumber *currentIntegralBalance;
	//实际支付积分
	@property (nonatomic, readonly, copy) NSNumber *actualIntegralBalance;
	//支付方式 1重消支付 2积分支付
	@property (nonatomic, readonly, copy) NSNumber *payTypeFlag;
	//当前平台健康豆余额
	@property (nonatomic, readonly, copy) NSNumber *currentBalance;
	
@end
