//
//  Role.h
//  VApiSDK_iOS
//
//  Created by duocai on 14-6-14.
//  Copyright (c) 2014年 duocai. All rights reserved.
//

#import "Mantle.h"

@interface IntegerTodayBO : MTLModel <MTLJSONSerializing>

	//今日完成次数
	@property (nonatomic, readonly, copy) NSNumber *todayTimes;
	//今日剩余次数
	@property (nonatomic, readonly, copy) NSNumber *uFtimes;
	//今日完成情况
	@property (nonatomic, readonly, copy) NSNumber *uF;
	//积分名称
	@property (nonatomic, readonly, copy) NSString *name;
	//积分标识 
	@property (nonatomic, readonly, copy) NSString *type;
	//积分完成次数限制类型（1：无次数限制 2：总次数限制 3：日次数限制）
	@property (nonatomic, readonly, copy) NSNumber *timesLimitType;
	//完成次数限制
	@property (nonatomic, readonly, copy) NSNumber *times;
	//积分数 
	@property (nonatomic, readonly, copy) NSNumber *integral;
	
@end
