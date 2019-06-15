//
//  YHJResponse.m
//  jingGang
//
//  Created by whlx on 2019/3/8.
//  Copyright © 2019年 dengxf_dev. All rights reserved.
//

#import "YHJResponse.h"

@implementation YHJResponse
+(NSDictionary *) JSONKeyPathsByPropertyKey {
    return @{
             @"errorCode":@"code",
             @"msg":@"msg",
             @"subCode":@"sub_code",
             @"subMsg":@"sub_msg",
             @"shopCouponList":@"shopCouponList"
             
             };
}

+(NSValueTransformer *) juanpiShareTransformer
{
    return [NSValueTransformer mtl_JSONDictionaryTransformerWithModelClass:[YHJModel class]];
}
@end
