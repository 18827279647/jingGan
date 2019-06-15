//
//  JGRedDetailRequest.h
//  jingGang
//
//  Created by hlguo2 on 2019/4/25.
//  Copyright © 2019 dengxf_dev. All rights reserved.
//

#import "IRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface JGRedDetailRequest : AbstractRequest

/**
 * 每页记录数|必须
 */
@property (nonatomic, readwrite, copy) NSNumber *api_pageSize;
/**
 * 页数|必须
 */
@property (nonatomic, readwrite, copy) NSNumber *api_pageNum;

@property (nonatomic, readwrite, copy) NSNumber *api_type;



@end

NS_ASSUME_NONNULL_END
