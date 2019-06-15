//
//  AppInitResponse.h
//  VApiSDK_iOS
//
//  Created by duocai on 14-6-16.
//  Copyright (c) 2014年 duocai. All rights reserved.
//


#import "AbstractResponse.h"
#import "APIMessageBO.h"

@interface UserMessageDetailResponse :  AbstractResponse
//消息详情
@property (nonatomic, readonly, copy) APIMessageBO *message;
@end
