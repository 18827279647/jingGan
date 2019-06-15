//
//  JGOrderRedDetailSucResponse.m
//  jingGang
//
//  Created by hlguo2 on 2019/4/25.
//  Copyright © 2019 dengxf_dev. All rights reserved.
//

#import "JGOrderRedDetailSucResponse.h"

@implementation JGOrderRedDetailSucResponse


+(NSDictionary *) JSONKeyPathsByPropertyKey {
    return @{
             @"isFirstShow":@"isFirstShow",
             @"isSecondShow":@"isSecondShow",
             @"redList":@"redList"
             };
}


@end
