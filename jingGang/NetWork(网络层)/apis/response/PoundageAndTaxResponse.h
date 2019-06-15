//
//  PoundageAndTaxResponse.h
//  Operator_JingGang
//
//  Created by whlx on 2019/4/16.
//  Copyright © 2019年 Dengxf. All rights reserved.
//

#import "AbstractResponse.h"

NS_ASSUME_NONNULL_BEGIN

@interface PoundageAndTaxResponse : AbstractResponse
@property (nonatomic, readonly, copy) NSString *poundage;
@property (nonatomic, readonly, copy) NSString *taxAmount;

@end

NS_ASSUME_NONNULL_END
