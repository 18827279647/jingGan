//
//  AppInitResponse.m
//  VApiSDK_iOS
//
//  Created by duocai on 14-6-16.
//  Copyright (c) 2014年 duocai. All rights reserved.
//

#import "PostPostListLoginResponse.h"

@implementation PostPostListLoginResponse
+(NSDictionary *) JSONKeyPathsByPropertyKey {
    return @{
             @"errorCode":@"code",
             @"msg":@"msg",
             @"subCode":@"sub_code",
             @"subMsg":@"sub_msg",
			@"postList":@"postList",
			@"evaluateList":@"evaluateList",
			@"totalCount":@"totalCount",
			@"post":@"post",
			@"userCustomer":@"userCustomer",
			@"praiseList":@"praiseList",
			@"islogin":@"islogin"
             };
}

+(NSValueTransformer *) postListTransformer
{
    return [NSValueTransformer mtl_JSONDictionaryTransformerWithModelClass:[PostBO class]];
}
+(NSValueTransformer *) evaluateListTransformer
{
    return [NSValueTransformer mtl_JSONDictionaryTransformerWithModelClass:[PostEvaluateBO class]];
}
+(NSValueTransformer *) postTransformer
{
    return [NSValueTransformer mtl_JSONDictionaryTransformerWithModelClass:[PostBO class]];
}
+(NSValueTransformer *) userCustomerTransformer
{
    return [NSValueTransformer mtl_JSONDictionaryTransformerWithModelClass:[UserBO class]];
}
+(NSValueTransformer *) praiseListTransformer
{
    return [NSValueTransformer mtl_JSONDictionaryTransformerWithModelClass:[PostEvaluateBO class]];
}
@end
