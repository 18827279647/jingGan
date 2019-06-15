//
//  AppInitResponse.m
//  VApiSDK_iOS
//
//  Created by duocai on 14-6-16.
//  Copyright (c) 2014年 duocai. All rights reserved.
//

#import "UsersMobileGoBindResponse.h"

@implementation UsersMobileGoBindResponse
+(NSDictionary *) JSONKeyPathsByPropertyKey {
    return @{
             @"errorCode":@"code",
             @"msg":@"msg",
             @"subCode":@"sub_code",
             @"subMsg":@"sub_msg",
			@"isBindMobile":@"isBindMobile",
			@"isCn":@"isCn",
			@"isLogin":@"isLogin"
             };
}

@end
