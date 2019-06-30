//
//  RXUserH5UrlResponse.m
//  jingGang
//
//  Created by 荣旭 on 2019/6/28.
//  Copyright © 2019年 dengxf_dev. All rights reserved.
//

#import "RXUserH5UrlResponse.h"

@implementation RXUserH5UrlResponse

+(NSDictionary *) JSONKeyPathsByPropertyKey {
    return @{
             @"isMember":@"isMember",
             @"messageH5":@"messageH5",
             @"ishasIdCard":@"ishasIdCard",
        };
}
@end
