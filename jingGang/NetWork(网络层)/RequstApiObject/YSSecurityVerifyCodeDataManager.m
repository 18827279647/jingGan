//
//  YSSecurityVerifyCodeDataManager.m
//  jingGang
//
//  Created by dengxf on 2017/10/20.
//  Copyright © 2017年 dengxf_dev. All rights reserved.
//

#import "YSSecurityVerifyCodeDataManager.h"

@implementation YSSecurityVerifyCodeDataManager

-(YSAPIRequestType)requestType{
    return YSAPIRequestTypePost;
}
- (NSString *)requestMethod{
    return @"v1/verify/code/img/contrast";
}

- (NSNumber *)shouldCache {
    return @0;
}

- (NSDictionary *)headerDict {
    //    NSString *strToken = [NSString stringWithFormat:@"bearer %@",[YSLoginManager queryAccessToken]];
    //    return @{@"Authorization":strToken,
    //             @"Content-Type":@"application/x-www-form-urlencoded"};
    return @{};
}

@end
