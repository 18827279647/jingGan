//
//  YHJModel.m
//  jingGang
//
//  Created by whlx on 2019/3/8.
//  Copyright © 2019年 dengxf_dev. All rights reserved.
//

#import "YHJModel.h"

@implementation YHJModel
+(NSDictionary *) JSONKeyPathsByPropertyKey {
    return @{
             @"appid":@"id",
             @"couponAmount":@"couponAmount",
             @"couponCount":@"couponCount",
             @"couponName":@"couponName",
             @"couponType":@"couponType",
             @"startTime":@"startTime",
             @"endTime":@"endTime",
            @"reciveCount":@"reciveCount",
             @"couponOrderAmount":@"couponOrderAmount",
             @"Recive":@"Recive"
            
             };
}

@end
