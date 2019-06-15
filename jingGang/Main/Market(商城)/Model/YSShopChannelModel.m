//
//  YSShopChannelModel.m
//  jingGang
//
//  Created by Eric Wu on 2019/6/1.
//  Copyright © 2019 dengxf_dev. All rights reserved.
//

#import "YSShopChannelModel.h"

@implementation YSShopChannelModel
+ (NSDictionary<NSString *, id> *)modelCustomPropertyMapper
{
    return @{
             CRPropertyString(recID): @"id"};
}
@end
