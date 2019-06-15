//
//  Role.m
//  VApiSDK_iOS
//
//  Created by duocai on 14-6-14.
//  Copyright (c) 2014年 duocai. All rights reserved.
//

#import "PostEvaluateBO.h"

@implementation PostEvaluateBO
+(NSDictionary *) JSONKeyPathsByPropertyKey {
    return @{
			@"apiId":@"id",
			@"content":@"content",
			@"toUserName":@"toUserName",
			@"fromUserName":@"fromUserName",
			@"toUserid":@"toUserid",
			@"fromUserid":@"fromUserid"
             };
}

@end
