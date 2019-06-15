//
//  AppInitResponse.m
//  VApiSDK_iOS
//
//  Created by duocai on 14-6-16.
//  Copyright (c) 2014年 duocai. All rights reserved.
//

#import "PostPostDetailResponse.h"

@implementation PostPostDetailResponse
+(NSDictionary *) JSONKeyPathsByPropertyKey {
    return @{
             @"errorCode":@"code",
             @"msg":@"msg",
             @"subCode":@"sub_code",
             @"subMsg":@"sub_msg",
             @"postList":@"postList",
             @"totalCount":@"totalCount",
             @"post":@"post",
             @"userCustomer":@"userCustomer",
             @"islogin":@"islogin"
             };
}

//+(NSValueTransformer *) postListTransformer
//{
//    return [NSValueTransformer mtl_JSONDictionaryTransformerWithModelClass:[PostBO class]];
//}
//+(NSValueTransformer *) postTransformer
//{
//    return [NSValueTransformer mtl_JSONDictionaryTransformerWithModelClass:[PostBO class]];
//}
//+(NSValueTransformer *) userCustomerTransformer
//{
//    return [NSValueTransformer mtl_JSONDictionaryTransformerWithModelClass:[UserBO class]];
//}
@end
