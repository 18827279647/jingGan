//
//  YSVersionConfig.h
//  jingGang
//
//  Created by dengxf on 16/11/1.
//  Copyright © 2016年 dengxf_dev. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, YSAuditStatusType) {
    YSAuditStatusWithProcessing = 900,
    YSAuditStatysWithProcessed
};

@interface YSVersionInfoModel : NSObject
//id
@property (nonatomic, copy) NSNumber *apiId;
//添加时间
@property (nonatomic, copy) NSDate *addTime;
//版本类型 1.ios 2.安卓
@property (nonatomic, copy) NSNumber *vcType;
//版本号
@property (nonatomic, copy) NSString *vcNumber;
//版本描述
@property (nonatomic, copy) NSString *vcDescribe;
//是否开启
@property (nonatomic, copy) NSNumber *ifOpen;
//是否强制
@property (nonatomic, copy) NSNumber *ifMandatory;
//下载次数
@property (nonatomic, copy) NSNumber *downloads;
//下载地址
@property (nonatomic, copy) NSString *downloadUrl;
//状态
@property (nonatomic, copy) NSNumber *vcState;
@end

@interface YSVersionConfig : NSObject
/**
 *  个人设置版本检查更新 */
+ (void)appVersionCheck:(void(^)(BOOL ret, NSString *versionMsg, NSString *downUrl))resultCallback;

/**
 *  查看版本信息 */
+ (void)queryVersionInformation;

/**
 *  设置审核进度 */
+ (void)setAuditStatus:(YSAuditStatusType)status;

/**
 *  获取当前审核进度 */
+ (YSAuditStatusType)queryAuditStatus;

/**
 *  获取当前是否为低版本通行模式 */
+ (BOOL)isLowerVersionFreeMode;

@end
