//
//  PDNumberListResponse.m
//  jingGang
//
//  Created by whlx on 2019/4/10.
//  Copyright © 2019年 dengxf_dev. All rights reserved.
//

#import "PDNumberListResponse.h"
#import "PDNumberListModels.h"
@implementation PDNumberListResponse
+(NSDictionary *) JSONKeyPathsByPropertyKey {
    return @{
             @"errorCode":@"code",
             @"msg":@"msg",
             @"subCode":@"sub_code",
             @"subMsg":@"sub_msg",
         
             @"orderPinDantList":@"orderPinDantList"
             };
}

+(NSValueTransformer *) juanpiShareTransformer
{
    return [NSValueTransformer mtl_JSONDictionaryTransformerWithModelClass:[PDNumberListModels class]];
}
@end
