//
//  RXSubmitDataRequest.h
//  jingGang
//
//  Created by 荣旭 on 2019/6/26.
//  Copyright © 2019年 dengxf_dev. All rights reserved.
//

#import "IRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface RXSubmitDataRequest : AbstractRequest

@property(nonatomic,strong)NSString*paramJson;
@property(nonatomic,assign)int paramCode;

@end

NS_ASSUME_NONNULL_END
