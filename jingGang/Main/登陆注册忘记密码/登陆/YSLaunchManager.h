//
//  YSLunchManager.h
//  jingGang
//
//  Created by dengxf on 16/9/21.
//  Copyright © 2016年 dengxf_dev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YSLaunchManager : NSObject

/**
 *  设置是否未第一次启动 */
+ (void)setFirstLaunchMode:(BOOL)launchMode;

/**
 *  查询是否未第一次启动 */
+ (BOOL)isFirstLauchMode;

/**
 *  设置完善信息 */
+ (void)setNeedSupplyInfo:(BOOL)supply;

/**
 *   是否要完善信息*/
+ (BOOL)isSupplyInfo;
@end
