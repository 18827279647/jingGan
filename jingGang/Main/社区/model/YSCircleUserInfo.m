//
//  YSCircleUserInfo.m
//  jingGang
//
//  Created by dengxf on 16/8/8.
//  Copyright © 2016年 Dengxf_Dev. All rights reserved.
//

#import "YSCircleUserInfo.h"

@implementation YSCircleUserInfo

- (NSString *)userSignature {
    if (!_userSignature) {
        return @"";
    }else if ([_userSignature isEqualToString:@"(null)"]) {
        return @"";
    }
    return [NSString stringWithFormat:@"个性签名:%@",_userSignature];
}

@end
