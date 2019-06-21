//
//  RXParamDetailResponse.m
//  jingGang
//
//  Created by 荣旭 on 2019/6/20.
//  Copyright © 2019年 dengxf_dev. All rights reserved.
//

#import "RXParamDetailResponse.h"

@implementation RXParamDetailResponse
+(NSDictionary *) JSONKeyPathsByPropertyKey {
    return @{
             @"paramDetail":@"paramDetail",
             @"levelList":@"levelList",
             @"keywordGoodsList":@"keywordGoodsList",
             @"invitationList":@"invitationList",
             };
}
@end
