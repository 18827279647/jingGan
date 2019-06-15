//
//  Role.m
//  VApiSDK_iOS
//
//  Created by duocai on 14-6-14.
//  Copyright (c) 2014年 duocai. All rights reserved.
//

#import "UserCustomerBO.h"

@implementation UserCustomerBO
+(NSDictionary *) JSONKeyPathsByPropertyKey {
    return @{
			@"uid":@"uid",
			@"name":@"name",
			@"nickName":@"nickName",
			@"headImgPath":@"headImgPath",
			@"currentRank":@"currentRank",
			@"highestRank":@"highestRank",
			@"rankJiFen":@"rankJiFen",
			@"sex":@"sex"
             };
}

@end
