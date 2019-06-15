//
//  JGRedCardSucResponse.m
//  jingGang
//
//  Created by hlguo2 on 2019/4/25.
//  Copyright © 2019 dengxf_dev. All rights reserved.
//

#import "JGRedCardSucResponse.h"
#import "JGRedCardModel.h"

@implementation JGRedCardSucResponse

+(NSDictionary *) JSONKeyPathsByPropertyKey {
    return @{
             @"couponNum":@"couponNum",
             @"redNum":@"redNum",
             @"integral":@"integral",
             @"coups":@"coups"
             };
}

+(NSValueTransformer *) coupsTransformer
{
    return [NSValueTransformer mtl_JSONDictionaryTransformerWithModelClass:[JGRedCardModel class]];
}

@end
