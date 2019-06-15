//
//  AppInitResponse.h
//  VApiSDK_iOS
//
//  Created by duocai on 14-6-16.
//  Copyright (c) 2014年 duocai. All rights reserved.
//


#import "AbstractResponse.h"
#import "PostBO.h"
#import "PostEvaluateBO.h"
#import "UserBO.h"

@interface PostPostListLoginResponse :  AbstractResponse
//帖子列表
@property (nonatomic, readonly, copy) NSArray *postList;
//评论列表
@property (nonatomic, readonly, copy) NSArray *evaluateList;
//总记录
@property (nonatomic, readonly, copy) NSNumber *totalCount;
//帖子对象
@property (nonatomic, readonly, copy) PostBO *post;
//用户对象
@property (nonatomic, readonly, copy) UserBO *userCustomer;
//点赞集合
@property (nonatomic, readonly, copy) NSArray *praiseList;
//是否登录
@property (nonatomic, readonly, copy) NSNumber *islogin;
@end
