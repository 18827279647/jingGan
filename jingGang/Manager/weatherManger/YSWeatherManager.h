//
//  YSWeatherManager.h
//  jingGang
//
//  Created by dengxf on 16/8/12.
//  Copyright © 2016年 Dengxf_Dev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSObject+AutoEncode.h"

@class YSWeatherInfo;

@interface YSWeatherManager : NSObject

+ (void)city:(NSString *)city fail:(void(^)())fail success:(void(^)(YSWeatherInfo *))successCallback;

@end



@interface YSWeatherInfo : NSObject

/**
 *  温度 */
@property (copy , nonatomic) NSString *temperature;

/**
 *  天气 */
@property (copy , nonatomic) NSString *weather;

/**
 *  天气标识 */
@property (copy , nonatomic) NSString *weatherTag;

@property (copy, nonatomic) NSString *times;


@end
