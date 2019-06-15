//
//  YHJRequest.h
//  jingGang
//
//  Created by whlx on 2019/3/8.
//  Copyright © 2019年 dengxf_dev. All rights reserved.
//

#import "IRequest.h"
#import "YHJResponse.h"
@interface YHJRequest : AbstractRequest
/**
 * 商品Id
 */
@property (nonatomic, readwrite, copy) NSNumber *api_goodsId;

@end
