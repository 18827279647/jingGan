//
//  AppInitResponse.m
//  VApiSDK_iOS
//
//  Created by duocai on 14-6-16.
//  Copyright (c) 2014年 duocai. All rights reserved.
//

#import "PostPostEvalueteResponse.h"

@implementation PostPostEvalueteResponse
+(NSDictionary *) JSONKeyPathsByPropertyKey {
    return @{
             @"errorCode":@"code",
             @"msg":@"msg",
             @"subCode":@"sub_code",
             @"subMsg":@"sub_msg",
             @"evalBO":@"evalBO",
             @"result":@"result"
             };
}

+(NSValueTransformer *) evalBOTransformer
{
    return [NSValueTransformer mtl_JSONDictionaryTransformerWithModelClass:[PostEvaluateBO class]];
}
@end
