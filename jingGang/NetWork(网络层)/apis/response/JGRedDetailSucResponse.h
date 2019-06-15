//
//  JGRedDetailSucResponse.h
//  jingGang
//
//  Created by hlguo2 on 2019/4/25.
//  Copyright © 2019 dengxf_dev. All rights reserved.
//

#import "AbstractResponse.h"

NS_ASSUME_NONNULL_BEGIN

@interface JGRedDetailSucResponse : AbstractResponse


@property (nonatomic , copy) NSNumber    *nowNumber;// 未使用数量
@property (nonatomic ,copy) NSNumber    *useNumber;//已使用数量
@property (nonatomic ,copy) NSNumber    *offNumber;//过期数量
//@property (nonatomic , copy) NSString   *deleteStatus;//0为未使用，1已使用，-1过期；
//@property (nonatomic , copy) NSString   *limitMoney;//0为无门槛，非0为限制金额
@property (nonatomic ,copy) NSNumber    *type;//

@property (nonatomic, readwrite, copy) NSNumber *sum;

@property (nonatomic, readwrite, copy) NSNumber *total;



@property (nonatomic, readonly, copy) NSArray *redList;




@end

NS_ASSUME_NONNULL_END
