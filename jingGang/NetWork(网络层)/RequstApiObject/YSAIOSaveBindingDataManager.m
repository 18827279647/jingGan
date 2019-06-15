//
//  YSAIOSaveBindingDataManager.m
//  jingGang
//
//  Created by dengxf on 2017/8/30.
//  Copyright © 2017年 dengxf_dev. All rights reserved.
//

#import "YSAIOSaveBindingDataManager.h"

@implementation YSAIOSaveBindingDataManager

- (YSAPIRequestType)requestType{
    return YSAPIRequestTypePost;
}
- (NSString *)requestMethod{
    return @"v1/aio/save/binding";
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
