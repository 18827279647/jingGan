//
//  YHJResponse.h
//  jingGang
//
//  Created by whlx on 2019/3/8.
//  Copyright © 2019年 dengxf_dev. All rights reserved.
//

#import "AbstractResponse.h"
#import "YHJModel.h"
@interface YHJResponse : AbstractResponse
@property (nonatomic, readonly, copy) NSArray *shopCouponList;
@end
