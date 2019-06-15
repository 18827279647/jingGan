//
//  JGOrderRedDetailSucResponse.h
//  jingGang
//
//  Created by hlguo2 on 2019/4/25.
//  Copyright © 2019 dengxf_dev. All rights reserved.
//

#import "AbstractResponse.h"

NS_ASSUME_NONNULL_BEGIN

@interface JGOrderRedDetailSucResponse : AbstractResponse

@property (nonatomic,  copy) NSNumber *isFirstShow;

@property (nonatomic, copy) NSNumber *isSecondShow;

@property (nonatomic,  copy) NSArray *redList;



@end

NS_ASSUME_NONNULL_END
