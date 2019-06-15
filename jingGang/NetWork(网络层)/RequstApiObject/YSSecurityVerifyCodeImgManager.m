//
//  YSSecurityVerifyCodeImgManager.m
//  jingGang
//
//  Created by HanZhongchou on 2017/10/19.
//  Copyright © 2017年 dengxf_dev. All rights reserved.
//

#import "YSSecurityVerifyCodeImgManager.h"

@implementation YSSecurityVerifyCodeImgManager
-(YSAPIRequestType)requestType{
    return YSAPIRequestTypePost;
}
- (NSString *)requestMethod{
    return @"v1/verify/code/img";
//    return @"v1/verify_code/test";
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
