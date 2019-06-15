//
//  YSNearClassListDataManager.m
//  jingGang
//
//  Created by dengxf on 17/7/11.
//  Copyright © 2017年 dengxf_dev. All rights reserved.
//

#import "YSNearClassListDataManager.h"

@implementation YSNearClassListDataManager

- (YSAPIRequestType)requestType{
    return YSAPIRequestTypePost;
}
- (NSString *)requestMethod{
    return @"v1/group/class/list";
}

- (NSNumber *)shouldCache {
    return @0;
}

- (NSDictionary *)headerDict {
    return @{};
}

@end
