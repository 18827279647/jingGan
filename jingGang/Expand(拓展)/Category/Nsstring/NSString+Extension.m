//
//  NSString+Extension.m
//  Operator_JingGang
//
//  Created by dengxf on 16/11/17.
//  Copyright © 2016年 XKJH. All rights reserved.
//

#import "NSString+Extension.h"

@implementation NSString (Extension)

- (BOOL)isEmpty {
    NSString *temp = [NSString stringWithFormat:@"%@",self];
    BOOL result = YES;
    
    if ([self isKindOfClass:[NSNumber class]]) {
        temp = [NSString stringWithFormat:@"%@",self];
    }
    
    if (self == nil) {
        
        return result;
    } else if ([self isKindOfClass:[NSNull class]]){
        
        return result;
    } else if ([temp stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length == 0) {
        
        return result;
    }else if ([temp isEqualToString:@"(null)"]){
    
        return result;
    }else if ([temp isEqualToString:@"<null>"]){
        
        return result;
    } else {
        
        result = NO;
    }
    
    return  result;
}

- (NSMutableAttributedString *)addAttributeWithString:(NSString *)string attriRange:(NSRange)range attriColor:(UIColor *)color attriFont:(UIFont *)font
{
    //   NSDictionary *attribtDic = @{NSStrikethroughStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
    // 中划线
    if (!string || string.length == 0) {
        JGLog(@"字符串不合法");
        return nil;
    }
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:string];
    NSMutableDictionary *attriMutableDict = [NSMutableDictionary dictionary];
    [attriMutableDict setObject:color forKey:NSForegroundColorAttributeName];
    [attriMutableDict setObject:font forKey:NSFontAttributeName];
    
    NSInteger location = range.location;
    NSInteger length = range.length;
    NSAssert(location + 1 <= string.length, @"location超过字符串长度");
    if (location + 1 > string.length) {
        return nil;
    }
    
    NSAssert(location + length  <= string.length, @"length超过字符串长度");
    if (location + length  > string.length) {
        return nil;
    }
    [attributeString addAttributes:attriMutableDict range:range];
    return attributeString;
    
}

-(NSString *)URLDecodedString:(NSString *)str
{
    NSString *decodedString=(__bridge_transfer NSString *)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(NULL, (__bridge CFStringRef)str, CFSTR(""), CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding));
    
    return decodedString;
}


+ (NSString*)weekdayStringFromDate:(NSDate*)inputDate {
    
    NSArray *weekdays = [NSArray arrayWithObjects: [NSNull null], @"周日", @"周一", @"周二", @"周三", @"周四", @"周五", @"周六", nil];
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    NSTimeZone *timeZone = [[NSTimeZone alloc] initWithName:@"Asia/Shanghai"];
    
    [calendar setTimeZone: timeZone];

    NSCalendarUnit calendarUnit = NSCalendarUnitWeekday;
    
    NSDateComponents *theComponents = [calendar components:calendarUnit fromDate:inputDate];
    
    return [weekdays objectAtIndex:theComponents.weekday];
    
}

@end
