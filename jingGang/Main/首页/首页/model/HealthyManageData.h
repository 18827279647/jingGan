//
//  HealthyManageSuggestionData.h
//  jingGang
//
//  Created by dengxf on 16/7/22.
//  Copyright © 2016年 Dengxf_Dev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YSHealthyManageDatas.h"

/**
 *  0:全部,1:热门 */
typedef NS_ENUM(NSUInteger, YSCircleDataType) {
    YSCircleDataWithAllType = 0,
    YSCircleDataWithHotType
};


typedef NS_ENUM(NSUInteger, YSLoginRequestStatus) {
    /**
     *  未登录 */
    YSUserUnloginedStatus = 0,
    /**
     *  已登录 */
    YSUserLoginedStatus
};

@class YSHealthyManageTestLinkConfig;

@interface HealthyManageData : NSObject


/**
 *  健康修改建议数据模型 */
+ (NSArray *)suggestDatasWithQuestionnaire:(YSQuestionnaire *)questionnaire;

/**
 *  健康任务 */
+ (NSArray *)taskDatasWithTaskList:(YSTodayTaskList *)taskList;

/**
 *  健康 */
+ (NSArray *)healthyDatas;

+ (NSArray *)randomDatas;

/**
 *  健康圈请求数据
 */
+ (void)circleDatasWithType:(YSCircleDataType)type
                 pageNumber:(NSInteger)pageNumber
                   pageSize:(NSInteger)pageSize
                    success:(void(^)(NSArray *,YSLoginRequestStatus loginStatus))success
                       fail:(voidCallback)fail
                loginStatus:(BOOL)loginStatus;

/**
 *  已登录健康管理接口 */
+ (void)healthyManagerSuccess:(void(^)(YSUserCustomer *,YSQuestionnaire *, NSArray *,YSTodayTaskList *,YSHealthyManageTestLinkConfig *))successCallback
                         fail:(voidCallback)failCallback
                        error:(voidCallback)errorCallback
                    unlogined:(void(^)(NSArray *))unloginedCallback isCache:(BOOL)isCache;

@end
