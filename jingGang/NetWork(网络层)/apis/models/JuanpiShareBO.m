//
//  Role.m
//  VApiSDK_iOS
//
//  Created by duocai on 14-6-14.
//  Copyright (c) 2014年 duocai. All rights reserved.
//

#import "JuanpiShareBO.h"

@implementation JuanpiShareBO
+(NSDictionary *) JSONKeyPathsByPropertyKey {
    return @{
			@"apiId":@"id",
			@"mark":@"mark",
			@"shareId":@"shareId",
			@"titleClass":@"titleClass",
			@"title":@"title",
			@"imgClass":@"imgClass",
			@"imgUrl":@"imgUrl",
			@"url":@"url",
			@"context":@"context"
             };
}

@end
