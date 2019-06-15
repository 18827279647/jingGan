//
//  YSIntegralSwapDataManager.m
//  jingGang
//
//  Created by dengxf on 17/7/31.
//  Copyright © 2017年 dengxf_dev. All rights reserved.
//

#import "YSIntegralSwapDataManager.h"

@implementation YSIntegralSwapDataManager

- (YSAPIRequestType)requestType{
    return YSAPIRequestTypePost;
}
- (NSString *)requestMethod{
    return @"v1/personal/integral/swap";
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
