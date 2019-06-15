//
//  AppInitResponse.m
//  VApiSDK_iOS
//
//  Created by duocai on 14-6-16.
//  Copyright (c) 2014年 duocai. All rights reserved.
//

#import "UsersYunGouMoneyListResponse.h"

@implementation UsersYunGouMoneyListResponse
+(NSDictionary *) JSONKeyPathsByPropertyKey {
    return @{
             @"errorCode":@"code",
             @"msg":@"msg",
             @"subCode":@"sub_code",
             @"subMsg":@"sub_msg",
			@"userYunGouMoneyBO":@"UserYunGouMoneyBO",
			@"yunGouMoney":@"yunGouMoney"
             };
}

+(NSValueTransformer *) userYunGouMoneyBOTransformer
{
    return [NSValueTransformer mtl_JSONDictionaryTransformerWithModelClass:[UserYunGouMoney class]];
}
@end
