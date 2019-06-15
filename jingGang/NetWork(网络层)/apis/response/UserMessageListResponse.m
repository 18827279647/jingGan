//
//  AppInitResponse.m
//  VApiSDK_iOS
//
//  Created by duocai on 14-6-16.
//  Copyright (c) 2014年 duocai. All rights reserved.
//

#import "UserMessageListResponse.h"

@implementation UserMessageListResponse
+(NSDictionary *) JSONKeyPathsByPropertyKey {
    return @{
             @"errorCode":@"code",
             @"msg":@"msg",
             @"subCode":@"sub_code",
             @"subMsg":@"sub_msg",
			@"messages":@"messages",
			@"unreadMessageNo":@"unreadMessageNo",
			@"readMessageNo":@"readMessageNo"
             };
}

+(NSValueTransformer *) messagesTransformer
{
    return [NSValueTransformer mtl_JSONDictionaryTransformerWithModelClass:[APIMessageBO class]];
}
@end
