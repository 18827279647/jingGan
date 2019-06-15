//
//  AppInitResponse.h
//  VApiSDK_iOS
//
//  Created by duocai on 14-6-16.
//  Copyright (c) 2014年 duocai. All rights reserved.
//


#import "AbstractResponse.h"
//#import "TodayHealthTaskBO.h"
//#import "HealthCircleBo.h"
//#import "UserCustomerBO.h"
//#import "UserQuestionnaireBO.h"

@interface HealthManageIndex2Response :  AbstractResponse
//会员信息
@property (nonatomic, readonly, copy) NSDictionary *userCustomer;
//会员问卷调查
@property (nonatomic, readonly, copy) NSDictionary *userQuestionnaire;
//今日健康任务
@property (nonatomic, readonly, copy) NSDictionary *todayTaskList;
//健康圈
@property (nonatomic, readonly, copy) NSDictionary *healthCircles;
@end
