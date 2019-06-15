//
//  PindanSuccessResponse.m
//  jingGang
//
//  Created by whlx on 2019/4/24.
//  Copyright © 2019年 dengxf_dev. All rights reserved.
//

#import "PindanSuccessResponse.h"

@implementation PindanSuccessResponse
+(NSDictionary *) JSONKeyPathsByPropertyKey {
    return @{
             @"errorCode":@"code",
             @"msg":@"msg",
             @"subCode":@"sub_code",
             @"subMsg":@"sub_msg",
             
             @"userCustomer":@"userCustomer",
             @"leftTime":@"leftTime",
             @"addTime":@"addTime"
             };
}
@end
