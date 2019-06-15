//
//  YSEliteZoneCommonAccountPayRequstManger.m
//  jingGang
//
//  Created by HanZhongchou on 2017/7/26.
//  Copyright © 2017年 dengxf_dev. All rights reserved.
//

#import "YSEliteZoneCommonAccountPayRequstManger.h"

@implementation YSEliteZoneCommonAccountPayRequstManger
- (YSAPIRequestType)requestType{
    return YSAPIRequestTypePost;
}
- (NSString *)requestMethod{
    return @"v1/shop/trade/jingxuan/pay";
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
