//
//  Role.m
//  VApiSDK_iOS
//
//  Created by duocai on 14-6-14.
//  Copyright (c) 2014年 duocai. All rights reserved.
//

#import "UserYunGouMoney.h"

@implementation UserYunGouMoney
+(NSDictionary *) JSONKeyPathsByPropertyKey {
    return @{
			@"dateTime":@"dateTime",
			@"type":@"type",
			@"payType":@"payType",
			@"usedRepeatMoney":@"usedRepeatMoney",
			@"usedBonusPrice":@"usedBonusPrice"
             };
}

@end
