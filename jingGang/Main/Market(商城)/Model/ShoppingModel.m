//
//  ShoppingModel.m
//  jingGang
//
//  Created by whlx on 2019/5/15.
//  Copyright © 2019年 dengxf_dev. All rights reserved.
//

#import "ShoppingModel.h"

@implementation ShoppingModel
+ (JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{
                                                                  @"_id": @"id"
                                                                  }];
   
}
@end
