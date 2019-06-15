//
//  TopCommodityResponse.h
//  jingGang
//
//  Created by whlx on 2019/4/9.
//  Copyright © 2019年 dengxf_dev. All rights reserved.
//

#import "AbstractResponse.h"

NS_ASSUME_NONNULL_BEGIN

@interface TopCommodityResponse : AbstractResponse
@property (nonatomic , assign) NSInteger              yijianke;
@property (nonatomic , copy) NSString              * invitationCode;
@property (nonatomic , copy) NSNumber    *lastTime;
@property (nonatomic , strong) NSArray               * topGoods;
@end

NS_ASSUME_NONNULL_END
