//
//  YSAchiveAIOInfoDataManager.m
//  jingGang
//
//  Created by dengxf on 2017/9/11.
//  Copyright © 2017年 dengxf_dev. All rights reserved.
//

#import "YSAchiveAIOInfoDataManager.h"

@implementation YSAchiveAIOInfoDataManager

- (YSAPIRequestType)requestType{
    return YSAPIRequestTypePost;
}
- (NSString *)requestMethod{
    return @"v1/aio/get/binding/info";
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
