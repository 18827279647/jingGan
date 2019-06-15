//
//  GoodsDetailsModel.m
//  jingGang
//
//  Created by whlx on 2019/5/23.
//  Copyright © 2019年 dengxf_dev. All rights reserved.
//

#import "GoodsDetailsModel.h"

@implementation GoodsDetailsModel
+ (JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"ID": @"id"}];
    
}
@end
