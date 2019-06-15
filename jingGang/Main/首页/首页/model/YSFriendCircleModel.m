//
//  YSFriendCircleModel.m
//  jingGang
//
//  Created by dengxf on 16/7/23.
//  Copyright © 2016年 Dengxf_Dev. All rights reserved.
//

#import "YSFriendCircleModel.h"
#import "JGDateTools.h"

@implementation YSFriendCircleModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
             @"postId" : @"id"
             };
}


- (NSString *)addTime {
    JGDateTools *tools = [[JGDateTools alloc] init];
    NSDate *date = [tools handleResposTimeForm:_addTime];
    return [@"发表于" stringByAppendingString:[YSFriendCircleModel stringWithTimelineDate:date]];
}

- (CGFloat)commentsHeight:(void(^)(NSArray *heights))commentsHeightCallback {
    if (self.evaluateList.count) {
        CGFloat marginx = 12;
        CGFloat width = ScreenWidth - 2 * marginx;
        CGFloat commentHeight = 0;
        NSMutableArray *heights = [NSMutableArray array];
        for (NSDictionary *commentDic in self.evaluateList) {
            NSString *fromUserName = commentDic[@"fromUserName"];
            NSString *content  = commentDic[@"content"];
            NSString *text = [NSString stringWithFormat:@"%@ :  %@",fromUserName,content];
            CGSize textSize = [text sizeWithFont:JGFont(14) maxW:width];
            CGFloat textHeight = textSize.height + 8;
            commentHeight += textHeight;
            [heights xf_safeAddObject:[NSNumber numberWithFloat:textHeight]];
        }
        BLOCK_EXEC(commentsHeightCallback,heights);
        return commentHeight;
    }
    return 0.f;
}


+ (NSString *)stringWithTimelineDate:(NSDate *)date {
    if (!date) return @"";
    
    static NSDateFormatter *formatterYesterday;
    static NSDateFormatter *formatterSameYear;
    static NSDateFormatter *formatterFullDate;

    formatterYesterday = [[NSDateFormatter alloc] init];
    [formatterYesterday setDateFormat:@"昨天 HH:mm"];
    [formatterYesterday setLocale:[NSLocale currentLocale]];
    
    formatterSameYear = [[NSDateFormatter alloc] init];
    [formatterSameYear setDateFormat:@"M月d日"];
    [formatterSameYear setLocale:[NSLocale currentLocale]];
    
    formatterFullDate = [[NSDateFormatter alloc] init];
    [formatterFullDate setDateFormat:@"yy年M月dd日 HH:mm"];
    [formatterFullDate setLocale:[NSLocale currentLocale]];
    
    NSDate *now = [NSDate date];
    NSTimeInterval delta = now.timeIntervalSince1970 - date.timeIntervalSince1970;
    if (delta < -60 * 10) { // 本地时间有问题
        return [formatterFullDate stringFromDate:date];
    } else if (delta < 60 * 10) { // 10分钟内
        return @"刚刚";
    } else if (delta < 60 * 60) { // 1小时内
        return [NSString stringWithFormat:@"%d分钟前", (int)(delta / 60.0)];
    } else if (date.isToday) {
        return [NSString stringWithFormat:@"%d小时前", (int)(delta / 60.0 / 60.0)];
    } else if (date.isYesterday) {
        return [formatterYesterday stringFromDate:date];
    } else if (date.year == now.year) {
        return [formatterSameYear stringFromDate:date];
    } else {
        return [formatterFullDate stringFromDate:date];
    }
}

@end
