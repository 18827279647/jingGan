//
//  JGRedCardSucResponse.h
//  jingGang
//
//  Created by hlguo2 on 2019/4/25.
//  Copyright © 2019 dengxf_dev. All rights reserved.
//

#import "AbstractResponse.h"

NS_ASSUME_NONNULL_BEGIN

@interface JGRedCardSucResponse : AbstractResponse


@property (nonatomic , copy) NSString    *couponNum;
@property (nonatomic ,copy) NSString    *redNum;
@property (nonatomic , copy) NSString   *integral;
@property (nonatomic, readonly, copy) NSArray *coups;

@end

NS_ASSUME_NONNULL_END
