//
//  YSEnvironmentConfig.m
//  jingGang
//
//  Created by dengxf on 17/6/5.
//  Copyright © 2017年 dengxf_dev. All rights reserved.
//

#import "YSEnvironmentConfig.h"

@interface YSEnvironmentConfig ()

@property (assign, nonatomic) YSProjectEnvironmentMode environmentMode;

@end

#define YSEnvironmentModeKey @"YSEnvironmentModeKey"

@implementation YSEnvironmentConfig

+ (YSProjectEnvironmentMode)currentMode {
    return [(NSNumber *)[self achieve:YSEnvironmentModeKey] integerValue];
}

+ (void)configDefaultEnvironmentMode:(YSProjectEnvironmentMode)environmentMode autoModifyAction:(BOOL)autoModifyAction
{
    NSNumber *modeObject = (NSNumber *)[self achieve:YSEnvironmentModeKey];
    if (modeObject && !autoModifyAction) {
        return;
    }
    [YSEnvironmentConfig configProjectEnvironmentWithMode:environmentMode];
}

+ (void)configProjectEnvironmentWithMode:(YSProjectEnvironmentMode)environmentMode
{
    [self save:[NSNumber numberWithInteger:environmentMode] key:YSEnvironmentModeKey];
}

+ (YSProjectEnvironmentMode)examineEnironmentMode {
    NSNumber *modeObject = (NSNumber *)[self achieve:YSEnvironmentModeKey];
    return [modeObject integerValue];
}

+ (NSString *)apiPort {
    YSProjectEnvironmentMode mode = [YSEnvironmentConfig examineEnironmentMode];
    switch (mode) {
        case YSProject209EnvironmentModel:
            //    return @"http://192.168.1.102:8080/carnation-apis-resource";
            return @"http://api.bhesky.cn";///carnation-apis-resource
            break;
        case YSProjectCNEnvironmentMode:
            return @"http://api.bhesky.cn";//http://api.bhesky.com/carnation-apis-resource
            break;
        case YSProjectCOMEnvironmentMode:
            return @"http://api.bhesky.cn";//http://api.bhesky.com/carnation-apis-resource
            break;
        default:
            break;
    }
}

+ (NSString *)baseAuthUrl {
    YSProjectEnvironmentMode mode = [YSEnvironmentConfig examineEnironmentMode];
    switch (mode) {
        case YSProject209EnvironmentModel:
            return @"http://auth.bhesky.cn/carnation-apis-auth-server";//http://192.168.1.209:8080
            break;
        case YSProjectCNEnvironmentMode:
            return @"http://auth.bhesky.cn/carnation-apis-auth-server";//http://auth.bhesky.com
            break;
        case YSProjectCOMEnvironmentMode:
            return @"http://auth.bhesky.cn/carnation-apis-auth-server";//http://auth.bhesky.com
            break;
        default:
            break;
    }
}

+ (NSString *)staticBaseUrl {
    YSProjectEnvironmentMode mode = [YSEnvironmentConfig examineEnironmentMode];
    switch (mode) {
        case YSProject209EnvironmentModel:
            return @"http://static.bhesky.com";
            break;
        case YSProjectCNEnvironmentMode:
            return @"http://static.bhesky.com";
            break;
        case YSProjectCOMEnvironmentMode:
            return @"http://static.bhesky.com";
            break;
        default:
            break;
    }
}

+ (NSString *)baseUrl {
    YSProjectEnvironmentMode mode = [YSEnvironmentConfig examineEnironmentMode];
    switch (mode) {
        case YSProject209EnvironmentModel:
            //            return @"http://192.168.1.14:8080/carnation-apis-resource";
            return @"http://api.bhesky.cn";
            break;
        case YSProjectCNEnvironmentMode:
            return @"http://api.bhesky.cn";
            break;
        case YSProjectCOMEnvironmentMode:
            return @"http://api.bhesky.cn";
            break;
        default:
            break;
    }
}

+ (NSString *)shopUrl {//shop.bhesky.com/carnation-shop-web
    YSProjectEnvironmentMode mode = [YSEnvironmentConfig examineEnironmentMode];
    switch (mode) {
        case YSProject209EnvironmentModel:
            return @"http://shop.bhesky.cn";
            break;
        case YSProjectCNEnvironmentMode:
            return @"http://shop.bhesky.cn";
            break;
        case YSProjectCOMEnvironmentMode:
            return @"http://shop.bhesky.cn";
            break;
        default:
            break;
    }
}

+ (NSString *)mobileWebUrl {
    YSProjectEnvironmentMode mode = [YSEnvironmentConfig examineEnironmentMode];
    switch (mode) {
        case YSProject209EnvironmentModel:
            return @"http://mobile.bhesky.cn";
            break;
        case YSProjectCNEnvironmentMode:
            return @"http://mobile.bhesky.cn";
            break;
        case YSProjectCOMEnvironmentMode:
            return @"http://mobile.bhesky.cn";
            break;
        default:
            break;
    } 
}
+ (NSString *)jpushEnvirStr {
    return @"p_";
}

+ (NSString *)jpushAppkey {
    // 测试 4f74f353ab356e7afb5c3f1e
    // 正式 a424c4eeabcc0d339ebef495
    return @"eb204e9a5f28efd44a6f87fd";
}

@end
