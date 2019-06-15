//
//  Role.h
//  VApiSDK_iOS
//
//  Created by duocai on 14-6-14.
//  Copyright (c) 2014年 duocai. All rights reserved.
//

#import "Mantle.h"

@interface APIMessageBO : MTLModel <MTLJSONSerializing>

	//消息ID
	@property (nonatomic, readonly, copy) NSNumber *apiId;
	//添加时间
	@property (nonatomic, readonly, copy) NSDate *addTime;
	//删除状态
	@property (nonatomic, readonly, copy) NSNumber *deleteStatus;
	//短信回复第一次 0为第一次发送短信，1为短信回复
	@property (nonatomic, readonly, copy) NSNumber *msgCat;
	//短信回复状态 0为没有回复，1为有新回复
	@property (nonatomic, readonly, copy) NSNumber *replyStatus;
	//短信状态0是未读，1为已读
	@property (nonatomic, copy) NSNumber *status;
	//短信标题
	@property (nonatomic, readonly, copy) NSString *title;
	//短信类型 0为系统短信，1为用户之间的短信
	@property (nonatomic, readonly, copy) NSNumber *type;
	//发送用户
	@property (nonatomic, readonly, copy) NSNumber *fromUserId;
	//父级
	@property (nonatomic, readonly, copy) NSNumber *parentId;
	//接收用户
	@property (nonatomic, readonly, copy) NSNumber *toUserId;
	//短信内容
	@property (nonatomic, readonly, copy) NSString *content;
	//错误信息
	@property (nonatomic, readonly, copy) NSString *errorMsg;
	//缩略图
	@property (nonatomic, readonly, copy) NSString *thumbnail;
	//消息摘要
	@property (nonatomic, readonly, copy) NSString *digest;
	//页面类型 1.H5链接 2商品 5服务商户 6服务 7原生
	@property (nonatomic, readonly, copy) NSNumber *pageType;
	//接受类型 1-只读,4-链接,3-富文本
	@property (nonatomic, readonly, copy) NSString *receiveType;
	//富文本内容
	@property (nonatomic, readonly, copy) NSString *richText;
	//显示时间
	@property (nonatomic, readonly, copy) NSString *showTime;
	//消息链接
	@property (nonatomic, readonly, copy) NSString *linkUrl;
	//置顶 1置顶
	@property (nonatomic, readonly, copy) NSString *topIndex;
	
@end
