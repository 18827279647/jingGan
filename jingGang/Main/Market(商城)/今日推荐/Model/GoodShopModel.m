//
//  GoodShopModel.m
//  jingGang
//
//  Created by whlx on 2019/5/22.
//  Copyright © 2019年 dengxf_dev. All rights reserved.
//

#import "GoodShopModel.h"

@implementation GoodShopModel
+ (JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"ID": @"id"}];
    
}
@end
