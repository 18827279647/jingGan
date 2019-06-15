//
//  AppInitResponse.h
//  VApiSDK_iOS
//
//  Created by duocai on 14-6-16.
//  Copyright (c) 2014年 duocai. All rights reserved.
//


#import "AbstractResponse.h"
#import "Trans.h"
#import "ShopUserAddress.h"
#import "ShopGoodsCart.h"
#import "ShopOrderListDetail.h"

@interface ShopCartGoodsDetailResponse :  AbstractResponse
//平台购物车列表
@property (nonatomic, readonly, copy) NSArray *cartList;
//cn购物车列表
@property (nonatomic, readonly, copy) NSArray *cnCartList;
//云购币购物车列表
@property (nonatomic, readonly, copy) NSArray *ygbCartList;
//cn购物车Size
@property (nonatomic, readonly, copy) NSNumber *cartListSize;
//cn购物车Size
@property (nonatomic, readonly, copy) NSNumber *cnCartListSize;
//cn购物车Size
@property (nonatomic, readonly, copy) NSNumber *ygbCartListSize;
//购物车商品id
@property (nonatomic, readonly, copy) NSNumber *gcId;
//商品总价
@property (nonatomic, readonly, copy) NSNumber *totalPrice;
//订单列表
@property (nonatomic, readonly, copy) ShopOrderListDetail *orderList;
//用户所有收货地址列表
@property (nonatomic, readonly, copy) NSArray *userAddressAll;
//用户默认地址
@property (nonatomic, readonly, copy) ShopUserAddress *defaultAddress;
//运送方式
@property (nonatomic, readonly, copy) NSArray *trans;
//购物车商品数量
@property (nonatomic, readonly, copy) NSNumber *shopCartSize;
//精品专区总邮费
@property (nonatomic, readonly, copy) NSNumber *allGoodsFree;
//精品专区积分购买包邮
@property (nonatomic, readonly, copy) NSNumber *freeShipAmount;
@end
