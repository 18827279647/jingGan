//
//  YSHealthySeleTestWebController.h
//  jingGang
//
//  Created by dengxf on 16/8/14.
//  Copyright © 2016年 Dengxf_Dev. All rights reserved.
//

#import "YSBaseController.h"
#import "YSHealthyMessageDatas.h"

typedef NS_ENUM(NSUInteger, YSHealthyManageWebType) {
    /**
     *  健康测试 */
    YSHealthyManageHealthyTestType = 0,
    /**
     *  健康建议 */
    YSHealthyManageHealthySuggestType,
    /**
     *  添加健康任务 */
    YSHealthyManageAddTaskType,
    /**
     *  去完成健康任务 */
    YSHealthyManageCompleteTaskType,
    /**
     *  疾病风险评估 */
    YSHealthyManageIllnessTestType,
    /**
     *  健康任务引导URL完成 */
    YSHealthyManageCompleteYinDaoUrlTaskDoneType,
    /**
     *  健康任务引导URL完成 */
    YSZhongYiManageIllnessTestTy
};

typedef NS_ENUM(NSUInteger, YSHealthyTaskCompleteProcess) {
    /**
     *  任务未完成 */
    YSHealthyTaskUnCompleted,
    /**
     *  任务已完成 */
    YSHealthyTaskCompleted
};

@interface YSHealthyManageWebController : YSBaseController

/**
 *  建议id */
@property (copy , nonatomic) NSString *proposalID;

/**
 *  任务id */
@property (copy , nonatomic) NSString *taskId;

@property (strong,nonatomic) NSString *linkConfig;
//引导url
@property (nonatomic,copy)   NSString *yinDaoURL;
//NavTitle,引导URL的时候用
@property (copy,nonatomic)  NSString *strNavYinDaoTitle;

/**
 *  是否来自完善个人信息页面
 */
@property (assign,nonatomic) BOOL isComeForUpdateUserInfoVC;

/**
 *  针对健康任务，分已完成、未完成 */
@property (assign, nonatomic) YSHealthyTaskCompleteProcess taskProcess;

@property (copy , nonatomic) NSString *completedTaskUrl;


- (instancetype)initWithWebType:(YSHealthyManageWebType)webType uid:(NSString *)uid;

@end
