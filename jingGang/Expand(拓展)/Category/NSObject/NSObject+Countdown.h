//
//  NSObject+Countdown.h
//  jingGang
//
//  Created by dengxf on 16/11/7.
//  Copyright © 2016年 dengxf_dev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (Countdown)

typedef void(^XFCountdownBlock)(NSUInteger timer);
typedef void(^XFFinishBlock)();

/**
 按钮倒计时
 @param time 倒计时总时间
 @param countDownBlock 每秒倒计时会执行的block
 @param finishBlock 倒计时完成会执行的block
 */
- (void)countDownTime:(NSUInteger)time
       countDownBlock:(XFCountdownBlock)countDownBlock
         outTimeBlock:(XFFinishBlock)finishBlock;

@end
