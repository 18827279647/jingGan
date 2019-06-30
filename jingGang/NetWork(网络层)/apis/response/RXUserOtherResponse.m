//
//  RXUserOtherResponse.m
//  jingGang
//
//  Created by 荣旭 on 2019/6/29.
//  Copyright © 2019年 dengxf_dev. All rights reserved.
//

#import "RXUserOtherResponse.h"

@implementation RXUserOtherResponse

+(NSDictionary *) JSONKeyPathsByPropertyKey {
    return @{
             @"isMember":@"isMember",
             @"message":@"message",
             @"ishasIdCard":@"ishasIdCard",
             };
}

@end
