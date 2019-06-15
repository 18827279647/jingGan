//
//  GoodsDetailsModel.h
//  jingGang
//
//  Created by whlx on 2019/5/23.
//  Copyright © 2019年 dengxf_dev. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <JSONModel.h>
NS_ASSUME_NONNULL_BEGIN

@interface GoodsDetailsModel : JSONModel
//商品名称
@property (nonatomic, copy) NSString <Optional>* goodsName;
//轮播图数据
@property (nonatomic, copy) NSArray <Optional>* goodsPhotosList;
//优惠价
@property (nonatomic, copy) NSString <Optional>* goodsCurrentPrice;
//原价
@property (nonatomic, copy) NSString <Optional>* goodsShowPrice;
//html
@property (nonatomic, copy) NSString <Optional>* goodsDetails;
//原价
@property (nonatomic, copy) NSString <Optional>* goodsPrice;
//邀请code
@property (nonatomic, copy) NSString <Optional>* invitationCode;
//优惠券
@property (strong, nonatomic) NSArray <Optional>*couponList;

// 剩余库存
@property (nonatomic, copy) NSString <Optional>* goodsInventory;
// 购买人数
@property (nonatomic, copy) NSString <Optional>* goodsSaleNum;
//自营 1: 0
@property (nonatomic, copy) NSString <Optional>* goodsType;
//包邮 1 ： 0
@property (nonatomic, copy) NSString <Optional>* goodsTransfee;
//积分购 1: 0
@property (nonatomic, copy) NSString <Optional>* isJiFenGou;
//判断是否能购买 1 能买。0 不能购买
@property (nonatomic, copy) NSString <Optional> * isCanBuy;
//积分数
@property (nonatomic, copy) NSString <Optional> * integralPrice;
//areaId == 3 限时抢购
@property (nonatomic, copy) NSString <Optional> * areaId;


//积分 + 钱数
@property (nonatomic, copy) NSString <Optional> * cashPrice;
// 是否是E建客用户 1 ： 0
@property (nonatomic, copy) NSString <Optional> * isYjk;

@property (nonatomic, copy) NSString <Optional> * ID;
//商品图片
@property (nonatomic, copy) NSString <Optional> * goodsMainPhotoPath;
//商品sq
@property (nonatomic,  copy) NSArray  <Optional> *detail;
//商品属性
@property (nonatomic,  copy) NSArray  <Optional> *property;
//将商品属性归类
@property (nonatomic,  copy) NSArray <Optional> *cationList;
//商品规格
@property (nonatomic,  copy) NSArray <Optional> *ficPropertyList;
//赚取金额
@property (nonatomic, copy) NSString <Optional> * text1;
//省金额
@property (nonatomic, copy) NSString <Optional> * text2;

//时间戳
@property (nonatomic, copy) NSString <Optional> * lastTime;
@end

NS_ASSUME_NONNULL_END
