//
//  Role.h
//  VApiSDK_iOS
//
//  Created by duocai on 14-6-14.
//  Copyright (c) 2014年 duocai. All rights reserved.
//

#import "Mantle.h"

@interface UserYunGouMoney : MTLModel <MTLJSONSerializing>

	//添加时间
	@property (nonatomic, readonly, copy) NSDate *dateTime;
	//0购物 1 退款
	@property (nonatomic, readonly, copy) NSNumber *type;
	//1奖金 3云购币
	@property (nonatomic, readonly, copy) NSNumber *payType;
	//使用的云购币
	@property (nonatomic, readonly, copy) NSNumber *usedRepeatMoney;
	//使用的奖金
	@property (nonatomic, readonly, copy) NSNumber *usedBonusPrice;
	
@end
