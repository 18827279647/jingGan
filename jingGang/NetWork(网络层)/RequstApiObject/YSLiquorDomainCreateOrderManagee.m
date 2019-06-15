//
//  YSLiquorDomainCreateOrderManagee.m
//  jingGang
//
//  Created by HanZhongchou on 2017/10/12.
//  Copyright © 2017年 dengxf_dev. All rights reserved.
//

#import "YSLiquorDomainCreateOrderManagee.h"

@implementation YSLiquorDomainCreateOrderManagee
-(YSAPIRequestType)requestType{
    return YSAPIRequestTypePost;
}
- (NSString *)requestMethod{
    return @"v1/jiuyeOrder/order/create";
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
