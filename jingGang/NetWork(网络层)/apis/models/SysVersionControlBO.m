//
//  Role.m
//  VApiSDK_iOS
//
//  Created by duocai on 14-6-14.
//  Copyright (c) 2014年 duocai. All rights reserved.
//

#import "SysVersionControlBO.h"

@implementation SysVersionControlBO
+(NSDictionary *) JSONKeyPathsByPropertyKey {
    return @{
			@"apiId":@"id",
			@"addTime":@"addTime",
			@"vcType":@"vcType",
			@"vcNumber":@"vcNumber",
			@"vcDescribe":@"vcDescribe",
			@"ifOpen":@"ifOpen",
			@"ifMandatory":@"ifMandatory",
			@"downloads":@"downloads",
			@"downloadUrl":@"downloadUrl",
			@"vcState":@"vcState"
             };
}

@end
