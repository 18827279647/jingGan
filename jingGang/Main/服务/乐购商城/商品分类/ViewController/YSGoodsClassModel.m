//
//  YSGoodsClassModel.m
//  jingGang
//
//  Created by Eric Wu on 2019/6/3.
//  Copyright © 2019 dengxf_dev. All rights reserved.
//

#import "YSGoodsClassModel.h"

@implementation YSGoodsClassModel
+ (NSDictionary<NSString *, id> *)modelCustomPropertyMapper
{
    return @{
             CRPropertyString(recID): @"id"};
}

+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass
{
    return @{CRPropertyString(childList): CRClass(YSGoodsChildModel)};
}
@end
    
