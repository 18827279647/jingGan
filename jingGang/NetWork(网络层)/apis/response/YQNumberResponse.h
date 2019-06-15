//
//  YQNumberResponse.h
//  jingGang
//
//  Created by whlx on 2019/4/8.
//  Copyright © 2019年 dengxf_dev. All rights reserved.
//

#import "AbstractResponse.h"

NS_ASSUME_NONNULL_BEGIN

@interface YQNumberResponse : AbstractResponse
@property (nonatomic, readonly, copy) NSArray *users;
@property (nonatomic, readonly, copy) NSString *num;
@property (nonatomic, readonly, copy) NSString *money;
@property (nonatomic, readonly, copy) NSDictionary * referUser;
@property (nonatomic, readonly, copy) NSString * uid;

@end

NS_ASSUME_NONNULL_END
