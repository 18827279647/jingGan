//
//  YSAdContentDataManager.m
//  jingGang
//
//  Created by dengxf on 2017/11/10.
//  Copyright © 2017年 dengxf_dev. All rights reserved.
//

#import "YSAdContentDataManager.h"

@implementation YSAdContentDataManager

- (YSAPIRequestType)requestType{
    return YSAPIRequestTypePost;
}
- (NSString *)requestMethod{
    return @"v1/get/ad/adContent";
}

- (NSNumber *)shouldCache {
    return @0;
}

- (NSDictionary *)headerDict {
    return @{};
}

@end
