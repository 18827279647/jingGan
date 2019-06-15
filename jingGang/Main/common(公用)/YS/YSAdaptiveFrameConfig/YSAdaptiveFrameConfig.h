//
//  YSAdaptiveFrameConfig.h
//  jingGang
//
//  Created by dengxf on 17/6/9.
//  Copyright © 2017年 dengxf_dev. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  基于iphone 6s 375 * 667 */
@interface YSAdaptiveFrameConfig : NSObject

/**
 *  返回基于iphone6s比例的当前设备宽度距离 */
+ (CGFloat)width:(CGFloat)modelWidth;

/**
 *  返回基于iphone6s比例的当前设备高度距离 */
+ (CGFloat)height:(CGFloat)modelHeight;

@end
