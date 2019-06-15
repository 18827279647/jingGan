//
//  PindanSuccessRequest.h
//  jingGang
//
//  Created by whlx on 2019/4/24.
//  Copyright © 2019年 dengxf_dev. All rights reserved.
//

#import "IRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface PindanSuccessRequest : AbstractRequest
/**
 * 订单id
 */
@property (nonatomic, readwrite, copy) NSString *api_id;

@end

NS_ASSUME_NONNULL_END
