//
//  AppInitResponse.m
//  VApiSDK_iOS
//
//  Created by duocai on 14-6-16.
//  Copyright (c) 2014年 duocai. All rights reserved.
//

#import "ShopTradeOrderCreateResponse.h"

@implementation ShopTradeOrderCreateResponse
+(NSDictionary *) JSONKeyPathsByPropertyKey {
    return @{
             @"errorCode":@"code",
             @"msg":@"msg",
             @"subCode":@"sub_code",
             @"subMsg":@"sub_msg",
			@"order":@"order",
			@"totalPrice":@"totalPrice",
			@"ygPayMode":@"ygPayMode",
			@"payTypeFlag":@"payTypeFlag"
             };
}

+(NSValueTransformer *) orderTransformer
{
    return [NSValueTransformer mtl_JSONDictionaryTransformerWithModelClass:[OrderForm class]];
}
+(NSValueTransformer *) ygPayModeTransformer
{
    return [NSValueTransformer mtl_JSONDictionaryTransformerWithModelClass:[ygPayMode class]];
}
@end
