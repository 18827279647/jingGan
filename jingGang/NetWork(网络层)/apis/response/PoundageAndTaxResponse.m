//
//  PoundageAndTaxResponse.m
//  Operator_JingGang
//
//  Created by whlx on 2019/4/16.
//  Copyright © 2019年 Dengxf. All rights reserved.
//

#import "PoundageAndTaxResponse.h"

@implementation PoundageAndTaxResponse
+(NSDictionary *) JSONKeyPathsByPropertyKey {
    return @{
             @"errorCode":@"code",
             @"msg":@"msg",
             @"subCode":@"sub_code",
             @"taxAmount":@"taxAmount",
             @"poundage":@"poundage"
             };
}

@end
