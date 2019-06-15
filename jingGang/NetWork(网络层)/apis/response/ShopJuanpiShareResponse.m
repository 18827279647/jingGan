//
//  AppInitResponse.m
//  VApiSDK_iOS
//
//  Created by duocai on 14-6-16.
//  Copyright (c) 2014年 duocai. All rights reserved.
//

#import "ShopJuanpiShareResponse.h"

@implementation ShopJuanpiShareResponse
+(NSDictionary *) JSONKeyPathsByPropertyKey {
    return @{
             @"errorCode":@"code",
             @"msg":@"msg",
             @"subCode":@"sub_code",
             @"subMsg":@"sub_msg",
			@"juanpiShare":@"juanpiShare"
             };
}

+(NSValueTransformer *) juanpiShareTransformer
{
    return [NSValueTransformer mtl_JSONDictionaryTransformerWithModelClass:[JuanpiShareBO class]];
}
@end
