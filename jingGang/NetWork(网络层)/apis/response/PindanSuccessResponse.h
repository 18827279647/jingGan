//
//  PindanSuccessResponse.h
//  jingGang
//
//  Created by whlx on 2019/4/24.
//  Copyright © 2019年 dengxf_dev. All rights reserved.
//

#import "AbstractResponse.h"

NS_ASSUME_NONNULL_BEGIN

@interface PindanSuccessResponse : AbstractResponse
@property (nonatomic , copy) NSNumber    *leftTime;
@property (nonatomic ,copy) NSArray * userCustomer;

@property (nonatomic , copy) NSString              * addTime;
@end

NS_ASSUME_NONNULL_END
