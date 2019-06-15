//
//  YSBaseInfoManager.h
//  jingGang
//
//  Created by dengxf on 16/8/12.
//  Copyright © 2016年 Dengxf_Dev. All rights reserved.
//

#import <Foundation/Foundation.h>

@class YSWeatherInfo;

/**
 *  处理健康管理基本信息类  当前城市、 天气 、温度等...*/
@interface YSBaseInfoManager : NSObject

+ (void)storageCity:(NSString *)city;

+ (NSString *)city;

+ (void)storageWeatherInfo:(YSWeatherInfo *)weatherInfo;

+ (void)loadBaseInfo:(void(^)(NSString *city,YSWeatherInfo *weatherInfo))baseInfo;

@end
