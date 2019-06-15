//
//  JGActivityHelper.h
//  jingGang
//
//  Created by dengxf on 16/1/15.
//  Copyright © 2016年 Dengxf_Dev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VApiManager.h"
#import "JGSingleton.h"
#import "YSUserSignInView.h"

@class YSActivitiesInfoItem;

/**
 *  签到弹窗视图状态 */
typedef NS_ENUM(NSUInteger, YSUserSignViewState) {
    // 开始查询用户签到情况
    YSUserSignViewStateWithShowBegin = 0,
    // 正在弹窗
    YSUserSignViewStateWithShowing,
    // 点击弹窗去赚积分按钮
    YSUserSignViewStateWithClickedButton,
    // 点击关闭按钮
    YSUserSignViewStateWithEnd,
    // 没弹窗
    YSUserSignViewStateNone
};

typedef NS_ENUM(NSUInteger, YSActivityProcessType) {
    /**
     *  活动未开始 */
    YSActivityProcessWithUnBeginType = 0,
    /**
     *  活动进行当中 */
    YSActivityProcessWithProcessingType,
    /**
     *  活动预期 */
    YSActivityProcessWithBeyondType,
};

typedef NS_ENUM(NSUInteger, YSEnterIntoGoodsDetailState) {
    /**
     *  从商品首页方式进入商品详情 */
    YSEnterIntoGoodsDetailWithComeFromShopHomePage = 0,
    /**
     *  从活动H5页面方式进入商品详情 */
    YSEnterIntoGoodsDetailWithComeFromActivtyH5
};

/**
 *  活动信息请求状态 */
typedef NS_ENUM(NSUInteger, YSActivityInfoRequestStatus) {
    /**
     *  活动信息还未请求 */
    YSActivityInfoRequestIdleStatus = 100,
    /**
     *  活动信息请求完成并且请求成功 */
    YSActivityInfoRequestSucceedStatus,
    /**
     *  活动信息请求完成并且请求失败 */
    YSActivityInfoRequestFailStatus
};

/**
 *  平台活动信息管理类 */
@interface JGActivityHelper : JGSingleton

@property (assign, nonatomic) BOOL conditeShowed;

@property (assign, nonatomic) BOOL signViewShowed;

@property (assign, nonatomic) BOOL showed;

@property (assign, nonatomic) BOOL integralCheckInDelayShow;

/**
 *  是否小于展现的次数
 */
@property (assign, nonatomic) BOOL lessShowCount;

@property (strong,nonatomic) SalePromotionActivityAdMainInfoResponse *response;

@property (strong,nonatomic) YSUserSignInView *signInView;

@property (assign, nonatomic) YSActivityInfoRequestStatus activityInfoRequestStatus;

/**
 *  活动信息列表 */
@property (strong,nonatomic,readonly) NSMutableArray *actLists;

/**
 *  满足弹框活动列表 */
@property (strong,nonatomic) NSMutableArray *availableActivities;

/**
 *  单例对象 */

+ (void)configEnterIntoGoodsDetailState:(YSEnterIntoGoodsDetailState)enterIntoGoodsDetailState;

+ (YSEnterIntoGoodsDetailState)enterIntoGoodsDetailState;


/**
 *  根据活动code 检测是否在活动时间内
 *
 *  @param activityCode 活动编码
 *  @param progressing  活动正在进行中回调
 *  @param beyond       不在活动时间内回调
 *  @param errorBlock   网络错误回调
 */
+ (void)queryActivityWithActivityCode:(NSString *)activityCode progressing:(void(^)())progressing beyondTime:(void(^)())beyond error:(void(^)(NSError *error))errorBlock notiBlock:(void(^)())noti shouldPop:(BOOL)pop;

/**
 *
    是否显示浮窗
 */
+ (void)mainPageShowFloatImageResult:(void(^)(BOOL result,UIImage *floatImage))result;

/**
 *  获取活动进度 */
+ (YSActivityProcessType)achiveActivityProcess;

+ (void)stProcessType:(YSActivityProcessType)processType;

/**
 *  返回活动图片
 */
+ (NSString *)downloadActivityImageWithUrlString;

/**
 *  是否展示图片
 */
//+ (BOOL)showActivity;

/**
 *  隐藏展示图片
 */
+ (void)dismissImage;

/**
 *  离开首页将不再显示 */
+ (void)notTargetControllerShowImage;

/**
 *  查询用户是否签到
 */
+ (void)queryUserDidCheckInPopView:(void(^)(UserSign *userSign))popViewBlock notPop:(void(^)())notPopBlock state:(void(^)(YSUserSignViewState state))state;

/**
 *  用户签到 */
+ (void)userCheckIn:(void(^)(UserSign *userSign))userSignBlock fail:(void(^)(NSError *error))errorBlock ;


/**
 *  这是一个状态 ，本应该弹出积分签到，但是避免活动页面 ，应该等到活动页面关闭后，延迟弹出
 */
+ (void)shouldPopViewButAvoidActivityView;

+ (void)controllerDidAppear:(NSString *)identifier requestStatus:(void(^)(YSActivityInfoRequestStatus status))status;

+ (void)controllerFloatImageDidAppear:(NSString *)identifier result:(void(^)(BOOL ret,UIImage *floatImge,YSActivitiesInfoItem *actInfoItem,YSActivityInfoRequestStatus status))resultCallback;

@end
