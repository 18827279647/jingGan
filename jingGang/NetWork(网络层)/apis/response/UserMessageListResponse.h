//
//  AppInitResponse.h
//  VApiSDK_iOS
//
//  Created by duocai on 14-6-16.
//  Copyright (c) 2014年 duocai. All rights reserved.
//


#import "AbstractResponse.h"
#import "APIMessageBO.h"

@interface UserMessageListResponse :  AbstractResponse
//个人消息集合
@property (nonatomic, readonly, copy) NSArray *messages;
//未读消息数目
@property (nonatomic, readonly, copy) NSNumber *unreadMessageNo;
//已读消息数目
@property (nonatomic, readonly, copy) NSNumber *readMessageNo;
@end
