//
//  YSAcquireMassageDataManager.m
//  jingGang
//
//  Created by dengxf on 17/7/5.
//  Copyright © 2017年 dengxf_dev. All rights reserved.
//

#import "YSAcquireMassageDataManager.h"

@implementation YSAcquireMassageDataManager

- (YSAPIRequestType)requestType{
    return YSAPIRequestTypePost;
}
- (NSString *)requestMethod{
    return @"v1/get/massage/details/data";
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
