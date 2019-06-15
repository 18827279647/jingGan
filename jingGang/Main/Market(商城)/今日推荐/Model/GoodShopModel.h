//
//  GoodShopModel.h
//  jingGang
//
//  Created by whlx on 2019/5/22.
//  Copyright © 2019年 dengxf_dev. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <JSONModel.h>
NS_ASSUME_NONNULL_BEGIN

@interface GoodShopModel : JSONModel
//商品名字
@property (nonatomic, copy) NSString <Optional>* goodsName;
//商品图片
@property (nonatomic, copy) NSString <Optional>* goodsMainPhotoPath;
//赚取金额
@property (nonatomic, copy) NSString <Optional>* earnMoneyText;
// 灰色价格
@property (nonatomic, copy) NSString <Optional>* goodsShowPrice;
// 显示价格
@property (nonatomic, copy) NSString <Optional>* goodsCurrentPrice;
// 剩余库存
@property (nonatomic, copy) NSString <Optional>* goodsInventory;
// 购买人数
@property (nonatomic, copy) NSString <Optional>* goodsSalenum;
// 百分比 >= 90 即将售罄
@property (nonatomic, copy) NSString <Optional>* percent;
//1 : 马上抢 0: 即将开抢
@property (nonatomic, copy) NSString <Optional>* isCanBuy;

@property (nonatomic, copy) NSString <Optional> * ID;

@end

NS_ASSUME_NONNULL_END
