//
//  YSHotelOrderCancelRequstManager.m
//  jingGang
//
//  Created by HanZhongchou on 2017/6/20.
//  Copyright © 2017年 dengxf_dev. All rights reserved.
//

#import "YSHotelOrderCancelRequstManager.h"

@implementation YSHotelOrderCancelRequstManager
- (YSAPIRequestType)requestType{
    return YSAPIRequestTypePost;
}
- (NSString *)requestMethod{
    return @"v1/elong/cancel/order";
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
