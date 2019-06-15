//
//  AppInitResponse.m
//  VApiSDK_iOS
//
//  Created by duocai on 14-6-16.
//  Copyright (c) 2014年 duocai. All rights reserved.
//

#import "HealthManageIndexResponse.h"

@implementation HealthManageIndexResponse
+(NSDictionary *) JSONKeyPathsByPropertyKey {
    return @{
             @"errorCode":@"code",
             @"msg":@"msg",
             @"subCode":@"sub_code",
             @"subMsg":@"sub_msg",
             @"userCustomer":@"userCustomer",
             @"userQuestionnaire":@"userQuestionnaire",
             @"todayTaskList":@"todayTaskList",
             @"healthCircles":@"healthCircles",
             @"jiBingURL":@"jiBingURL",
             @"yangShengURL":@"yangShengURL",
             @"shanShiURL":@"shanShiURL",
             @"retestURL":@"retestURL"
             };
}


//+(NSValueTransformer *) userCustomerTransformer
//{
//    return [NSValueTransformer mtl_JSONDictionaryTransformerWithModelClass:[UserCustomerBO class]];
//}
//+(NSValueTransformer *) userQuestionnaireTransformer
//{
//    return [NSValueTransformer mtl_JSONDictionaryTransformerWithModelClass:[UserQuestionnaireBO class]];
//}
//+(NSValueTransformer *) todayTaskListTransformer
//{
//    return [NSValueTransformer mtl_JSONDictionaryTransformerWithModelClass:[TodayHealthTaskBO class]];
//}
//+(NSValueTransformer *) healthCirclesTransformer
//{
//    return [NSValueTransformer mtl_JSONDictionaryTransformerWithModelClass:[HealthCircleBo class]];
//}
@end
