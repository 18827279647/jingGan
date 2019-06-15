//
//  YSHotelOrderListRequstManager.m
//  jingGang
//
//  Created by HanZhongchou on 2017/6/16.
//  Copyright © 2017年 dengxf_dev. All rights reserved.
//

#import "YSHotelOrderListRequstManager.h"

@implementation YSHotelOrderListRequstManager

- (YSAPIRequestType)requestType{
    return YSAPIRequestTypePost;
}
- (NSString *)requestMethod{
    return @"v1/elong/order/list";
}

- (NSNumber *)shouldCache {
    return @0;
}

- (NSDictionary *)headerDict {
    NSString *strToken = [NSString stringWithFormat:@"bearer %@",[YSLoginManager queryAccessToken]];
    return @{@"Authorization":strToken,
             @"Content-Type":@"application/x-www-form-urlencoded"};
}

- (NSDictionary *)params{
    return nil;
}

- (NSDictionary *)paramsForAPI {
    return [YSRequestParamsManager paramsDictWithUrl:[self requestMethod]
                                          paramsDict:[self params]
                                           cacheTime:[self shouldCache]
                                          headerDict:([self headerDict]?[self headerDict]:nil)];
}

@end
