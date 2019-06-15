//
//  TopCommodityResponse.m
//  jingGang
//
//  Created by whlx on 2019/4/9.
//  Copyright © 2019年 dengxf_dev. All rights reserved.
//

#import "TopCommodityResponse.h"
#import "TopCommodityModels.h"
@implementation TopCommodityResponse
+(NSDictionary *) JSONKeyPathsByPropertyKey {
    return @{
             @"errorCode":@"code",
             @"msg":@"msg",
             @"subCode":@"sub_code",
             @"subMsg":@"sub_msg",
             @"yijianke":@"yijianke",
             @"invitationCode":@"invitationCode",
             @"lastTime":@"lastTime",
              @"topGoods":@"topGoods"
             };
}

+(NSValueTransformer *) juanpiShareTransformer
{
    return [NSValueTransformer mtl_JSONDictionaryTransformerWithModelClass:[TopCommodityModels class]];
}
@end
