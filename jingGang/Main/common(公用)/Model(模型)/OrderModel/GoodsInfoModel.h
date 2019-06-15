//
//  GoodsInfoModel.h
//  jingGang
//
//  Created by 张康健 on 15/8/15.
//  Copyright (c) 2015年 yi jiehuang. All rights reserved.
//

#import "BaseModel.h"

@interface GoodsInfoModel : BaseModel
//商品价格
@property (nonatomic,  copy) NSString *goodsPrice;
//商品快照
@property (nonatomic,  copy) NSString *goodsSnapshoot;
//商品规格
@property (nonatomic,  copy) NSString *goodsGspVal;
//商品总价
@property (nonatomic,  copy) NSString *goodsAllPrice;
//拼单价格
@property (nonatomic,  copy) NSString *pdPrice;
//商品id
@property (nonatomic,  copy) NSString *goodsId;
//商品类型
@property (nonatomic,  copy) NSString *goodsType;
//商品名称
@property (nonatomic,  copy) NSString *goodsName;
//商品主图
@property (nonatomic,  copy) NSString *goodsDomainPath;
//商品是否实体  0实体商品，1为虚拟商品
@property (nonatomic,  copy) NSString *goodsChoiceType;
//商品主图片
@property (nonatomic,  copy) NSString *goodsMainphotoPath;
//goodsGspIds
@property (nonatomic,  copy) NSString *goodsGspIds;
//goodsPayoffPrice
@property (nonatomic,  copy) NSString *goodsPayoffPrice;
//goodsCommissionPrice
@property (nonatomic,  copy) NSString *goodsCommissionPrice;
//goodsCommissionRate
@property (nonatomic,  copy) NSString *goodsCommissionRate;
//storeDomainPath
@property (nonatomic,  copy) NSString *storeDomainPath;
//商品数量
@property (nonatomic,  copy) NSNumber *goodsCount;
//云购币总和
@property (nonatomic, copy) NSNumber *needYgb;
//云购产品现金总和
@property (nonatomic, copy) NSNumber *needMoney;
//佣金总费用/BV
@property (nonatomic, copy) NSNumber *cnSelfAddPrice;
//是否可退货
@property (nonatomic, copy) NSNumber *hasReturn;
//支付方式 ，1重消 2积分
@property (nonatomic, copy) NSNumber *payTypeFlag;
//需要的积分
@property (nonatomic, copy) NSNumber *needIntegral;

#pragma mark - 订单状态



@end
