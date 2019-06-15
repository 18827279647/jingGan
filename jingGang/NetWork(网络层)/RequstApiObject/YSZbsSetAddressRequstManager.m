//
//  YSZbsSetAddressRequstManager.m
//  jingGang
//
//  Created by HanZhongchou on 2017/11/17.
//  Copyright © 2017年 dengxf_dev. All rights reserved.
//

#import "YSZbsSetAddressRequstManager.h"

@implementation YSZbsSetAddressRequstManager
-(YSAPIRequestType)requestType{
    return YSAPIRequestTypePost;
}
- (NSString *)requestMethod{
    return @"v1/zbs/set/address";
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
