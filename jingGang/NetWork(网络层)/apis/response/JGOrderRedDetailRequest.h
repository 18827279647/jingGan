//
//  JGOrderRedDetailRequest.h
//  jingGang
//
//  Created by hlguo2 on 2019/4/25.
//  Copyright © 2019 dengxf_dev. All rights reserved.
//

#import "IRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface JGOrderRedDetailRequest : AbstractRequest

@property (nonatomic, readwrite, copy) NSNumber *api_orderId;

//isFirstShow：1表示是红包商品要弹窗，0不要弹
//isSecondShow：1表示获得红包，0未获得成功

@end

NS_ASSUME_NONNULL_END
