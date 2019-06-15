//
//  ConfirmJiankangdouResponse.m
//  jingGang
//
//  Created by whlx on 2019/4/23.
//  Copyright © 2019年 dengxf_dev. All rights reserved.
//

#import "ConfirmJiankangdouResponse.h"

@implementation ConfirmJiankangdouResponse
+(NSDictionary *) JSONKeyPathsByPropertyKey {
    return @{
             @"errorCode":@"code",
             @"msg":@"msg",
             @"subCode":@"sub_code",
             @"subMsg":@"sub_msg",
             
             @"show":@"show",
             @"num":@"num",
             @"money":@"money"
             };
}

@end
