//
//  HealthyManageSuggestionData.m
//  jingGang
//
//  Created by dengxf on 16/7/22.
//  Copyright © 2016年 Dengxf_Dev. All rights reserved.
//

#import "HealthyManageSuggestionData.h"

@implementation HealthyManageSuggestionData

+ (NSArray *)datas {
    NSString *text = @"";
    NSArray *commons = @[@"饮食习惯需要改进",@"每周运动锻炼次数较少",@"精神压力偏大",@"体重(超重)",@"饮食均衡"];
    NSString *string = @"1项需要注意的当面:";
    NSAttributedString *attString = [text addAttributeWithString:string attriRange:NSMakeRange(0, string.length) attriColor:JGColor(80, 144, 221, 1)attriFont:JGFont(14)];
    NSMutableArray *datas = [NSMutableArray array];
    [datas addObjectsFromArray:commons];
    [datas xf_safeInsertObject:attString atIndex:commons.count - 2];
    string = @"4项有待改进的生活方式:";
    attString = [text addAttributeWithString:string attriRange:NSMakeRange(0, string.length) attriColor:JGColor(80, 144, 221, 1) attriFont:JGFont(14)];
    [datas xf_safeInsertObject:attString atIndex:0];
    
    string = @"健康改进的建议";
    attString = [text addAttributeWithString:string attriRange:NSMakeRange(0, string.length) attriColor:[JGBlackColor colorWithAlphaComponent:0.85] attriFont:[UIFont boldSystemFontOfSize:16]];
    
    [datas xf_safeInsertObject:attString atIndex:0];
    return [datas copy];
}

@end
