//
//  YSActivitiesInfoItem.m
//  jingGang
//
//  Created by dengxf on 2017/10/12.
//  Copyright © 2017年 dengxf_dev. All rights reserved.
//

#import "YSActivitiesInfoData.h"

@implementation YSActivitiesInfoItem

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"activtyID" : @"id"};
}

- (void)setPopUpSite:(NSString *)popUpSite {
    _popUpSite = popUpSite;
    NSInteger site = [popUpSite integerValue];
    switch (site) {
        case 1:
            self.activityIdentifier = @"healthmanage.com";  //首页
            break;
        case 2:
            self.activityIdentifier = @"healthcircle.com";//商城
            break;
        case 3:
            self.activityIdentifier = @"nearm.com";//周边
            break;
        case 4:
            self.activityIdentifier = @"shopm.com";//我的
            break;
        case 5:
            self.activityIdentifier = @"jirirenwu.com";//今日任务
            break;
        default:
            break;
    }
}

@end

@implementation YSActivitiesInfoData

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
             @"actList" : [YSActivitiesInfoItem class]
             };
}

@end
