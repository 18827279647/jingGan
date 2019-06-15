//
//  GoodListModel.h
//  jingGang
//
//  Created by whlx on 2019/5/21.
//  Copyright © 2019年 dengxf_dev. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <JSONModel.h>

NS_ASSUME_NONNULL_BEGIN

@interface GoodListModel : JSONModel<YYModel>
//商品名称
@property (nonatomic, copy) NSString * goodsName;
//商品图片
@property (nonatomic, copy) NSString * goodsMainPhotoPath;
//赚取金额
@property (nonatomic, copy) NSString * earnMoneyText;
//商品原价格
@property (nonatomic, copy) NSString * storePrice;
//优惠价
@property (nonatomic, copy) NSString * goodsInventory;
//售价
@property (nonatomic, copy) NSString * goodsCurrentPrice;


@property (nonatomic, copy) NSString * ID;

@end

NS_ASSUME_NONNULL_END
