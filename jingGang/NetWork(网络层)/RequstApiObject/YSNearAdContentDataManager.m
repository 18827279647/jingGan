//
//  YSNearAdContentDataManager.m
//  jingGang
//
//  Created by dengxf on 17/7/10.
//  Copyright © 2017年 dengxf_dev. All rights reserved.
//

#import "YSNearAdContentDataManager.h"

@implementation YSNearAdContentDataManager

- (YSAPIRequestType)requestType{
    return YSAPIRequestTypePost;
}
- (NSString *)requestMethod{
    return @"v1/get/ad/content";
}

- (NSNumber *)shouldCache {
    return @0;
}

- (NSDictionary *)headerDict {
    return @{};
}

@end
