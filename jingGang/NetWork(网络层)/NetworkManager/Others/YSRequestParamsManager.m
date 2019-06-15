//
//  YSRequestParamsManager.m
//  YSNetworkManagerDemo
//
//  Created by dengxf on 17/6/14.
//  Copyright © 2017年 dengxf. All rights reserved.
//

#import "YSRequestParamsManager.h"
#import "YSNetworkConstFile.h"
#import "YSEnvironmentConfig.h"

@implementation YSRequestParamsManager

+ (NSDictionary *)paramsDictWithUrl:(NSString *)url paramsDict:(NSDictionary *)dict cacheTime:(NSNumber *)cacheTime headerDict:(NSDictionary *)headDict {
    NSMutableDictionary *paramsDict = [NSMutableDictionary dictionary];
    [paramsDict setObject:[self requestUrlWithRequestMethod:url] forKey:kYSRequestURLKey];
    [paramsDict setObject:dict forKey:kYSRequestDictKey];
    [paramsDict setObject:cacheTime forKey:kYSRequestCacheTimeKey];
    if (headDict) {
        [paramsDict setObject:headDict forKey:kYSRequestHeaderDictKey];
    }
    return [paramsDict copy];
}

+ (NSString *)requestUrlWithRequestMethod:(NSString *)requestMethod {
    // [YSEnvironmentConfig apiPort]
    return [NSString stringWithFormat:@"%@/%@", [YSEnvironmentConfig apiPort],requestMethod];
}

@end
