//
//  Role.h
//  VApiSDK_iOS
//
//  Created by duocai on 14-6-14.
//  Copyright (c) 2014年 duocai. All rights reserved.
//

#import "Mantle.h"

@interface PostBO : MTLModel <MTLJSONSerializing>

	//帖子id
	@property (nonatomic, readonly, copy) NSNumber *apiId;
	//添加时间
	@property (nonatomic, readonly, copy) NSDate *addTime;
	//帖子标题
	@property (nonatomic, readonly, copy) NSString *title;
	//帖子内容
	@property (nonatomic, readonly, copy) NSString *content;
	//帖子点赞数
	@property (nonatomic, readonly, copy) NSNumber *praiseNum;
	//帖子评论数
	@property (nonatomic, readonly, copy) NSNumber *evaluateNum;
	//帖子图片路径
	@property (nonatomic, readonly, copy) NSString *thumbnail;
	//帖子标签名称
	@property (nonatomic, readonly, copy) NSString *labelName;
	//帖子标签id
	@property (nonatomic, readonly, copy) NSString *labelId;
	//发帖人名称
	@property (nonatomic, readonly, copy) NSString *nickname;
	//发帖人位置信息
	@property (nonatomic, readonly, copy) NSString *location;
	
@end
