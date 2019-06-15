//
//  Role.h
//  VApiSDK_iOS
//
//  Created by duocai on 14-6-14.
//  Copyright (c) 2014年 duocai. All rights reserved.
//

#import "Mantle.h"
#import "ShopTransPort.h"
#import "ShopStore.h"
#import "ShopCouponInfo.h"
#import "ShopGoodsCart.h"

@interface ShopOrderList : MTLModel <MTLJSONSerializing>

	//商品商铺对象
	@property (nonatomic, readonly, copy) ShopStore *shopStore;
	//商品列表
	@property (nonatomic, readonly, copy) NSArray *goodsCartList;
	//是否支持货到付款|true支持，false不支持
	@property (nonatomic, readonly, copy) NSNumber *goodsCod;
	//默认可以开具增值税发票|1可以
	@property (nonatomic, readonly, copy) NSNumber *taxInvoice;
	//运送方式
	@property (nonatomic, readonly, copy) NSArray *transList;
	//优惠券
	@property (nonatomic, readonly, copy) NSArray *couponInfoList;
	//BV值合计
	@property (nonatomic, readonly, copy) NSNumber *bvCount;
	//是否为云购币专区订单
	@property (nonatomic, readonly, copy) NSNumber *isYgb;
	//需要的积分-精品专区
	@property (nonatomic, readonly, copy) NSNumber *needIntegral;
	//需要的现金
	@property (nonatomic, readonly, copy) NSNumber *needMoney;
	//需要的云购币
	@property (nonatomic, readonly, copy) NSNumber *needYgb;
	//购物积分
	@property (nonatomic, readonly, copy) NSNumber *shopingIntegral;
	//重消
	@property (nonatomic, readonly, copy) NSNumber *cnRepeat;
	//商品支付类型 1 重消,2购物积分 3重消+购物积分 4平台积分
	@property (nonatomic, readonly, copy) NSNumber *proType;
	
@end
