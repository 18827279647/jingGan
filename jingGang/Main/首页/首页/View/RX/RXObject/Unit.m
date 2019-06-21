//
//  UnitJson.m
//  你点我帮
//
//  Created by admin on 16/4/23.
//  Copyright © 2016年 zhaoyaqun. All rights reserved.
//

#import "Unit.h"
#import <CommonCrypto/CommonDigest.h>

@implementation Unit

+(long)GetMS;
{
    return  [[NSDate date] timeIntervalSince1970]*1000;
}

+(NSString*)String:(NSData*)data;
{
    return  [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

+(NSMutableDictionary*)ParseJSONObject:(NSString *)JSONString;
{
    NSMutableDictionary*resJson=nil;
    if(JSONString && ![JSONString isEqualToString:@""]){
        NSError*err=nil;
        NSData*JsonData=[JSONString dataUsingEncoding:NSUTF8StringEncoding];
        resJson=[NSJSONSerialization  JSONObjectWithData:JsonData options:NSJSONReadingMutableContainers error:&err];
        
        if(err){
            resJson=nil;
        }
    }
    
    if (!resJson) {
        return [[NSMutableDictionary alloc]init];
    }else
    {
        return resJson;
    }
}

+(NSMutableArray*)ParseJSONArray:(NSString *)JSONString;
{
    NSMutableArray*resJson=nil;
    if(JSONString && ![JSONString isEqualToString:@""]){
        
        NSError*err=nil;

        NSData*jsonData=[JSONString dataUsingEncoding:NSUTF8StringEncoding];

        resJson=[NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&err];
        if (err) {
            
            resJson=nil;
        }
    }
    if (!resJson) {
        
        return [[NSMutableArray alloc]init];
    }else
    {
        return resJson;
    }

}






+(NSString*)FormatJSONObject:(NSMutableDictionary*)dic;
{
    if (dic ==nil) {
        return @"{}";
    }
    NSError*err=nil;
    NSString*jsonString=nil;
    NSData*jsonData=[NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&err];
    if ([jsonData length]>0&&err==nil)
    {
        jsonString=[[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    }else
    {
        jsonString=@"{}";
    }
    
    return jsonString ;
}

+(NSString*)FormatJSONArray:(NSMutableArray*)array;
{
    if (array ==nil) {
        return @"[]";
    }
    NSError*err=nil;
    NSString*jsonString=nil;
    NSData*jsonData=[NSJSONSerialization dataWithJSONObject:array options:NSJSONWritingPrettyPrinted error:&err];
    if ([jsonData length]>0&&err==nil)
    {
       jsonString=[[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
        
    }else
    {
        
    jsonString=@"[]";
        
    }
    
    return jsonString ;
}
+(NSString*)JSONString:(NSMutableDictionary*)json key:(NSString*)key;{
    NSString* val=[json objectForKey:key];
    if ([val isKindOfClass:[NSNull class]]) {
        return @"";
    }
    
    if(!val){
        val=@"";
    }
    return val;
}



+(NSString*)GetTimeString:(NSString*)time;{
    NSString *timeStampString  =time;
    
    // iOS 生成的时间戳是10位
    NSTimeInterval interval    =[timeStampString doubleValue] / 1000.0;
    NSDate *date               = [NSDate dateWithTimeIntervalSince1970:interval];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateString       = [formatter stringFromDate: date];
    return dateString;
}


+(NSDate*)getString:(NSString*)string;
{
    NSString *birthdayStr=string;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:8]];//解决8小时时间差问题
    NSDate *birthdayDate = [dateFormatter dateFromString:birthdayStr];
    return birthdayDate;
}


+(NSString*)getDate:(NSDate*)date;{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *strDate = [dateFormatter stringFromDate:date];
    return strDate;
}
+(NSInteger)getDaysFrom:(NSDate *)serverDate To:(NSDate *)endDate;
{
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    [gregorian setFirstWeekday:2];
    
    //去掉时分秒信息
    NSDate *fromDate;
    NSDate *toDate;
    [gregorian rangeOfUnit:NSCalendarUnitDay startDate:&fromDate interval:NULL forDate:serverDate];
    [gregorian rangeOfUnit:NSCalendarUnitDay startDate:&toDate interval:NULL forDate:endDate];
    NSDateComponents *dayComponents = [gregorian components:NSCalendarUnitDay fromDate:fromDate toDate:toDate options:0];
    
    return dayComponents.day;
}







+(NSMutableDictionary*)JSONArrayObject:(NSMutableArray*)json key:(int)key;{
    id data=[json objectAtIndex:key];
    if (![data isKindOfClass:[NSMutableDictionary class]])
    {
        data=nil;
    }
    
    if(!data){
        data=[[NSMutableDictionary alloc]init];
    }
    return data;
}
+(NSMutableDictionary*)JSONObject:(NSMutableDictionary*)json key:(NSString*)key;{
    id data=[json objectForKey:key];
    if (![data isKindOfClass:[NSMutableDictionary class]])
    {
        data=nil;
    }
    
    if(!data){
        data=[[NSMutableDictionary alloc]init];
    }
    return data;
}







+(NSMutableArray*)JSONArrayArray:(NSMutableArray*)json key:(int)key;{
    id data=[json objectAtIndex:key];
    if (![data isKindOfClass:[NSMutableArray class]])
    {
        data=nil;
    }
    
    if(!data){
        data=[[NSMutableArray alloc]init];
    }
    return data;
}
+(NSMutableArray*)JSONArray:(NSMutableDictionary*)json key:(NSString*)key;{
    id data=[json objectForKey:key];
    if (![data isKindOfClass:[NSMutableArray class]])
        {
        data=nil;
        }
    
    if(!data){
        data=[[NSMutableArray alloc]init];
    }
    return data;
}


+(UIImage*)drarmake:(UIImage*)image wither:(float)width hight:(float)height;{
    
    CGSize imageSize=CGSizeMake(width,height);
    UIGraphicsBeginImageContextWithOptions(imageSize, NO,0.0);
    CGRect imageRect = CGRectMake(0.0, 0.0, imageSize.width, imageSize.height);
    [image drawInRect:imageRect];
    UIImage*imageVlaue  = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return imageVlaue;
}



+(NSMutableDictionary*)ConvertStrToTime:(NSString *)timeStr;
{
    long long time=[timeStr longLongValue];
    NSMutableDictionary*dic=[[NSMutableDictionary alloc]init];
    long hour=0;
    long minute=0;
    long second=0;
    
    second=time/1000;
    
    if(second>60) {
        minute=second/60;
        second=second%60;
    }
    if (minute>60) {
        hour=minute/60;
        minute=minute%60;
    }
    
    [dic setObject:[NSNumber numberWithLong:hour] forKey:@"hour"];
    [dic setObject:[NSNumber numberWithLong:minute] forKey:@"minute"];
    [dic setObject:[NSNumber numberWithLong:second] forKey:@"second"];
    
    return dic;

}







+(bool)JSONBool:(NSMutableDictionary*)json key:(NSString*)key;
{
    NSString* val=[json objectForKey:key];
    if ([val isKindOfClass:[NSNull class]]) {
        return false;
    }
   bool agrs=[[json objectForKey:key]boolValue];
    return agrs;
}
+(long)JSONLong:(NSMutableDictionary*)json key:(NSString*)key;
{
    NSString* val=[json objectForKey:key];
    if ([val isKindOfClass:[NSNull class]]) {
        return 0;
    }
    long agrs=[[json objectForKey:key]longValue];
    
    return agrs;
}
+(double)JSONDouble:(NSMutableDictionary*)json key:(NSString*)key;
{

    NSString* val=[json objectForKey:key];
    if ([val isKindOfClass:[NSNull class]]) {
        return 0;
    }
    double agrs=[[json objectForKey:key]doubleValue];
    
    return agrs;
}
+(int)JSONInt:(NSMutableDictionary*)json key:(NSString*)key;
{
    NSString* val=[json objectForKey:key];
    if ([val isKindOfClass:[NSNull class]]) {
        return 0;
    }
    int agrs=[[json objectForKey:key]intValue];
    
    return agrs;
}

+(NSString*)JSONArayString:(NSMutableArray*)json key:(int)key;
{

    NSString*agrs=[NSString stringWithFormat:@"%@",[json objectAtIndex:key]];
    
    return agrs;

}
+(bool)JSONArrayBool:(NSMutableArray*)json key:(int)key;
{
    bool agrs=[[json objectAtIndex:key]boolValue];
    
    return agrs;
 

}
+(long)JSONArrayLong:(NSMutableArray*)json key:(int)key;
{
    long agrs=[[json objectAtIndex:key]longValue];
    
    return agrs;


}
+(double)JSONArrayDouble:(NSMutableArray*)json key:(int)key;
{
    double agrs=[[json objectAtIndex:key]doubleValue];

    return agrs;
}
+(int)JSONArrayInt:(NSMutableArray*)json key:(int)key;
{
   
    int data=[[json objectAtIndex:key]intValue];
    
    return data;

}

+(long long)longLongFromDate:(NSDate*)date;{
    return [date timeIntervalSince1970] * 1000;
}

+(void)setDic:(NSMutableDictionary*)dic key:(NSString*)key value:(id)value;{
    if (value==nil) {
        value=@"";
    }
    [dic setObject:value forKey:key];
}
+(UIColor*)getUiColor:(NSString*)hexColorString;
{
    unsigned int red,green,blue;
    //切割字符
    NSRange range;
    //长度2
    range.length=2;
    //从0位开始
    range.location=0;
    //获得红色
    [[NSScanner scannerWithString:[hexColorString substringWithRange:range]]scanHexInt:&red];
    //获得绿色
    range.location=2;
    [[NSScanner scannerWithString:[hexColorString substringWithRange:range]]scanHexInt:&green];
    //获得蓝色
    range.location=4;
    [[NSScanner scannerWithString:[hexColorString substringWithRange:range]]scanHexInt:&blue];
    return [UIColor colorWithRed:(float)(red/255.0f) green:(float)(green/255.0f) blue:(float)(blue/255.0f) alpha:1.0f];
}

+(NSString *)convertToJsonData:(id)dict
{
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString;

    if (!jsonData) {
        NSLog(@"%@",error);
    }else{
        jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    NSMutableString *mutStr = [NSMutableString stringWithString:jsonString];

    NSRange range = {0,jsonString.length};

    //去掉字符串中的空格

    [mutStr replaceOccurrencesOfString:@" " withString:@"" options:NSLiteralSearch range:range];

    NSRange range2 = {0,mutStr.length};

    //去掉字符串中的换行符

    [mutStr replaceOccurrencesOfString:@"\n" withString:@"" options:NSLiteralSearch range:range2];
    return mutStr;
}


+ (NSString *)md5Hash:(NSString *)str {
    const char *cStr = [str UTF8String];
    unsigned char result[16];
    CC_MD5( cStr, (CC_LONG)strlen(cStr), result );
    NSString *md5Result = [NSString stringWithFormat:
                           @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
                           result[0], result[1], result[2], result[3],
                           result[4], result[5], result[6], result[7],
                           result[8], result[9], result[10], result[11],
                           result[12], result[13], result[14], result[15]
                           ];
    return md5Result;
}


//比较两个日期大小
+(int)compareDate:(NSString*)startDate withDate:(NSString*)endDate;{
    
    int comparisonResult;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *date1 = [[NSDate alloc] init];
    NSDate *date2 = [[NSDate alloc] init];
    date1 = [formatter dateFromString:startDate];
    date2 = [formatter dateFromString:endDate];
    NSComparisonResult result = [date1 compare:date2];
    NSLog(@"result==%ld",(long)result);
    switch (result)
    {
            //date02比date01大
        case NSOrderedAscending:
            comparisonResult = 1;
            break;
            //date02比date01小
        case NSOrderedDescending:
            comparisonResult = -1;
            break;
            //date02=date01
        case NSOrderedSame:
            comparisonResult = 0;
            break;
        default:
            NSLog(@"erorr dates %@, %@", date1, date2);
            break;
    }
    return comparisonResult;
}

+ (NSString*)getWeekDayFordate;

{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    
    NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit |
    
    NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    
    NSDate *now = [NSDate date];
    
    // 在真机上需要设置区域，才能正确获取本地日期，天朝代码:zh_CN
    
    calendar.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    
    comps = [calendar components:unitFlags fromDate:now];
    
    NSInteger age= [comps weekday] - 1;
    
    NSString*ageNumber=@"一";
    if (age==0) {
        ageNumber=@"日";
    }
    if (age==1) {
        ageNumber=@"一";
    }
    if (age==2) {
        ageNumber=@"二";
    }
    if (age==3) {
        ageNumber=@"三";
    }
    if (age==4) {
        ageNumber=@"四";
    }
    if (age==5) {
        ageNumber=@"五";
    }
    if (age==6) {
        ageNumber=@"六";
    }
    return ageNumber;
}
//+(UIImage *)buttonImageFromColor:(UIColor *)color;{
//    
//    CGRect rect = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
//    UIGraphicsBeginImageContext(rect.size);
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    CGContextSetFillColorWithColor(context, [color CGColor]);
//    CGContextFillRect(context, rect);
//    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    return img;
//}
@end
