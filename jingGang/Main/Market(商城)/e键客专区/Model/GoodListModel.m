//
//  GoodListModel.m
//  jingGang
//
//  Created by whlx on 2019/5/21.
//  Copyright © 2019年 dengxf_dev. All rights reserved.
//

#import "GoodListModel.h"

@implementation GoodListModel
+ (JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{
                                                                  @"ID": @"id"
                                                                  }];
    
}
+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper
{
    return @{CRPropertyString(ID): @"id"};
}
@end
