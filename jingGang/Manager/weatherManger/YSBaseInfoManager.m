//
//  YSBaseInfoManager.m
//  jingGang
//
//  Created by dengxf on 16/8/12.
//  Copyright © 2016年 Dengxf_Dev. All rights reserved.
//

#import "YSBaseInfoManager.h"
#import "YSWeatherManager.h"
#import "GlobeObject.h"

#define  kUpdateWeatherTimes (10 * 60)

@implementation YSBaseInfoManager

#define KDocumentPath [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) lastObject]
#define kWeatherInfoPath [KDocumentPath stringByAppendingPathComponent:@"weather.archiver"]

+ (void)storageCity:(NSString *)city {
    if (!city) {
        return;
    }
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    [userDefaults setObject:city forKey:kBaseInfoUserCityKey];
    
    [userDefaults synchronize];
}

+ (NSString *)city {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *cityString = [userDefaults objectForKey:kBaseInfoUserCityKey];
    if (cityString && cityString.length && ![cityString isKindOfClass:[NSNull class]]) {
        return cityString;
    }else{
        return @"武汉市";
    }
}

+ (void)storageWeatherInfo:(YSWeatherInfo *)weatherInfo {
    if (!weatherInfo) {
        return;
    }
    
    weatherInfo.times = [NSString stringWithFormat:@"%f",[NSDate timeStampWithDate:[NSDate date]]];
    BOOL ret =  [NSKeyedArchiver archiveRootObject:weatherInfo toFile:kWeatherInfoPath];
    if (!ret) {
        return;
    }else {
        
    }
}

+ (void)loadBaseInfo:(void (^)(NSString *, YSWeatherInfo *))baseInfoCallback {
    NSString *city;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    city = [defaults objectForKey:kBaseInfoUserCityKey];
    if (!city) {
        city = @"武汉市";
    }
    
    YSWeatherInfo *weatherInfo;
    weatherInfo = [NSKeyedUnarchiver unarchiveObjectWithFile:kWeatherInfoPath];
    
    NSTimeInterval nowTimes = [NSDate timeStampWithDate:[NSDate date]];
    
    if ((nowTimes - [weatherInfo.times floatValue]) > kUpdateWeatherTimes) {
        weatherInfo.times = [NSString stringWithFormat:@"%f",nowTimes];
        [self storageWeatherInfo:weatherInfo];
        
        [YSWeatherManager city:city fail:^{
            if (weatherInfo) {
                BLOCK_EXEC(baseInfoCallback,city,weatherInfo);
            }else{
                BLOCK_EXEC(baseInfoCallback,city,nil);
            }

        } success:^(YSWeatherInfo *weatherInfo) {
            if (weatherInfo) {
                BLOCK_EXEC(baseInfoCallback,city,weatherInfo);
            }else{
                BLOCK_EXEC(baseInfoCallback,city,nil);
            }
            
        }];
    }else {
        if (weatherInfo) {
            BLOCK_EXEC(baseInfoCallback,city,weatherInfo);
        }else{
            BLOCK_EXEC(baseInfoCallback,city,nil);
        }
    
    }
}

@end
