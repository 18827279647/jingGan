//
//  YSRequestCacheHelper.m
//  jingGang
//
//  Created by dengxf11 on 16/8/24.
//  Copyright © 2016年 dengxf_dev. All rights reserved.
//

#import "YSRequestCacheHelper.h"
#import "YYKit.h"

NSString *const kHealthyManageCacheKey = @"kHealthyManageCacheKey";
NSString *const kHealthyManageDataKey = @"kHealthyManageDataKey";

@interface YSRequestCacheHelper()

@property (strong,nonatomic) YYCache *healthyManageCache;

@end

@implementation YSRequestCacheHelper

+ (void)healthyManageCacheWithResposne:(HealthManageIndexResponse *)response {
    if (![YSRequestCacheHelper sharedInstance].healthyManageCache) {
        [YSRequestCacheHelper sharedInstance].healthyManageCache = [[YYCache alloc] initWithName:kHealthyManageCacheKey];
        [YSRequestCacheHelper sharedInstance].healthyManageCache.memoryCache.shouldRemoveAllObjectsOnMemoryWarning = NO;
        [YSRequestCacheHelper sharedInstance].healthyManageCache.memoryCache.shouldRemoveAllObjectsWhenEnteringBackground = NO;
    }
    [[YSRequestCacheHelper sharedInstance].healthyManageCache setObject:response forKey:kHealthyManageDataKey];
}

+ (HealthManageIndexResponse *)healthyManageCache {
    if (![YSRequestCacheHelper sharedInstance].healthyManageCache) {
        return nil;
    }else
        return (HealthManageIndexResponse *) [[YSRequestCacheHelper sharedInstance].healthyManageCache objectForKey:kHealthyManageDataKey];
    
}

@end
