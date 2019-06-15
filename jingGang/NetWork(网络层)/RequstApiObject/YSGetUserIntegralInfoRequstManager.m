//
//  YSGetUserIntegralInfoRequstManager.m
//  jingGang
//
//  Created by HanZhongchou on 2017/7/24.
//  Copyright © 2017年 dengxf_dev. All rights reserved.
//

#import "YSGetUserIntegralInfoRequstManager.h"

@implementation YSGetUserIntegralInfoRequstManager
- (YSAPIRequestType)requestType{
    return YSAPIRequestTypePost;
}
- (NSString *)requestMethod{
    return @"v1/personal/integral/myIntegral";
}

- (NSNumber *)shouldCache {
    return @0;
}

- (NSDictionary *)headerDict {
    NSString *strToken = [NSString stringWithFormat:@"bearer %@",[YSLoginManager queryAccessToken]];
    return @{@"Authorization":strToken,
             @"Content-Type":@"application/x-www-form-urlencoded"};
}
@end
