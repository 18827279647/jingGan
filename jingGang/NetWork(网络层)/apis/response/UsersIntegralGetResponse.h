//
//  AppInitResponse.h
//  VApiSDK_iOS
//
//  Created by duocai on 14-6-16.
//  Copyright (c) 2014年 duocai. All rights reserved.
//


#import "AbstractResponse.h"
#import "IntegerTodayBO.h"
#import "UserIntegral.h"

@interface UsersIntegralGetResponse :  AbstractResponse
//用户积分信息
@property (nonatomic, readonly, copy) UserIntegral *integral;
//用户今日积分任务情况
@property (nonatomic, readonly, copy) NSArray *integralToday;
//用户一次性积分任务情况
@property (nonatomic, readonly, copy) NSArray *integralOther;
@end
