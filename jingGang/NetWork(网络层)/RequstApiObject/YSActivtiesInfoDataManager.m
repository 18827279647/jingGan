//
//  YSActivtiesInfoDataManager.m
//  jingGang
//
//  Created by dengxf on 2017/10/12.
//  Copyright © 2017年 dengxf_dev. All rights reserved.
//

#import "YSActivtiesInfoDataManager.h"

@implementation YSActivtiesInfoDataManager

- (YSAPIRequestType)requestType{
    return YSAPIRequestTypePost;
}
- (NSString *)requestMethod{
    return @"v1/salePromotion/activityAd/mainInfos";
}

- (NSNumber *)shouldCache {
    return @0;
}

- (NSDictionary *)headerDict {
    return @{};
}

@end
