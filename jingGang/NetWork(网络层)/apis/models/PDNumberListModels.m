//
//  PDNumberListModels.m
//  jingGang
//
//  Created by whlx on 2019/4/10.
//  Copyright © 2019年 dengxf_dev. All rights reserved.
//

#import "PDNumberListModels.h"

@implementation PDNumberListModels
+(NSDictionary *) JSONKeyPathsByPropertyKey {
    return @{
             @"addTime":@"addTime",
             @"userId":@"userId",
             @"allygPrice":@"allygPrice",
             @"isygOrder":@"isygOrder",
             @"actualPrice":@"actualPrice",
             @"orderTypeFlag":@"orderTypeFlag",
             @"actualIntegral":@"actualIntegral",
             @"allIntegral":@"allIntegral",
             @"statusCount":@"statusCount",
             @"nickName":@"nickName",
             @"headImgPath":@"headImgPath",
             @"leftTime":@"leftTime",
             @"orderId":@"orderId",
             
             };
}

@end
