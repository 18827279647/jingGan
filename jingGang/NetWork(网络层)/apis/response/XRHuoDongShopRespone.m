//
//  XRHuoDongShopRespone.m
//  jingGang
//
//  Created by whlx on 2019/4/8.
//  Copyright © 2019年 dengxf_dev. All rights reserved.
//

#import "XRHuoDongShopRespone.h"
#import "XRHuoDongShopModels.h"
@implementation XRHuoDongShopRespone
+(NSDictionary *) JSONKeyPathsByPropertyKey {
    return @{
             @"errorCode":@"code",
             @"msg":@"msg",
             @"subCode":@"sub_code",
             @"subMsg":@"sub_msg",
             @"goods":@"goods"
             
             };
}

+(NSValueTransformer *) juanpiShareTransformer
{
    return [NSValueTransformer mtl_JSONDictionaryTransformerWithModelClass:[XRHuoDongShopModels class]];
}
@end
