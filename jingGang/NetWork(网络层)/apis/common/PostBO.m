//
//  Role.m
//  VApiSDK_iOS
//
//  Created by duocai on 14-6-14.
//  Copyright (c) 2014年 duocai. All rights reserved.
//

#import "PostBO.h"

@implementation PostBO
+(NSDictionary *) JSONKeyPathsByPropertyKey {
    return @{
			@"apiId":@"id",
			@"addTime":@"addTime",
			@"title":@"title",
			@"content":@"content",
			@"praiseNum":@"praiseNum",
			@"evaluateNum":@"evaluateNum",
			@"thumbnail":@"thumbnail",
			@"labelName":@"labelName",
			@"labelId":@"labelId",
			@"nickname":@"nickname",
			@"location":@"location"
             };
}

@end
