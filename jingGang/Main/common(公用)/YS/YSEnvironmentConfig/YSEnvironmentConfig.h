//
//  YSEnvironmentConfig.h
//  jingGang
//
//  Created by dengxf on 17/6/5.
//  Copyright © 2017年 dengxf_dev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JGSingleton.h"

typedef NS_ENUM(NSUInteger, YSProjectEnvironmentMode) {
    YSProject209EnvironmentModel = 7000,
    YSProjectCNEnvironmentMode,
    YSProjectCOMEnvironmentMode,
};

@interface YSEnvironmentConfig : JGSingleton

+ (YSProjectEnvironmentMode)currentMode;

/**
 *  默认设置为cn
    environmentMode 设置环境模式
    autoModifyAction 是否支持手动更改*/
+ (void)configDefaultEnvironmentMode:(YSProjectEnvironmentMode)environmentMode autoModifyAction:(BOOL)autoModifyAction;

/**
 *  更改项目环境 */
+ (void)configProjectEnvironmentWithMode:(YSProjectEnvironmentMode)environmentMode;

/**
 *  api接口 */
+ (NSString *)apiPort;

+ (NSString *)baseAuthUrl;

+ (NSString *)staticBaseUrl;

+ (NSString *)baseUrl;

+ (NSString *)shopUrl;

+ (NSString *)mobileWebUrl;

+ (NSString *)jpushAppkey;

+ (NSString *)jpushEnvirStr;

@end
