//
//  RXSubmitDataResponse.h
//  jingGang
//
//  Created by 荣旭 on 2019/6/26.
//  Copyright © 2019年 dengxf_dev. All rights reserved.
//

#import "AbstractResponse.h"

NS_ASSUME_NONNULL_BEGIN

@interface RXSubmitDataResponse : AbstractResponse

@property(nonatomic,strong)NSString*msg;
@property(nonatomic,strong)NSString*id;
@end

NS_ASSUME_NONNULL_END
