//
//  YSSurroundAreaCityInfo.m
//  jingGang
//
//  Created by dengxf on 17/2/23.
//  Copyright © 2017年 dengxf_dev. All rights reserved.
//

#import "YSSurroundAreaCityInfo.h"
#import "YSLocationManager.h"

#define kLocateAreaCityIdInfoKey           @"kLocateAreaCityIdInfoKey"
#define kLocateAreaCityNameInfoKey         @"kLocateAreaCityNameInfoKey"
#define kElseSelectedAreaCityIdInfoKey     @"kElseSelectedAreaCityIdInfoKey"
#define kElseSelectedAreaCityNameInfoKey   @"kElseSelectedAreaCityNameInfoKey"
#define kIsElseCityKey                     @"kIsElseCityKey"

@implementation YSSurroundAreaCityInfo

+ (void)saveLocateAreaInfo:(YSSurroundAreaCityInfo *)locateAreaInfo {
    [self save:locateAreaInfo.areaId key:kLocateAreaCityIdInfoKey];
    [self save:locateAreaInfo.areaName key:kLocateAreaCityNameInfoKey];
}

+ (void)saveElseSelectedAreaInfo:(YSSurroundAreaCityInfo *)selectedAreaInfo {
    [self save:selectedAreaInfo.areaId key:kElseSelectedAreaCityIdInfoKey];
    if ([selectedAreaInfo.areaId integerValue] == [[YSLocationManager sharedInstance].cityID integerValue]) {
        [self save:@0 key:kIsElseCityKey];
    }else {
        [self save:@1 key:kIsElseCityKey];
    }
    [self save:selectedAreaInfo.areaName key:kElseSelectedAreaCityNameInfoKey];
}

+ (YSSurroundAreaCityInfo *)achieveLocateAreaInfo {
    YSSurroundAreaCityInfo *locateAreaInfo = [[YSSurroundAreaCityInfo alloc] init];
    locateAreaInfo.areaId = [self achieve:kLocateAreaCityIdInfoKey];
    locateAreaInfo.areaName = [self achieve:kLocateAreaCityNameInfoKey];
    return locateAreaInfo;
}

+ (YSSurroundAreaCityInfo *)achieveElseSelectedAreaInfo {
    YSSurroundAreaCityInfo *selectedAreaInfo = [[YSSurroundAreaCityInfo alloc] init];
    selectedAreaInfo.areaId = [self achieve:kElseSelectedAreaCityIdInfoKey];
    selectedAreaInfo.areaName = [self achieve:kElseSelectedAreaCityNameInfoKey];
    return selectedAreaInfo;
}

+ (BOOL)isElseCity {
    return [(NSNumber *)[self achieve:kIsElseCityKey] integerValue];
}

+ (NSNumber *)selectedCityId {
    if ([self isElseCity]) {
        return (NSNumber *)[self achieve:kElseSelectedAreaCityIdInfoKey];
    }else {
        return [YSLocationManager sharedInstance].cityID;
    }
}

@end
