//
//  Role.m
//  VApiSDK_iOS
//
//  Created by duocai on 14-6-14.
//  Copyright (c) 2014年 duocai. All rights reserved.
//

#import "APIMessageBO.h"

@implementation APIMessageBO
+(NSDictionary *) JSONKeyPathsByPropertyKey {
    return @{
			@"apiId":@"id",
			@"addTime":@"addTime",
			@"deleteStatus":@"deleteStatus",
			@"msgCat":@"msgCat",
			@"replyStatus":@"replyStatus",
			@"status":@"status",
			@"title":@"title",
			@"type":@"type",
			@"fromUserId":@"fromUserId",
			@"parentId":@"parentId",
			@"toUserId":@"toUserId",
			@"content":@"content",
			@"errorMsg":@"errorMsg",
			@"thumbnail":@"thumbnail",
			@"digest":@"digest",
			@"pageType":@"pageType",
			@"receiveType":@"receiveType",
			@"richText":@"richText",
			@"showTime":@"showTime",
			@"linkUrl":@"linkUrl",
			@"topIndex":@"topIndex"
             };
}

@end
