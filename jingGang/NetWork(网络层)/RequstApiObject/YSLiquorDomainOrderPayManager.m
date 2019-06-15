//
//  YSLiquorDomainOrderPayManager.m
//  jingGang
//
//  Created by HanZhongchou on 2017/10/12.
//  Copyright © 2017年 dengxf_dev. All rights reserved.
//

#import "YSLiquorDomainOrderPayManager.h"

@implementation YSLiquorDomainOrderPayManager
-(YSAPIRequestType)requestType{
    return YSAPIRequestTypePost;
}
- (NSString *)requestMethod{
    return @"v1/jiuyeOrder/order/pay";
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
