//
//  YSScreenLauchAdItem.m
//  jingGang
//
//  Created by dengxf on 2017/11/7.
//  Copyright © 2017年 dengxf_dev. All rights reserved.
//

#import "YSScreenLauchAdItem.h"

@implementation YSSLAdItem

- (BOOL)isSample:(YSSLAdItem *)adItme {
    BOOL ret = NO;
    if ([self.adImgPath isEqualToString:adItme.adImgPath] && self.adType == adItme.adType) {
        ret = YES;
    }
    return ret;
}

@end

@implementation YSScreenLauchAdItem

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
             @"advList" : [YSSLAdItem class]
             };
}

@end
