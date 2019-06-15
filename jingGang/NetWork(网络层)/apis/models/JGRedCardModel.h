//
//  JGRedCardModel.h
//  jingGang
//
//  Created by hlguo2 on 2019/4/25.
//  Copyright © 2019 dengxf_dev. All rights reserved.
//

#import "MTLModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JGRedCardModel : MTLModel

//id
@property (nonatomic, readonly, copy) NSNumber *apiId;
//
@property (nonatomic, readonly, copy) NSString *addTime;
//
@property (nonatomic, readonly, copy) NSString *deleteStatus;

@property (nonatomic, readonly, copy) NSString *couponSn;

@property (nonatomic, readonly, copy) NSString *status;

@property (nonatomic, readonly, copy) NSString *couponId
;
@property (nonatomic, readonly, copy) NSString *userId;

@property (nonatomic, readonly, copy) NSString *confirm;

@property (nonatomic, readonly, strong) NSDictionary *coupon;

@property (nonatomic, readonly, copy) NSString *type;


@end

NS_ASSUME_NONNULL_END
