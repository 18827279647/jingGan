//
//  Role.h
//  VApiSDK_iOS
//
//  Created by duocai on 14-6-14.
//  Copyright (c) 2014年 duocai. All rights reserved.
//

#import "Mantle.h"
#import "GoodsProperty.h"
#import "GoodsSpecification.h"
#import "GoodsSpecProperty.h"
#import "ShopGoodsPhoto.h"
#import "GoodsInventoryDetail.h"

@interface Goods : MTLModel <MTLJSONSerializing>

	//商品id
	@property (nonatomic, readonly, copy) NSNumber *apiId;
	//商品图片
	@property (nonatomic, readonly, copy) NSString *goodsMainPhotoPath;
	//商品名称
	@property (nonatomic, readonly, copy) NSString *goodsName;
	//商品当前价格
	@property (nonatomic, readonly, copy) NSNumber *goodsCurrentPrice;
	//店铺价格
	@property (nonatomic, readonly, copy) NSNumber *storePrice;
	//是否有积分兑换价格
	@property (nonatomic, readonly, copy) NSNumber *hasExchangeIntegral;
	//商品积分兑换后的价格，无兑换显示原价
	@property (nonatomic, readonly, copy) NSNumber *goodsIntegralPrice;
	//是否有手机专享价
	@property (nonatomic, readonly, copy) NSNumber *hasMobilePrice;
	//手机专享价
	@property (nonatomic, readonly, copy) NSNumber *goodsMobilePrice;
	//详细说明
	@property (nonatomic, readonly, copy) NSString *goodsDetails;
	//商品包装清单
	@property (nonatomic, readonly, copy) NSString *packDetails;
	//商品描述评分
	@property (nonatomic, readonly, copy) NSNumber *descriptionEvaluate;
	//详细说明app
	@property (nonatomic, readonly, copy) NSString *goodsDetailsMobile;
	//商品运费承担方式 0为买家承担，1为卖家承担
	@property (nonatomic, readonly, copy) NSNumber *goodsTransfee;
	//商品类型  0为自营商品，1为第三方经销商
	@property (nonatomic, readonly, copy) NSNumber *goodsType;
	//商品sq
	@property (nonatomic, readonly, copy) NSArray *detail;
	//商品属性
	@property (nonatomic, readonly, copy) NSArray *property;
	//将商品属性归类
	@property (nonatomic, readonly, copy) NSArray *cationList;
	//商品规格
	@property (nonatomic, readonly, copy) NSArray *ficPropertyList;
	//商品浏览图片
	@property (nonatomic, readonly, copy) NSArray *goodsPhotosList;
	//商品库存
	@property (nonatomic, readonly, copy) NSNumber *goodsInventory;
	//兑换积分值，如果是0的话表示不设置积分兑购
	@property (nonatomic, readonly, copy) NSNumber *exchangeIntegral;
	//是否支持货到付款 0为支持，-1为不支持
	@property (nonatomic, readonly, copy) NSNumber *goodsCod;
	//商品是否实体  0实体商品，1为虚拟商品
	@property (nonatomic, readonly, copy) NSNumber *goodsChoiceType;
	//是否支持增值税发票
	@property (nonatomic, readonly, copy) NSNumber *taxInvoice;
	//店铺id
	@property (nonatomic, readonly, copy) NSNumber *goodsStoreId;
	//店铺名称
	@property (nonatomic, readonly, copy) NSString *goodsStoreName;
	//店铺图片
	@property (nonatomic, readonly, copy) NSString *storePhoto;
	//商品显示价格-显示的购买价格
	@property (nonatomic, readonly, copy) NSNumber *goodsShowPrice;
	//手机专享价
	@property (nonatomic, readonly, copy) NSNumber *mobilePrice;
	//商品原价-灰色划线价格
	@property (nonatomic, readonly, copy) NSNumber *goodsPrice;
	//BV值
	@property (nonatomic, readonly, copy) NSNumber *selfAddPrice;
	//快递费
	@property (nonatomic, readonly, copy) NSNumber *expressTransFee;
	//折扣价
	@property (nonatomic, readonly, copy) NSNumber *discount;
	//CN商品BV
	@property (nonatomic, readonly, copy) NSNumber *bv;
	//云购币
	@property (nonatomic, readonly, copy) NSNumber *yunGouBi;
	//现金
	@property (nonatomic, readonly, copy) NSNumber *cash;
	//店铺Logo
	@property (nonatomic, readonly, copy) NSString *storeLogo;
	//是否是支持云购币购买的产品
	@property (nonatomic, readonly, copy) NSNumber *exPriceFlag;
	//是否是云购币产品
	@property (nonatomic, readonly, copy) NSNumber *hasYgb;
	//需要的积分-精品专区
	@property (nonatomic, readonly, copy) NSNumber *needIntegral;
	//需要的现金
	@property (nonatomic, readonly, copy) NSNumber *needMoney;
	//需要的云购币
	@property (nonatomic, readonly, copy) NSNumber *needYgb;
	//商品支付类型 1 重消,2购物积分 3重消+购物积分
	@property (nonatomic, readonly, copy) NSNumber *proType;
	//是否是卷皮0否 1是
	@property (nonatomic, readonly, copy) NSNumber *isJuanpi;
	//H5卷皮跳转页面路径
	@property (nonatomic, readonly, copy) NSString *targetUrlM;

 //是否是拼单商品 1是0不是
    @property (nonatomic, readonly, copy) NSNumber *isPinDan;
//拼单价格
    @property (nonatomic, readonly, copy) NSNumber *pdPrice;

@end
