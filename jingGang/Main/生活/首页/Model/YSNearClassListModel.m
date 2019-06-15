//
//  YSNearClassListModel.m
//  jingGang
//
//  Created by dengxf on 17/7/11.
//  Copyright © 2017年 dengxf_dev. All rights reserved.
//

#import "YSNearClassListModel.h"

@implementation YSGroupClassItem
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"groupId" : @"id"};
}

@end

@implementation YSNearClassListModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
             @"groupClassList" : [YSGroupClassItem class]
             };
}

@end
