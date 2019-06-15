//
//  YSMakeDetailResponse.h
//  jingGang
//
//  Created by whlx on 2019/5/9.
//  Copyright © 2019年 dengxf_dev. All rights reserved.
//

#import "AbstractResponse.h"

NS_ASSUME_NONNULL_BEGIN

@interface YSMakeDetailResponse : AbstractResponse

@property (nonatomic, copy) NSDictionary * customer;

@property (nonatomic, copy) NSArray * list;

@property (nonatomic, copy) NSString * redNum;

@property (nonatomic, copy) NSString * balanceNum;

@end

NS_ASSUME_NONNULL_END
