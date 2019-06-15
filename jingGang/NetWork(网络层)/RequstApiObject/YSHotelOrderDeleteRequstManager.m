//
//  YSHotelOrderDeleteRequstManager.m
//  jingGang
//
//  Created by HanZhongchou on 2017/6/21.
//  Copyright © 2017年 dengxf_dev. All rights reserved.
//

#import "YSHotelOrderDeleteRequstManager.h"

@implementation YSHotelOrderDeleteRequstManager
- (YSAPIRequestType)requestType{
    return YSAPIRequestTypePost;
}
- (NSString *)requestMethod{
    return @"v1/elong/delete/order";
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
