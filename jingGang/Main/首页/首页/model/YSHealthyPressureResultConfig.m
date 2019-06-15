//
//  YSHealthyPressureResultConfig.m
//  jingGang
//
//  Created by dengxf on 2017/8/7.
//  Copyright © 2017年 dengxf_dev. All rights reserved.
//

#import "YSHealthyPressureResultConfig.h"

#define YSPressureRecentlyResultDatas 5

@implementation YSHealthyPressureResultConfig

+ (NSInteger)handleBloodOxenResultDatas:(NSArray *)resultDatas {
    NSMutableArray *tempBloodOxens = [NSMutableArray arrayWithArray:resultDatas];
    if (tempBloodOxens.count > YSPressureRecentlyResultDatas) {
        [tempBloodOxens removeObjectsInRange:NSMakeRange(YSPressureRecentlyResultDatas, tempBloodOxens.count - YSPressureRecentlyResultDatas)];
    }
    NSNumber *arvBloodOxenNumber = [tempBloodOxens valueForKeyPath:@"@avg.intValue"];
    int arvBloodOxen = [arvBloodOxenNumber intValue];
    arvBloodOxen = (arvBloodOxen - (1 - arc4random_uniform(3)));
    return (NSInteger)arvBloodOxen;
}

+ (NSInteger)handleHeartResultDatas:(NSMutableArray *)resultsDatas {
    NSMutableArray *tempHeartRates = [NSMutableArray arrayWithArray:[resultsDatas copy]];
    if (tempHeartRates.count > YSPressureRecentlyResultDatas) {
        [tempHeartRates removeObjectsInRange:NSMakeRange(YSPressureRecentlyResultDatas, tempHeartRates.count - YSPressureRecentlyResultDatas)];
    }
    NSNumber *arvHeartRateNumber = [tempHeartRates valueForKeyPath:@"@avg.intValue"];
    int arvHeartRate = [arvHeartRateNumber intValue];
    
    arvHeartRate = (arvHeartRate - (2 - arc4random_uniform(4)));
    return (NSInteger)arvHeartRate;
}

+ (YSBloodPressure)handleBloodPressureResultDatas:(NSArray *)localDatas {
    YSBloodPressure tempBloodPressure;
    NSMutableArray *tempHighPressure = [NSMutableArray array];
    NSMutableArray *tempLowPressure = [NSMutableArray array];
    for (NSString *obj in localDatas) {
        NSArray *comArray = [obj componentsSeparatedByString:@"-"];
        [tempLowPressure xf_safeAddObject:comArray[0]];
        [tempHighPressure xf_safeAddObject:comArray[1]];
    }
    if (tempHighPressure.count > YSPressureRecentlyResultDatas) {
        [tempHighPressure removeObjectsInRange:NSMakeRange(YSPressureRecentlyResultDatas, tempHighPressure.count - YSPressureRecentlyResultDatas)];
        [tempLowPressure removeObjectsInRange:NSMakeRange(YSPressureRecentlyResultDatas, tempHighPressure.count - YSPressureRecentlyResultDatas)];
    }
    
    NSNumber *highNumber= [[tempHighPressure copy] valueForKeyPath:@"@avg.intValue"];
    NSNumber *lowNumber = [[tempLowPressure copy] valueForKeyPath:@"@avg.intValue"];
    
    tempBloodPressure.lowPressure = (NSInteger) ([lowNumber intValue] - (2 - arc4random_uniform(4)));
    tempBloodPressure.highPressure = (NSInteger)([highNumber intValue] - (2 - arc4random_uniform(4)));
    return tempBloodPressure;
}

+ (YSBloodPressure)defaultBloodPressure {
    return [self configFinalHighPressure:400 finalLowPressure:0];
}

// 处理高压数据
+ (YSBloodPressure)configFinalHighPressure:(int)highPressure finalLowPressure:(int)lowPressure
{
    JGLog(@"\n*********************");
    JGLog(@"\n#### Unity Manager ####");
    JGLog(@"\nHighPressure:%d \nLowPressure:%d",highPressure,lowPressure);
    JGLog(@"\n*********************");
    YSBloodPressure tempBloodPressure;
    tempBloodPressure.lowPressure = lowPressure;
    tempBloodPressure.highPressure = highPressure;
    // 处理异常数据
    if (highPressure < 110 || highPressure > 180 || lowPressure < 40 || lowPressure > 100) {
        // 查询本地数据
        id datas = [self achieve:kBloodPressureResultsDataKey];
        if (!datas) {
            // 本地数据为空
            if (highPressure < 110 || highPressure > 180) {
                highPressure = (int)[self highPressureRandomResult];;
            }
            
            if (lowPressure < 40 || lowPressure > 100) {
                lowPressure = (int)[self lowPressureRandomResult];
            }
            tempBloodPressure.lowPressure = (NSInteger)lowPressure;
            tempBloodPressure.highPressure = (NSInteger)highPressure;
            return tempBloodPressure;
        }else {
            // 存在本地数据
            tempBloodPressure = [self handleBloodPressureResultDatas:(NSMutableArray *)datas];
            return tempBloodPressure;
        }
    }else {
        // 查询是否有本地数据
        id datas = [self achieve:kBloodPressureResultsDataKey];
        NSString *datasString = [NSString stringWithFormat:@"%d-%d",lowPressure,highPressure];
        if (!datas) {
            // 不存在本地数据
            NSMutableArray *tempArray = [NSMutableArray array];
            [tempArray xf_safeAddObject:datasString];
            [self save:[tempArray copy] key:kBloodPressureResultsDataKey];
            tempBloodPressure = [self handleBloodPressureResultDatas:[tempArray copy]];
            return tempBloodPressure;
        }else {
            // 存在本地数据
            NSMutableArray *tempArray = [NSMutableArray arrayWithArray:(NSArray *)datas];
            [tempArray xf_safeInsertObject:datasString atIndex:0];
            [self save:[tempArray copy] key:kBloodPressureResultsDataKey];
            tempBloodPressure = [self handleBloodPressureResultDatas:[tempArray copy]];
            return tempBloodPressure;
        }
    }
    return tempBloodPressure;
}

+ (NSInteger)configNormalValueWithBloodOxen:(int)bloodOxen {
    if (bloodOxen < 80 || bloodOxen > 100) {
        return [self bloodOxenRandomResult];
    }else {
        return (NSInteger)bloodOxen;
    }
}

+ (NSInteger)defaultBloodOxen {
    return [self configFinalBloodOxen:0];
}

// 处理血氧数据
+ (NSInteger)configFinalBloodOxen:(int)bloodOxen {
    JGLog(@"\n*********************");
    JGLog(@"\n#### Unity Manager ####");
    JGLog(@"\nBloodOxen:%d",bloodOxen);
    JGLog(@"\n*********************");
    id datas = [self achieve:kBloodOxyenResultsDataKey];
    // 处理心率异常结果数据
    if (bloodOxen < 80 || bloodOxen > 100) {
        // 心率异常
        if (datas ) {
            // 本地存有数据
            return [self handleBloodOxenResultDatas:(NSArray *)datas];
        }else {
            // 本地没有数据 取随机数
            return [self bloodOxenRandomResult];
        }
    }else {
        // 心率结果在正常范围内
        NSNumber *bloodOxenNumber = [NSNumber numberWithInt:bloodOxen];
        if (datas) {
            NSMutableArray *tempBloodOxens = [NSMutableArray arrayWithArray:(NSArray *)datas];
            [tempBloodOxens xf_safeInsertObject:bloodOxenNumber atIndex:0];
            [self save:[tempBloodOxens copy] key:kBloodOxyenResultsDataKey];
            return [self handleBloodOxenResultDatas:[tempBloodOxens copy]];
        }else {
            NSMutableArray *tempBloodOxens = [NSMutableArray array];
            [tempBloodOxens xf_safeAddObject:bloodOxenNumber];
            [self save:[tempBloodOxens copy] key:kBloodOxyenResultsDataKey];
            return [self handleBloodOxenResultDatas:[tempBloodOxens copy]];
        }
    }
    return 0;
}

+ (NSInteger)defaultHeartRate {
    return [self configFinalHeartRate:0];
}

+ (NSInteger)configNormalValueWithHeartRate:(int)heartRate {
    if (heartRate < 40 || heartRate > 140) {
        return [self heartRateRandomResult];
    }else {
        return (NSInteger)heartRate;
    }
}

// 处理心率数据
+ (NSInteger)configFinalHeartRate:(int)heartRate {
    JGLog(@"\n*********************");
    JGLog(@"\n#### Unity Manager ####");
    JGLog(@"\nHeartRate:%d",heartRate);
    JGLog(@"\n*********************");
    // 处理异常心率结果数据
    id datas = [self achieve:kHeartRateResultsDataKey];
    if (heartRate < 40 || heartRate > 140) {
        // 心率测试结果异常
        // 获取本地数据
        if (datas) {
            // 本地有存储的数据
            return [self handleHeartResultDatas:[NSMutableArray arrayWithArray:(NSArray *)datas]];
        }else {
            return [self heartRateRandomResult];
        }
    }else {
        // 心率测试结果正常
        NSNumber *heartRateNumber = [NSNumber numberWithInt:heartRate];
        if (datas) {
            // 本地有存储的数据
            NSMutableArray *tempHeartRates = [NSMutableArray arrayWithArray:(NSArray *)datas];
            [tempHeartRates xf_safeInsertObject:heartRateNumber atIndex:0];
            [self save:[tempHeartRates copy] key:kHeartRateResultsDataKey];
            return [self handleHeartResultDatas:tempHeartRates];
        }else {
            // 本地没有存储数据
            NSMutableArray *tempArray = [NSMutableArray array];
            [tempArray xf_safeAddObject:heartRateNumber];
            [self save:[tempArray copy] key:kHeartRateResultsDataKey];
            return [self handleHeartResultDatas:tempArray];
        }
    }
    return 0;
}

// 返回心率随机数
+ (NSInteger)heartRateRandomResult {
    return (NSInteger)(67 - (2 - arc4random_uniform(5)));
}

// 返回血氧随机数
+ (NSInteger)bloodOxenRandomResult {
    return (NSInteger)(96 - (1 - arc4random_uniform(4)));
}

// 高压
+ (NSInteger)highPressureRandomResult {
    return (NSInteger)(115 - (1 - arc4random_uniform(4)));
}

// 低压
+ (NSInteger)lowPressureRandomResult {
    return (NSInteger)(80 - (3 - arc4random_uniform(6)));
}
@end
