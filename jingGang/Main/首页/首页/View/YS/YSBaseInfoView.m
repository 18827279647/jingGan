
//  YSBaseInfoView.m
//  jingGang
//
//  Created by dengxf on 16/7/21.
//  Copyright © 2016年 Dengxf_Dev. All rights reserved.
//

#import "YSBaseInfoView.h"
#import "YSTextLinePositionModifier.h"
#import "YSWeatherManager.h"
#import "NSDate+ChineseDay.h"
#import "YSLoginManager.h"
@interface YSBaseInfoView ()



/**
 *  天气icon */
@property (strong,nonatomic) UIImageView *weatherIcon;

/**
 *  天气  温度 */
@property (strong,nonatomic) UILabel *weatherLab;

/**
 *  日期lab */
@property (strong,nonatomic) UILabel *dateLab;


@end

@implementation YSBaseInfoView


- (instancetype)initWithFrame:(CGRect)frame withData:(id)data
{
    self = [super init];
    if (self) {
        self.frame = frame;
        [self setup];
    }
    return self;
}

- (void)setCity:(NSString *)city weather:(YSWeatherInfo *)weather {
//    self.localLab.text = city;
    NSString *dateText = [NSDate getChineseCalendarWithDate:[NSDate date]];
//    [dateLab setText:[NSString stringWithFormat:@"今天  %@",dateText]];
    self.weatherLab.text = [NSString stringWithFormat:@"今天  %@  %@  %@",weather.weather,weather.temperature,dateText];
    self.weatherIcon.image = [UIImage imageNamed:[NSString stringWithFormat:@"weatherStatus%02ld",[weather.weatherTag integerValue]]];
}

- (void)setup {
    self.backgroundColor = JGWhiteColor;

//    UIImage *img = [UIImage imageNamed:@"ys_healthymanager_locationicon"];
//    UIImageView *imgView = [[UIImageView alloc] initWithImage:img];
//    imgView.x = 12.0f;
//    imgView.y = (self.height - img.imageHeight) / 2;
//    imgView.width = img.imageWidth;
//    imgView.height = img.imageHeight;
//    [self addSubview:imgView];
    
//    UIImageView*imageView=[[UIImageView alloc]initWithFrame:self.frame];
//    imageView.image=[UIImage imageNamed:@"Consummate_back_image"];
//    [self addSubview:imageView];
//
//
//
//    NSString *localName =[NSString stringWithFormat:@"%@,%@",[YSLoginManager userNickName], [self getTheTimeBucket] ];
//    UILabel *localLab = [[UILabel alloc] init];
//    localLab.x = 12;
//    localLab.height = 50;
//    localLab.width = 130;
//    localLab.font = JGFont(14);
//    localLab.y = (self.height - localLab.height) / 2;
//    localLab.text = localName;
//    [self addSubview:localLab];
//    self.localLab = localLab;
//
//    UIImage *weatherImg = [UIImage imageNamed:@"ys_healthmanager_weather_01"];
//    UIImageView *weatherIcon = [[UIImageView alloc] initWithImage:weatherImg];
//    weatherIcon.y = (self.height -30) / 2;
//    weatherIcon.width = 28;
//    weatherIcon.height =  28;;
//    [self addSubview:weatherIcon];
//    self.weatherIcon = weatherIcon;
//
//    UILabel *weatherLab = [[UILabel alloc] init];
//    weatherLab.width = 210;
//    weatherLab.x = self.width - weatherLab.width - 12;
//    weatherLab.height = 30;
//    weatherLab.y =  (self.height -30) / 2;
//    weatherLab.textAlignment = NSTextAlignmentRight;
//    weatherLab.font = JGFont(12.0);
//    [self addSubview:weatherLab];
//    self.weatherLab = weatherLab;
//    self.weatherIcon.x = CGRectGetMinX(self.weatherLab.frame) - 10;
//
//    UILabel *dateLab = [[UILabel alloc] init];
//    dateLab.x = weatherIcon.x;
//    dateLab.y = MaxY(weatherIcon) + 4.2;
//    dateLab.width = 134;
//    dateLab.height = 22;
//    dateLab.textAlignment = NSTextAlignmentRight;
//    NSString *dateText = [NSDate getChineseCalendarWithDate:[NSDate date]];
//    [dateLab setText:[NSString stringWithFormat:@"今天  %@",dateText]];
//    dateLab.font = JGFont(13);
////    [self addSubview:dateLab];
//    self.dateLab = dateLab;
//    self.dateLab.x = self.width - dateLab.width - 12;
    

//    [self addSubview:calendarLab];
}

- (NSDate *)transLoacalDate:(NSDate *)date {
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate:date];
    date = [date  dateByAddingTimeInterval:interval];
    return date;
}
- (NSDate *)getCustomDateWithHour:(NSInteger)hour

{
    
    //获取当前时间
    
    NSDate * destinationDateNow = [NSDate date];
    
    NSCalendar *currentCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    NSDateComponents *currentComps = [[NSDateComponents alloc] init];
    
    NSInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    currentComps = [currentCalendar components:unitFlags fromDate:destinationDateNow];
    NSDateComponents *resultComps = [[NSDateComponents alloc] init];
    [resultComps setYear:[currentComps year]];
    [resultComps setMonth:[currentComps month]];
    [resultComps setDay:[currentComps day]];
    [resultComps setHour:hour];
    NSCalendar *resultCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    return [resultCalendar dateFromComponents:resultComps];
}
-(NSString *)getTheTimeBucket
{NSDate * currentDate = [NSDate date];
    if ([currentDate compare:[self getCustomDateWithHour:0]] == NSOrderedDescending && [currentDate compare:[self getCustomDateWithHour:9]] == NSOrderedAscending)
    {   return @"早上好";
    } else if ([currentDate compare:[self getCustomDateWithHour:9]] == NSOrderedDescending && [currentDate compare:[self getCustomDateWithHour:11]] == NSOrderedAscending)
    {return @"上午好";
    }else if ([currentDate compare:[self getCustomDateWithHour:11]] == NSOrderedDescending && [currentDate compare:[self getCustomDateWithHour:13]] == NSOrderedAscending) {return @"中午好";
    }else if ([currentDate compare:[self getCustomDateWithHour:13]] == NSOrderedDescending && [currentDate compare:[self getCustomDateWithHour:18]] == NSOrderedAscending)
    { return @"下午好";
    } else
    {
        return @"晚上好";
    }
}
@end
