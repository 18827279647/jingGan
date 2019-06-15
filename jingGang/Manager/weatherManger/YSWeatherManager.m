//
//  YSWeatherManager.m
//  jingGang
//
//  Created by dengxf on 16/8/12.
//  Copyright © 2016年 Dengxf_Dev. All rights reserved.
//

#import "YSWeatherManager.h"
#import "AFHTTPRequestOperationManager.h"

@implementation YSWeatherInfo

- (NSString *)description {
    return [NSString stringWithFormat:@"temperature:%@-weather%@",self.temperature,self.weather];
}

@end

@implementation YSWeatherManager

- (NSMutableArray *)citys {
    static NSMutableArray *citys;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        citys = [NSMutableArray array];
        NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"weather" ofType:@"json"];
        NSData *datas = [NSData dataWithContentsOfFile:plistPath];
        NSError *error;
        NSDictionary *weatherDict = [NSJSONSerialization JSONObjectWithData:datas options:NSJSONReadingMutableContainers error:&error];
        if (error) {
            JGLog(@"天气初始化失败");
        }else {
            for (NSDictionary *dict in weatherDict[@"cityCode"]) {
                for (NSDictionary *dict1 in dict[@"city"]) {
                    [citys xf_safeAddObject:dict1];
                }
            }
        }
    });
    return citys;
}

+ (void)city:(NSString *)city fail:(void(^)())fail success:(void(^)(YSWeatherInfo *))successCallback{
    NSString *cityId;
    for (NSDictionary *dict in [[self alloc] citys]) {
        if ([city rangeOfString:dict[@"cityName" ]].length > 0) {
            cityId = dict[@"id"];
            if (cityId.length) {
                [self requestWeatherWithCityId:cityId weatherInfoCallback:successCallback error:fail];
            }
            return;
        }else {
            BLOCK_EXEC(fail);
        }
    }
}

+ (void)requestWeatherWithCityId:(NSString *)cityId weatherInfoCallback:(void(^)(YSWeatherInfo *))weatherInfoCallback error:(voidCallback)error{
    NSString *path = @"http://weather.123.duba.net/static/weather_info/cityNumber.html";
    if (cityId) {
        path=[path stringByReplacingOccurrencesOfString:@"cityNumber" withString:cityId];
    }
    
    
//    JGLog(@"update:%f",[NSDate timeStampWithDate:[NSDate date]]);
    
    NSURL *url = [NSURL URLWithString:path];
    NSURLRequest *req = [NSURLRequest requestWithURL:url];
    
    [NSURLConnection sendAsynchronousRequest:req queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (connectionError) {
            BLOCK_EXEC(error);
        }else {
            NSString *jsonValue = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSArray *array = [jsonValue componentsSeparatedByString:@"_callback"];
            NSString * jsonStr = [array lastObject];
            NSArray *array1 = [jsonStr componentsSeparatedByString:@"("];
            NSString * jsonStr1 = [array1 lastObject];
            NSArray *array2 = [jsonStr1 componentsSeparatedByString:@")"];
            NSString * jsonStr2 = [array2 firstObject];
            NSData *jsonData = [jsonStr2 dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                options:NSJSONReadingMutableContainers
                                                                  error:nil];
//            NSString *city = [[dic objectForKey:@"weatherinfo"] objectForKey:@"city"];
            /**
             *  温度 */
            NSString * temp = [[dic objectForKey:@"weatherinfo"] objectForKey:@"temp1"];
//            NSArray  * max = [temp componentsSeparatedByString:@"℃~"];
//            NSString * maxWeather = [max firstObject];
//            NSString *minWeather = [max lastObject];
            /**
             *  天气 */
            NSString *weather    = [[dic objectForKey:@"weatherinfo"] objectForKey:@"weather1"];
            
            YSWeatherInfo *weatherInfo = [[YSWeatherInfo alloc] init];
            weatherInfo.temperature = temp;
            weatherInfo.weather = weather;
            
            NSString *weatherTag = [NSString stringWithFormat:@"%@",[[dic objectForKey:@"weatherinfo"] objectForKey:@"st1"]];
            weatherInfo.weatherTag = weatherTag;
            BLOCK_EXEC(weatherInfoCallback,weatherInfo);
//            NSString *pm     = [[dic objectForKey:@"weatherinfo"] objectForKey:@"pm"];
//            NSString *sd_num     = [[dic objectForKey:@"weatherinfo"] objectForKey:@"sd"];
//            NSString *pm_lev     = [[dic objectForKey:@"weatherinfo"] objectForKey:@"pm-level"];
//            NSString *wind       = [[dic objectForKey:@"weatherinfo"] objectForKey:@"wd"];
//            NSString *wind_lev   = [[dic objectForKey:@"weatherinfo"] objectForKey:@"wind1"];
//            NSString *st1        = dic[@"weatherinfo"][@"st1"];
//            NSString *pm_num     = dic[@"weatherinfo"][@"pm-num"];
//            NSString *pm_pubtime = dic[@"weatherinfo"][@"pm-pubtime"];
        }
    }];
}


@end
