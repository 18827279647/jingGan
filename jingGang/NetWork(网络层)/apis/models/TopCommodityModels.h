//
//  TopCommodityModels.h
//  jingGang
//
//  Created by whlx on 2019/4/9.
//  Copyright © 2019年 dengxf_dev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Mantle.h"
NS_ASSUME_NONNULL_BEGIN

@interface TopCommodityModels : MTLModel <MTLJSONSerializing>
@property (nonatomic , assign) NSInteger              goodsid;
@property (nonatomic , assign) NSInteger              goodsInventory;
@property (nonatomic , copy) NSString              * goodsName;
@property (nonatomic , assign) NSInteger              goodsSalenum;
@property (nonatomic , copy) NSNumber *              storePrice;
@property (nonatomic , copy) NSString              * goodsMainPhotoPath;
@property (nonatomic , assign) NSInteger              isTuangou;
@property (nonatomic , assign) NSInteger              tuanCprice;
@property (nonatomic , copy)  NSNumber *              realPrice;
@property (nonatomic , assign) BOOL              inventoryStatus;
@property (nonatomic , assign) NSInteger              uniqueCode;
@property (nonatomic , copy) NSString * percent;
@end

NS_ASSUME_NONNULL_END
