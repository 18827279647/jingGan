//
//  Const.h
//  jingGang
//
//  Created by dengxf on 15/11/12.
//  Copyright © 2015年 yi jiehuang. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  参数为空，返回为空类型block */
typedef dispatch_block_t voidCallback;
/**
 *  返回一个字符串block类型 */
typedef void (^msg_block_t)(NSString *msg);

typedef void (^number_block_t)(NSNumber *number);

typedef void (^id_block_t)(id obj);


/**
 *  返回一个bool block类型 */
typedef void (^bool_block_t)(BOOL result);

extern NSString * const kApMobile4s;
extern NSString * const kApMobile5s;
extern NSString * const kApMobile6s;
extern NSString * const kApMobile6plus;
extern NSString * const kPushImageUrlKey;
// 友盟统计页面
// 首页
extern NSString * const kMainViewController;
// 生活
extern NSString * const kLifeViewController;
// 自测
extern NSString * const kMeasureViewController;
// 服务
extern NSString * const kServiceViewController;
// 社区
extern NSString * const kCommunityViewController;
// 个人中心
extern NSString * const kPersonalCenterViewController;
// 签到
extern NSString * const kSignInEventMobClickKey;
// 分享邀请码
extern NSString * const kShareInviteEventMobClickKey;
// 发帖 、回帖页面
extern NSString * const kPostViewController;
// 发帖、回帖点击事件
extern NSString * const kPostEventMobClickKey;
// 消息列表
extern NSString * const kNewsListControllerKey;
// 体检菜单页面
extern NSString * const kMeassureMenuControllerKey;



// 体检事件
extern NSString * const kBloodPressureMobClickKey;        // 血压
extern NSString * const kHeartRateMobClickKey;            // 心率
extern NSString * const kSightMobClickKey;                // 视力
extern NSString * const kListeningPressureMobClickKey;    // 听力
extern NSString * const kVitalCapacityMobClickKey;        // 肺活量
extern NSString * const kBloodOxygenMobClickKey;          // 血氧
extern NSString * const kSpeedMobClickKey;                // 快速体检
// 健康任务点击事件
extern NSString * const kSightHealthMobClickKey;          // 视力保健
extern NSString * const kListeningHealthMobClickKey;      // 听力保健
extern NSString * const kBloodPressureControlMobClickKey; // 血压控制
extern NSString * const kWeightControlControlMobClickKey; // 体重控制

#pragma mark --- 健康管理数据保存 ----
extern NSString * const kBloodPressureResultsDataKey;  // 保存血压测量数据
extern NSString * const kHeartRateResultsDataKey;
extern NSString * const kBloodOxyenResultsDataKey;

#pragma mark userdefault
extern NSString * const kUserDefaultRecentUseDatasKey;
extern NSString * const kCNUserAccountFlagKey;

#pragma mark notification
extern NSString * const kMaskingguidePostKey;

extern NSString * const kDidUpdateUserLocationKey;

extern NSString * const kPostActivityKey;

extern NSString * const kDropMenuViewDidShowKey;

extern NSString * const kActivityProcessKey;

extern NSString * const kActivitySaveImageKey;

extern NSString * const kDismissActivityMenuKey;

extern NSString * const kActivityFloatImageKey;

extern NSString * const kUserBindTeleSuccessKey;

extern NSString * const kUserBindTeleFailKey;
