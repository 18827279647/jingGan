//
//  XRHuoDongShopRequest.h
//  jingGang
//
//  Created by whlx on 2019/4/8.
//  Copyright © 2019年 dengxf_dev. All rights reserved.
//

#import "IRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface XRHuoDongShopRequest : AbstractRequest
/**
 * 每页记录数|必须
 */
@property (nonatomic, readwrite, copy) NSNumber *api_pageSize;
/**
 * 页数|必须
 */
@property (nonatomic, readwrite, copy) NSNumber *api_pageNum;

@end

NS_ASSUME_NONNULL_END
