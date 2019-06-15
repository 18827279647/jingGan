//
//  YSCheckUserIsBindIdentityCardDataManager.m
//  jingGang
//
//  Created by dengxf on 2017/8/29.
//  Copyright © 2017年 dengxf_dev. All rights reserved.
//

#import "YSCheckUserIsBindIdentityCardDataManager.h"

@implementation YSCheckUserIsBindIdentityCardDataManager

- (YSAPIRequestType)requestType{
    return YSAPIRequestTypePost;
}
- (NSString *)requestMethod{
    return @"v1/aio/is/binding";
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
