//
//  YSUMMobClickManager.m
//  jingGang
//
//  Created by dengxf on 17/7/14.
//  Copyright © 2017年 dengxf_dev. All rights reserved.
//

#import "YSUMMobClickManager.h"
#import "UMMobClick/MobClick.h"
#import "GlobeObject.h"
#import "ThirdPlatformInfo.h"

@implementation YSUMMobClickManager

+ (void)_initMobClick {
    // 友盟统计
    UMConfigInstance.appKey = MobClick_AppKey;
    UMConfigInstance.channelId = @"App Store";
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    [MobClick setAppVersion:version];
    [MobClick startWithConfigure:UMConfigInstance];
}

+ (void)profileSignOnWithUid:(NSString *)uid {
    [MobClick profileSignInWithPUID:uid];
}


+ (void)profileSignOff {
    [MobClick profileSignOff];
}

+(void)beginLogPageWithKey:(NSString *)key {
    [MobClick beginLogPageView:key];
}

+ (void)endLogPageWithKey:(NSString *)key {
    [MobClick endLogPageView:key];
}

+ (void)event:(NSString *)key {
    [MobClick event:key];
}

@end
