//
//  AppInitResponse.h
//  VApiSDK_iOS
//
//  Created by duocai on 14-6-16.
//  Copyright (c) 2014年 duocai. All rights reserved.
//


#import "AbstractResponse.h"


@interface PostPostDetailResponse :  AbstractResponse
//帖子列表
@property (nonatomic, readonly, copy) NSArray *postList;
//总记录
@property (nonatomic, readonly, copy) NSNumber *totalCount;
//帖子对象
@property (nonatomic, readonly, copy) NSDictionary *post;
//用户对象
@property (nonatomic, readonly, copy) NSDictionary *userCustomer;
//是否登录
@property (nonatomic, readonly, copy) NSNumber *islogin;
@end
