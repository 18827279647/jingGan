//
//  YSTargetTriggerLimitConfig.h
//  jingGang
//
//  Created by dengxf on 17/2/24.
//  Copyright © 2017年 dengxf_dev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YSTargetTriggerLimitConfig : NSObject

/**
 *  添加事件触发配置<按日期计算>
    identifier   事件的标志
    configCount  事件触发次数限制
    以当天字符串在本地数组出现的次数,比如：
    @[@"20017-03-16",@"20017-03-16",@"20017-03-17",@"20017-03-18",] 进行限制
 */
+ (void)addTargetArrayTriggerWithIdentifier:(NSString *)identifier configCount:(NSInteger)configCount result:(bool_block_t)result;

/**
 *  带延迟提示 添加事件触发配置<按日期计算>
    identifier   事件的标志
    configCount  事件触发次数限制
    以当天字符串在本地数组出现的次数,比如：
    @[@"20017-03-16",@"20017-03-16",@"20017-03-17",@"20017-03-18",] 进行限制
 */
+ (void)addTargetArrayTriggerWithIdentifier:(NSString *)identifier configCount:(NSInteger)configCount delay:(NSTimeInterval)delay result:(bool_block_t)result;

@end
