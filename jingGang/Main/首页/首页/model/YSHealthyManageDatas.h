//
//  YSHealthyManageDatas.h
//  jingGang
//
//  Created by dengxf on 16/8/13.
//  Copyright © 2016年 Dengxf_Dev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YSHealthyManageDatas : NSObject

@end


/**
 *  会员信息 */
@interface YSUserCustomer : NSObject

@property (copy , nonatomic) NSString *currentRank;
@property (copy , nonatomic) NSString *headImgPath;
@property (copy , nonatomic) NSString *highestRank;
@property (copy , nonatomic) NSString *name;
@property (copy , nonatomic) NSString *nickName;
@property (copy , nonatomic) NSDictionary *rankJiFen;
@property (copy , nonatomic) NSString *sex;
@property (copy , nonatomic) NSString *uid;
@property (copy , nonatomic) NSString *integral;

/**
 *  1.请求成功 2.请求失败 */
@property (assign, nonatomic) NSInteger successCode;

@end


@interface YSQuestionnaire : NSObject
@property (copy , nonatomic) NSString *userid;
@property (copy , nonatomic) NSString *totalStore;
@property (copy , nonatomic) NSString *isHigh;
@property (copy , nonatomic) NSString *isYjk;
@property (copy , nonatomic) NSString *isHealthy;
@property (copy , nonatomic) NSString *isChronic;
@property (strong , nonatomic) NSArray * proposalList;
@property (strong , nonatomic) NSArray * improveList;
@property (copy , nonatomic) NSString *result;
@property (copy , nonatomic) NSString *content;
/**
 *  1.请求成功 2.请求失败 */
@property (assign, nonatomic) NSInteger successCode;

@end

@interface YSTodayTaskList : NSObject

/**
 *  200 为有数据   210 没数据 */
@property (copy , nonatomic) NSString *result;
@property (copy , nonatomic) NSString *content;
@property (strong,nonatomic) NSArray *healthTaskList;
/**
 *  1.请求成功 2.请求失败 */
@property (assign, nonatomic) NSInteger successCode;
@end

@interface YSHealthTaskList : NSObject

@property (copy, nonatomic) NSString *finishState;
@property (copy , nonatomic) NSString *taskId;
@property (copy , nonatomic) NSString *joinNum;
@property (copy , nonatomic) NSString *taskName;
@property (copy , nonatomic) NSString *describe;
@property (copy , nonatomic) NSString *iconURL;
@property (copy , nonatomic) NSString *yinDaoURL;
@property (copy , nonatomic) NSString *finishTaskURL;

@end


