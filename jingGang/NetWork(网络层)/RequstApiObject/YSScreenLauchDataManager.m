//
//  YSScreenLauchDataManager.m
//  jingGang
//
//  Created by dengxf on 2017/11/7.
//  Copyright © 2017年 dengxf_dev. All rights reserved.
//

#import "YSScreenLauchDataManager.h"

@implementation YSScreenLauchDataManager

-(YSAPIRequestType)requestType{
    return YSAPIRequestTypePost;
}
- (NSString *)requestMethod{
    return @"v1/sns/splash/screen";
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
