//
//  AppInitResponse.h
//  VApiSDK_iOS
//
//  Created by duocai on 14-6-16.
//  Copyright (c) 2014年 duocai. All rights reserved.
//


#import "AbstractResponse.h"
#import "ShopGoodsCart.h"
#import "ShopOrderListDetail.h"
#import "Trans.h"
#import "ShopUserAddress.h"

@interface ShopFindUserCartQueryResponse :  AbstractResponse
//平台购物车列表
@property (nonatomic, readonly, copy) NSArray *cartList;
//cn购物车列表
@property (nonatomic, readonly, copy) NSArray *cnCartList;
//云购币购物车列表
@property (nonatomic, readonly, copy) NSArray *ygbCartList;

@property (nonatomic, readonly, copy) NSArray *spikeCanBuyCartList;

@property (nonatomic, readonly, copy) NSArray *spikeNotCanBuyCartList;


@property (nonatomic, readonly, copy) NSArray *jingxuanCartList;
//积分购
@property (nonatomic, readonly, copy) NSArray *jiFenGouCartList;


//cn购物车Size
@property (nonatomic, readonly, copy) NSNumber *cartListSize;
//cn购物车Size
@property (nonatomic, readonly, copy) NSNumber *cnCartListSize;
//cn购物车Size
@property (nonatomic, readonly, copy) NSNumber *ygbCartListSize;
@property (nonatomic, readonly, copy) NSNumber *jingxuanCartListSize;

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
@end
