//
//  PDNumberListRequest.h
//  jingGang
//
//  Created by whlx on 2019/4/10.
//  Copyright © 2019年 dengxf_dev. All rights reserved.
//

#import "IRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface PDNumberListRequest : AbstractRequest
@property (nonatomic, readwrite, copy) NSNumber *api_goodsId;
@end

NS_ASSUME_NONNULL_END
