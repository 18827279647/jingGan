//
//  YSGetAIODataManager.m
//  jingGang
//
//  Created by dengxf on 2017/8/31.
//  Copyright © 2017年 dengxf_dev. All rights reserved.
//

#import "YSGetAIODataManager.h"

@implementation YSGetAIODataManager

- (YSAPIRequestType)requestType{
    return YSAPIRequestTypePost;
}
- (NSString *)requestMethod{
    return @"v1/get/aio/data";
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
