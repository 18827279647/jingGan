//
//  YQNumberModes.m
//  jingGang
//
//  Created by whlx on 2019/4/8.
//  Copyright © 2019年 dengxf_dev. All rights reserved.
//

#import "YQNumberModes.h"

@implementation YQNumberModes
+(NSDictionary *) JSONKeyPathsByPropertyKey {
    return @{
             @"appid":@"id",
             @"nickName":@"nickName",
             @"status":@"status",
             @"createTime":@"createTime",
             @"headImgPath":@"headImgPath"
             };
}
@end
