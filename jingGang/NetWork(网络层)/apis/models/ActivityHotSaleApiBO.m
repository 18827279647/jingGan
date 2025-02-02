//
//  Role.m
//  VApiSDK_iOS
//
//  Created by duocai on 14-6-14.
//  Copyright (c) 2014年 duocai. All rights reserved.
//

#import "ActivityHotSaleApiBO.h"

@implementation ActivityHotSaleApiBO
+(NSDictionary *) JSONKeyPathsByPropertyKey {
    return @{
             @"apiId":@"id",
             @"hotName":@"hotName",
             @"firstImage":@"firstImage",
             @"headImage":@"headImage",
             @"footImage":@"footImage",
             @"vcode":@"vcode",
             @"startTime":@"startTime",
             @"endTime":@"endTime",
             @"backGroundColor":@"backGroundColor",
             @"adsURL":@"adsURL",
             @"imageSize":@"imageSize",
             @"updateMark":@"updateMark",
             @"alterPic":@"alterPic",
             @"firstOpen":@"firstOpen",
             @"customOpen":@"customOpen",
             @"floatPic":@"floatPic",
             @"floatPicShow":@"floatPicShow",
             @"openStartTime":@"openStartTime",
             @"openEndTime":@"openEndTime"
             };
}
@end
