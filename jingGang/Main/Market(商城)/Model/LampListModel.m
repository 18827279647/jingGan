//
//  LampListModel.m
//  jingGang
//
//  Created by whlx on 2019/5/21.
//  Copyright © 2019年 dengxf_dev. All rights reserved.
//

#import "LampListModel.h"

@implementation LampListModel
+ (NSDictionary<NSString *, id> *)modelCustomPropertyMapper
{
    return @{
             CRPropertyString(recID): @"id"};
}
@end
