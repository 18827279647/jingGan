//
//  YQNumberResponse.m
//  jingGang
//
//  Created by whlx on 2019/4/8.
//  Copyright © 2019年 dengxf_dev. All rights reserved.
//

#import "YQNumberResponse.h"
#import "YQNumberModes.h"
@implementation YQNumberResponse
+(NSDictionary *) JSONKeyPathsByPropertyKey {
    return @{
             @"errorCode":@"code",
             @"msg":@"msg",
             @"subCode":@"sub_code",
             @"subMsg":@"sub_msg",
             @"users":@"users",
             @"money":@"money",
             @"num":@"num",
             };
}

+(NSValueTransformer *) juanpiShareTransformer
{
    return [NSValueTransformer mtl_JSONDictionaryTransformerWithModelClass:[YQNumberModes class]];
}
@end
