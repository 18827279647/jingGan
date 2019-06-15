//
//  YSHotelDetailRequstManager.m
//  jingGang
//
//  Created by HanZhongchou on 2017/6/19.
//  Copyright © 2017年 dengxf_dev. All rights reserved.
//

#import "YSHotelDetailRequstManager.h"

@implementation YSHotelDetailRequstManager
- (YSAPIRequestType)requestType{
    return YSAPIRequestTypePost;
}
- (NSString *)requestMethod{
    return @"v1/get/elong/order/by/orderId";
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
