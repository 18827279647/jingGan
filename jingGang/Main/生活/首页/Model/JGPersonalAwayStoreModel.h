//
//  JGPersonalAwayStoreModel.h
//  jingGang
//
//  Created by HanZhongchou on 16/7/28.
//  Copyright © 2016年 Dengxf_Dev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JGPersonalAwayStoreModel : NSObject
/**
 *  距离
 */
@property (nonatomic,copy) NSString *distance;
/**
 *  id
 */
@property (nonatomic,strong) NSNumber *id;
/**
 *  商品名称
 */
@property (nonatomic,copy) NSString *goodsName;
/**
 *  价格
 */
@property (nonatomic,assign) CGFloat price;
/**
 *  商品Id
 */
@property (nonatomic,strong) NSNumber *goodsId;
/**
 *  图片Url
 */
@property (nonatomic,copy) NSString *goodsPath;
/**
 *  商店名称
 */
@property (nonatomic,copy) NSString *storeName;

/**
 *  销售数量
 */
@property (nonatomic,copy) NSString *sales;
/**
 *  原价
 */
@property (nonatomic,assign) CGFloat costPrice;

@end
