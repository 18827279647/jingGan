//
//  YSUMMobClickManager.h
//  jingGang
//
//  Created by dengxf on 17/7/14.
//  Copyright © 2017年 dengxf_dev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YSUMMobClickManager : NSObject
/**
 *  初始化统计 */
+ (void)_initMobClick;

/**
 *  开始统计账号 */
+ (void)profileSignOnWithUid:(NSString *)uid;

/**
 *  退出统计 */
+ (void)profileSignOff;

/**
 *  进入页面 */
+ (void)beginLogPageWithKey:(NSString *)key;

/**
 *  离开页面 */
+ (void)endLogPageWithKey:(NSString *)key;

/**
 *  点击事件 */
+ (void)event:(NSString *)key;
@end
