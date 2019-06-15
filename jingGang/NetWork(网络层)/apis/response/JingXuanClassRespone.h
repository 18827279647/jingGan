//
//  JingXuanClassRespone.h
//  jingGang
//
//  Created by whlx on 2019/1/17.
//  Copyright © 2019年 dengxf_dev. All rights reserved.
//

#import "AbstractResponse.h"
#import "ShopStore.h"
#import "Goods.h"
#import "GoodsCase.h"
#import "GoodsClass.h"
@interface JingXuanClassRespone : AbstractResponse
@property (nonatomic, readonly, copy) NSArray *goodsClassList;
@end
