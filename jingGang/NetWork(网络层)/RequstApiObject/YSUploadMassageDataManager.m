//
//  YSUploadMassageDataManager.m
//  jingGang
//
//  Created by dengxf on 17/7/5.
//  Copyright © 2017年 dengxf_dev. All rights reserved.
//

#import "YSUploadMassageDataManager.h"

@implementation YSUploadMassageDataManager

- (YSAPIRequestType)requestType{
    return YSAPIRequestTypePost;
}
- (NSString *)requestMethod{
    return @"v1/massage/details/data/upload";
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
