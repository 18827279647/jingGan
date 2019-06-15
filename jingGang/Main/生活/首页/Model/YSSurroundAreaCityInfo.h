//
//  YSSurroundAreaCityInfo.h
//  jingGang
//
//  Created by dengxf on 17/2/23.
//  Copyright © 2017年 dengxf_dev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YSSurroundAreaCityInfo : NSObject

@property (copy , nonatomic) NSNumber *areaId;
@property (copy , nonatomic) NSString *areaName;

/**
 *  保存定位城市信息 */
+ (void)saveLocateAreaInfo:(YSSurroundAreaCityInfo *)locateAreaInfo;

/**
 *  保存选择城市信息 */
+ (void)saveElseSelectedAreaInfo:(YSSurroundAreaCityInfo *)selectedAreaInfo;

/**
 *  获取定位城市信息 */
+ (YSSurroundAreaCityInfo *)achieveLocateAreaInfo;

/**
 *  获取已选择城市信息 */
+ (YSSurroundAreaCityInfo *)achieveElseSelectedAreaInfo;

/**
 *  是否为非定位城市 */
+ (BOOL)isElseCity;

/**
 *  选择城市Id */
+ (NSNumber *)selectedCityId;

@end
