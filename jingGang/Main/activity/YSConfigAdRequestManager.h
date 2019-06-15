//
//  YSConfigAdRequestManager.h
//  jingGang
//
//  Created by dengxf on 2017/11/7.
//  Copyright © 2017年 dengxf_dev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JGSingleton.h"
#import "YSScreenLauchAdItem.h"
#import "YSAdContentItem.h"
/**
 *  结束启动广告页方式 */
typedef NS_ENUM(NSUInteger, YSLauchScreenEndType) {
    // 跳过
    YSLauchScreenEndWithSkipType = 1,
    // 点击广告
    YSLauchScreenEneWithClickAdType,
    // 倒计时完成跳过
    YSLauchScreenEndWithOvertimeType
};

/**
 *  广告模板请求类型 */
typedef NS_ENUM(NSUInteger, YSAdContentRequestType) {
    // 健康管理首页广告位
    YSAdContentWithHealthyManagerType = 30,
    // 健康圈首页广告位
    YSAdContentWithHealthyCircleType,
    // 周边服务首页广告位
    YSAdContentWithNearServiceType,
    // 商城活动专区广告位 活动专区：APP_JXZQ_AD_PT   热销品牌名酒：APP_EMALL_AD_SF    积分兑好礼：APP_INTEGRAL_MALL_IN
    YSAdContentWithStoreHuoDongZhuanQuType,
    // 健康商城首页广告位
    YSAdContentWithHealthyShoppingType,
    // 积分商城入口广告位
    YSAdContentWithIntegrateShoppingType,
    // 精选专区（普通用户）广告位
    YSAdContentWithFeaturedCommonType,
    // 精选专区（CN用户）广告位
    YSAdContentWithFeaturedCNType
};

extern NSString * const kCloseScreenLauchAdPageNotificateKey;

@interface YSConfigAdRequestManager : JGSingleton

#pragma mark  ---- 启动页广告
- (void)screenLauchRequestResult:(void(^)(BOOL ret,YSSLAdItem *adItem,BOOL requestResult))result;

- (void)downImageWithUrl:(NSString *)urlString success:(void(^)(UIImage *image))result;

- (BOOL)containImageWithKey:(NSString *)key;

- (void)saveScreenLauchCacheWithAdItem:(YSSLAdItem *)adItem requestResult:(BOOL)request;

- (NSArray *)achieveScreenCacheItems;

- (void)cacheItem:(void(^)(YSSLAdItem *cacheAdItem))itemBlock;

- (void)configClickedScreenLanuchAd;

- (BOOL)screenLanuchAdIsClick;

/**
 *  开启启动广告页 */
- (void)startLaunchScreenAdPage;

/**
 *  是否在广告页中 */
- (BOOL)inLanunchScreenAdPage;

/**
 *  结束广告模式 */
- (void)endLauchScreenAdPage;

// 启动广告页结束，完成回调通知
- (void)notificateEndLanuchAdWithEndType:(YSLauchScreenEndType)endType adItem:(YSSLAdItem *)adItem;

// 解析通知信息
- (YSLauchScreenEndType)endTypeWithNoti:(NSDictionary *)noti;
- (YSSLAdItem *)clickAdItemWithNoti:(NSDictionary *)noti;

#pragma mark --- 广告位广告

@property (assign, nonatomic,readonly) YSAdContentRequestType requestType;

/**
 *
 requestType 请求入口方式
 cacheAdItem 返回一个缓存广告位对象
 result      请求最新广告位对象
 */
- (void)requestAdContent:(YSAdContentRequestType)requestType cacheItem:(void(^)(YSAdContentItem *cacheItem))cacheAdItem result:(void(^)(YSAdContentItem *adContentItem))result;

/**
 *  根据当前请求返回相应请求参数code */
- (NSString *)requestAdContentCode;
/**
 *  根据type返回相应请求参数code */
- (NSString *)requestAdContentCodeWithRequestType:(YSAdContentRequestType)requestType;

/**
 *  获取广告位缓存数据 */
- (NSArray *)achieveAdContentCacheItmes;

@end
