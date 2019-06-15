//
//  TopCommodityModels.m
//  jingGang
//
//  Created by whlx on 2019/4/9.
//  Copyright © 2019年 dengxf_dev. All rights reserved.
//

#import "TopCommodityModels.h"

@implementation TopCommodityModels
+(NSDictionary *) JSONKeyPathsByPropertyKey {
    return @{
             @"goodsid":@"id",
             @"goodsInventory":@"goodsInventory",
             @"goodsName":@"goodsName",
             @"goodsSalenum":@"goodsSalenum",
             @"storePrice":@"storePrice",
             @"goodsMainPhotoPath":@"goodsMainPhotoPath",
             @"isTuangou":@"isTuangou",
             @"tuanCprice":@"tuanCprice",
             @"realPrice":@"realPrice",
             @"inventoryStatus":@"inventoryStatus",
             @"uniqueCode":@"uniqueCode",
             @"percent":@"percent"
             
             };
}
@end
