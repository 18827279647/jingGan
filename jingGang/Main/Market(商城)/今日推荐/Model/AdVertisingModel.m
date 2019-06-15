//
//  AdVertisingModel.m
//  jingGang
//
//  Created by whlx on 2019/5/17.
//  Copyright © 2019年 dengxf_dev. All rights reserved.
//

#import "AdVertisingModel.h"

@implementation AdVertisingModel
+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass
{
    return @{CRPropertyString(adContent): CRClass(AdVertisingListModel)};
}
@end
