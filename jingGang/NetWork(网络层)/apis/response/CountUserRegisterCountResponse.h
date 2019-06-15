//
//  AppInitResponse.h
//  VApiSDK_iOS
//
//  Created by duocai on 14-6-16.
//  Copyright (c) 2014年 duocai. All rights reserved.
//


#import "AbstractResponse.h"

@interface CountUserRegisterCountResponse :  AbstractResponse
//注册会员总数
@property (nonatomic, readonly, copy) NSNumber *userRegisterCount;
//返回标签
@property (nonatomic, readonly, copy) NSString *result;
@end
