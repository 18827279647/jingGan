//
//  GoodsDetailModel.h
//  jingGang
//
//  Created by 张康健 on 15/8/11.
//  Copyright (c) 2015年 yi jiehuang. All rights reserved.
//

#import "BaseModel.h"
#import <UIKit/UIKit.h>

@interface GoodsDetailModel : BaseModel

//商品id
@property (nonatomic,  copy) NSNumber *GoodsDetailModelID;
//商品id
@property (nonatomic,  copy) NSNumber *id;
//商品图片
@property (nonatomic,  copy) NSString *goodsMainPhotoPath;
//商品名称
@property (nonatomic,  copy) NSString *goodsName;
//商品当前价格
@property (nonatomic,  copy) NSNumber *goodsCurrentPrice;
//店铺价格
@property (nonatomic,  copy) NSNumber *storePrice;
//是否有积分兑换价格
@property (nonatomic,  copy) NSNumber * hasExchangeIntegral;
//商品积分兑换后的价格，无兑换显示原价
@property (nonatomic,  copy) NSNumber *goodsIntegralPrice;
//是否有手机专享价
@property (nonatomic,  copy) NSNumber *hasMobilePrice;
//手机专享价
@property (nonatomic,  copy) NSNumber *goodsMobilePrice;
//详细说明
@property (nonatomic,  copy) NSString *goodsDetails;
//商品包装清单
@property (nonatomic,  copy) NSString *packDetails;
//商品描述评分
@property (nonatomic,  copy) NSNumber *descriptionEvaluate;
//详细说明app
@property (nonatomic,  copy) NSString *goodsDetailsMobile;
//商品运费承担方式 0为买家承担，1为卖家承担
@property (nonatomic,  copy) NSNumber *goodsTransfee;
//商品类型  0为自营商品，1为第三方经销商
@property (nonatomic,  copy) NSNumber *goodsType;
//商品sq
@property (nonatomic,  copy) NSArray  *detail;
//商品属性
@property (nonatomic,  copy) NSArray  *property;
//将商品属性归类
@property (nonatomic,  copy) NSArray *cationList;
//商品规格
@property (nonatomic,  copy) NSArray *ficPropertyList;
//商品浏览图片
@property (nonatomic,  copy) NSArray *goodsPhotosList;
//商品库存
@property (nonatomic,  copy) NSNumber *goodsInventory;
//兑换积分值，如果是0的话表示不设置积分兑购
@property (nonatomic,  copy) NSNumber *exchangeIntegral;
//是否支持货到付款 0为支持，-1为不支持
@property (nonatomic,  copy) NSNumber *goodsCod;
//商品是否实体  0实体商品，1为虚拟商品
@property (nonatomic,  copy) NSNumber *goodsChoiceType;
//是否支持增值税发票
@property (nonatomic,  copy) NSNumber *taxInvoice;
//店铺id
@property (nonatomic,  copy) NSNumber *goodsStoreId;
//店铺名称
@property (nonatomic,  copy) NSString *goodsStoreName;
//店铺图片
@property (nonatomic,  copy) NSString *storePhoto;
//商品显示价格
@property (nonatomic,  copy) NSNumber *goodsShowPrice;
//手机专享价
@property (nonatomic,  copy) NSNumber *mobilePrice;
//商品原价
@property (nonatomic, copy) NSNumber *goodsPrice;

#pragma mark - 商品实际价格,因为可能有积分价，手机专享价
@property (nonatomic, assign)CGFloat actualPrice;

//规格字符串
@property (nonatomic, copy)NSString *cationNameStr;
//快递费
@property (nonatomic, copy) NSNumber *expressTransFee;
//现金
@property (nonatomic, copy) NSNumber *needMoney;
//店铺Logo
@property (nonatomic, copy) NSString *storeLogo;
//是否精品专区商品
@property (nonatomic, copy) NSNumber *hasYgb;
//精品专区商品积分
@property (nonatomic, copy) NSString *needIntegral;
//精品专区商品重消
@property (nonatomic, copy) NSNumber *needYgb;
//商品支付类型 1 重消,2购物积分 3重消+购物积分
@property (nonatomic, assign) NSInteger proType;
//提示信息
@property (nonatomic, copy) NSString *warnInfo;
//是否是卷皮0否 1是
@property (nonatomic, copy) NSNumber *isJuanpi;
//是否是团购 0否 1是
@property (nonatomic, copy) NSNumber *isTuangou;
//H5卷皮跳转页面路径
@property (nonatomic, copy) NSString *targetUrlM;
//拼团价格
@property (nonatomic, copy) NSNumber *tuanCprice;

@property (nonatomic, copy) NSNumber *isPinDan;
@property (nonatomic, copy) NSNumber *pdPrice;

@end
