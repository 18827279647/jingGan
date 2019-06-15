//
//  AppInitResponse.m
//  VApiSDK_iOS
//
//  Created by duocai on 14-6-16.
//  Copyright (c) 2014年 duocai. All rights reserved.
//

#import "VersionControlGetNewResponse.h"

@implementation VersionControlGetNewResponse
+(NSDictionary *) JSONKeyPathsByPropertyKey {
    return @{
             @"errorCode":@"code",
             @"msg":@"msg",
             @"subCode":@"sub_code",
             @"subMsg":@"sub_msg",
			@"sysVersionControlBO":@"SysVersionControlBO"
             };
}

+(NSValueTransformer *) sysVersionControlBOTransformer
{
    return [NSValueTransformer mtl_JSONDictionaryTransformerWithModelClass:[SysVersionControlBO class]];
}
@end
