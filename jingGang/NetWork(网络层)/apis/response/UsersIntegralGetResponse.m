//
//  AppInitResponse.m
//  VApiSDK_iOS
//
//  Created by duocai on 14-6-16.
//  Copyright (c) 2014年 duocai. All rights reserved.
//

#import "UsersIntegralGetResponse.h"

@implementation UsersIntegralGetResponse
+(NSDictionary *) JSONKeyPathsByPropertyKey {
    return @{
             @"errorCode":@"code",
             @"msg":@"msg",
             @"subCode":@"sub_code",
             @"subMsg":@"sub_msg",
			@"integral":@"integral",
			@"integralToday":@"integralToday",
			@"integralOther":@"integralOther"
             };
}

+(NSValueTransformer *) integralTransformer
{
    return [NSValueTransformer mtl_JSONDictionaryTransformerWithModelClass:[UserIntegral class]];
}
+(NSValueTransformer *) integralTodayTransformer
{
    return [NSValueTransformer mtl_JSONDictionaryTransformerWithModelClass:[IntegerTodayBO class]];
}
+(NSValueTransformer *) integralOtherTransformer
{
    return [NSValueTransformer mtl_JSONDictionaryTransformerWithModelClass:[IntegerTodayBO class]];
}
@end
