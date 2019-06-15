//
//  JGRedCardModel.m
//  jingGang
//
//  Created by hlguo2 on 2019/4/25.
//  Copyright © 2019 dengxf_dev. All rights reserved.
//

#import "JGRedCardModel.h"

@implementation JGRedCardModel

+(NSDictionary *) JSONKeyPathsByPropertyKey {
    return @{
             
             @"apiId":@"id",
             @"addTime":@"addTime",
             @"deleteStatus":@"deleteStatus",
             @"couponSn":@"couponSn",
             @"status":@"status",
             @"couponId":@"couponId",
             @"userId":@"userId",
             @"confirm":@"confirm",
             @"coupon":@"coupon",
             @"type":@"type"
             };
}


@end
