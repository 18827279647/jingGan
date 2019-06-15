//
//  YSMakeDetailResponse.m
//  jingGang
//
//  Created by whlx on 2019/5/9.
//  Copyright © 2019年 dengxf_dev. All rights reserved.
//

#import "YSMakeDetailResponse.h"

#import "YSMakeModel.h"

@implementation YSMakeDetailResponse
+(NSDictionary *) JSONKeyPathsByPropertyKey {
    return @{
             @"customer":@"customer",
             @"list":@"list",
             };
}
+(NSValueTransformer *) juanpiShareTransformer
{
    return [NSValueTransformer mtl_JSONDictionaryTransformerWithModelClass:[YSMakeModel class]];
}
@end
