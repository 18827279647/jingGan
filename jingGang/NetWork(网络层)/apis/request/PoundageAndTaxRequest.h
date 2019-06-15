//
//  PoundageAndTaxRequest.h
//  Operator_JingGang
//
//  Created by whlx on 2019/4/16.
//  Copyright © 2019年 Dengxf. All rights reserved.
//

#import "IRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface PoundageAndTaxRequest : AbstractRequest
@property (nonatomic, readwrite, copy) NSString *cashAmount;
@end

NS_ASSUME_NONNULL_END
