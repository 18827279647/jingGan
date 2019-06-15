//
//  YSYunGouBiZoneGoodsListModel.h
//  jingGang
//
//  Created by HanZhongchou on 2017/4/10.
//  Copyright © 2017年 dengxf_dev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YSYunGouBiZoneGoodsListModel : NSObject

//商品图片
@property (nonatomic,copy) NSString *goodsMainPhotoPath;
//商品名称
@property (nonatomic,copy) NSString *goodsName;
//商品显示价格
@property (nonatomic,assign) CGFloat goodsShowPrice;
//商品原价
@property (nonatomic,assign) CGFloat goodsPrice;
//需要的积分-精品专区
@property (nonatomic,copy) NSString *needIntegral;
//云购币
@property (nonatomic,assign) CGFloat needYgb;
//现金
@property (nonatomic,assign) CGFloat needMoney;
//商品id
@property (nonatomic,strong) NSNumber *id;
//商品支付类型 1 重消,2购物积分 3重消+购物积分
@property (nonatomic, assign) NSInteger proType;
@end
