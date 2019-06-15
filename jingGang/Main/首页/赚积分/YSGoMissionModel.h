//
//  YSGoMissionModel.h
//  jingGang
//
//  Created by HanZhongchou on 16/8/25.
//  Copyright © 2016年 dengxf_dev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YSGoMissionModel : NSObject
/**
 *  积分完成次数限制类型（1：无次数限制 2：总次数限制 3：日次数限制）

 */
@property (nonatomic, assign) NSInteger timesLimitType;
/**
 *  积分标识
 */
@property (nonatomic,copy) NSString *type;
/**
 *  积分名称
 */
@property (nonatomic,copy) NSString *name;
/**
 *  今日完成情况
 */
@property (nonatomic,assign) NSInteger UF;

/**
 *  今日完成次数
 */
@property (nonatomic,assign) NSInteger today_times;
/**
 *  今日剩余次数
 */
@property (nonatomic,assign) NSInteger UFtimes;
/**
 *  完成次数限制
 */
@property (nonatomic, assign) NSInteger times;
/**
 *  积分数
 */
@property (nonatomic, assign) NSInteger integral;

@end
