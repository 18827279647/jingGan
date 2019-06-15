//
//  AppInitResponse.h
//  VApiSDK_iOS
//
//  Created by duocai on 14-6-16.
//  Copyright (c) 2014年 duocai. All rights reserved.
//


#import "AbstractResponse.h"
#import "StepRecord.h"

@interface EquipDayQueryByRangeResponse :  AbstractResponse
//总步数
@property (nonatomic, readonly, copy) NSNumber *stepNumber;
//卡路里
@property (nonatomic, readonly, copy) NSNumber *calories;
//总里程
@property (nonatomic, readonly, copy) NSNumber *distance;
//一周数据
@property (nonatomic, readonly, copy) NSArray *weekStep;
//日期范围内的总步数记录
@property (nonatomic, readonly, copy) NSNumber *totalStepNumber;
//日期范围内的总卡路里记录
@property (nonatomic, readonly, copy) NSNumber *totalCalories;
//日期范围内的总里程记录
@property (nonatomic, readonly, copy) NSNumber *totalDistance;
@end
