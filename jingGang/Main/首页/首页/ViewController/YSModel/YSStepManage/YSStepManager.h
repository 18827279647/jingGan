//
//  YSStepManager.h
//  jingGang
//
//  Created by dengxf on 16/7/28.
//  Copyright © 2016年 Dengxf_Dev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JGSingleton.h"


#define kWalkRunningCount @"kWalkRunningCount"
#define kStepCount        @"kStepCount"

@interface YSStepManager :JGSingleton

/**
 *  健康数据权限 */
+ (BOOL)healthyKitAccess;

+ (void)healthStoreDataWithStartDate:(NSString *)startDate
                             endDate:(NSString *)endDate
                      WithFailAccess:(voidCallback)fail
                 walkRunningCallback:(void(^)(NSNumber *))walkRunningCallback
                        stepCallback:(void(^)(NSNumber *))stepCallback;

@end


@interface YSCalorieCalculateManage : NSObject

+ (CGFloat)calorieWithSteps:(NSInteger)steps;

@end
