//
//  Role.h
//  VApiSDK_iOS
//
//  Created by duocai on 14-6-14.
//  Copyright (c) 2014年 duocai. All rights reserved.
//

#import "Mantle.h"

@interface PostEvaluateBO : MTLModel <MTLJSONSerializing>

	//帖子id
	@property (nonatomic, readonly, copy) NSNumber *apiId;
	//评论内容
	@property (nonatomic, readonly, copy) NSString *content;
	//被回复者姓名
	@property (nonatomic, readonly, copy) NSString *toUserName;
	//回复者姓名
	@property (nonatomic, readonly, copy) NSString *fromUserName;
	//被回复者id
	@property (nonatomic, readonly, copy) NSNumber *toUserid;
	//回复者id
	@property (nonatomic, readonly, copy) NSNumber *fromUserid;
	
@end
