//
//  RXUserDetailResponse.m
//  jingGang
//
//  Created by 荣旭 on 2019/6/17.
//  Copyright © 2019年 dengxf_dev. All rights reserved.
//

#import "RXUserDetailResponse.h"

@implementation RXUserDetailResponse
+(NSDictionary *) JSONKeyPathsByPropertyKey {
    return @{
             @"healthUserBO":@"healthUserBO",
             @"recommends":@"recommends",
             @"adContentBO":@"adContentBO",
             @"healthServiceRecommendBgBO":@"healthServiceRecommendBgBO",
             @"healthServiceRecommendJdBO":@"healthServiceRecommendJdBO",
             @"healthServiceRecommendXyBO":@"healthServiceRecommendXyBO",
             @"invitationList":@"invitationList",
             @"keywordGoodsList":@"keywordGoodsList",
             @"others":@"others",
             @"healthList":@"healthList",
//             @"bgImg":@"bgImg",
             @"memberNotice":@"memberNotice",
             @"memberLastTime":@"memberLastTime",
             @"isMember":@"isMember",
             @"messageTitle":@"messageTitle",
             @"isLA":@"isLA",
             @"hasHealth":@"hasHealth",
             @"url":@"url"
            };
}
@end
