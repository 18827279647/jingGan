//
//  AppInitResponse.h
//  VApiSDK_iOS
//
//  Created by duocai on 14-6-16.
//  Copyright (c) 2014年 duocai. All rights reserved.
//


#import "AbstractResponse.h"
#import "NSObject+AutoEncode.h"

@interface HealthManageIndexResponse :  AbstractResponse
//会员信息
@property (nonatomic, readonly, copy) NSDictionary *userCustomer;
//会员问卷调查
@property (nonatomic, readonly, copy) NSDictionary *userQuestionnaire;
//今日健康任务
@property (nonatomic, readonly, copy) NSDictionary *todayTaskList;
//健康圈
@property (nonatomic, readonly, copy) NSDictionary *healthCircles;

//用户未做疾病自测题时，返回疾病自测访问地址
@property (nonatomic, readonly, copy) NSString *jiBingURL;
//用户已做疾病自测题时，返回养生访问地址
@property (nonatomic, readonly, copy) NSString *yangShengURL;
//用户已做疾病自测题时，返回膳食访问地址
@property (nonatomic, readonly, copy) NSString *shanShiURL;
//重测访问地址
@property (nonatomic, readonly, copy) NSString *retestURL;

@end
