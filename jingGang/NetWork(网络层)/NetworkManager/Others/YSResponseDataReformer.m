//
//  YSResponseDataReformer.m
//  YSNetworkManagerDemo
//
//  Created by dengxf on 17/6/15.
//  Copyright © 2017年 dengxf. All rights reserved.
//

#import "YSResponseDataReformer.h"
#import "YSAuquireMassageDataModel.h"
#import "NSObject+YYModel.h"
#import "YSNearAdContentModel.h"
#import "YSNearClassListModel.h"
#import "YSQueryIntegralInfoModel.h"
#import "YSSwapIntegralModel.h"
#import "YSCheckUserBingIdentityCardItem.h"
#import "YSAIOSaveBindingItem.h"
#import "YSAIODataItem.h"
#import "YSUserAIOInfoItem.h"
#import "YSActivitiesInfoData.h"
#import "YSVerifyCodeItem.h"
#import "YSScreenLauchAdItem.h"
#import "YSAdContentItem.h"

@implementation YSResponseDataReformer

- (id)reformDataWithAPIManager:(YSAPIBaseManager *)manager {
    NSDictionary *dict = manager.response.responseObject;
    if ([manager isKindOfClass:NSClassFromString(@"YSAcquireMassageDataManager")]) {
        return [YSAuquireMassageDataModel modelWithDictionary:dict];
    }else if ([manager isKindOfClass:NSClassFromString(@"YSNearAdContentDataManager")]){
        return [YSNearAdContentModel modelWithDictionary:dict];
    }else if ([manager isKindOfClass:NSClassFromString(@"YSNearClassListDataManager")]){
        return [YSNearClassListModel modelWithDictionary:dict];
    }else if ([manager isKindOfClass:NSClassFromString(@"YSPersonalIntegalDataManager")]) {
        return [YSQueryIntegralInfoModel modelWithDictionary:dict];
    }else if ([manager isKindOfClass:NSClassFromString(@"YSIntegralSwapDataManager")]) {
        return [YSSwapIntegralModel modelWithDictionary:dict];
    }else if ([manager isKindOfClass:NSClassFromString(@"YSCheckUserIsBindIdentityCardDataManager")]) {
        return [YSCheckUserBingIdentityCardItem modelWithDictionary:dict];
    }else if ([manager isKindOfClass:NSClassFromString(@"YSAIOSaveBindingDataManager")]) {
        return [YSAIOSaveBindingItem modelWithDictionary:dict];
    }else if ([manager isKindOfClass:NSClassFromString(@"YSGetAIODataManager")]) {
        return [YSAIODataItem modelWithDictionary:dict];
    }else if ([manager isKindOfClass:NSClassFromString(@"YSAchiveAIOInfoDataManager")]) {
        return [YSUserAIOInfoItem modelWithDictionary:dict];
    }else if ([manager isKindOfClass:NSClassFromString(@"YSActivtiesInfoDataManager")]) {
        return [YSActivitiesInfoData modelWithDictionary:dict];
    }else if ([manager isKindOfClass:NSClassFromString(@"YSSecurityVerifyCodeDataManager")]) {
        return [YSVerifyCodeItem modelWithDictionary:dict];
    }else if ([manager isKindOfClass:NSClassFromString(@"YSScreenLauchDataManager")]) {
        return [YSScreenLauchAdItem modelWithDictionary:dict];
    }else if ([manager isKindOfClass:NSClassFromString(@"YSAdContentDataManager")]) {
        return [YSAdContentItem modelWithDictionary:dict];
    }
    return [YSBaseResponseItem modelWithDictionary:dict];
}

@end
