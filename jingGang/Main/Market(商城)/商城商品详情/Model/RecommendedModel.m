//
//  RecommendedModel.m
//  jingGang
//
//  Created by whlx on 2019/5/27.
//  Copyright © 2019年 dengxf_dev. All rights reserved.
//

#import "RecommendedModel.h"

@implementation RecommendedModel
+ (JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"ID": @"id"}];
    
}
@end
