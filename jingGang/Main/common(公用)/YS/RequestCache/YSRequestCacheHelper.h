//
//  YSRequestCacheHelper.h
//  jingGang
//
//  Created by dengxf11 on 16/8/24.
//  Copyright © 2016年 dengxf_dev. All rights reserved.
//

#import "JGSingleton.h"
#import "VApiManager.h"

@interface YSRequestCacheHelper : JGSingleton

/**
 *  setter健康管理首页缓存 */
+ (void)healthyManageCacheWithResposne:(HealthManageIndexResponse *)response;

/**
 *  getter健康管理首尔缓存 */
+ (HealthManageIndexResponse *)healthyManageCache;

@end
