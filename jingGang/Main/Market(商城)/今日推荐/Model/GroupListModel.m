//
//  GroupListModel.m
//  jingGang
//
//  Created by whlx on 2019/5/22.
//  Copyright © 2019年 dengxf_dev. All rights reserved.
//

#import "GroupListModel.h"

@implementation GroupListModel
+ (JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"ID": @"id"}];

}

@end
