//
//  PDNumberListResponse.h
//  jingGang
//
//  Created by whlx on 2019/4/10.
//  Copyright © 2019年 dengxf_dev. All rights reserved.
//

#import "AbstractResponse.h"

NS_ASSUME_NONNULL_BEGIN

@interface PDNumberListResponse : AbstractResponse
@property (nonatomic , strong) NSArray               * orderPinDantList;
@end

NS_ASSUME_NONNULL_END
