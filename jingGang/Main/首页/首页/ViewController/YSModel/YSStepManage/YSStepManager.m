//
//  YSStepManager.m
//  jingGang
//
//  Created by dengxf on 16/7/28.
//  Copyright © 2016年 Dengxf_Dev. All rights reserved.
//

//获取步数请打开

#import "YSStepManager.h"
#import <HealthKit/HealthKit.h>
#import "DateTools.h"
#import "GCD.h"
#import "JGDateTools.h"

@implementation YSCalorieCalculateManage


+ (CGFloat)calorieWithSteps:(NSInteger)steps
{
    CGFloat mileage = [self getMileageWithSteps:steps];
    CGFloat Weight = 60;
    CGFloat caloli = 0.6 * Weight * mileage;
    return caloli;
}

+ (CGFloat)getMileageWithSteps:(NSInteger)steps
{
    NSInteger stepLength = [self readDisCMByHeight:165];
    return (stepLength * steps)/100000.0;
}

+ (int)readDisCMByHeight:(int)hei
{
    int tempHei = hei;
    if (tempHei < 50) {
        tempHei = 50;
    } else if (tempHei > 190) {
        tempHei = 190;
    } else {
        if (tempHei%10) {
            tempHei = (tempHei/10+1)*10;
        } else {
            tempHei = tempHei/10*10;
        }
    }
    
    int stepLength = 0;
    switch (tempHei) {
        case 50:
        {
            stepLength = 20;
        }
            break;
        case 60:
        {
            stepLength = 22;
        }
            break;
        case 70:
        {
            stepLength = 25;
        }
            break;
        case 80:
        {
            stepLength = 29;
        }
            break;
        case 90:
        {
            stepLength = 33;
        }
            break;
        case 100:
        {
            stepLength = 37;
        }
            break;
        case 110:
        {
            stepLength = 40;
        }
            break;
        case 120:
        {
            stepLength = 44;
        }
            break;
        case 130:
        {
            stepLength = 48;
        }
            break;
        case 140:
        {
            stepLength = 51;
        }
            break;
        case 150:
        {
            stepLength = 55;
        }
            break;
        case 160:
        {
            stepLength = 59;
        }
            break;
        case 170:
        {
            stepLength = 62;
        }
            break;
        case 180:
        {
            stepLength = 66;
        }
            break;
        case 190:
        {
            stepLength = 70;
        }
            break;
        default:
            break;
    }
    return stepLength;
}


@end

@interface YSStepManager ()

@property (strong,nonatomic) HKHealthStore *healthStore;

@end

@implementation YSStepManager

/**
 *  健康数据权限 */
+ (BOOL)healthyKitAccess {
    if(![HKHealthStore isHealthDataAvailable]) {
        JGLog(@"设备不支持healthKit");
        return NO;
    }else {
        return YES;
    }
}

+ (void)healthStoreDataWithStartDate:(NSString *)startDate
                             endDate:(NSString *)endDate
                      WithFailAccess:(voidCallback)fail
                  walkRunningCallback:(void(^)(NSNumber *))walkRunningCallback
                         stepCallback:(void(^)(NSNumber *))stepCallback {
//
//
    NSString *nowDateString = [JGDateTools nowDateInfo];
    NSString *beginDateString = [NSString stringWithFormat:@"%@ %@",nowDateString,@"00:00:00"];
    NSString *endDateString = [NSString stringWithFormat:@"%@ %@",nowDateString,@"23:59:59"];

    if (![YSStepManager sharedInstance].healthStore) {

        [YSStepManager sharedInstance].healthStore = [[HKHealthStore alloc] init];
    }

    // HKQuantityTypeIdentifierDistanceWalkingRunning

    //设置需要获取的权限这里仅设置了步数
    HKObjectType *stepCount = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierStepCount];
    HKObjectType *walkRunningCount = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierDistanceWalkingRunning];

    NSSet *healthSet = [NSSet setWithObjects:stepCount, walkRunningCount,nil];
    [GCDQueue executeInGlobalQueue:^{
        [[YSStepManager sharedInstance].healthStore requestAuthorizationToShareTypes:nil readTypes:healthSet completion:^(BOOL success, NSError * _Nullable error) {
            if (success)
            {
                JGLog(@"获取权限成功");
                //NSSortDescriptors用来告诉healthStore怎么样将结果排序。
                NSSortDescriptor *start = [NSSortDescriptor sortDescriptorWithKey:HKSampleSortIdentifierStartDate ascending:NO];
                NSSortDescriptor *end = [NSSortDescriptor sortDescriptorWithKey:HKSampleSortIdentifierEndDate ascending:NO];
                NSDate *startDate =  [self dateAddTimeZone:[self handleResposTimeForm:beginDateString]];

                NSDate *endDate = [self dateAddTimeZone:[self handleResposTimeForm:endDateString]];

                NSPredicate *predicate = [HKQuery predicateForSamplesWithStartDate:startDate endDate:endDate options:HKQueryOptionNone];

                //获取步数后我们调用获取步数的方法

                //查询采样信息
                HKSampleType *walkRunningType = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierDistanceWalkingRunning];

                HKSampleType *stepType = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierStepCount];

                /*查询的基类是HKQuery，这是一个抽象类，能够实现每一种查询目标，这里我们需要查询的步数是一个
                 HKSample类所以对应的查询类就是HKSampleQuery。
                 下面的limit参数传1表示查询最近一条数据,查询多条数据只要设置limit的参数值就可以了
                 */

                // walkRunning
                [GCDQueue executeInGlobalQueue:^{
                    HKSampleQuery *walkRunningQuery = [[HKSampleQuery alloc] initWithSampleType:walkRunningType predicate:predicate limit:0 sortDescriptors:@[start,end] resultsHandler:^(HKSampleQuery * _Nonnull query, NSArray<__kindof HKSample *> * _Nullable results, NSError * _Nullable error) {

                        CGFloat totleWalkRunnings = 0;
                          double totleSteps = 0;
                        for (HKQuantitySample *simple in results) {
//                            NSString *walkRunningString = [simple.quantity description];
//                            NSArray *walkRunnings = [walkRunningString componentsSeparatedByString:@" "];
//                            walkRunningString = walkRunnings[0];
//
//                            NSInteger walkRunning = [walkRunningString integerValue];
//                            totleWalkRunnings += walkRunning;
//                            NSLog(@"walkRunning==========%zi", walkRunning);
                            HKQuantity *quantity = simple.quantity;
                            HKUnit *distanceUnit = [HKUnit meterUnitWithMetricPrefix:HKMetricPrefixKilo];
                            double usersHeight = [quantity doubleValueForUnit :distanceUnit];
//                            NSLog(@"usersHeight==========%zi", usersHeight);

                            totleSteps += usersHeight;
                        }
//                            NSLog(@"totleSteps==========%zi", totleSteps);

//                        totleWalkRunnings = totleWalkRunnings / 1000.0;


                        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                            //查询是在多线程中进行的，如果要对UI进行刷新，要回到主线程中
                            NSDictionary *walkRunningDict = @{
                                                              kWalkRunningCount:[NSNumber numberWithInteger:totleWalkRunnings]
                                                              };
                            BLOCK_EXEC(walkRunningCallback,[NSNumber numberWithFloat:totleWalkRunnings]);

                        }];

                    }];
                    [[YSStepManager sharedInstance].healthStore executeQuery:walkRunningQuery];
                }];

                [GCDQueue executeInGlobalQueue:^{
                    HKSampleQuery *stepQuery = [[HKSampleQuery alloc] initWithSampleType:stepType predicate:predicate limit:0 sortDescriptors:@[start,end] resultsHandler:^(HKSampleQuery * _Nonnull query, NSArray<__kindof HKSample *> * _Nullable results, NSError * _Nullable error) {

                        NSInteger totleSteps = 0;
//                        for (HKQuantitySample *simple in results) {
//                            NSString *stepString = [simple.quantity description];
//                            NSArray *steps = [stepString componentsSeparatedByString:@" "];
//                            stepString = steps[0];
//
//                            NSInteger step = [stepString integerValue];
//                            NSLog(@"step==========%zi", step);
//
//                            totleSteps += step;
//                        }
                        
                            //设置一个int型变量来作为步数统计
                            for (int i = 0; i < results.count; i ++) {
                                //把结果转换为字符串类型
                                HKQuantitySample *result = results[i];
                                HKQuantity *quantity = result.quantity;
                                NSMutableString *stepCount = (NSMutableString *)quantity;
                                NSString *stepStr =[ NSString stringWithFormat:@"%@",stepCount];
                                //获取51 count此类字符串前面的数字
                                NSString *str = [stepStr componentsSeparatedByString:@" "][0];
                                
                                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                                    NSLog(@"获取今天到现在为止的步数 %@",stepCount);
                                }];
                                int stepNum = [str intValue];
                                NSLog(@"%d",stepNum);
                                //把一天中所有时间段中的步数加到一起
                                totleSteps = totleSteps + stepNum;
                            }
                            
                  
                        
                        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                            //查询是在多线程中进行的，如果要对UI进行刷新，要回到主线程中
                            NSDictionary *stepDict = @{
                                                              kStepCount:[NSNumber numberWithInteger:totleSteps]
                                                              };
                            BLOCK_EXEC(stepCallback,[NSNumber numberWithInteger:totleSteps]);
                        }];

                    }];
                    [[YSStepManager sharedInstance].healthStore executeQuery:stepQuery];
                }];


        }else
            {
                [GCDQueue executeInMainQueue:^{
                    JGLog(@"获取步数权限失败");
                    BLOCK_EXEC(fail);
                }];
            }
        }];


    }];
}

+ (NSDate *)dateAddTimeZone:(NSDate *)date{
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate: date];
    NSDate *zoneDate = [date  dateByAddingTimeInterval:interval];
    return zoneDate;
}

+ (NSDate *)handleResposTimeForm:(NSString *)formTime {
    if (!formTime || [formTime isEqualToString:@"(null)"]) {
        return nil;
    }
    
    NSString *year;
    NSString *month;
    NSString *day;
    
    NSString *hour;
    NSString *minute;
    NSString *second;
    
    NSArray *array = [formTime componentsSeparatedByString:@" "];
    NSString *date = array[0];
    NSString *time = array[1];
    
    if (!date || !time) {
        return nil;
    }
    NSArray *dateArray = [date componentsSeparatedByString:@"-"];
    year = dateArray[0];
    month = dateArray[1];
    day = dateArray[2];
    
    NSArray *timeArray = [time componentsSeparatedByString:@":"];
    hour = timeArray[0];
    minute = timeArray[1];
    second = timeArray[2];
    
    NSDate *targetDate = [NSDate dateWithYear:[self stringTransformInteger:year] month:[self stringTransformInteger:month] day:[self stringTransformInteger:day] hour:[self stringTransformInteger:hour] minute:[self stringTransformInteger:minute] second:[self stringTransformInteger:second]];    return targetDate;
}

+ (NSInteger)stringTransformInteger:(NSString *)string
{
    return [string integerValue];
}


@end
