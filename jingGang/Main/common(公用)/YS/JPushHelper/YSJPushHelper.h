//
//  YSJPushHelper.h
//  jingGang
//
//  Created by dengxf on 17/5/16.
//  Copyright © 2017年 dengxf_dev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JGSingleton.h"
#import "JPUSHService.h"
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif

typedef NS_ENUM(NSUInteger, YSJPushMessageType) {
    // 春雨医生问题回复通知
    YSChunYuProblemReplyType = 30,
    // 春雨医生问题关闭通知
    YSChunYuProblemCloseType = 40,
    // 周边服务订单详情
    YSServiceOrderDetailType = 50,
    // 健康豆明细
    YSCloudMoneyDetailType
};

typedef NS_ENUM(NSUInteger, YSHandleForegroundApnsProcess) {
    /**
     *  前台推送闲置状态 */
    YSForegroundApnsProcessIdle = 100,
    /**
     *  前台推送开始状态，马上进行正在进行状态 */
    YSForegroundApnsProcessBegin,
    /**
     *  前台推送正在进行状态 */
    YSForegroundApnsProcessBeing,
    /**
     *  前台推送关闭状态，马上进入闲置状态 */
    YSForegroundApnsProcessEnd
};

@interface YSJPushHelper : JGSingleton

@property (assign, nonatomic) YSJPushMessageType msgType;

/**
 *  极光推送注册 */
+ (void)registerJPushWithOptions:(NSDictionary *)options;

/**
 *  推送别名设置 */
+ (void)jpushSetAlias:(NSString *)alias;

/**
 *  推送别名移除 */
+ (void)jpushRemoveAlias;

/**
 *  取消手机系统推送设置 */
+ (void)unregisterForRemoteNotifications;

/**
 *  注册手机系统推送设置 */
+ (void)registerForRemoteNotifications;

/**
 *  配置当前屏幕是否在H5之内 */
+ (void)configWithInChunYuH5:(BOOL)withInH5;

/**
 *  获取当前状态是否在H5内 */
+ (BOOL)queryCurrentStateWithInChunYuH5;

/**
 *  处理推送信息 */
+ (void)dealJPushWithUserInfo:(NSDictionary *)userInfo;

/**
 *  设置前台推送消息处理进程 */
+ (void)setForegroundApnsStates:(YSHandleForegroundApnsProcess)apnsStates;

/**
 *  消除站内消息对应问题id */
+ (void)dealClickJPushWithQuestionId:(NSNumber *)questionId;
@end
