//
//  YSTargetTriggerLimitConfig.m
//  jingGang
//
//  Created by dengxf on 17/2/24.
//  Copyright © 2017年 dengxf_dev. All rights reserved.
//

#import "YSTargetTriggerLimitConfig.h"
#import "JGDateTools.h"

@implementation YSTargetTriggerLimitConfig

+ (void)addTargetArrayTriggerWithIdentifier:(NSString *)identifier configCount:(NSInteger)configCount result:(bool_block_t)result
{
    [self addTargetArrayTriggerWithIdentifier:identifier configCount:configCount delay:0 result:result];
}

+ (void)addTargetArrayTriggerWithIdentifier:(NSString *)identifier configCount:(NSInteger)configCount delay:(NSTimeInterval)delay result:(bool_block_t)result
{
    if (!identifier) {
        BLOCK_EXEC(result,NO);
        return;
    }
    if (!configCount) {
        BLOCK_EXEC(result,NO);
        [self remove:identifier];
        return;
    }
    
    NSString *nowDateString = [JGDateTools nowDateInfo];
    NSMutableArray *queryDates = [NSMutableArray arrayWithArray:(NSArray *)[self achieve:identifier]];
    if (queryDates.count) {
        NSInteger count = 0;
        for (NSString *nowDate in queryDates) {
            if ([nowDate isEqualToString:nowDateString]) {
                count += 1;
            }
        }
        if (count < configCount) {
            [queryDates xf_safeAddObject:nowDateString];
            [self save:queryDates key:identifier];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                BLOCK_EXEC(result,YES);
            });
        }else {
            BLOCK_EXEC(result,NO);
        }
        
    }else {
        [queryDates xf_safeAddObject:nowDateString];
        [self save:queryDates key:identifier];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            BLOCK_EXEC(result,YES);
        });
    }
}

@end
