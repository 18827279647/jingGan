//
//  JGRecommStoreInfoModel.h
//  jingGang
//
//  Created by HanZhongchou on 16/7/25.
//  Copyright © 2016年 Dengxf_Dev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JGRecommStoreInfoModel : NSObject

/**
 *  id
 */
@property (nonatomic,  copy) NSNumber *id;
/**
 *  店铺名称
 */
@property (nonatomic,  copy) NSString *storeName;
/**
 *  店铺详细地址
 */
@property (nonatomic,  copy) NSString *storeAddress;
/**
 *  店铺详细地址
 */
@property (nonatomic,  copy) NSString *area;
/**
 *  星级
 */
@property (nonatomic,  copy) NSNumber *star;
/**
 *  距离
 */
@property (nonatomic,  copy) NSNumber *distance;
/**
 *  图片Url
 */
@property (nonatomic,  copy) NSString *storeInfoPath;
/**
 *  服务评分
 */
@property (nonatomic,  copy) NSNumber *evaluationAverage;

@end
