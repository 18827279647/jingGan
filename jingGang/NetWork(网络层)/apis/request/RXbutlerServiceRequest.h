//
//  RXbutlerServiceRequest.h
//  jingGang
//
//  Created by 荣旭 on 2019/6/25.
//  Copyright © 2019年 dengxf_dev. All rights reserved.
//

#import "IRequest.h"
#import "RXbutlerServiceResponse.h"

NS_ASSUME_NONNULL_BEGIN

@interface RXbutlerServiceRequest : AbstractRequest

@property(nonatomic,strong)NSString*goodsId;

@end

NS_ASSUME_NONNULL_END
