//
//  AppInitResponse.h
//  VApiSDK_iOS
//
//  Created by duocai on 14-6-16.
//  Copyright (c) 2014年 duocai. All rights reserved.
//


#import "AbstractResponse.h"
#import "GoodsConsult.h"
#import "Goods.h"
#import "ShopEvaluate.h"

@interface GoodsDetailsResponse :  AbstractResponse
//商品详情
@property (nonatomic, readonly, copy) Goods *goodsDetails;
//商品评价列表
@property (nonatomic, readonly, copy) NSArray *shopEvaluateList;
//商品咨询列表
@property (nonatomic, readonly, copy) NSArray *goodsConsultList;
//总记录数
@property (nonatomic, readonly, copy) NSNumber *totalSize;
//0元购标识 1标识是0云购
@property (nonatomic, readonly, copy) NSNumber *zeroFlag;
//是否买过true买过, false没有
@property (nonatomic, readonly, copy) NSNumber *isBought;
//提示信息
@property (nonatomic, readonly, copy) NSString *warnInfo;
@end
