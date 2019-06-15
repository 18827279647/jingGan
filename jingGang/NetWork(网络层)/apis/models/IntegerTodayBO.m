//
//  Role.m
//  VApiSDK_iOS
//
//  Created by duocai on 14-6-14.
//  Copyright (c) 2014年 duocai. All rights reserved.
//

#import "IntegerTodayBO.h"

@implementation IntegerTodayBO
+(NSDictionary *) JSONKeyPathsByPropertyKey {
    return @{
			@"todayTimes":@"today_times",
			@"uFtimes":@"UFtimes",
			@"uF":@"UF",
			@"name":@"name",
			@"type":@"type",
			@"timesLimitType":@"timesLimitType",
			@"times":@"times",
			@"integral":@"integral"
             };
}

@end
