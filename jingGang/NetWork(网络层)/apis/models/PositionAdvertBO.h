//
//  Role.h
//  VApiSDK_iOS
//
//  Created by duocai on 14-6-14.
//  Copyright (c) 2014年 duocai. All rights reserved.
//

#import "Mantle.h"
#import "ShopStore.h"
#import "PGroupGoods.h"
#import "PStoreInfo.h"
#import "InformationBO.h"
#import "CircleInvitation.h"
#import "Goods.h"

@interface PositionAdvertBO : MTLModel <MTLJSONSerializing>

	//推荐id
	@property (nonatomic, copy) NSString *itemId;
	//广告描述
	@property (nonatomic, copy) NSString *adText;
	//广告标题
	@property (nonatomic, copy) NSString *adTitle;
	//广告链接
	@property (nonatomic, copy) NSString *adUrl;
	//1:帖子（链接），2商品，3商户，4资讯（e生康缘项目）（链接）5服务商户 6服务
	@property (nonatomic, copy) NSString *adType;
	//广告图片
	@property (nonatomic, copy) NSString *adImgPath;
	//查询时间戳
	@property (nonatomic, copy) NSString *timeStamp;
    //开始时间
    @property (nonatomic, copy) NSString *adBeginTime;
    //结束时间
    @property (nonatomic, copy) NSString *adEndTime;

	//附加信息－帖子信息
	@property (nonatomic, copy) CircleInvitation *invitation;
	//附加信息－e生康缘项目信息
	@property (nonatomic, copy) InformationBO *information;
	//附加信息－商城商品信息
	@property (nonatomic, copy) Goods *shopGoods;
	//附加信息－商城商家信息
	@property (nonatomic, copy) ShopStore *shopStore;
	//附加信息－商户服务信息
	@property (nonatomic, copy) PGroupGoods *pGroupGoods;
	//附加信息－商户信息
	@property (nonatomic, copy) PStoreInfo *pStoreInfo;
	//广告显示类型(1:Html5页面,2:原生页面)
	@property (nonatomic, copy) NSNumber *nativeType;
	//商品当前价格
	@property (nonatomic, copy) NSNumber *goodsCurrentPrice;
	//商品手机专享价
	@property (nonatomic, copy) NSNumber *goodsMobilePrice;
	//商品名称
	@property (nonatomic, copy) NSString *goodsName;
	//是否有手机专享价
	@property (nonatomic, copy) NSNumber *hasMobilePrice;
	//商品BV值
	@property (nonatomic, copy) NSNumber *bv;
	//是否是卷皮0否 1是
	@property (nonatomic, copy) NSNumber *isJuanpi;
	//是否是团购 0否 1是
	@property (nonatomic, copy) NSNumber *isTuangou;
	//H5卷皮跳转页面路径
	@property (nonatomic, copy) NSString *targetUrlM;
	//拼团价格
	@property (nonatomic, copy) NSNumber *tuanCprice;
	
@end
