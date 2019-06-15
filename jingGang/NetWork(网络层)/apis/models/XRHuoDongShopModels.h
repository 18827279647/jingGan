//
//  XRHuoDongShopModels.h
//  jingGang
//
//  Created by whlx on 2019/4/8.
//  Copyright © 2019年 dengxf_dev. All rights reserved.
//

#import "Mantle.h"

NS_ASSUME_NONNULL_BEGIN

@interface XRHuoDongShopModels : MTLModel <MTLJSONSerializing>

//商品id
//商品id
@property (nonatomic, readonly, copy) NSNumber *apiId;
//剩余存货
@property (nonatomic , assign) NSInteger              goodsInventory;
//商品名称
@property (nonatomic , copy) NSString              * goodsName;
//已售出量
@property (nonatomic , assign) NSInteger              goodsSalenum;
//商品价格
@property (nonatomic, copy) NSNumber *             storePrice;
//商品图片
@property (nonatomic , copy) NSString              * goodsMainPhotoPath;


@property (nonatomic , assign) NSInteger              isTuangou;
@property (nonatomic , assign) NSInteger              tuanCprice;
//卷后价格
@property (nonatomic, copy) NSNumber *                   realPrice;
@property (nonatomic , assign) BOOL              inventoryStatus;
@property (nonatomic , assign) NSInteger              uniqueCode;
@property (nonatomic , copy) NSString              * percent;
@end

NS_ASSUME_NONNULL_END
