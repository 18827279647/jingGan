//
//  YSAdaptiveFrameConfig.m
//  jingGang
//
//  Created by dengxf on 17/6/9.
//  Copyright © 2017年 dengxf_dev. All rights reserved.
//

#import "YSAdaptiveFrameConfig.h"

@implementation YSAdaptiveFrameConfig

+ (CGFloat)currentDeviceWidth {
    return [UIScreen mainScreen].bounds.size.width;
}

+ (CGFloat)currentDeviceHeight {
    return [UIScreen mainScreen].bounds.size.height;
}

+ (CGFloat)width:(CGFloat)modelWidth {
    return (modelWidth * [self currentDeviceWidth]) / 375.0 ;
}

+ (CGFloat)height:(CGFloat)modelHeight {
    return (modelHeight * [self currentDeviceHeight]) / 667.0;
}

@end
