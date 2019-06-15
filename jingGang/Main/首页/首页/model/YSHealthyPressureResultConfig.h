//
//  YSHealthyPressureResultConfig.h
//  jingGang
//
//  Created by dengxf on 2017/8/7.
//  Copyright © 2017年 dengxf_dev. All rights reserved.
//

#import <Foundation/Foundation.h>

struct YSBloodPressure {
    NSInteger highPressure;
    NSInteger lowPressure;
};

typedef struct YSBloodPressure YSBloodPressure;

@interface YSHealthyPressureResultConfig : NSObject

+ (YSBloodPressure)configFinalHighPressure:(int)highPressure finalLowPressure:(int)lowPressure;

+ (YSBloodPressure)defaultBloodPressure;

// 心率
+ (NSInteger)configFinalHeartRate:(int)heartRate;

+ (NSInteger)defaultHeartRate;

+ (NSInteger)configNormalValueWithHeartRate:(int)heartRate;

// 血氧
+ (NSInteger)configFinalBloodOxen:(int)bloodOxen;

+ (NSInteger)defaultBloodOxen;

+ (NSInteger)configNormalValueWithBloodOxen:(int)bloodOxen;

@end
