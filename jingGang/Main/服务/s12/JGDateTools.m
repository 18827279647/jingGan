//
//  JGDateTools.m
//  jingGang
//
//  Created by dengxf on 15/12/22.
//  Copyright © 2015年 yi jiehuang. All rights reserved.
//

#import "JGDateTools.h"
#import "NSDate+DateTools.h"

static JGDateTools *tools = nil;

static NSInteger popCount = 2;

@implementation JGDateTools

+ (instancetype)sharedInstanced {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        tools = [[self alloc] init];
    });
    return tools;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.containArray = [NSMutableArray array];
    }
    return self;
}

+ (void)addDate:(NSString *)dateString {
    NSMutableArray *array = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"kContainArray"]];
    [array addObject:dateString];
    [[NSUserDefaults standardUserDefaults] setObject:array forKey:@"kContainArray"];
    [[NSUserDefaults standardUserDefaults] synchronize];

}

+ (NSMutableArray *)queryArray {
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"kContainArray"];
}

+ (BOOL)checkShouldPopDateSting:(NSString *)dateString {
    NSMutableArray *defArray = [NSMutableArray arrayWithArray:[self queryArray]];
    NSInteger i = 0;
    for (NSString *obj in defArray) {
        if ([obj isEqualToString:dateString]) {
            i += 1;
        }
    }
    JGLog(@"----------------------------------------");
    JGLog(@"********\n第%ld次",i);
    JGLog(@"----------------------------------------");

    if (i < popCount) {
        return YES;
    }else
        return NO;
}

+ (NSString *)nowDateInfo{
//   @"2015-12-24";
    //return @"2015-12-12";
    return [[self todayDateInfo] xf_safeObjectAtIndex:0];
}

+ (NSString *)currentTimeInfo {
    return [[self todayDateInfo] xf_safeObjectAtIndex:1];
}

+ (NSInteger)transformCurrentTime {
    NSString *currenTimeString = [self currentTimeInfo];
    NSArray *times = [currenTimeString componentsSeparatedByString:@":"];
    NSInteger hour = [[NSString stringWithFormat:@"%@",[times xf_safeObjectAtIndex:0]] integerValue];
    NSInteger minute = [[NSString stringWithFormat:@"%@",[times xf_safeObjectAtIndex:1]] integerValue];
    return (hour * 60 + minute);
}

+ (NSArray *)todayDateInfo {
    NSDate *date = [NSDate date];
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    
    NSInteger interval = [zone secondsFromGMTForDate: date];
    NSDate *localeDate = [date  dateByAddingTimeInterval:interval];
    NSString *dateString = [localeDate description];
    
    return [dateString componentsSeparatedByString:@" "];
}

- (NSDate *)handleResposTimeForm:(NSString *)formTime {
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
    if (!dateArray.count) {
        return nil;
    }
    year = [dateArray xf_safeObjectAtIndex:0];
    month = [dateArray xf_safeObjectAtIndex:1];
    day = [dateArray xf_safeObjectAtIndex:2];
    
    NSArray *timeArray = [time componentsSeparatedByString:@":"];
    
    hour = [timeArray xf_safeObjectAtIndex:0];
    minute = [timeArray xf_safeObjectAtIndex:1];
    second = [timeArray xf_safeObjectAtIndex:2];
    
    NSDate *targetDate = [NSDate dateWithYear:[self stringTransformInteger:year] month:[self stringTransformInteger:month] day:[self stringTransformInteger:day] hour:[self stringTransformInteger:hour] minute:[self stringTransformInteger:minute] second:[self stringTransformInteger:second]];
    
//    NSTimeZone *zone = [NSTimeZone systemTimeZone];
//    NSInteger interval = [zone secondsFromGMTForDate: targetDate];
//    targetDate = [targetDate dateByAddingTimeInterval: interval];
    return targetDate;
}

- (BOOL)nowContainedActivityPeriodWithBeginTime:(NSString *)beginTime endTime:(NSString *)endTime
{
    // 当前时间
    NSDate *nowDate = [tools transLoacalDate:[NSDate date]];
    
    // 活动开始时间
    NSDate *beginDate = [tools handleResposTimeForm:beginTime];
    beginDate = [tools transLoacalDate:beginDate];
    
    // 活动结束时间
    NSDate *endDate = [tools handleResposTimeForm:endTime];
    endDate = [tools transLoacalDate:endDate];
        
    // 与开始时间比较
    NSComparisonResult later = [nowDate compare:beginDate];

    // 与结束时间比较
    NSComparisonResult early = [nowDate compare:endDate];
    
    if (early == -1 && later == 1) {
        return YES;
    }else
        return NO;
}

- (NSDate *)transLoacalDate:(NSDate *)date {
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate:date];
    date = [date  dateByAddingTimeInterval:interval];
    return date;
}


- (NSInteger)stringTransformInteger:(NSString *)string
{
    return [string integerValue];
}

@end
