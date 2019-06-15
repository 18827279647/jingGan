//
//  YHJModel.h
//  jingGang
//
//  Created by whlx on 2019/3/8.
//  Copyright © 2019年 dengxf_dev. All rights reserved.
//

#import "Mantle.h"

@interface YHJModel : MTLModel <MTLJSONSerializing>

@property (nonatomic, readonly, copy) NSString *appid;
//金额
@property (nonatomic, readonly, copy) NSNumber *couponAmount;

@property (nonatomic, readonly, copy) NSNumber *couponCount;
@property (nonatomic, readonly, copy) NSNumber *reciveCount;
@property (nonatomic, readonly, copy) NSString *couponName;
//使用条件
@property (nonatomic, readonly, copy) NSNumber *couponOrderAmount;

@property (nonatomic, readonly, copy) NSNumber *couponType;
//开始时间
@property (nonatomic, readonly, copy) NSString *startTime;
//结束时间
@property (nonatomic, readonly, copy) NSString *endTime;
//状态
@property (nonatomic, readonly) BOOL *Recive;



@end
